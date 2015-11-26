//
//  UIView+ViewExt.m
//  FolderTableView
//
//  Created by Hu, Peng on 11/9/15.
//  Copyright © 2015 Hu, Peng. All rights reserved.
//

#import "UIView+ViewExt.h"

@implementation UIView (ViewExt)

@end

@implementation UIView (ImageExt)

- (UIImageView *)clip:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [[UIImageView alloc] initWithImage:image];
}

- (NSArray *)clipWithAnchorPoint:(NSArray *)anchorPoints inDimension:(UIViewAnchorPointDimension)dimension
{
    if (!anchorPoints || anchorPoints.count < 1) {
        return @[self];
    }
    
    NSMutableArray *_anchorPoints =  [anchorPoints mutableCopy];
    if (![_anchorPoints containsObject:@(1.0)]) {
        [_anchorPoints addObject:@(1.0)];
    }
    if ([_anchorPoints containsObject:@(0.0)]) {
        [_anchorPoints removeObject:@(0.0)];
    }
    
    NSMutableArray *fragments = [[NSMutableArray alloc] initWithCapacity:anchorPoints.count];
    
    float w = CGRectGetWidth(self.bounds);
    float h = CGRectGetHeight(self.bounds);
    float cursor = 0;
    
    if (dimension == UIViewAnchorPointDimensionX) {
        
        for (int i = 0; i < _anchorPoints.count; i++) {
            
            float nextCursor = [_anchorPoints[i] floatValue];
            nextCursor = MIN(nextCursor, 1.0);
            
            float fragmentWidth = (nextCursor - cursor) * w;
            if (fragmentWidth <= 0) {
                break;
            }
            
            CGRect frame = CGRectMake(cursor * w, 0, fragmentWidth, h);
            [fragments addObject:[self clip:frame]];
            
            cursor = nextCursor;
        }
    } else if (dimension == UIViewAnchorPointDimensionY) {
        for (int i = 0; i < _anchorPoints.count; i++) {
            
            float nextCursor = [_anchorPoints[i] floatValue];
            nextCursor = MIN(nextCursor, 1.0);
            
            float fragmentHeight = (nextCursor - cursor) * h;
            if (fragmentHeight <= 0) {
                break;
            }
            
            CGRect frame = CGRectMake(0, cursor * h, w, fragmentHeight);
            [fragments addObject:[self clip:frame]];
            
            cursor = nextCursor;
        }
    }
    return fragments;
}
@end