//
//  NSTimer+Common.h
//  Coding_iOS
//
//  Created by ??? on 15/4/29.
//  Copyright (c) 2015年 ???. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Common)
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void(^)())block repeats:(BOOL)yesOrNo;

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
