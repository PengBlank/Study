//
//  HYCIConfirmViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYCIDeliverInfo.h"
#import "HYCIOwnerInfo.h"
#import "HYCICarInfo.h"

/**
 *  车险订单确认界面
 */
@interface HYCIConfirmViewController : HYMallViewBaseController

@property (nonatomic, strong) HYCIDeliverInfo *deliverInfo;

@property (nonatomic, strong) NSArray *commercialInsureInfos;
@property (nonatomic, strong) NSArray *forceInsureInfos;
@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, strong) NSArray *insureDates;

@property (nonatomic, strong) HYCIOwnerInfo *ownerInfo;
@property (nonatomic, strong) HYCICarInfo *carInfo;
@property (nonatomic, strong) NSString *sessionid;
@property (nonatomic, assign) CGFloat points;

@end
