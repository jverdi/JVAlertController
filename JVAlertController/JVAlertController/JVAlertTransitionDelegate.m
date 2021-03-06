//
//  JVAlertTransitionDelegate.m
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
#import "JVAlertTransitionDelegate.h"

@interface JVAlertTransitionDelegate ()
@property (nonatomic, assign, getter=isPresenting) BOOL presenting;
@property (nonatomic, strong) UIView *obscureView;
@end

@implementation JVAlertTransitionDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.presenting = YES;
    
    if (!self.obscureView) {
        self.obscureView = [UIView new];
        self.obscureView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.obscureView.backgroundColor = [JVAlertControllerStyles alertObscureViewBackgroundColor];
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presenting = NO;
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:
    (id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:
    (id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return kJVAlertAnimationDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *fromViewController =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *toView = toViewController.view;
    UIView *fromView = fromViewController.view;
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    __weak typeof(self) weakSelf = self;
    
    if (self.isPresenting) {
        if (fromViewController.navigationController) {
            fromViewController.navigationController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        }
        fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        
        self.obscureView.frame = toView.bounds;
        
        toView.frame = [self rectForPresentedState:transitionContext];
        
        CGAffineTransform startingTransform = toView.transform;
        toView.transform = CGAffineTransformScale(toView.transform,
                                                  kJVAlertAnimationStartingScale,
                                                  kJVAlertAnimationStartingScale);
        
        self.obscureView.alpha = 0.0f;
        
        [[transitionContext containerView] addSubview:fromView];
        [[transitionContext containerView] addSubview:self.obscureView];
        [[transitionContext containerView] addSubview:toView];
        
        [UIView animateWithDuration:duration
                              delay:0.0f
             usingSpringWithDamping:kJVAlertAnimationSpringDamping
              initialSpringVelocity:0
                            options:0
                         animations:
         ^{
             toView.transform = startingTransform;
             weakSelf.obscureView.alpha = kJVAlertObscureViewAlpha;
         }
                         completion:
         ^(BOOL finished) {
             [transitionContext completeTransition:YES];
         }];
    }
    else {
        if (toViewController.navigationController) {
            toViewController.navigationController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        }
        toView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        
        [[transitionContext containerView] addSubview:toView];
        [[transitionContext containerView] addSubview:self.obscureView];
        [[transitionContext containerView] addSubview:fromView];
        
        [UIView animateWithDuration:duration
                              delay:0.0f
             usingSpringWithDamping:kJVAlertAnimationSpringDamping
              initialSpringVelocity:0
                            options:0
                         animations:
         ^{
             fromView.transform = CGAffineTransformScale(fromView.transform,
                                                         kJVAlertAnimationEndingScale,
                                                         kJVAlertAnimationEndingScale);
             fromView.alpha = 0.0f;
             weakSelf.obscureView.alpha = 0.0f;
         }
                         completion:
         ^(BOOL finished) {
             [transitionContext completeTransition:YES];
         }];
    }
}

- (CGRect)rectForDismissedState:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *controller = nil;
    
    if (self.isPresenting) {
        controller = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    else {
        controller = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    UIView *containerView = [transitionContext containerView];
    
    CGRect frame = CGRectZero;
    CGFloat w = CGRectGetWidth(containerView.bounds);
    CGFloat h = CGRectGetHeight(containerView.bounds);
    
    switch (controller.interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return CGRectMake(w, 0.0f, w, h);
            
        case UIInterfaceOrientationLandscapeRight:
            return CGRectMake(-w, 0.0f, w, h);
            
        case UIInterfaceOrientationPortrait:
            return CGRectMake(0.0f, h, w, h);
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGRectMake(0.0f, -h, w, h);
            
        default:
            return frame;
    }
}

- (CGRect)rectForPresentedState:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *controller = nil;
    
    if (self.isPresenting) {
        controller = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    else {
        controller = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    UIView *containerView = [transitionContext containerView];
    
    CGRect frame = [self rectForDismissedState:transitionContext];
    CGFloat w = CGRectGetWidth(containerView.bounds);
    CGFloat h = CGRectGetHeight(containerView.bounds);
    
    switch (controller.interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return CGRectOffset(frame, -1.0f * w, 0.0f);
            
        case UIInterfaceOrientationLandscapeRight:
            return CGRectOffset(frame, w, 0.0f);
            
        case UIInterfaceOrientationPortrait:
            return CGRectOffset(frame, 0.0f, -1.0f * h);
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGRectOffset(frame, 0.0f, h);
            
        default:
            return frame;
    }
}

@end
