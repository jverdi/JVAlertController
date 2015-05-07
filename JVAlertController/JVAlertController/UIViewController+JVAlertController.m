//
//  UIViewController+JVAlertController.m
//  JVAlertController
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Jared Verdi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "UIViewController+JVAlertController.h"

#define JVAC_SYSTEM_VERSION_GTE(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

void (*JVAC_OrigPresentViewController)(id, SEL, UIViewController *, BOOL, void (^)(void));
void (*JVAC_OrigDismissViewController)(id, SEL, BOOL, void (^)(void));

static void * JVAC_PopoverControllerKey = &JVAC_PopoverControllerKey;
static void * JVAC_PopoverHostControllerKey = &JVAC_PopoverHostControllerKey;

@implementation UIViewController (JVAlertController)

+ (void)load
{
    if (JVAC_SYSTEM_VERSION_GTE(@"8.0")) {
        return;
    }
    
    // presentViewController:animated:completion: -> JVAC_PresentViewController
    [self JVAC_replacePresent];
    
    // dismissViewControllerAnimated:completion: -> JVAC_DismissViewController
    [self JVAC_replaceDismiss];
}

+ (void)JVAC_replacePresent
{
    SEL OrigSelector = @selector(presentViewController:animated:completion:);
    Method origMethod = class_getInstanceMethod(self, OrigSelector);
    JVAC_OrigPresentViewController = (void *)method_getImplementation(origMethod); // retain original implementation
    class_replaceMethod(self, OrigSelector, (IMP)JVAC_PresentViewController, method_getTypeEncoding(origMethod));
}

+ (void)JVAC_replaceDismiss
{
    SEL OrigSelector = @selector(dismissViewControllerAnimated:completion:);
    Method origMethod = class_getInstanceMethod(self, OrigSelector);
    JVAC_OrigDismissViewController = (void *)method_getImplementation(origMethod); // retain original implementation
    class_replaceMethod(self, OrigSelector, (IMP)JVAC_DismissViewController, method_getTypeEncoding(origMethod));
    
}

- (UIPopoverController *)JVAC_popoverController
{
    return objc_getAssociatedObject(self, JVAC_PopoverControllerKey);
}

- (void)setJVAC_popoverController:(UIPopoverController *)JVAC_popoverController
{
    objc_setAssociatedObject(self,
                             JVAC_PopoverControllerKey,
                             JVAC_popoverController,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIViewController *)JVAC_popoverHostController
{
    return objc_getAssociatedObject(self, JVAC_PopoverHostControllerKey);
}

- (void)setJVAC_popoverHostController:(UIViewController *)JVAC_popoverHostController
{
    objc_setAssociatedObject(self,
                             JVAC_PopoverHostControllerKey,
                             JVAC_popoverHostController,
                             OBJC_ASSOCIATION_ASSIGN);
}

static void JVAC_PresentViewController(UIViewController *self,
                                       SEL _cmd,
                                       UIViewController *viewControllerToPresent,
                                       BOOL flag,
                                       void (^completion)(void))
{
    // modification: use popovers if we're presenting an action sheet on iPad
    if ([viewControllerToPresent isKindOfClass:NSClassFromString(@"JVAlertController")]
        && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        UIAlertController *vc = (UIAlertController *)viewControllerToPresent;
        if (UIAlertControllerStyleActionSheet == vc.preferredStyle) {
            
            // visible check is necessary because we don't know when popovers are closed from outside our jurisdiction
            if (self.JVAC_popoverController && self.JVAC_popoverController.isPopoverVisible) {
                NSLog(@"Warning: Attempt to present %@ on %@ which is already presenting %@",
                      viewControllerToPresent, self, self.JVAC_popoverController);
                return;
            }
            
            UIPopoverPresentationController *ppc = [vc popoverPresentationController];
            
            self.JVAC_popoverController =
            [[UIPopoverController alloc] initWithContentViewController:viewControllerToPresent];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            if ([ppc respondsToSelector:@selector(setJv_legacyPopoverController:)]) {
                [ppc performSelector:@selector(setJv_legacyPopoverController:) withObject:self.JVAC_popoverController];
            }
#pragma clang diagnostic pop
            
            if ([ppc conformsToProtocol:@protocol(UIPopoverControllerDelegate)]) {
                self.JVAC_popoverController.delegate = (id<UIPopoverControllerDelegate>)ppc;
            }

            viewControllerToPresent.JVAC_popoverHostController = self;
            
            if (ppc.barButtonItem) {
                [self.JVAC_popoverController presentPopoverFromBarButtonItem:ppc.barButtonItem
                                                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                                                    animated:flag];
            }
            else {
                [self.JVAC_popoverController presentPopoverFromRect:ppc.sourceRect
                                                             inView:ppc.sourceView
                                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                                           animated:flag];
            }
            return;
        }
    }
    
    // call original implementation of presentViewController:animated:completion:
    JVAC_OrigPresentViewController(self, _cmd, viewControllerToPresent, flag, completion);
}

static void JVAC_DismissViewController(UIViewController *self,
                                       SEL _cmd,
                                       BOOL flag,
                                       void (^completion)(void))
{
    // modification: use popovers if we're presenting an action sheet on iPad
    if (self.JVAC_popoverHostController != nil
        && self.JVAC_popoverHostController.JVAC_popoverController != nil
        && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        [self.JVAC_popoverHostController.JVAC_popoverController dismissPopoverAnimated:flag];
        // call completion immediatedly
        if (completion != NULL) {
            @try {
                completion();
            } @finally {
                self.JVAC_popoverHostController.JVAC_popoverController = nil;
                self.JVAC_popoverHostController = nil;
            }
        } else {
            self.JVAC_popoverHostController.JVAC_popoverController = nil;
            self.JVAC_popoverHostController = nil;
        }

        return;
    }
    
    // call original implementation of dismissViewControllerAnimated:completion:
    JVAC_OrigDismissViewController(self, _cmd, flag, completion);
}

@end
