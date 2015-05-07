//
//  JVAlertController.m
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

#import "JVAlertAction.h"
#import "JVAlertControllerBackgroundView.h"
#import "JVAlertControllerButton.h"
#import "JVAlertControllerStyles.h"
#import "JVAlertControllerTextField.h"
#import "JVAlertTransitionDelegate.h"
#import "JVActionSheetTransitionDelegate.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

// JVAlertController is not meant to be instantiated directly,
// which is why there is no JVAlertController.h

// JVAlertController serves as a template class,
// to be injected via the objc runtime as "UIAlertController"
// Once this class and its accompanying files are imported into your project,
// you can use the standard UIAlertController APIs freely on iOS 7

@interface JVAlertController : UIViewController

@property (nonatomic, readonly) NSArray *actions;
@property (nonatomic, readonly) NSArray *textFields;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, readonly) UIAlertControllerStyle preferredStyle;

@property (nonatomic, readonly) UIPopoverPresentationController *popoverPresentationController;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle;
- (void)addAction:(UIAlertAction *)action;
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;

@end

@interface JVAlertController ()
@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) NSArray *textFields;
@property (nonatomic, strong) NSArray *textFieldConfigurationHandlers;
@property (nonatomic) UIAlertControllerStyle preferredStyle;

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIScrollView *alertScrollView;
@property (nonatomic, strong) UIScrollView *alertButtonScrollView;
@property (nonatomic, strong) UILabel *alertTitleView;
@property (nonatomic, strong) UILabel *alertMessageView;
@property (nonatomic, strong) JVAlertTransitionDelegate *alertTransitionDelegate;
@property (nonatomic, strong) NSArray *textFieldWrappers;

@property (nonatomic, strong) UIView *actionSheetView;
@property (nonatomic, strong) UIScrollView *actionSheetScrollView;
@property (nonatomic, strong) UIScrollView *actionSheetButtonScrollView;
@property (nonatomic, strong) UILabel *actionSheetTitleView;
@property (nonatomic, strong) UILabel *actionSheetMessageView;
@property (nonatomic, strong) JVActionSheetTransitionDelegate *actionSheetTransitionDelegate;
@property (nonatomic, strong) UIView *actionSheetCancelButtonWrapperView;
@property (nonatomic, strong) JVAlertControllerButton *actionSheetCancelButton;

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSArray *buttonSeparators;
@property (nonatomic, strong) UIView *buttonPairSeparator;

@property (nonatomic, getter=isCancelButtonPresent) BOOL cancelButtonPresent;

@property (nonatomic, getter=isInPopover) BOOL inPopover;

@property (nonatomic) CGFloat keyboardHeight;

@property (nonatomic, strong) UIPopoverPresentationController *popoverPresentationController;
@end

@interface JVAlertController (AlertView)
- (void)createAlertView;
@end

@interface JVAlertController (ActionSheetView)
- (void)createActionSheetView;
@end

@implementation JVAlertController

@dynamic title;

@synthesize actions = _actions;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    JVAlertController *controller = [JVAlertController new];
    controller.title = [title copy];
    controller.message = [message copy];
    controller.preferredStyle = preferredStyle;
    return controller;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.actions = @[];
        self.textFields = @[];
        self.textFieldConfigurationHandlers = [NSArray new];
        self.preferredStyle = UIAlertControllerStyleAlert;
        self.popoverPresentationController = [UIPopoverPresentationController new];
        self.inPopover = NO;
        self.definesPresentationContext = YES;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (UIAlertControllerStyleAlert == self.preferredStyle) {
        [self createAlertView];
        [self updateFontSizes];
        [self layoutAlertView];
        
        if ([self.textFields count] > 0) {
            [self.textFields[0] becomeFirstResponder];
        }
    }
    else {
        self.inPopover = ([self isPad] && [self popoverPresentationController] != nil);
        
        [self createActionSheetView];
        [self updateFontSizes];
        [self layoutActionSheetView];
    }
    
    UITapGestureRecognizer *closeGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goClose)];
    [self.view addGestureRecognizer:closeGR];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowOrHide:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowOrHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dynamicTypeSizesDidChange)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self layoutAlertController];
}

- (CGSize)preferredContentSize
{
    if (![self isPad]) {
        return [super preferredContentSize];
    }
    
    UIView *view = (UIAlertControllerStyleActionSheet == self.preferredStyle) ? self.actionSheetView : self.alertView;
    
    CGFloat w =
    (UIAlertControllerStyleActionSheet == self.preferredStyle) ? kJVActionSheetPopoverWidth : kJVAlertWidth;
    return CGSizeMake(w, CGRectGetHeight(view.bounds));
}

