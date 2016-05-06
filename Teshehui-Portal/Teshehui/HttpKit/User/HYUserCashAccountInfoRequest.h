//
//  HYUserCashAccountInfoRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYUserCashAccountInfoResponse.h"

@interface HYUserCashAccountInfoRequest : CQBaseRequest

@property (nonatomic, assign) NSInteger currencyType;   //0人民币

@end
