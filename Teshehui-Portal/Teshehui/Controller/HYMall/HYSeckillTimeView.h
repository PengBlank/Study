//
//  HYSeckillTimeView.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYSeckillActivityModel.h"

///秒杀界面, 顶部计时界面
@interface HYSeckillTimeView : UIView

/// 需要计时的时间
@property (nonatomic, assign) NSTimeInterval timeInterval;

///结束时间回调, 计时结束时调用
@property (nonatomic, copy) void (^timeEndCallback)(void);

/// 活动对象
@property (nonatomic, strong) HYSeckillActivityModel *activity;

@end
