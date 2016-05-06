//
//  HYCIRecipiViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYCIOwnerInfo.h"
#import "HYCICarInfo.h"

/**
 * 车险收件人信息界面
 */
@interface HYCIRecipiViewController : HYMallViewBaseController

//保单信息，从报价界面传入，再传到订单确认界面
@property (nonatomic, strong) NSArray *commercialInsureInfos;
@property (nonatomic, strong) NSArray *forceInsureInfos;
@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, assign) CGFloat points;
@property (nonatomic, strong) NSArray *insureDates;

@property (nonatomic, strong) HYCIOwnerInfo *ownerInfo;
@property (nonatomic, strong) HYCICarInfo *carInfo;
@property (nonatomic, strong) NSString *sessionid;

@end