#pragma mark - Public

- (void)addAction:(UIAlertAction *)action
{
    if (UIAlertActionStyleCancel == action.style) {
        for (UIAlertAction *otherAction in self.actions) {
            NSAssert(UIAlertActionStyleCancel != otherAction.style,
                     @"UIAlertController can only have one action with a style of UIAlertActionStyleCancel");
        }
    }
    
    self.actions = [self.actions arrayByAddingObject:action];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler
{
    NSAssert(UIAlertControllerStyleAlert == self.preferredStyle,
             @"Text fields can only be added to an alert controller of style UIAlertControllerStyleAlert");
    
    if (!configurationHandler) {
        configurationHandler = ^(UITextField *textField){};
    }
    
    self.textFieldConfigurationHandlers =
    [self.textFieldConfigurationHandlers arrayByAddingObject:[configurationHandler copy]];
}

#pragma mark - Private

- (void)setPreferredStyle:(UIAlertControllerStyle)preferredStyle
{
    _preferredStyle = preferredStyle;
    
    if (UIAlertControllerStyleAlert == self.preferredStyle) {
        self.alertTransitionDelegate = [JVAlertTransitionDelegate new];
        self.transitioningDelegate = self.alertTransitionDelegate;
    }
    else {
        self.actionSheetTransitionDelegate = [JVActionSheetTransitionDelegate new];
        self.transitioningDelegate = self.actionSheetTransitionDelegate;
    }
}

- (BOOL)isPad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void)goClose
{
    if (([self isPad] || self.isCancelButtonPresent) && UIAlertControllerStyleActionSheet == self.preferredStyle) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)keyboardWillShowOrHide:(NSNotification *)notification
{
    NSString *name = [notification name];
    NSDictionary *userInfo = notification.userInfo;
    
    if ([name isEqualToString:UIKeyboardWillHideNotification]) {
        self.keyboardHeight = 0;
    }
    else {
        CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.keyboardHeight = MIN(keyboardFrame.size.width, keyboardFrame.size.height);
    }
    
    if (self.preferredStyle == UIAlertControllerStyleAlert) {
        [self updateAlertViewPosition];
    }
}

- (void)dynamicTypeSizesDidChange
{
    [self updateFontSizes];
    [self layoutAlertController];
}

- (void)updateFontSizes
{
    if (UIAlertControllerStyleAlert == self.preferredStyle) {
        _alertTitleView.font = [JVAlertControllerStyles alertTitleFont];
        _alertMessageView.font = [JVAlertControllerStyles alertMessageFont];
        
        NSUInteger i=0;
        for (UIButton *button in self.buttons) {
            i++;
            
            if (i == [self.actions count]) {
                [[button titleLabel] setFont:[JVAlertControllerStyles alertLastButtonFont]];
            }
            else {
                [[button titleLabel] setFont:[JVAlertControllerStyles alertButtonFont]];
            }
        }
    }
    else {
        _actionSheetTitleView.font = [JVAlertControllerStyles actionSheetTitleFont];
        _actionSheetMessageView.font = [JVAlertControllerStyles actionSheetMessageFont];
        
        NSUInteger i=0;
        
        for (UIAlertAction *action in self.actions) {
            
            if ([self isPad] && UIAlertActionStyleCancel == action.style) {
                continue;
            }
            
            UIButton *button = [self.buttons objectAtIndex:i];
            
            if (UIAlertActionStyleDefault == action.style) {
                [[button titleLabel] setFont:[JVAlertControllerStyles actionSheetButtonFont]];
            }
            else if (UIAlertActionStyleDestructive == action.style) {
                [[button titleLabel] setFont:[JVAlertControllerStyles actionSheetButtonFont]];
            }
            else if (UIAlertActionStyleCancel == action.style) {
                [[button titleLabel] setFont:[JVAlertControllerStyles actionSheetCancelButtonFont]];
            }
            
            i++;
        }
    }
}

- (void)layoutAlertController
{
    if (UIAlertControllerStyleAlert == self.preferredStyle) {
        [self layoutAlertView];
    }
    else {
        [self layoutActionSheetView];
    }
}

- (UIView *)alertView
{
    if (!_alertView) {
        _alertView = [UIView new];
        _alertView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin
                                       | UIViewAutoresizingFlexibleRightMargin
                                       | UIViewAutoresizingFlexibleTopMargin
                                       | UIViewAutoresizingFlexibleBottomMargin);
        _alertView.backgroundColor = [UIColor clearColor];
        _alertView.layer.cornerRadius = kJVAlertCornerRadius;
        _alertView.layer.masksToBounds = YES;
        [self.view addSubview:_alertView];
    }
    return _alertView;
}

