//
//  UIImage+ResizableUtil.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-6-3.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "UIImage+ResizableUtil.h"

@implementation UIImage (ResizableUtil)

- (UIImage *)utilResizableImageWithCapInsets:(UIEdgeInsets)capInsets
{
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)])
    {
        return [self resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    } else {
        return [self resizableImageWithCapInsets:capInsets];
    }
}

@end
