//
//  HYCIQuoteCalculateRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIBaseReq.h"
#import "HYCIQuoteCalculateResponse.h"
#import "HYCIAreaAndDriverInfo.h"

@interface HYCIQuoteCalculateRequest : HYCIBaseReq

@property (nonatomic, strong) NSString *fillTypeKey;
@property (nonatomic, strong) NSArray *fillTypeList;

@property (nonatomic, strong) NSString *dateKey;
@property (nonatomic, strong) NSArray *dateList;

@property (nonatomic, strong) NSString *packageType;
@property (nonatomic, strong) NSString *sessionId;

@property (nonatomic, assign) BOOL forceFlag;

@property (nonatomic, strong) HYCIAreaAndDriverInfo *areaAndDriverInfo;

//指省指价
@property (nonatomic, assign) BOOL runAreaFlag;
@property (nonatomic, assign) BOOL driverFlag;  //是否可指
@property (nonatomic, assign) BOOL isAssignDriver;
@property (nonatomic, strong) HYCICarInfoFillType *runAreaInfo;

//驾驶员信息
@property (nonatomic, strong) NSString *driverName;
@property (nonatomic, strong) NSString *driverNum;
@property (nonatomic, strong) NSString *drivateDate;

@end
