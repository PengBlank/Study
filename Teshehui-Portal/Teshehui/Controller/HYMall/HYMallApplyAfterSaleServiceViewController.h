//
//  HYMallApplyAfterSaleServiceViewController.h
//  Teshehui
//
//  Created by Kris on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYMallOrderItem.h"
#import "HYMallChildOrder.h"
#import "HYMallAfterSaleInfo.h"
#import "HYAddressInfo.h"

/**
 *   申请售后服务 申请退换货 申请闪电退
 */
@interface HYMallApplyAfterSaleServiceViewController : HYMallViewBaseController

@property (nonatomic, strong) HYMallOrderItem *returnGoodsInfo;
@property (nonatomic, strong) HYAddressInfo *addressInfo;
@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, assign) BOOL isChange;
@property (nonatomic, strong) HYMallAfterSaleInfo *saleInfo;
@property (nonatomic, copy) void (^updateCallback)(void);   //修改成功回调
@property (nonatomic, copy) void (^applyCallback)(void);    //申请成功回调

@end
