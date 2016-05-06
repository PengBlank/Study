//
//  HYCIAddOrderRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIBaseReq.h"
#import "HYCIOwnerInfo.h"
#import "HYCICarInfo.h"
#import "HYCIPersonInfo.h"
#import "HYCIDeliverInfo.h"


@interface HYCIAddOrderRequest : HYCIBaseReq

@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, assign) CGFloat points;
@property (nonatomic, strong) NSString *sessionid;

@property (nonatomic, strong) HYCIOwnerInfo *ownerInfo;
@property (nonatomic, strong) HYCICarInfo *carInfo;
@property (nonatomic, strong) HYCIPersonInfo *insuredInfo;
@property (nonatomic, strong) HYCIPersonInfo *applicantInfo;
@property (nonatomic, strong) HYCIDeliverInfo *deliverInfo;
@property (nonatomic, strong) NSArray *insureInfoList;
@property (nonatomic, strong) NSArray *forceList;
@property (nonatomic, strong) NSArray *dateList;

@end
