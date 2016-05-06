//
//  HYLineStylePageControl.m
//  Teshehui
//
//  Created by HYZB on 15/1/23.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLineStylePageControl.h"

@implementation HYLineStylePageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}

#pragma mark setter/getter
- (void)setSilderColor:(UIColor *)silderColor
{
    if (silderColor != _silderColor)
    {
        _silderColor = silderColor;
    }
}

@end
