//
//  RefundViewController.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/11.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  退款页面
//
#import "HYMallViewBaseController.h"

@interface RefundViewController : HYMallViewBaseController

/** 套餐名称，数量，金额＋现金券*/
@property (nonatomic, strong) NSArray *bindData;
/** o2o订单号 */
@property (nonatomic, copy) NSString *o2oOrderNo;
/** 套餐名*/
@property (nonatomic, copy) NSString *packageName;

@property (nonatomic, copy) void(^refreshBlock)();

@end
