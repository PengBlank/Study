//
//  HYRiseCabinInfo.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * rise_cabin_info(升舱信息)
 */


#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface HYRiseCabinInfo : JSONModel

@property (nonatomic, copy) NSString *riseId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *passengers;
@property (nonatomic, copy) NSString *cabinType;
@property (nonatomic, copy) NSString *cabinCode;

@property (nonatomic, assign) CGFloat orderCash;
@property (nonatomic, assign) CGFloat walletAmount;
@property (nonatomic, assign) BOOL walletStatus;

@property (nonatomic, assign) CGFloat payTotal;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) CGFloat sourceFee;
@property (nonatomic, copy) NSString *sourceOrderNo;
@property (nonatomic, copy) NSString *extraData;
@property (nonatomic, copy) NSString *creationTime;
@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString *toCabinType;
@property (nonatomic, copy) NSString *toCabinCode;

@property (nonatomic, readonly, copy) NSString *statusDesc;

@end

/*
 "id":42,
 "orderId":2242,
 "passengers":"陈海龙",
 "cabinType":"F",
 "cabinCode":"234",
 "payTotal":0.01,
 "points":1,
 "sourceFee":0.01,
 "sourceOrderNo":"",
 "extraData":"",
 "creationTime":"2014-12-17 14:43:35",
 "status":4,
 "toCabinType":"F",
 "toCabinCode":"234"
 */
