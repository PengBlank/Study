//
//  HYStrokeField.m
//  HYManagmentDept
//
//  Created by apple on 15/4/21.
//  Copyright (c) 2015年 回亿资本. All rights reserved.
//

#import "HYStrokeField.h"

@implementation HYStrokeField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor colorWithWhite:.93 alpha:1];
        line.tag = 1024;
        [self addSubview:line];
    }
    return self;
}

- (void)awakeFromNib
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor colorWithWhite:.93 alpha:1];
    line.tag = 1024;
    [self addSubview:line];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIView *line = [self viewWithTag:1024];
    line.frame = CGRectMake(0, CGRectGetHeight(self.frame)-4, CGRectGetWidth(self.frame), 1);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
