//
//  HYMallOrderDetail.h
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  商城订单详情
 */
#import "HYMallOrderSummary.h"
#import "HYMallReturnsInfo.h"

@interface HYMallOrderDetail : HYMallOrderSummary

@property (nonatomic, strong) NSArray *refoundsList;  //退换货信息

@end