- (UIScrollView *)alertScrollView
{
    if (!_alertScrollView) {
        _alertScrollView = [UIScrollView new];
        _alertScrollView.backgroundColor = [UIColor clearColor];
        _alertScrollView.scrollsToTop = NO;
        [self.alertView addSubview:_alertScrollView];
    }
    return _alertScrollView;
}

- (UIScrollView *)alertButtonScrollView
{
    if (!_alertButtonScrollView) {
        _alertButtonScrollView = [UIScrollView new];
        _alertButtonScrollView.backgroundColor = [UIColor clearColor];
        _alertButtonScrollView.scrollsToTop = NO;
        [self.alertView addSubview:_alertButtonScrollView];
    }
    return _alertButtonScrollView;
}

- (UILabel *)alertTitleView
{
    if (!_alertTitleView) {
        _alertTitleView = [UILabel new];
        _alertTitleView.textColor = [JVAlertControllerStyles alertTitleColor];
        _alertTitleView.textAlignment = [JVAlertControllerStyles alertTitleTextAlignment];
        _alertTitleView.numberOfLines = 0;
        [self.alertScrollView addSubview:_alertTitleView];
    }
    return _alertTitleView;
}

- (UILabel *)alertMessageView
{
    if (!_alertMessageView) {
        _alertMessageView = [UILabel new];
        _alertMessageView.textColor = [JVAlertControllerStyles alertMessageColor];
        _alertMessageView.textAlignment = [JVAlertControllerStyles alertMessageTextAlignment];
        _alertMessageView.numberOfLines = 0;
        [self.alertScrollView addSubview:_alertMessageView];
    }
    return _alertMessageView;
}

- (UIView *)actionSheetView
{
    if (!_actionSheetView) {
        _actionSheetView = [UIView new];
        _actionSheetView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin
                                             | UIViewAutoresizingFlexibleRightMargin
                                             | UIViewAutoresizingFlexibleTopMargin);
        _actionSheetView.backgroundColor = [UIColor clearColor];
        _actionSheetView.layer.cornerRadius = kJVActionSheetCornerRadius;
        _actionSheetView.layer.masksToBounds = YES;
        [self.view addSubview:_actionSheetView];
    }
    return _actionSheetView;
}

- (UIScrollView *)actionSheetScrollView
{
    if (!_actionSheetScrollView) {
        _actionSheetScrollView = [UIScrollView new];
        _actionSheetScrollView.backgroundColor = [UIColor clearColor];
        _actionSheetScrollView.scrollsToTop = NO;
        [self.actionSheetView addSubview:_actionSheetScrollView];
    }
    return _actionSheetScrollView;
}

- (UIScrollView *)actionSheetButtonScrollView
{
    if (!_actionSheetButtonScrollView) {
        _actionSheetButtonScrollView = [UIScrollView new];
        _actionSheetButtonScrollView.backgroundColor = [UIColor clearColor];
        _actionSheetButtonScrollView.scrollsToTop = NO;
        [self.actionSheetView addSubview:_actionSheetButtonScrollView];
    }
    return _actionSheetButtonScrollView;
}

- (UILabel *)actionSheetTitleView
{
    if (!_actionSheetTitleView) {
        _actionSheetTitleView = [UILabel new];
        _actionSheetTitleView.textColor = [JVAlertControllerStyles actionSheetTitleColor];
        _actionSheetTitleView.textAlignment = [JVAlertControllerStyles actionSheetTitleTextAlignment];
        _actionSheetTitleView.numberOfLines = 0;
        [self.actionSheetScrollView addSubview:_actionSheetTitleView];
    }
    return _actionSheetTitleView;
}

- (UILabel *)actionSheetMessageView
{
    if (!_actionSheetMessageView) {
        _actionSheetMessageView = [UILabel new];
        _actionSheetMessageView.textColor = [JVAlertControllerStyles actionSheetMessageColor];
        _actionSheetMessageView.textAlignment = [JVAlertControllerStyles actionSheetMessageTextAlignment];
        _actionSheetMessageView.numberOfLines = 0;
        [self.actionSheetScrollView addSubview:_actionSheetMessageView];
    }
    return _actionSheetMessageView;
}

