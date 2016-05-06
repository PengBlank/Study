//
//  HYComparePriceNullView.m
//  Teshehui
//
//  Created by Kris on 15/9/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYComparePriceNullView.h"

@implementation HYComparePriceNullView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel *label = [UILabel new];
        label.text = @"抱歉,平台数据正在完善中";
        label.frame = TFRectMake(85, 10, 150, 20);
        label.contentMode = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:TFScalePoint(13)];
        [self addSubview:label];
    }
    return self;
}

@end
