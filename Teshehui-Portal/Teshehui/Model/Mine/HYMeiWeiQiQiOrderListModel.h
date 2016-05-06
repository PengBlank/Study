//
//  HYMeiWeiQiQiOrderListModel.h
//  Teshehui
//
//  Created by HYZB on 15/12/26.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYMeiWeiQiQiOrderListModel : JSONModel

@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *orderShowStatus;
@property (nonatomic, copy) NSString *orderTotalAmount;
@property (nonatomic, copy) NSString *orderActualAmount;
@property (nonatomic, copy) NSString *itemTotalAmount;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *creationTime;
@property (nonatomic, copy) NSString *updateTime;


/*
 "orderCode":"订单编号",
 "status":"状态值",
 "orderShowStatus":"状态显示名称",
 "orderTotalAmount":"订单总金额",
 "orderActualAmount":"订单应付金额",
 "itemTotalAmount":"商品总金额",
 "points":"现金券"，
 "createTime":"下单时间"，
 "updateTime":"下单时间"
 */

@end