- (UIView *)actionSheetCancelButtonWrapperView
{
    if (!_actionSheetCancelButtonWrapperView) {
        _actionSheetCancelButtonWrapperView = [JVAlertControllerBackgroundView new];
        _actionSheetCancelButtonWrapperView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        _actionSheetCancelButtonWrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin
                                                                    | UIViewAutoresizingFlexibleRightMargin
                                                                    | UIViewAutoresizingFlexibleTopMargin);
        _actionSheetCancelButtonWrapperView.layer.cornerRadius = kJVActionSheetCancelButtonCornerRadius;
        _actionSheetCancelButtonWrapperView.layer.masksToBounds = YES;
    }
    return _actionSheetCancelButtonWrapperView;
}

// copy the JVAlertController implementation into UIAlertController's place on iOS 7
// adapted from Cédric Luthi's NSUUID project: https://github.com/0xced/NSUUID
+ (void)load
{
    if (objc_getClass("UIAlertController"))
    {
        return;
    }
    
    Class *UIAlertControllerClassRef = NULL;
#if TARGET_CPU_ARM
    __asm(
          "movw %0, :lower16:(L_OBJC_CLASS_UIAlertController-(LPC1+4))\n"
          "movt %0, :upper16:(L_OBJC_CLASS_UIAlertController-(LPC1+4))\n"
          "LPC1: add %0, pc" : "=r"(UIAlertControllerClassRef)
          );
#elif TARGET_CPU_ARM64
    __asm(
          "adrp %0, L_OBJC_CLASS_UIAlertController@PAGE\n"
          "add  %0, %0, L_OBJC_CLASS_UIAlertController@PAGEOFF" : "=r"(UIAlertControllerClassRef)
          );
#elif TARGET_CPU_X86_64
    __asm("leaq L_OBJC_CLASS_UIAlertController(%%rip), %0" : "=r"(UIAlertControllerClassRef));
#elif TARGET_CPU_X86
    void *pc = NULL;
    __asm(
          "calll L1\n"
          "L1: popl %0\n"
          "leal L_OBJC_CLASS_UIAlertController-L1(%0), %1" : "=r"(pc), "=r"(UIAlertControllerClassRef)
          );
#endif
    if (UIAlertControllerClassRef && *UIAlertControllerClassRef == Nil)
    {
        Class UIAlertControllerClass = objc_allocateClassPair(self, "UIAlertController", 0);
        if (UIAlertControllerClass) {
            objc_registerClassPair(UIAlertControllerClass);
            *UIAlertControllerClassRef = UIAlertControllerClass;
        }
    }
}

__asm(
#if defined(__OBJC2__) && __OBJC2__
      ".section        __DATA,__objc_classrefs,regular,no_dead_strip\n"
    #if	TARGET_RT_64_BIT
      ".align          3\n"
      "L_OBJC_CLASS_UIAlertController:\n"
      ".quad           _OBJC_CLASS_$_UIAlertController\n"
    #else
      ".align          2\n"
      "L_OBJC_CLASS_UIAlertController:\n"
      ".long           _OBJC_CLASS_$_UIAlertController\n"
    #endif
#else
      ".section        __TEXT,__cstring,cstring_literals\n"
      "L_OBJC_CLASS_NAME_UIAlertController:\n"
      ".asciz          \"UIAlertController\"\n"
      ".section        __OBJC,__cls_refs,literal_pointers,no_dead_strip\n"
      ".align          2\n"
      "L_OBJC_CLASS_UIAlertController:\n"
      ".long           L_OBJC_CLASS_NAME_UIAlertController\n"
#endif
      ".weak_reference _OBJC_CLASS_$_UIAlertController\n"
      );

#pragma mark - Alert View

