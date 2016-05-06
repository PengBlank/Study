//
//  CircleProgressView.h
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIControl

@property (nonatomic) NSTimeInterval elapsedTime;

@property (nonatomic) NSTimeInterval timeLimit;

@property (nonatomic, strong) NSAttributedString *status;

@property (assign, nonatomic, readonly) double percent;

- (void)start;
- (void)stop;
- (void)pause;
@property (nonatomic, assign, readonly) BOOL isPause;
- (void)resume;

/**
 *  计时完成
 *  @param isEnd    是否时间被完全走完(也可能是手动结束计时)
 */
@property (nonatomic, copy) void (^timeDidEnd)(BOOL isEnd);

@end
