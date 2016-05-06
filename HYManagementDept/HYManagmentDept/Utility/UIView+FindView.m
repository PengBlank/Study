//
//  UIView+FindView.m
//  DaXueBao
//
//  Created by Ray on 14-3-9.
//  Copyright (c) 2014年 souvi. All rights reserved.
//

#import "UIView+FindView.h"

@implementation UIView (FindView)

- (id)findSuperViewForClass:(Class)superViewClass
{
    UIView *ret = self.superview;
    while (![ret isKindOfClass:superViewClass] && ret != nil) {
        ret = ret.superview;
    }
    return ret;
}

@end
