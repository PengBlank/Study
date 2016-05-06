//
//  HYFlightOrderHeaderView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightOrderHeaderView.h"

@implementation HYFlightOrderHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 24, 24)];
        imageView.image = [UIImage imageNamed:@"icon_flightwhite"];
        [self addSubview:imageView];
        
        _dateInfoLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 11, 80, 18)];
        _dateInfoLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [_dateInfoLab setFont:[UIFont systemFontOfSize:15]];
        _dateInfoLab.backgroundColor = [UIColor clearColor];
        [self addSubview:_dateInfoLab];
        
        _airlineLab = [[UILabel alloc] initWithFrame:CGRectMake(130, 11, 60, 18)];
        _airlineLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [_airlineLab setFont:[UIFont systemFontOfSize:15]];
        _airlineLab.backgroundColor = [UIColor clearColor];
        [self addSubview:_airlineLab];
        
        _airlineNOLab = [[UILabel alloc] initWithFrame:CGRectMake(190, 11, 60, 18)];
        _airlineNOLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [_airlineNOLab setFont:[UIFont systemFontOfSize:15]];
        _airlineNOLab.backgroundColor = [UIColor clearColor];
        [self addSubview:_airlineNOLab];
        
        _planTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(250, 11, 60, 18)];
        _planTypeLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [_planTypeLab setFont:[UIFont systemFontOfSize:15]];
        _planTypeLab.backgroundColor = [UIColor clearColor];
        [self addSubview:_planTypeLab];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
