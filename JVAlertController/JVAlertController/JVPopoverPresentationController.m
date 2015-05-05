//
//  JVPopoverPresentationController.m
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

@interface JVPopoverPresentationController : NSObject <UIPopoverControllerDelegate>
@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic) CGRect sourceRect;
@property (nonatomic, strong) UIBarButtonItem *barButtonItem;
@property (nonatomic, weak) id<UIPopoverPresentationControllerDelegate> delegate;
@property(nonatomic, readwrite) UIEdgeInsets popoverLayoutMargins;
@property(nonatomic, copy) UIColor *backgroundColor;
@property(nonatomic, copy) NSArray *passthroughViews;
@property(nonatomic, readwrite, strong) Class< UIPopoverBackgroundViewMethods > popoverBackgroundViewClass;
@property(nonatomic, assign) UIPopoverArrowDirection permittedArrowDirections;
@property(nonatomic, readonly) UIPopoverArrowDirection arrowDirection;
@property(nonatomic, readwrite, weak) UIPopoverController *jv_legacyPopoverController;
@end

@implementation JVPopoverPresentationController

@dynamic popoverLayoutMargins, backgroundColor, passthroughViews, popoverBackgroundViewClass, arrowDirection;

- (UIEdgeInsets)popoverLayoutMargins {
    return self.jv_legacyPopoverController.popoverLayoutMargins;
}

- (void)setPopoverLayoutMargins:(UIEdgeInsets)newLayoutMargins {
    self.jv_legacyPopoverController.popoverLayoutMargins = newLayoutMargins;
}

- (UIColor*)backgroundColor {
    return self.jv_legacyPopoverController.backgroundColor;
}

- (void)setBackgroundColor:(UIColor*)newColor {
    self.jv_legacyPopoverController.backgroundColor = newColor;
}

- (NSArray*)passthroughViews {
    return self.jv_legacyPopoverController.passthroughViews;
}

- (void)setPassthroughViews:(NSArray*)newViews {
    self.jv_legacyPopoverController.passthroughViews = newViews;
}

- (Class< UIPopoverBackgroundViewMethods >)popoverBackgroundViewClass {
    return self.jv_legacyPopoverController.popoverBackgroundViewClass;
}

- (void)setPopoverBackgroundViewClass:(Class< UIPopoverBackgroundViewMethods >)newClass {
    self.jv_legacyPopoverController.popoverBackgroundViewClass = newClass;
}

- (UIPopoverArrowDirection)arrowDirection {
    return self.jv_legacyPopoverController.popoverArrowDirection;
}

- (void)popoverController:(UIPopoverController *)popoverController
willRepositionPopoverToRect:(inout CGRect *)rect
                   inView:(inout UIView **)view {

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(popoverPresentationController:willRepositionPopoverToRect:inView:)]) {

        [self.delegate popoverPresentationController:(UIPopoverPresentationController*)self
                         willRepositionPopoverToRect:rect
                                              inView:view
         ];
    }
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(popoverPresentationControllerShouldDismissPopover:)]) {

        return [self.delegate popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController*)self];
    }
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(popoverPresentationControllerDidDismissPopover:)]) {

        [self.delegate popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController*)self];
    }
}



// copy the JVPopoverPresentationController implementation into UIPopoverPresentationController's place on iOS 7
// adapted from Cédric Luthi's NSUUID project: https://github.com/0xced/NSUUID
+ (void)load
{
    if (objc_getClass("UIPopoverPresentationController"))
    {
        return;
    }
    
    Class *UIPopoverPresentationControllerClassRef = NULL;
#if TARGET_CPU_ARM
    __asm(
          "movw %0, :lower16:(L_OBJC_CLASS_UIPopoverPresentationController-(LPC2+4))\n"
          "movt %0, :upper16:(L_OBJC_CLASS_UIPopoverPresentationController-(LPC2+4))\n"
          "LPC2: add %0, pc" : "=r"(UIPopoverPresentationControllerClassRef)
          );
#elif TARGET_CPU_ARM64
    __asm(
          "adrp %0, L_OBJC_CLASS_UIPopoverPresentationController@PAGE\n"
          "add  %0, %0, L_OBJC_CLASS_UIPopoverPresentationController@PAGEOFF" : "=r"(UIPopoverPresentationControllerClassRef)
          );
#elif TARGET_CPU_X86_64
    __asm("leaq L_OBJC_CLASS_UIPopoverPresentationController(%%rip), %0" : "=r"(UIPopoverPresentationControllerClassRef));
#elif TARGET_CPU_X86
    void *pc = NULL;
    __asm(
          "calll L2\n"
          "L2: popl %0\n"
          "leal L_OBJC_CLASS_UIPopoverPresentationController-L2(%0), %1" : "=r"(pc), "=r"(UIPopoverPresentationControllerClassRef)
          );
#endif
    if (UIPopoverPresentationControllerClassRef && *UIPopoverPresentationControllerClassRef == Nil)
    {
        Class UIPopoverPresentationControllerClass = objc_allocateClassPair(self, "UIPopoverPresentationController", 0);
        if (UIPopoverPresentationControllerClass) {
            objc_registerClassPair(UIPopoverPresentationControllerClass);
            *UIPopoverPresentationControllerClassRef = UIPopoverPresentationControllerClass;
        }
    }
}

@end

__asm(
#if defined(__OBJC2__) && __OBJC2__
      ".section        __DATA,__objc_classrefs,regular,no_dead_strip\n"
    #if	TARGET_RT_64_BIT
      ".align          3\n"
      "L_OBJC_CLASS_UIPopoverPresentationController:\n"
      ".quad           _OBJC_CLASS_$_UIPopoverPresentationController\n"
    #else
      ".align          2\n"
      "L_OBJC_CLASS_UIPopoverPresentationController:\n"
      ".long           _OBJC_CLASS_$_UIPopoverPresentationController\n"
    #endif
#else
      ".section        __TEXT,__cstring,cstring_literals\n"
      "L_OBJC_CLASS_NAME_UIPopoverPresentationController:\n"
      ".asciz          \"UIPopoverPresentationController\"\n"
      ".section        __OBJC,__cls_refs,literal_pointers,no_dead_strip\n"
      ".align          2\n"
      "L_OBJC_CLASS_UIPopoverPresentationController:\n"
      ".long           L_OBJC_CLASS_NAME_UIPopoverPresentationController\n"
#endif
      ".weak_reference _OBJC_CLASS_$_UIPopoverPresentationController\n"
      );