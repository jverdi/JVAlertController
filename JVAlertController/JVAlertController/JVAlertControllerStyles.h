//
//  JVAlertControllerStyles.h
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

#import <UIKit/UIKit.h>

#define JVAC_PIXEL (1.0f/[[UIScreen mainScreen] scale])

extern const CGFloat kJVAlertWidth;
extern const CGFloat kJVAlertCornerRadius;
extern const CGFloat kJVAlertButtonHeight;
extern const CGFloat kJVAlertButtonHPadding;
extern const CGFloat kJVAlertButtonVPaddingTop;
extern const CGFloat kJVAlertButtonVPaddingBottom;
extern const CGFloat kJVAlertButtonMinimumScaleFactor;
extern const CGFloat kJVAlertContentHPadding;
extern const CGFloat kJVAlertContentVPadding;
extern const CGFloat kJVAlertContentTextFieldBottomPadding;
extern const CGFloat kJVAlertObscureViewAlpha;
extern const CGFloat kJVAlertAnimationDuration;
extern const CGFloat kJVAlertAnimationSpringDamping;
extern const CGFloat kJVAlertAnimationStartingScale;
extern const CGFloat kJVAlertAnimationEndingScale; //ios7 only

extern const CGFloat kJVActionSheetWidth;
extern const CGFloat kJVActionSheetPopoverWidth;
extern const CGFloat kJVActionSheetCornerRadius;
extern const CGFloat kJVActionSheetCancelButtonCornerRadius;
extern const CGFloat kJVActionSheetButtonHeight;
extern const CGFloat kJVActionSheetButtonHPadding;
extern const CGFloat kJVActionSheetButtonVPaddingTop;
extern const CGFloat kJVActionSheetButtonVPaddingBottom;
extern const CGFloat kJVActionSheetButtonMinimumScaleFactor;
extern const CGFloat kJVActionSheetTitleMessageVPadding;
extern const CGFloat kJVActionSheetContentHPadding;
extern const CGFloat kJVActionSheetContentVPadding;
extern const CGFloat kJVActionSheetVMargin;
extern const CGFloat kJVActionSheetObscureViewAlpha;
extern const CGFloat kJVActionSheetObscureViewAlphaPad;
extern const CGFloat kJVActionSheetAnimationDuration;

extern const CGFloat kJVAlertControllerTextFieldPadding;

@interface JVAlertControllerStyles : NSObject

+ (UIColor *)alertTitleColor;
+ (UIFont *)alertTitleFont;
+ (NSTextAlignment)alertTitleTextAlignment;
+ (UIColor *)alertMessageColor;
+ (UIFont *)alertMessageFont;
+ (NSTextAlignment)alertMessageTextAlignment;
+ (UIColor *)alertButtonSeparatorBackgroundColor;
+ (UIColor *)alertButtonHighlightedBackgroundColor;
+ (UIColor *)alertButtonDefaultTextColor;
+ (UIColor *)alertButtonDisabledTextColor;
+ (UIColor *)alertButtonDestructiveTextColor;
+ (UIColor *)alertButtonCancelTextColor;
+ (UIFont *)alertButtonFont;
+ (UIFont *)alertLastButtonFont;
+ (UIColor *)alertTextFieldBorderColor;
+ (CGFloat)alertTextFieldBorderWidth;
+ (UIFont *)alertTextFieldFont;
+ (UIColor *)alertObscureViewBackgroundColor;

+ (UIColor *)actionSheetTitleColor;
+ (UIFont *)actionSheetTitleFont;
+ (NSTextAlignment)actionSheetTitleTextAlignment;
+ (UIColor *)actionSheetMessageColor;
+ (UIFont *)actionSheetMessageFont;
+ (NSTextAlignment)actionSheetMessageTextAlignment;
+ (UIColor *)actionSheetButtonSeparatorBackgroundColor;
+ (UIColor *)actionSheetButtonHighlightedBackgroundColor;
+ (UIColor *)actionSheetButtonDefaultTextColor;
+ (UIColor *)actionSheetButtonDisabledTextColor;
+ (UIColor *)actionSheetButtonDestructiveTextColor;
+ (UIColor *)actionSheetButtonCancelTextColor;
+ (UIFont *)actionSheetButtonFont;
+ (UIFont *)actionSheetCancelButtonFont;
+ (UIColor *)actionSheetCancelButtonHighlightedBackgroundColor;
+ (UIColor *)actionSheetObscureViewBackgroundColor;

@end
