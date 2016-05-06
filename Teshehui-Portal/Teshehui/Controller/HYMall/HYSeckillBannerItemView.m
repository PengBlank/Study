//
//  HYSeckillBannerItemView.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSeckillBannerItemView.h"
#import "Masonry.h"
#import "NSDate+Addition.h"

@implementation HYSeckillBannerItemView
{
    UILabel *_date;
    UILabel *_time;
    UILabel *_state;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        /// 布局说明
        /// 日期与状态均分宽度,各自居中显示
        
        // 日期
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectZero];
        date.font = [UIFont systemFontOfSize:TFScalePoint(14.0)];
        date.textColor = [UIColor whiteColor];
        date.textAlignment = NSTextAlignmentCenter;
        [self addSubview:date];
        [date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.width.equalTo(self.mas_width).multipliedBy(0.6);
        }];
        _date = date;
        
        // 时间
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectZero];
        time.font = [UIFont systemFontOfSize:TFScalePoint(16.0)];
        time.textAlignment = NSTextAlignmentCenter;
        time.textColor = [UIColor whiteColor];
        [self addSubview:time];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.equalTo(date.mas_bottom).offset(2);
            make.width.equalTo(date.mas_width);
        }];
        _time = time;
        
        // 状态
        UILabel *state = [[UILabel alloc] initWithFrame:CGRectZero];
        state.font = [UIFont systemFontOfSize:TFScalePoint(14.0)];
        state.textAlignment = NSTextAlignmentCenter;
        state.textColor = [UIColor whiteColor];
        state.numberOfLines = 0;
        [self addSubview:state];
        [state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.4);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        _state = state;
        
        [self setSelected:NO];
        
        _date.text = @"10月8日";
        _time.text = @"20:00";
        _state.text = @"抢购中";
    }
    return self;
}

- (void)setActivity:(HYSeckillActivityModel *)activity
{
    _activity = activity;
    
    NSDate *begin = [NSDate dateFromString:activity.beginTime withFormate:@"yyyy-MM-dd HH:mm"];
    NSString *beginDate = [begin toStringWithFormat:@"MM月dd日"];
    NSString *beginTime = [begin toStringWithFormat:@"HH:mm"];
    _date.text = beginDate;
    _time.text = beginTime;
    _state.text = activity.activityStatusName;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:225/255.0 green:16/255.0 blue:33/255.0 alpha:1];
    }
    else {
        self.backgroundColor = [UIColor colorWithWhite:.18 alpha:1];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