- (void)createAlertView
{
    if (!self.isInPopover) {
        JVAlertControllerBackgroundView *bgView = [JVAlertControllerBackgroundView new];
        bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.alertView addSubview:bgView];
    }
    
    NSString *title = self.title ? self.title : self.message;
    NSString *message = self.title ? self.message : nil;
    
    if (title) {
        self.alertTitleView.text = title;
    }
    
    if (message) {
        self.alertMessageView.text = message;
    }
    
    NSMutableArray *textFields = [NSMutableArray new];
    NSMutableArray *textFieldWrappers = [NSMutableArray new];
    
    for (void (^configurationHandler)(UITextField *textField) in self.textFieldConfigurationHandlers) {
        JVAlertControllerTextField *field = [JVAlertControllerTextField new];
        configurationHandler(field.textField);
        [self.alertScrollView addSubview:field];
        
        [textFields addObject:field.textField];
        [textFieldWrappers addObject:field];
    }
    
    self.textFields = [textFields copy];
    self.textFieldWrappers = [textFieldWrappers copy];
    
    NSMutableArray *buttons = [NSMutableArray new];
    NSMutableArray *buttonSeparators = [NSMutableArray new];
    
    if ([self.actions count] > 0) {
        NSInteger i=0;
        
        for (UIAlertAction *action in self.actions) {
            
            if ([self.actions count] != 2 || i != 1) {
                UIView *buttonSeparator = [UIView new];
                buttonSeparator.backgroundColor = [JVAlertControllerStyles alertButtonSeparatorBackgroundColor];
                [self.alertButtonScrollView addSubview:buttonSeparator];
                [buttonSeparators addObject:buttonSeparator];
            }
                
            JVAlertControllerButton *button = [JVAlertControllerButton new];
            button.tag = i;
            button.enabled = action.isEnabled;
            button.highlightedBackgroundColor = [JVAlertControllerStyles alertButtonHighlightedBackgroundColor];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.minimumScaleFactor = kJVAlertButtonMinimumScaleFactor;
            [button setTitle:action.title forState:UIControlStateNormal];
            [button setContentEdgeInsets:UIEdgeInsetsMake(kJVAlertButtonVPaddingTop,
                                                          kJVAlertButtonHPadding,
                                                          kJVAlertButtonVPaddingBottom,
                                                          kJVAlertButtonHPadding)];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
            [buttons addObject:button];
            
            i++;
            
            if (UIAlertActionStyleDefault == action.style) {
                [button setTitleColor:[JVAlertControllerStyles alertButtonDefaultTextColor]
                             forState:UIControlStateNormal];
                [button setTitleColor:[JVAlertControllerStyles alertButtonDisabledTextColor]
                             forState:UIControlStateDisabled];
            }
            else if (UIAlertActionStyleDestructive == action.style) {
                [button setTitleColor:[JVAlertControllerStyles alertButtonDestructiveTextColor]
                             forState:UIControlStateNormal];
                [button setTitleColor:[JVAlertControllerStyles alertButtonDestructiveTextColor]
                             forState:UIControlStateDisabled]; // same color intentionally
            }
            else if (UIAlertActionStyleCancel == action.style) {
                [button setTitleColor:[JVAlertControllerStyles alertButtonCancelTextColor]
                             forState:UIControlStateNormal];
                [button setTitleColor:[JVAlertControllerStyles alertButtonDisabledTextColor]
                             forState:UIControlStateDisabled];
                self.cancelButtonPresent = YES;
            }
            
            [self.alertButtonScrollView addSubview:button];
        }
        
        self.buttons = [buttons copy];
        self.buttonSeparators = [buttonSeparators copy];
        
        if ([self.actions count] == 2) {
            self.buttonPairSeparator = [UIView new];
            self.buttonPairSeparator.backgroundColor = [JVAlertControllerStyles alertButtonSeparatorBackgroundColor];
            [self.alertButtonScrollView addSubview:self.buttonPairSeparator];
        }
    }
}

