//
//  HPFolderAnimation.h
//  FolderTableView
//
//  Created by Hu, Peng on 11/9/15.
//  Copyright © 2015 Hu, Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HPFolderAnimationPush,
    HPFolderAnimationPop
} HPFolderAnimationType;

@interface HPFolderAnimation : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithView:(UIView *)view;

@property (nonatomic, assign) CGRect anchorFrame;
@property (nonatomic, assign) HPFolderAnimationType type;

@end
