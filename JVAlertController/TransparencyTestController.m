//
//  TransparencyTestController.m
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

@implementation TransparencyTestController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_pattern"]];
    bgView.frame = self.view.bounds;
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgView];
    
    CGFloat buttonSpacing = 10.0f;
    CGFloat buttonWidth = floorf((CGRectGetWidth(self.view.bounds) - (3 * buttonSpacing)) / 2.0f);
    CGFloat buttonHeight = 44.0f;
    
    UIButton *alertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    alertButton.frame = CGRectMake(buttonSpacing,
                                   CGRectGetHeight(self.view.bounds) - buttonSpacing - buttonHeight,
                                   buttonWidth,
                                   buttonHeight);
    alertButton.backgroundColor = [UIColor blackColor];
    alertButton.layer.cornerRadius = 4.0f;
    alertButton.layer.masksToBounds = YES;
    [alertButton setTitle:@"Show Alert" forState:UIControlStateNormal];
    [alertButton addTarget:self action:@selector(showAlertTest)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertButton];
    
    UIButton *actionSheetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    actionSheetButton.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - buttonSpacing - buttonWidth,
                                         CGRectGetHeight(self.view.bounds) - buttonSpacing - buttonHeight,
                                         buttonWidth,
                                         buttonHeight);
    actionSheetButton.backgroundColor = [UIColor blackColor];
    actionSheetButton.layer.cornerRadius = 4.0f;
    actionSheetButton.layer.masksToBounds = YES;
    [actionSheetButton setTitle:@"Show Action Sheet" forState:UIControlStateNormal];
    [actionSheetButton addTarget:self action:@selector(showActionSheetTestFromButton:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:actionSheetButton];
}

- (void)showAlertTest
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

- (void)showActionSheetTestFromButton:(UIButton *)button
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
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = button;
        popPresenter.sourceRect = button.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

@end
