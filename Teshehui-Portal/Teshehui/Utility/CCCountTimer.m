//
//  CCCountTimer.m
//  ZStone
//
//  Created by 成才 向 on 15/9/26.
//  Copyright © 2015年 成才 向. All rights reserved.
//

#import "CCCountTimer.h"

@interface CCCountTimer ()
{
    NSInteger _count;
    NSInteger _beginCount;
    
    NSTimer *_timer;
}
@end

@implementation CCCountTimer


- (void)stop
{
    [_timer invalidate];
}

- (void)dealloc
{
    [_timer invalidate];
}

- (instancetype)initWithCount:(NSInteger)count
{
    if (self = [super init])
    {
        _increase = NO;
        _beginCount = count;
    }
    return self;
}

- (instancetype)initWithCountIncrease:(NSInteger)count
{
    if (self = [super init]) {
        _increase = YES;
        _beginCount = count;
    }
    return self;
}

- (void)start
{
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    _count = _beginCount;
}

- (void)pause
{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)resume
{
    [_timer setFireDate:[NSDate date]];
}

- (void)timerAction:(NSTimer *)timer
{
    BOOL stop = NO;
    if (_increase)
    {
        _count = _count + 1;
    }
    else
    {
        _count = _count - 1;
        stop = _count == 0;
    }
    if (self.countCallback)
    {
        self.countCallback(_count, stop);
    }
    if (stop)
    {
        [_timer invalidate];
    }
}

@end
