//
//  HYMallHomeRecommendHeader.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/5.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeRecommendHeader.h"

@implementation HYMallHomeRecommendHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat labelwidth = 72;
        CGFloat linewidth = (frame.size.width - 72) / 2 - 20;
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(12, frame.size.height/2, linewidth, .5)];
        line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2 + labelwidth/2 +10, frame.size.height/2, linewidth, .5)];
        line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self addSubview:line2];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2- labelwidth/2, 0, labelwidth, frame.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:.63 alpha:1];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"为您推荐";
        [self addSubview:label];
    }
    return self;
}

@end
