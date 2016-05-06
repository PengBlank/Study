//
//  HYMallHomeMoreTimeCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeMoreTimeCell.h"

@interface HYMallHomeMoreTimeCell ()

@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *dateLab;

@end

@implementation HYMallHomeMoreTimeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.borderColor = [UIColor colorWithWhite:.9 alpha:1].CGColor;
        self.layer.borderWidth = .5;
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/2, frame.size.height)];
        timeLab.font = [UIFont systemFontOfSize:11.0];
        timeLab.textColor = [UIColor colorWithWhite:.43 alpha:1];
        timeLab.backgroundColor = [UIColor clearColor];
        timeLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:timeLab];
        self.timeLab = timeLab;
        
        UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height)];
        dateLab.font = [UIFont systemFontOfSize:11.0];
        dateLab.textColor = [UIColor colorWithWhite:.43 alpha:1];
        dateLab.backgroundColor = [UIColor clearColor];
        dateLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dateLab];
        self.dateLab = dateLab;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2, 3, 1, frame.size.height-6)];
        line.backgroundColor = [UIColor colorWithWhite:.90 alpha:1];
        [self addSubview:line];
        
        //test
        self.timeLab.text = @"24:00 更新";
        self.dateLab.text = @"09/14 星期一";
    }
    return self;
}

- (void)setTime:(NSString *)time
{
    _timeLab.text = time;
}
- (void)setDate:(NSString *)date
{
    _dateLab.text = date;
}

@end
