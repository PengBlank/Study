//
//  HYOrderPayViewController.h
//  Teshehui
//
//  Created by macmini7 on 15/11/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//  订单支付列表

#import "HYMallViewBaseController.h"
#import "BilliardsOrderInfo.h"
#import "BilliardsTableInfo.h"
@interface HYOrderPayViewController : HYMallViewBaseController
@property (nonatomic, strong) BilliardsOrderInfo *orderInfo;
@property (nonatomic, strong) NSMutableArray *goodsList;
@property (nonatomic, strong) BilliardsTableInfo *billiardsTableInfo;

@property (nonatomic, strong) NSString *isPayStatus;
@property (nonatomic, assign) BOOL backRefresh;
@property (nonatomic, assign) BOOL isOperationPay;

@end
