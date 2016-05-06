//
//  UIView+GetImage.m
//  Teshehui
//
//  Created by RayXiang on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "UIView+GetImage.h"

@implementation UIView (GetImage)

- (UIImage *)getImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
