//
//  PrepaySuccessViewController.h
//  Teshehui
//
//  Created by macmini5 on 16/3/3.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  会员充值成功页面/付款结果

#import "HYMallViewBaseController.h"
#import "OrderInfo.h"
@interface PrepaySuccessViewController : HYMallViewBaseController

@property (nonatomic, copy) NSString *merName; // 商家名
@property (nonatomic, copy) NSString *money;   // 充值金额
@property (nonatomic, copy) NSString *coupon;  // 现金券

/****这是实体店付款的属性*****/
@property (nonatomic, copy) NSString *remindMoney;  // 剩余的钱
@property (nonatomic, copy) NSString *merId; // 商家id
@property (nonatomic, copy) NSString *o2o_trade_no; // 付款号
/**************************/

@property (nonatomic,strong) OrderInfo *orderInfo;
@property (nonatomic,assign) NSInteger successType; //0付款成功 1充值 3付款失败

@property (nonatomic,assign) NSInteger comeType;    // 进来时路径 0扫码 1商家详情 2我的

@end
