//
//  ViewController.m
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

#import "Config.h"
#import "TransparencyTestController.h"
#import "ViewController.h"

#define SYSTEM_VERSION_LT(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * sections;
@property (nonatomic, strong) NSArray * items;
@end

@implementation ViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(goInfo)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Credits"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(goCredits)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    if (SYSTEM_VERSION_LT(@"8.0")) {
        self.tableView.contentInset =
        UIEdgeInsetsMake(20.0f + CGRectGetHeight(self.navigationController.navigationBar.bounds), 0.0f, 0.0f, 0.0f);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.sections = @[@"Alert",
                      @"Action Sheet",
                      @"Transparency"];
    
    self.items = @[@[@"Title",
                     @"Message",
                     @"Title and Message",
                     @"1 Button",
                     @"1 Cancel Button",
                     @"2 Buttons",
                     @"3 Buttons",
                     @"10 Buttons",
                     @"20 Buttons",
                     @"1 Disabled Button",
                     @"Text Field, 1 Buttons",
                     @"2 Text Fields, 2 Buttons",
                     @"2 Text Fields, 10 Buttons",
                     @"10 Text Fields, 1 Buttons",
                     @"10 Text Fields, 10 Buttons",
                     @"Custom TextField",
                     @"Custom TextField w/bg image",
                     @"Hidden TextField",
                     @"Long Strings",
                     @"Empty String Title",
                     @"Empty String Message",
                     @"Empty String Title and Message",
                     @"Presenting Multiple Alerts (TODO)",
                     @"2 Cancel Buttons (Exception)"],
                   
                   @[@"Title",
                     @"Message",
                     @"Title and Message",
                     @"1 Button",
                     @"1 Cancel Button",
                     @"2 Buttons",
                     @"3 Buttons",
                     @"10 Buttons",
                     @"20 Buttons",
                     @"1 Disabled Button",
                     @"Long Strings",
                     @"Empty String Title",
                     @"Empty String Message",
                     @"Empty String Title and Message",
                     @"Presenting Multiple Action Sheets (TODO)",
                     @"2 Cancel Buttons (Exception)"],
                   
                   @[@"Transparency Tests"],
                   
                   ];
}

#pragma mark - UIAlertControllerStyleAlert Tests

- (void)showAlertWithTitle
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [alert show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:-1 animated:YES];
    });
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self closeAlert];
    });
#endif
}

- (void)showAlertWithMessage
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [alert show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:-1 animated:YES];
    });
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self closeAlert];
    });
#endif
}

- (void)showAlertWithTitleMessage
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [alert show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:-1 animated:YES];
    });
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self closeAlert];
    });
#endif
}

