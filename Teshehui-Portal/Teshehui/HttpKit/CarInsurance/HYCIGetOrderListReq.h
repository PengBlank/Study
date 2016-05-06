//
//  HYCIGetOrderList.h
//  Teshehui
//
//  Created by HYZB on 15/7/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIBaseReq.h"
#import "HYCIGetOrderListResp.h"

@interface HYCIGetOrderListReq : HYCIBaseReq

@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@end

/*
 :"查询的订单类型，0所有，1待支付，2已支付"｝
*/