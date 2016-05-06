//
//  HYFlightRefundInfo.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 退票信息
 */

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface HYFlightRefundInfo : JSONModel

@property (nonatomic, strong) NSString * returnId;
@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, strong) NSString * passengers;
@property (nonatomic, assign) CGFloat payTotal;
@property (nonatomic, assign) NSInteger payType;
@property (nonatomic, strong) NSString * payNo;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, assign) CGFloat sourceFee;
@property (nonatomic, strong) NSString * sourceOrderNo;
@property (nonatomic, strong) NSString * extraData;
@property (nonatomic, strong) NSString * finishTime;
@property (nonatomic, strong) NSString * creationTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * ticketNo;
@property (nonatomic, assign) NSInteger passengerCount;

@end


/*
 "id":101,
 "orderId":2280,
 "passengers":"陈海龙",
 "payTotal":0.01,
 "payType":"0.01",
 "payNo":"0.01",
 "remark":"退票",
 "sourceFee":0.01,
 "sourceOrderNo":"",
 "extraData":"",
 "finishTime":"2015-01-07 16:21:37",
 "creationTime":"2015-01-07 16:21:27",
 "status":2,
 "ticketNo":"",
 "passengerCount":1
 */