- (void)showAlertWithTitleMessageAnd1Buttons
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [self alertDoNothing];
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessageAnd1CancelButton
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessageAnd2Buttons
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessageAnd3Buttons
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", @"No", nil];
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"No"
                                              style:UIAlertActionStyleDestructive
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessageAnd10Buttons
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:
                          @"Button 1", @"Button 2", @"Button 3", @"Button 4", @"Button 5",
                          @"Button 6", @"Button 7", @"Button 8", @"Button 9", @"Button 10", nil];
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSUInteger i=0; i<10; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Button %lu", (unsigned long)i+1]
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessageAnd20Buttons
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:
                          @"Button 1", @"Button 2", @"Button 3", @"Button 4", @"Button 5",
                          @"Button 6", @"Button 7", @"Button 8", @"Button 9", @"Button 10",
                          @"Button 11", @"Button 12", @"Button 13", @"Button 14", @"Button 15",
                          @"Button 16", @"Button 17", @"Button 18", @"Button 19", @"Button 20", nil];
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSUInteger i=0; i<20; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Button %lu", (unsigned long)i+1]
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessageAnd1DisabledButtons
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Enabled"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    UIAlertAction *disabledAction = [UIAlertAction actionWithTitle:@"Disabled"
                                                             style:UIAlertActionStyleDefault
                                                           handler:nil];
    disabledAction.enabled = NO;
    [alert addAction:disabledAction];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessage1ButtonsAndTextField
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    UITextField *field = [alert textFieldAtIndex:0];
    field.placeholder = @"Name";
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessage2ButtonsAnd2TextFields
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Login", nil];
    UITextField *field1 = [alert textFieldAtIndex:0];
    field1.placeholder = @"Username";
    UITextField *field2 = [alert textFieldAtIndex:1];
    field2.placeholder = @"Password";
    field2.secureTextEntry = YES;
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Login"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Username";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password"; //for passwords
        textField.secureTextEntry = YES;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessage10ButtonsAnd2TextFields
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:
                          @"Button 1", @"Button 2", @"Button 3", @"Button 4", @"Button 5",
                          @"Button 6", @"Button 7", @"Button 8", @"Button 9", @"Button 10", nil];
    UITextField *field1 = [alert textFieldAtIndex:0];
    field1.placeholder = @"Username";
    UITextField *field2 = [alert textFieldAtIndex:1];
    field2.placeholder = @"Password";
    field2.secureTextEntry = YES;
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    for (NSUInteger i=0; i<10; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Button %lu", (unsigned long)i+1]
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Username";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password"; //for passwords
        textField.secureTextEntry = YES;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessage1ButtonsAnd10TextFields
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    for (NSUInteger i=0; i<10; i++) {
        UITextField *field1 = [alert textFieldAtIndex:i];
        field1.placeholder = [NSString stringWithFormat:@"Field %lu", (unsigned long)i+1];
    }
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    for (NSUInteger i=0; i<10; i++) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = [NSString stringWithFormat:@"Field %lu", (unsigned long)i+1];
        }];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessage10ButtonsAnd10TextFields
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:
                          @"Button 1", @"Button 2", @"Button 3", @"Button 4", @"Button 5",
                          @"Button 6", @"Button 7", @"Button 8", @"Button 9", @"Button 10", nil];
    for (NSUInteger i=0; i<10; i++) {
        UITextField *field1 = [alert textFieldAtIndex:i];
        field1.placeholder = [NSString stringWithFormat:@"Field %lu", (unsigned long)i+1];
    }
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    for (NSUInteger i=0; i<10; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Button %lu", (unsigned long)i+1]
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    for (NSUInteger i=0; i<10; i++) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = [NSString stringWithFormat:@"Field %lu", (unsigned long)i+1];
        }];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessageAndCustomTextField
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.placeholder = @"Custom TextField";
    textField.text = @"Text";
    textField.textColor = [UIColor greenColor];
    
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    CGFloat pointSize = descriptor.pointSize * 1.41176470588235f;
    textField.font = [UIFont fontWithDescriptor:descriptor size:pointSize];
    
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearsOnBeginEditing = YES;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.minimumFontSize = 18.0f;
//    textField.background = [UIImage imageNamed:@"bg"];
//    textField.disabledBackground = [UIImage imageNamed:@"bg"];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 1.0f)];
    textField.leftViewMode = UITextFieldViewModeWhileEditing;
    textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 1.0f)];
    textField.rightViewMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = [UIColor yellowColor];
    textField.alpha = 0.5f;
//    textField.hidden = YES;
    
    textField.layer.borderColor = [UIColor redColor].CGColor;
    textField.layer.borderWidth = 2.0f;
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Custom TextField";
        textField.text = @"Text";
        textField.textColor = [UIColor greenColor];
        
        UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
        CGFloat pointSize = descriptor.pointSize * 1.41176470588235f;
        textField.font = [UIFont fontWithDescriptor:descriptor size:pointSize];
        
        textField.textAlignment = NSTextAlignmentCenter;
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearsOnBeginEditing = YES;
        textField.adjustsFontSizeToFitWidth = YES;
        textField.minimumFontSize = 18.0f;
//        textField.background = [UIImage imageNamed:@"bg"];
//        textField.disabledBackground = [UIImage imageNamed:@"bg"];
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 1.0f)];
        textField.leftViewMode = UITextFieldViewModeWhileEditing;
        textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 1.0f)];
        textField.rightViewMode = UITextFieldViewModeWhileEditing;
        textField.backgroundColor = [UIColor yellowColor];
        textField.alpha = 0.5f;
