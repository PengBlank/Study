//
//  CCCountTimer.h
//  ZStone
//
//  Created by 成才 向 on 15/9/26.
//  Copyright © 2015年 成才 向. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  计数器
 */
@interface CCCountTimer : NSObject
{
    //是否增长
    BOOL _increase;
}

//从count 向下计数,到0为止
- (instancetype)initWithCount:(NSInteger)count;

///从count开始向上计数,不停止
- (instancetype)initWithCountIncrease:(NSInteger)count;

- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;

///回调, 每次计数均回调一次, 为0时willStop为YES
@property (nonatomic, copy) void (^countCallback)(NSInteger count, BOOL willStop);

@end
