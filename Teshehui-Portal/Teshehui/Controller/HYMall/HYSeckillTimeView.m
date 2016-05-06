//
//  HYSeckillTimeView.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSeckillTimeView.h"
#import "Masonry.h"
#import "CCCountTimer.h"
#import "NSDate+Addition.h"

@implementation HYSeckillTimeView
{
    UILabel *_state;
    UILabel *_endLab;
    UILabel *_hour;
    UILabel *_minute;
    UILabel *_second;
    UILabel *_timeLab;
    
    UILabel *_startingDate; //开抢时间
    
    CCCountTimer *_timer;
}

- (void)dealloc
{
    [_timer stop];
}

- (void)configTimeLab:(UILabel *)timeLab
{
    timeLab.textColor = [UIColor whiteColor];
    timeLab.backgroundColor = [UIColor blackColor];
    timeLab.font = [UIFont systemFontOfSize:14.0];
    timeLab.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                               green:237.0f/255.0f
                                                blue:237.0f/255.0f
                                               alpha:1.0];
    }
    return self;
}

/**
 *  @brief 已开始界面
 */
- (void)setViewWithStarted
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    /// 布局说明
    /// state(抢购中) 靠左15像素, 上下居中
    /// 右边时间靠右布局
    
    UILabel *state = [[UILabel alloc] initWithFrame:CGRectZero];
    state.textColor = [UIColor blackColor];
    state.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:state];
    [state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self);
    }];
    _state = state;
    
    NSString *time = @"60";
    CGSize size = [time sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(100, 100)];
    
    
    UILabel *second = [[UILabel alloc] initWithFrame:CGRectZero];
    [self configTimeLab:second];
    [self addSubview:second];
    [second mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(size.width+10);
    }];
    _second = second;
    
    UILabel *minute = [[UILabel alloc] initWithFrame:CGRectZero];
    [self configTimeLab:minute];
    [self addSubview:minute];
    [minute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(second.mas_left).offset(-2);
        make.centerY.equalTo(second);
        make.width.equalTo(second);
    }];
    _minute = minute;
    
    UILabel *hour = [[UILabel alloc] initWithFrame:CGRectZero];
    [self configTimeLab:hour];
    [self addSubview:hour];
    [hour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(minute.mas_left).offset(-2);
        make.centerY.equalTo(minute);
        make.width.equalTo(minute);
    }];
    _hour = hour;
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLab.font = [UIFont systemFontOfSize:14.0];
    timeLab.textColor = [UIColor colorWithWhite:.7 alpha:1];
    timeLab.text = @"结束倒计时";
    [self addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(hour.mas_left).offset(-2);
        make.centerY.equalTo(hour);
    }];
    _timeLab = timeLab;
    
    _state.text = @"抢购中";
    _hour.text = @"00";
    _minute.text = @"00";
    _second.text = @"00";
}

/**
 *  @brief 未开始界面
 */
- (void)setViewWithWaiting
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImage *icon = [UIImage imageNamed:@"seckill_icon"];
    UIImageView *iconv = [[UIImageView alloc] initWithImage:icon];
    [self addSubview:iconv];
    [iconv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self);
    }];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.textColor = [UIColor  colorWithWhite:.7 alpha:1];
    title.font = [UIFont systemFontOfSize:14.0];
    title.text = @"秒杀预告";
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconv.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectZero];
    date.textColor = [UIColor redColor];
    date.font = [UIFont systemFontOfSize:15.0];
    date.text = @"开抢";
    [self addSubview:date];
    _startingDate = date;
    [date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];
}

- (void)setActivity:(HYSeckillActivityModel *)activity
{
    _activity = activity;
    if (activity)
    {
        NSDate *startDate = [NSDate dateFromString:activity.beginTime withFormate:@"yyyy-MM-dd HH:mm"];
        NSDate *endDate = [NSDate dateFromString:activity.endTime withFormate:@"yyyy-MM-dd HH:mm"];
        NSDate *current = [NSDate dateFromString:activity.serviceCurrentTime withFormate:@"yyyy-MM-dd HH:mm:ss"];
        /// 已经开始
        if ([current compare:startDate] == NSOrderedDescending || [current compare:startDate] == NSOrderedSame)
        {
            [self setViewWithStarted];
            _state.text = activity.activityStatusName;
            _timeLab.text = @"结束倒计时";
            [self setTimeInterval:[endDate timeIntervalSinceDate:current]];
        }
        /// 还未开始
        else if ([current compare:startDate] == NSOrderedAscending)
        {
            //        _timeLab.text = @"开始倒计时";
            [self setTimeInterval:[startDate timeIntervalSinceDate:current]];
            
            [self setViewWithWaiting];
            NSString *starting = [startDate toStringWithFormat:@"MM月dd号 HH:mm开抢"];
            _startingDate.text = starting;
            _state.text = activity.activityStatusName;
        }
    }
    else
    {
        _state.text = nil;
        _timeLab.text = nil;
        _startingDate.text = nil;
        [_timer stop];
    }
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    if (_timeInterval != timeInterval)
    {
        _timeInterval = timeInterval;
        
        
        if (timeInterval < 0)   // 小于0直接停止，并刷新
        {
            if (self.timeEndCallback)
            {
                self.timeEndCallback();
            }
            return;
        }
        
        // 开始计时
        [_timer stop];
        _timer = [[CCCountTimer alloc] initWithCount:timeInterval];
        WS(weakSelf);
        
        // 计时触发时，更新界面显示
        [_timer start];
        _timer.countCallback = ^(NSInteger count, BOOL willStop)
        {
            if (weakSelf)
            {
                HYSeckillTimeView * strongSelf = weakSelf;
                
                NSInteger second = count % 60;
                NSInteger minute = count / 60;
                NSInteger hour = minute / 60;
                minute = minute % 60;
                
                strongSelf->_second.text = [NSString stringWithFormat:@"%02ld", (long)second];
                strongSelf->_minute.text = [NSString stringWithFormat:@"%02ld", (long)minute];
                strongSelf->_hour.text = [NSString stringWithFormat:@"%02ld", (long)hour];
                
                if (weakSelf.timeEndCallback && willStop)
                {
                    weakSelf.timeEndCallback();
                }
                //  停止
                if (willStop) {
                    [strongSelf->_timer stop];
                }
            }
            
        };
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
