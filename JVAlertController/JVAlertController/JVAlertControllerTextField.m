//
//  JVAlertControllerTextField.m
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

#import "JVAlertControllerStyles.h"
#import "JVAlertControllerTextField.h"

@interface JVAlertControllerTextField ()
@property (nonatomic, strong) UITextField * textField;
@end

@implementation JVAlertControllerTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [JVAlertControllerStyles alertTextFieldBorderColor].CGColor;
        self.layer.borderWidth = [JVAlertControllerStyles alertTextFieldBorderWidth];
        
        [self setFrame:frame];
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.font = [JVAlertControllerStyles alertTextFieldFont];
        [self addSubview:self.textField];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.textField.frame = CGRectMake(kJVAlertControllerTextFieldPadding + JVAC_PIXEL,
                                      kJVAlertControllerTextFieldPadding + JVAC_PIXEL,
                                      CGRectGetWidth(frame) - 2*(kJVAlertControllerTextFieldPadding+JVAC_PIXEL),
                                      CGRectGetHeight(frame) - 2*(kJVAlertControllerTextFieldPadding+JVAC_PIXEL));
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize fieldSize = [self.textField sizeThatFits:size];
    fieldSize.height += 2*kJVAlertControllerTextFieldPadding;
    return fieldSize;
}

@end
