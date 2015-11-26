//
//  HPFolderAnimation.m
//  FolderTableView
//
//  Created by Hu, Peng on 11/9/15.
//  Copyright © 2015 Hu, Peng. All rights reserved.
//

#import "HPFolderAnimation.h"
#import "UIView+ViewExt.h"

@interface HPFolderAnimation ()
{
    UIView *_realView;
    
    UIImageView *_clippedTopView;
    UIImageView *_clippedBottomView;
    
    CGRect _topViewFrame;
    CGRect _bottomViewFrame;
}
@end

@implementation HPFolderAnimation

- (instancetype)initWithView:(UIView *)view
{
    if (self = [super init]) {
        _realView = view;
    }
    return self;
}

- (void)setAnchorFrame:(CGRect)anchorFrame
{
    if (CGRectEqualToRect(anchorFrame, _anchorFrame)) {
        return;
    }
    _anchorFrame = anchorFrame;
    float dY = CGRectGetMaxY(_anchorFrame);
    
    _topViewFrame = CGRectMake(0, 0, CGRectGetWidth(_realView.bounds), dY);
    _bottomViewFrame = CGRectMake(0, dY, CGRectGetWidth(_realView.bounds), CGRectGetHeight(_realView.bounds) - dY);
    
    _clippedTopView = [_realView clip:_topViewFrame];
    _clippedTopView.frame = _topViewFrame;
    
    _clippedBottomView = [_realView clip:_bottomViewFrame];
    _clippedBottomView.frame = _bottomViewFrame;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
    
    if (self.type == HPFolderAnimationPush) {
        
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        fromViewController.view.alpha = 0.0;
        
        [containerView addSubview:_clippedTopView];
        [containerView addSubview:_clippedBottomView];
        
        CGRect topViewToFrame = CGRectMake(0, -CGRectGetHeight(_topViewFrame), CGRectGetWidth(_topViewFrame), CGRectGetHeight(_topViewFrame));
        CGRect bottomViewToFrame = CGRectMake(0, CGRectGetHeight(_realView.bounds), CGRectGetWidth(_bottomViewFrame), CGRectGetHeight(_bottomViewFrame));
        [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
           
            _clippedTopView.frame = topViewToFrame;
            _clippedBottomView.frame = bottomViewToFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [_clippedBottomView removeFromSuperview];
            [_clippedTopView removeFromSuperview];
            fromViewController.view.alpha = 1.0;
        }];
        
    } else if (self.type == HPFolderAnimationPop) {
        
        //Add 'to' view to the hierarchy
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        toViewController.view.alpha = 0.0;
        
        [containerView addSubview:_clippedTopView];
        [containerView addSubview:_clippedBottomView];
        
        [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _clippedTopView.frame = _topViewFrame;
            _clippedBottomView.frame = _bottomViewFrame;
        } completion:^(BOOL finished) {
            toViewController.view.alpha = 1.0;
            [_clippedBottomView removeFromSuperview];
            [_clippedTopView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

@end