- (void)layoutAlertView
{
    CGFloat top = 0.0f;
    CGFloat left = 0.0f;
    
    NSString *title = self.title ? self.title : self.message;
    NSString *message = self.title ? self.message : nil;
    
    if (title) {
        top += kJVAlertContentVPadding;
        CGSize size = [self.alertTitleView sizeThatFits:CGSizeMake(kJVAlertWidth - 2*kJVAlertContentHPadding, 0.0f)];
        self.alertTitleView.frame = CGRectMake(kJVAlertContentHPadding,
                                               top,
                                               kJVAlertWidth - 2*kJVAlertContentHPadding,
                                               size.height);
        top = CGRectGetMaxY(self.alertTitleView.frame);
    }
    
    if (message) {
        CGSize size = [self.alertMessageView sizeThatFits:CGSizeMake(kJVAlertWidth - 2*kJVAlertContentHPadding, 0.0f)];
        self.alertMessageView.frame = CGRectMake(kJVAlertContentHPadding,
                                                 top,
                                                 kJVAlertWidth - 2*kJVAlertContentHPadding,
                                                 size.height);
        top = CGRectGetMaxY(self.alertMessageView.frame);
    }
    
    top += kJVAlertContentVPadding;
    
    for (JVAlertControllerTextField *textFieldWrapper in self.textFieldWrappers) {
        
        CGFloat textFieldWidth = kJVAlertWidth - 2*kJVAlertContentHPadding;
        CGSize size = [textFieldWrapper sizeThatFits:CGSizeMake(textFieldWidth, 0)];
        textFieldWrapper.frame = CGRectMake(kJVAlertContentHPadding, top, textFieldWidth, size.height);
        
        top = CGRectGetMaxY(textFieldWrapper.frame);
    }
    
    if ([self.textFieldConfigurationHandlers count] > 0) {
        top += kJVAlertContentTextFieldBottomPadding;
    }
    
    if (_alertScrollView) {
        self.alertScrollView.contentSize = CGSizeMake(kJVAlertWidth, top);
    }
    
    top = 0.0f;
    
    if ([self.actions count] > 0) {
        CGFloat buttonTop = top + JVAC_PIXEL;
        CGFloat buttonWidth = ([self.actions count] != 2) ? kJVAlertWidth : ceil(kJVAlertWidth / 2.0f);
        CGFloat buttonHeight = kJVAlertButtonHeight - JVAC_PIXEL;
        
        for (NSUInteger i=0; i<[self.actions count]; i++) {
            
            if ([self.actions count] != 2 || i != 1) {
                UIView *buttonSeparator = [self.buttonSeparators objectAtIndex:i];
                buttonSeparator.frame = CGRectMake(0.0f, top, kJVAlertWidth, JVAC_PIXEL);
                top = CGRectGetMaxY(buttonSeparator.frame);
            }
            
            JVAlertControllerButton *button = [self.buttons objectAtIndex:i];
            button.frame = CGRectMake(left, top, buttonWidth, buttonHeight);
            
            if ([self.actions count] == 2 && i == 0) {
                left = ceil(kJVAlertWidth / 2.0f) + JVAC_PIXEL;
            }
            else {
                top = CGRectGetMaxY(button.frame);
            }
        }
        
        if ([self.actions count] == 2) {
            self.buttonPairSeparator.frame = CGRectMake(left - JVAC_PIXEL,
                                                        buttonTop + JVAC_PIXEL,
                                                        JVAC_PIXEL,
                                                        buttonHeight);
        }
        
        self.alertButtonScrollView.contentSize = CGSizeMake(kJVAlertWidth, top);
    }
    
    [self updateAlertViewPosition];
}

- (void)updateAlertViewPosition
{
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds) - self.keyboardHeight;
    
    CGFloat alertButtonHeight = MIN(_alertButtonScrollView ? _alertButtonScrollView.contentSize.height : 0.0f,
                                    viewHeight);
    CGFloat alertContentHeight = MIN(_alertScrollView ? _alertScrollView.contentSize.height : 0.0f,
                                     viewHeight - alertButtonHeight);
    
    if (_alertScrollView) {
        self.alertScrollView.frame = CGRectMake(0.0f, 0.0f, kJVAlertWidth, alertContentHeight);
    }
    if (_alertButtonScrollView) {
        self.alertButtonScrollView.frame = CGRectMake(0.0f, alertContentHeight, kJVAlertWidth, alertButtonHeight);
    }
    
    self.alertView.frame = CGRectMake(0.0f, 0.0f, kJVAlertWidth, alertContentHeight + alertButtonHeight);
    
    self.alertView.center = CGPointMake(ceil(viewWidth / 2.0f), ceil(viewHeight / 2.0f));
}

- (void)performAction:(UIButton *)button
{
    NSInteger buttonIndex = button.tag;
    
    JVAlertAction *action = self.actions[buttonIndex];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (action.handler) {
            action.handler((UIAlertAction *)action);
        }
    }];
}

#pragma mark - Action Sheet View

