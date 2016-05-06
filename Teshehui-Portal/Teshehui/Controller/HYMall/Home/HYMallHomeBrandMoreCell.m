//
//  HYMallHomeBrandMoreCell.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallHomeBrandMoreCell.h"

@implementation HYMallHomeBrandMoreCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-0.5)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor colorWithRed:255/255.0 green:0/255.0 blue:44/255.0 alpha:1];
        label.text = @"更多品牌 >";
        [self.contentView addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:line];
    }
    return self;
}

@end
