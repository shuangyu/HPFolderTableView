//
//  UIView+ViewExt.h
//  FolderTableView
//
//  Created by Hu, Peng on 11/9/15.
//  Copyright © 2015 Hu, Peng. All rights reserved.
//

typedef enum {
    UIViewAnchorPointDimensionX,
    UIViewAnchorPointDimensionY
} UIViewAnchorPointDimension;

#import <UIKit/UIKit.h>

@interface UIView (ViewExt)

@end

@interface UIView (ImageExt)

- (UIImageView *)clip:(CGRect)rect;

- (NSArray *)clipWithAnchorPoint:(NSArray *)anchorPoints
                     inDimension:(UIViewAnchorPointDimension)dimension;

@end