- (void)createActionSheetView
{
    if (!self.isInPopover) {
        JVAlertControllerBackgroundView *bgView = [JVAlertControllerBackgroundView new];
        bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.actionSheetView addSubview:bgView];
    }
    
    NSString *title = self.title && self.message ? self.title : self.message;
    NSString *message = self.title && self.message ? self.message : self.title;
    
    if (title) {
        self.actionSheetTitleView.text = title;
    }
    
    if (message) {
        self.actionSheetMessageView.text = message;
    }
    
    if ([self.actions count] > 0) {
        
        NSInteger i=0;
        
        NSMutableArray *buttons = [NSMutableArray new];
        NSMutableArray *buttonSeparators = [NSMutableArray new];
        
        for (UIAlertAction *action in self.actions) {
            
            if ([self isPad] && UIAlertActionStyleCancel == action.style) {
                // cancel buttons for action sheets are ignored on iPad
                continue;
            }
            
            UIView *buttonSeparator = [UIView new];
            buttonSeparator.backgroundColor = [JVAlertControllerStyles actionSheetButtonSeparatorBackgroundColor];
            [self.actionSheetButtonScrollView addSubview:buttonSeparator];
            [buttonSeparators addObject:buttonSeparator];
            
            JVAlertControllerButton *button = [JVAlertControllerButton new];
            button.tag = i;
            button.enabled = action.isEnabled;
            button.highlightedBackgroundColor = [JVAlertControllerStyles actionSheetButtonHighlightedBackgroundColor];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.minimumScaleFactor = kJVActionSheetButtonMinimumScaleFactor;
            [button setTitle:action.title forState:UIControlStateNormal];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [button setContentEdgeInsets:UIEdgeInsetsMake(1.0f, 0.0f, 0.0f, 0.0f)];
            [button setContentEdgeInsets:UIEdgeInsetsMake(kJVActionSheetButtonVPaddingTop,
                                                          kJVActionSheetButtonHPadding,
                                                          kJVActionSheetButtonVPaddingBottom,
                                                          kJVActionSheetButtonHPadding)];
            [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [buttons addObject:button];
            
            i++;
            
            if (UIAlertActionStyleDefault == action.style) {
                [button setTitleColor:[JVAlertControllerStyles actionSheetButtonDefaultTextColor]
                             forState:UIControlStateNormal];
                [button setTitleColor:[JVAlertControllerStyles actionSheetButtonDisabledTextColor]
                             forState:UIControlStateDisabled];
            }
            else if (UIAlertActionStyleDestructive == action.style) {
                [button setTitleColor:[JVAlertControllerStyles actionSheetButtonDestructiveTextColor]
                             forState:UIControlStateNormal];
                [button setTitleColor:[JVAlertControllerStyles actionSheetButtonDestructiveTextColor]
                             forState:UIControlStateDisabled]; // same color intentionally
            }
            else if (UIAlertActionStyleCancel == action.style) {
                [button setTitleColor:[JVAlertControllerStyles actionSheetButtonCancelTextColor]
                             forState:UIControlStateNormal];
                [button setTitleColor:[JVAlertControllerStyles actionSheetButtonDisabledTextColor]
                             forState:UIControlStateDisabled];
                
                button.backgroundColor = [UIColor clearColor];
                button.highlightedBackgroundColor = [JVAlertControllerStyles
                                                     actionSheetCancelButtonHighlightedBackgroundColor];
                self.actionSheetCancelButton = button;
                self.cancelButtonPresent = YES;
                //cancel buttons get added at the end, not to the actionSheetView
                continue;
            }
            
            [self.actionSheetButtonScrollView addSubview:button];
        }
        
        if (self.actionSheetCancelButton) {
            [[buttonSeparators lastObject] removeFromSuperview];
            [buttonSeparators removeLastObject];
        }
        
        self.buttons = [buttons copy];
        self.buttonSeparators = [buttonSeparators copy];
    }
    
    if (self.actionSheetCancelButton) {
        if (1 == [self.actions count]) {
            [self.actionSheetButtonScrollView addSubview:self.actionSheetCancelButton];
        }
        else {
            self.actionSheetCancelButton.layer.cornerRadius = kJVActionSheetCancelButtonCornerRadius;
            self.actionSheetCancelButton.layer.masksToBounds = YES;
            [self.actionSheetCancelButtonWrapperView addSubview:self.actionSheetCancelButton];
            [self.view addSubview:self.actionSheetCancelButtonWrapperView];
        }
    }
    
    [self.actionSheetView bringSubviewToFront:self.actionSheetButtonScrollView];
}