//        textField.hidden = YES;
        
        textField.layer.borderColor = [UIColor redColor].CGColor;
        textField.layer.borderWidth = 2.0f;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessageAndCustomTextFieldWithBackgroundImage
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.placeholder = @"Custom TextField";
    textField.text = @"Text";
    textField.textColor = [UIColor greenColor];
    
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    CGFloat pointSize = descriptor.pointSize * 1.41176470588235f;
    textField.font = [UIFont fontWithDescriptor:descriptor size:pointSize];
    
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearsOnBeginEditing = YES;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.minimumFontSize = 18.0f;
    textField.background = [UIImage imageNamed:@"bg"];
    textField.disabledBackground = [UIImage imageNamed:@"bg"];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 1.0f)];
    textField.leftViewMode = UITextFieldViewModeWhileEditing;
    textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 1.0f)];
    textField.rightViewMode = UITextFieldViewModeWhileEditing;
    //    textField.backgroundColor = [UIColor yellowColor];
    textField.alpha = 0.5f;
    //    textField.hidden = YES;
    
    textField.layer.borderColor = [UIColor redColor].CGColor;
    textField.layer.borderWidth = 2.0f;
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Custom TextField";
        textField.text = @"Text";
        textField.textColor = [UIColor greenColor];
        
        UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
        CGFloat pointSize = descriptor.pointSize * 1.41176470588235f;
        textField.font = [UIFont fontWithDescriptor:descriptor size:pointSize];
        
        textField.textAlignment = NSTextAlignmentCenter;
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearsOnBeginEditing = YES;
        textField.adjustsFontSizeToFitWidth = YES;
        textField.minimumFontSize = 18.0f;
        textField.background = [UIImage imageNamed:@"bg"];
        textField.disabledBackground = [UIImage imageNamed:@"bg"];
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 1.0f)];
        textField.leftViewMode = UITextFieldViewModeWhileEditing;
        textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 1.0f)];
        textField.rightViewMode = UITextFieldViewModeWhileEditing;
        //        textField.backgroundColor = [UIColor yellowColor];
        textField.alpha = 0.5f;
        //        textField.hidden = YES;
        
        textField.layer.borderColor = [UIColor redColor].CGColor;
        textField.layer.borderWidth = 2.0f;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithTitleMessageAndHiddenTextField
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.placeholder = @"Custom TextField";
    textField.text = @"Text";
    textField.textColor = [UIColor greenColor];
    
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    CGFloat pointSize = descriptor.pointSize * 1.41176470588235f;
    textField.font = [UIFont fontWithDescriptor:descriptor size:pointSize];
    
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearsOnBeginEditing = YES;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.minimumFontSize = 18.0f;
//    textField.background = [UIImage imageNamed:@"bg"];
//    textField.disabledBackground = [UIImage imageNamed:@"bg"];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 1.0f)];
    textField.leftViewMode = UITextFieldViewModeWhileEditing;
    textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 1.0f)];
    textField.rightViewMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = [UIColor yellowColor];
    textField.alpha = 0.5f;
    textField.hidden = YES;
    
    textField.layer.borderColor = [UIColor redColor].CGColor;
    textField.layer.borderWidth = 2.0f;
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Custom TextField";
        textField.text = @"Text";
        textField.textColor = [UIColor greenColor];
        
        UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
        CGFloat pointSize = descriptor.pointSize * 1.41176470588235f;
        textField.font = [UIFont fontWithDescriptor:descriptor size:pointSize];
        
        textField.textAlignment = NSTextAlignmentCenter;
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearsOnBeginEditing = YES;
        textField.adjustsFontSizeToFitWidth = YES;
        textField.minimumFontSize = 18.0f;
