//
//  HYSeckillGoodsListViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "RKPageContentViewController.h"
#import "HYSeckillActivityModel.h"
#import "HYSeckillGoodsListModel.h"

/// 秒杀界面 列表controller
@interface HYSeckillGoodsListViewController : RKPageContentViewController

@property (nonatomic, strong) HYSeckillActivityModel *activity;

/// 上接回调
//@property (nonatomic, copy) void (^pullCallback)(void);

/// 下拉回调
@property (nonatomic, copy) void (^pulldownCallback)(HYSeckillActivityModel *activity);

@property (nonatomic, copy) void (^timeEndCallback)(void);

@end