- (void)layoutActionSheetView
{    
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    
    NSString *title = self.title && self.message ? self.title : self.message;
    NSString *message = self.title && self.message ? self.message : self.title;
    
    CGFloat top = 0.0f;
    
    if (title) {
        top = kJVActionSheetContentVPadding;
        CGSize size = [self.actionSheetTitleView sizeThatFits:
                       CGSizeMake(kJVActionSheetWidth - 2*kJVActionSheetContentHPadding, 0.0f)];
        self.actionSheetTitleView.frame = CGRectMake(kJVActionSheetContentHPadding,
                                                     top,
                                                     kJVActionSheetWidth - 2*kJVActionSheetContentHPadding,
                                                     size.height);
        top = CGRectGetMaxY(self.actionSheetTitleView.frame);
    }
    
    if (title && message) {
        top += kJVActionSheetTitleMessageVPadding;
    }
    
    if (message) {
        if (!title) {
            top += kJVActionSheetContentVPadding;
        }
        CGSize size = [self.actionSheetMessageView sizeThatFits:
                       CGSizeMake(kJVActionSheetWidth - 2*kJVActionSheetContentHPadding, 0.0f)];
        self.actionSheetMessageView.frame = CGRectMake(kJVActionSheetContentHPadding,
                                                       top,
                                                       kJVActionSheetWidth - 2*kJVActionSheetContentHPadding,
                                                       size.height);
        top = CGRectGetMaxY(self.actionSheetMessageView.frame);
    }
    
    top += kJVActionSheetContentVPadding;
    
    if (_actionSheetScrollView) {
        self.actionSheetScrollView.contentSize = CGSizeMake(kJVActionSheetWidth, top);
    }
    
    top = 0.0f;
    
    CGFloat buttonWidth = kJVActionSheetWidth;
    CGFloat buttonHeight = kJVActionSheetButtonHeight - JVAC_PIXEL;
    
    NSInteger i=0;
    
    for (UIView *buttonSeparator in self.buttonSeparators) {
        buttonSeparator.frame = CGRectMake(0.0f, i*kJVActionSheetButtonHeight, kJVActionSheetWidth, JVAC_PIXEL);
        i++;
    }
    
    if ([self.actions count] > 0) {
        
        i=0;
        
        NSInteger j=0;
        JVAlertControllerButton *button;
        
        for (UIAlertAction *action in self.actions) {
            if (UIAlertActionStyleCancel != action.style) {
                // cancel button added last
                button = [self.buttons objectAtIndex:i];
                button.frame = CGRectMake(0.0f, j*kJVActionSheetButtonHeight, buttonWidth, buttonHeight);
                j++;
            }
            i++;
        }
        
        if (self.actionSheetCancelButton) {
            if (![self isPad]) { // cancel buttons for action sheets are ignored on iPad
                self.actionSheetCancelButton.frame = CGRectMake(0.0f,
                                                                CGRectGetMaxY(button.frame),
                                                                buttonWidth,
                                                                buttonHeight);
                if ([self.actions count] == 1) {
                    button = self.actionSheetCancelButton;
                }
            }
        }
        
        self.actionSheetButtonScrollView.contentSize = CGSizeMake(kJVActionSheetWidth, CGRectGetMaxY(button.frame));
    }
    
    CGFloat cancelButtonSpace = 0.0f;
    CGFloat maxActionSheetHeight = self.isInPopover ? viewHeight : viewHeight - (2 * kJVActionSheetVMargin);
    CGFloat actionSheetViewSpacer = 0.0f;
    
    if (self.actionSheetCancelButton && [self.actions count] > 1) {
        
        actionSheetViewSpacer = kJVActionSheetVMargin;

        cancelButtonSpace = buttonHeight;
        if (!self.inPopover) {
            cancelButtonSpace += kJVActionSheetVMargin;
        }
        actionSheetViewSpacer += cancelButtonSpace;
        
        self.actionSheetCancelButtonWrapperView.frame = CGRectMake(ceil((viewWidth - buttonWidth) / 2.0f),
                                                                   viewHeight - cancelButtonSpace,
                                                                   buttonWidth,
                                                                   kJVActionSheetButtonHeight);
        
        maxActionSheetHeight -= cancelButtonSpace;
        
        self.actionSheetCancelButton.frame = CGRectMake(0.0f, 0.0f, buttonWidth, buttonHeight);
    }
    else {
        if (!self.inPopover) {
            viewHeight -= kJVActionSheetVMargin;
        }
    }
    
    CGFloat actionSheetButtonHeight =
    MIN(_actionSheetButtonScrollView ? _actionSheetButtonScrollView.contentSize.height : 0.0f, maxActionSheetHeight);
    
    CGFloat maxActionSheetContentHeight = maxActionSheetHeight - actionSheetButtonHeight;
    
    CGFloat actionSheetContentHeight =
    MIN(_actionSheetScrollView ? _actionSheetScrollView.contentSize.height : 0.0f, maxActionSheetContentHeight);
    
    if (_actionSheetScrollView) {
        self.actionSheetScrollView.frame = CGRectMake(0.0f, 0.0f, kJVActionSheetWidth, actionSheetContentHeight);
    }
    if (_actionSheetButtonScrollView) {
        self.actionSheetButtonScrollView.frame =
        CGRectMake(0.0f, actionSheetContentHeight, kJVActionSheetWidth, actionSheetButtonHeight);
    }
    
    CGFloat actionSheetHeight = actionSheetContentHeight + actionSheetButtonHeight;
    
    self.actionSheetView.frame =
    CGRectMake(ceil((viewWidth - kJVActionSheetWidth) / 2.0f),
               viewHeight - actionSheetViewSpacer - actionSheetHeight,
               kJVActionSheetWidth,
               actionSheetHeight);
}

@end