//        textField.background = [UIImage imageNamed:@"bg"];
//        textField.disabledBackground = [UIImage imageNamed:@"bg"];
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 1.0f)];
        textField.leftViewMode = UITextFieldViewModeWhileEditing;
        textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 1.0f)];
        textField.rightViewMode = UITextFieldViewModeWhileEditing;
        textField.backgroundColor = [UIColor yellowColor];
        textField.alpha = 0.5f;
        textField.hidden = YES;
        
        textField.layer.borderColor = [UIColor redColor].CGColor;
        textField.layer.borderWidth = 2.0f;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithLongText
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas eu semper sem. Aenean semper sollicitudin facilisis. Praesent vel accumsan justo, id pulvinar enim. Maecenas et faucibus neque. Quisque pharetra bibendum augue, et ultricies elit interdum eget. Aliquam in libero sit amet metus condimentum faucibus eget vel tortor. Sed lobortis tortor nec augue gravida, eu tincidunt turpis sagittis. Etiam aliquam dolor a dignissim ultrices. Aliquam finibus vestibulum feugiat."
                                                    message:@"Praesent imperdiet quam sit amet lacus lacinia, venenatis dapibus quam cursus. Aenean blandit in neque vitae laoreet. In elementum libero nunc. Vestibulum arcu est, commodo et condimentum eu, lacinia ac lacus. Curabitur efficitur sem sit amet augue euismod, nec placerat odio eleifend. Ut ut ipsum quis tellus elementum sagittis. Nulla bibendum, elit at rhoncus vestibulum, urna turpis lobortis ligula, sed sagittis ipsum sapien at lacus. Duis faucibus ante ac ligula fermentum porttitor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Ut finibus mauris nulla, eget commodo orci semper sed. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Ut sit amet ante vel nibh tincidunt tristique. Fusce tincidunt tellus eu lacus placerat, vitae laoreet dui volutpat. Sed non elementum nulla.\n\nMaecenas feugiat metus in leo euismod molestie. Praesent suscipit, enim a pellentesque dapibus, quam tortor scelerisque risus, in blandit eros metus ornare neque. Morbi pharetra eget nisi nec molestie. Morbi vel facilisis ex, eu dapibus felis. Vivamus ornare quis lectus et egestas. Aenean at quam molestie, iaculis elit sed, faucibus nunc. Quisque nibh quam, molestie ac lacus a, venenatis facilisis tortor. Donec dapibus nisi et eros dictum, sit amet elementum diam aliquet. Etiam pellentesque placerat sodales. Proin suscipit semper posuere. Nullam ullamcorper elit vitae ullamcorper venenatis."
                                                   delegate:nil
                                          cancelButtonTitle:@"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit"
                                          otherButtonTitles:@"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit", @"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit", nil];
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas eu semper sem. Aenean semper sollicitudin facilisis. Praesent vel accumsan justo, id pulvinar enim. Maecenas et faucibus neque. Quisque pharetra bibendum augue, et ultricies elit interdum eget. Aliquam in libero sit amet metus condimentum faucibus eget vel tortor. Sed lobortis tortor nec augue gravida, eu tincidunt turpis sagittis. Etiam aliquam dolor a dignissim ultrices. Aliquam finibus vestibulum feugiat."
                                                                   message:@"Praesent imperdiet quam sit amet lacus lacinia, venenatis dapibus quam cursus. Aenean blandit in neque vitae laoreet. In elementum libero nunc. Vestibulum arcu est, commodo et condimentum eu, lacinia ac lacus. Curabitur efficitur sem sit amet augue euismod, nec placerat odio eleifend. Ut ut ipsum quis tellus elementum sagittis. Nulla bibendum, elit at rhoncus vestibulum, urna turpis lobortis ligula, sed sagittis ipsum sapien at lacus. Duis faucibus ante ac ligula fermentum porttitor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Ut finibus mauris nulla, eget commodo orci semper sed. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Ut sit amet ante vel nibh tincidunt tristique. Fusce tincidunt tellus eu lacus placerat, vitae laoreet dui volutpat. Sed non elementum nulla.\n\nMaecenas feugiat metus in leo euismod molestie. Praesent suscipit, enim a pellentesque dapibus, quam tortor scelerisque risus, in blandit eros metus ornare neque. Morbi pharetra eget nisi nec molestie. Morbi vel facilisis ex, eu dapibus felis. Vivamus ornare quis lectus et egestas. Aenean at quam molestie, iaculis elit sed, faucibus nunc. Quisque nibh quam, molestie ac lacus a, venenatis facilisis tortor. Donec dapibus nisi et eros dictum, sit amet elementum diam aliquet. Etiam pellentesque placerat sodales. Proin suscipit semper posuere. Nullam ullamcorper elit vitae ullamcorper venenatis."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit"
                                              style:UIAlertActionStyleDestructive
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithEmptyTitle
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithEmptyMessage
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showAlertWithEmptyTitleAndMessage
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showMultipleAlerts
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert 1"
                                                    message:@"Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Alert 2"
                                                     message:@"Message"
                                                    delegate:nil
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:nil];
    [alert2 show];
    
    
    UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"Alert 3"
                                                     message:@"Message"
                                                    delegate:nil
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:nil];
    [alert3 show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert 1"
                                                                   message:@"Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"Alert 2"
                                                                    message:@"Message"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    [alert2 addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];
    
    [self presentViewController:alert2 animated:YES completion:nil];
    
    UIAlertController *alert3 = [UIAlertController alertControllerWithTitle:@"Alert 3"
                                                                    message:@"Message"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    [alert3 addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];
    
    [self presentViewController:alert3 animated:YES completion:nil];
#endif
}

- (void)showAlertWith2CancelButtons
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Title"
                                                    message:@"My Message"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Cancel", nil];
    [alert show];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Close"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}


#pragma mark - UIAlertControllerStyleActionSheet Tests

- (void)showActionSheetWithTitleFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"My Title"
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [actionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    });
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self closeAlert];
    });
#endif
}

- (void)showActionSheetWithMessageFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"My Title"
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [actionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    });
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self closeAlert];
    });
#endif
}

- (void)showActionSheetWithTitleMessageFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"My Title"
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [actionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    });
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self closeAlert];
    });
#endif
}

- (void)showActionSheetWithTitleMessageAnd1ButtonsFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"My Title"
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"OK", nil];
    [actionSheet showInView:self.view];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [self actionSheetDoNothing];
                                            }]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showActionSheetWithTitleMessageAnd1CancelButtonFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"My Title"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showActionSheetWithTitleMessageAnd2ButtonsFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"My Title"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"OK", nil];
    [actionSheet showInView:self.view];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showActionSheetWithTitleMessageAnd3ButtonsFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"My Title"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"No"
                                                    otherButtonTitles:@"Yes", nil];
    [actionSheet showInView:self.view];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"No"
                                              style:UIAlertActionStyleDestructive
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showActionSheetWithTitleMessageAnd10ButtonsFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"My Title"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  @"Button 1", @"Button 2", @"Button 3", @"Button 4", @"Button 5",
                                  @"Button 6", @"Button 7", @"Button 8", @"Button 9", @"Button 10", nil];
    [actionSheet showInView:self.view];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSUInteger i=0; i<10; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Button %lu", (unsigned long)i+1]
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showActionSheetWithTitleMessageAnd20ButtonsFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"My Title"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  @"Button 1", @"Button 2", @"Button 3", @"Button 4", @"Button 5",
                                  @"Button 6", @"Button 7", @"Button 8", @"Button 9", @"Button 10",
                                  @"Button 11", @"Button 12", @"Button 13", @"Button 14", @"Button 15",
                                  @"Button 16", @"Button 17", @"Button 18", @"Button 19", @"Button 20", nil];
    [actionSheet showInView:self.view];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSUInteger i=0; i<20; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Button %lu", (unsigned long)i+1]
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showActionSheetWithTitleMessageAnd1DisabledButtonsFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"My Title"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Enabled"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    UIAlertAction *disabledAction = [UIAlertAction actionWithTitle:@"Disabled"
                                                             style:UIAlertActionStyleDefault
                                                           handler:nil];
    disabledAction.enabled = NO;
    [alert addAction:disabledAction];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showActionSheetWithLongTextFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas eu semper sem. Aenean semper sollicitudin facilisis. Praesent vel accumsan justo, id pulvinar enim. Maecenas et faucibus neque. Quisque pharetra bibendum augue, et ultricies elit interdum eget. Aliquam in libero sit amet metus condimentum faucibus eget vel tortor. Sed lobortis tortor nec augue gravida, eu tincidunt turpis sagittis. Etiam aliquam dolor a dignissim ultrices. Aliquam finibus vestibulum feugiat."
                                                             delegate:nil
                                                    cancelButtonTitle:@"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit"
                                               destructiveButtonTitle:@"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit"
                                                    otherButtonTitles:@"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit", nil];
    [actionSheet showInView:self.view];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas eu semper sem. Aenean semper sollicitudin facilisis. Praesent vel accumsan justo, id pulvinar enim. Maecenas et faucibus neque. Quisque pharetra bibendum augue, et ultricies elit interdum eget. Aliquam in libero sit amet metus condimentum faucibus eget vel tortor. Sed lobortis tortor nec augue gravida, eu tincidunt turpis sagittis. Etiam aliquam dolor a dignissim ultrices. Aliquam finibus vestibulum feugiat."
                                                                   message:@"Praesent imperdiet quam sit amet lacus lacinia, venenatis dapibus quam cursus. Aenean blandit in neque vitae laoreet. In elementum libero nunc. Vestibulum arcu est, commodo et condimentum eu, lacinia ac lacus. Curabitur efficitur sem sit amet augue euismod, nec placerat odio eleifend. Ut ut ipsum quis tellus elementum sagittis. Nulla bibendum, elit at rhoncus vestibulum, urna turpis lobortis ligula, sed sagittis ipsum sapien at lacus. Duis faucibus ante ac ligula fermentum porttitor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Ut finibus mauris nulla, eget commodo orci semper sed. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Ut sit amet ante vel nibh tincidunt tristique. Fusce tincidunt tellus eu lacus placerat, vitae laoreet dui volutpat. Sed non elementum nulla.\n\nMaecenas feugiat metus in leo euismod molestie. Praesent suscipit, enim a pellentesque dapibus, quam tortor scelerisque risus, in blandit eros metus ornare neque. Morbi pharetra eget nisi nec molestie. Morbi vel facilisis ex, eu dapibus felis. Vivamus ornare quis lectus et egestas. Aenean at quam molestie, iaculis elit sed, faucibus nunc. Quisque nibh quam, molestie ac lacus a, venenatis facilisis tortor. Donec dapibus nisi et eros dictum, sit amet elementum diam aliquet. Etiam pellentesque placerat sodales. Proin suscipit semper posuere. Nullam ullamcorper elit vitae ullamcorper venenatis."
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit"
                                              style:UIAlertActionStyleDestructive
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showActionSheetWithEmptyTitleFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showActionSheetWithEmptyMessageFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"My Title"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showActionSheetWithEmptyTitleAndMessageFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)showMultipleActionSheetsFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sheet 1"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Button 1", @"Button 2", nil];
    [actionSheet showInView:self.view];
    UIActionSheet *actionSheet2 = [[UIActionSheet alloc] initWithTitle:@"Sheet 2"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Button 1", @"Button 2", nil];
    [actionSheet2 showInView:self.view];
    UIActionSheet *actionSheet3 = [[UIActionSheet alloc] initWithTitle:@"Sheet 3"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Button 1", @"Button 2", nil];
    [actionSheet3 showInView:self.view];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sheet 1"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Button 1"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Button 2"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"Sheet 2"
                                                                    message:@""
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    [alert2 addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];
    [alert2 addAction:[UIAlertAction actionWithTitle:@"Button 1"
                                               style:UIAlertActionStyleDefault
                                             handler:nil]];
    [alert2 addAction:[UIAlertAction actionWithTitle:@"Button 2"
                                               style:UIAlertActionStyleDefault
                                             handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert2 popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert2 animated:YES completion:nil];
    
    UIAlertController *alert3 = [UIAlertController alertControllerWithTitle:@"Sheet 3"
                                                                    message:@""
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    [alert3 addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];
    [alert3 addAction:[UIAlertAction actionWithTitle:@"Button 1"
                                               style:UIAlertActionStyleDefault
                                             handler:nil]];
    [alert3 addAction:[UIAlertAction actionWithTitle:@"Button 2"
                                               style:UIAlertActionStyleDefault
                                             handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert3 popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert3 animated:YES completion:nil];
#endif
}

- (void)showActionSheetWith2CancelButtonsFromCell:(UITableViewCell *)cell
{
#if USE_SYSTEM_IOS7_IMPLEMENTATION
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"My Title"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Cancel", nil];
    [actionSheet showInView:self.view];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Title"
                                                                   message:@"My Message"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Close"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

#pragma mark - Info/Credits

- (void)goInfo
{
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Info"
                                        message:@"JVAlertController is an API-compatible backport of UIAlertController for iOS 7."
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Github"
                                              style:UIAlertActionStyleDefault
                                            handler:
                      ^(UIAlertAction * action) {
                          [[UIApplication sharedApplication] openURL:
                           [NSURL URLWithString:@"http://www.github.com/jverdi/JVAlertController"]];
                      }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.barButtonItem = self.navigationItem.leftBarButtonItem;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)goCredits
{
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Credits"
                                        message:@"Created By Jared Verdi\n\nEmail: jared@jaredverdi.com\nTwitter: @jverdi"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Twitter"
                                              style:UIAlertActionStyleDefault
                                            handler:
                      ^(UIAlertAction * action) {
                          [[UIApplication sharedApplication] openURL:
                           [NSURL URLWithString:@"http://www.twitter.com/jverdi"]];
                      }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    if ([self isPad]) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.barButtonItem = self.navigationItem.rightBarButtonItem;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Utility Methods

- (BOOL)isPad
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

- (void)closeAlert
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertDoNothing
{
    NSLog(@"hit alertDoNothing");
}

- (void)actionSheetDoNothing
{
    NSLog(@"hit alertDoNothing");
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section < [self.items count] ? [self.items[section] count] : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sections[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * TableViewCellIdentifier = @"TableViewCellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:TableViewCellIdentifier];
    }
    cell.textLabel.text = self.items[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        switch (indexPath.row) {
            case 0: [self showAlertWithTitle]; break;
            case 1: [self showAlertWithMessage]; break;
            case 2: [self showAlertWithTitleMessage]; break;
            case 3: [self showAlertWithTitleMessageAnd1Buttons]; break;
            case 4: [self showAlertWithTitleMessageAnd1CancelButton]; break;
            case 5: [self showAlertWithTitleMessageAnd2Buttons]; break;
            case 6: [self showAlertWithTitleMessageAnd3Buttons]; break;
            case 7: [self showAlertWithTitleMessageAnd10Buttons]; break;
            case 8: [self showAlertWithTitleMessageAnd20Buttons]; break;
            case 9: [self showAlertWithTitleMessageAnd1DisabledButtons]; break;
            case 10: [self showAlertWithTitleMessage1ButtonsAndTextField]; break;
            case 11: [self showAlertWithTitleMessage2ButtonsAnd2TextFields]; break;
            case 12: [self showAlertWithTitleMessage10ButtonsAnd2TextFields]; break;
            case 13: [self showAlertWithTitleMessage1ButtonsAnd10TextFields]; break;
            case 14: [self showAlertWithTitleMessage10ButtonsAnd10TextFields]; break;
            case 15: [self showAlertWithTitleMessageAndCustomTextField]; break;
            case 16: [self showAlertWithTitleMessageAndCustomTextFieldWithBackgroundImage]; break;
            case 17: [self showAlertWithTitleMessageAndHiddenTextField]; break;
            case 18: [self showAlertWithLongText]; break;
            case 19: [self showAlertWithEmptyTitle]; break;
            case 20: [self showAlertWithEmptyMessage]; break;
            case 21: [self showAlertWithEmptyTitleAndMessage]; break;
            case 22: [self showMultipleAlerts]; break;
            case 23: [self showAlertWith2CancelButtons]; break;
        }
    }
    else if (1 == indexPath.section) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 0: [self showActionSheetWithTitleFromCell:cell]; break;
            case 1: [self showActionSheetWithMessageFromCell:cell]; break;
            case 2: [self showActionSheetWithTitleMessageFromCell:cell]; break;
            case 3: [self showActionSheetWithTitleMessageAnd1ButtonsFromCell:cell]; break;
            case 4: [self showActionSheetWithTitleMessageAnd1CancelButtonFromCell:cell]; break;
            case 5: [self showActionSheetWithTitleMessageAnd2ButtonsFromCell:cell]; break;
            case 6: [self showActionSheetWithTitleMessageAnd3ButtonsFromCell:cell]; break;
            case 7: [self showActionSheetWithTitleMessageAnd10ButtonsFromCell:cell]; break;
            case 8: [self showActionSheetWithTitleMessageAnd20ButtonsFromCell:cell]; break;
            case 9: [self showActionSheetWithTitleMessageAnd1DisabledButtonsFromCell:cell]; break;
            case 10: [self showActionSheetWithLongTextFromCell:cell]; break;
            case 11: [self showActionSheetWithEmptyTitleFromCell:cell]; break;
            case 12: [self showActionSheetWithEmptyMessageFromCell:cell]; break;
            case 13: [self showActionSheetWithEmptyTitleAndMessageFromCell:cell]; break;
            case 14: [self showMultipleActionSheetsFromCell:cell]; break;
            case 15: [self showActionSheetWith2CancelButtonsFromCell:cell]; break;
        }
    }
    else if (2 == indexPath.section) {
        TransparencyTestController *vc = [TransparencyTestController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
