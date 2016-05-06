//
//  HYUserCashAccountInfoResponse.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYUserCashAccountInfo.h"

@interface HYUserCashAccountInfoResponse : CQBaseResponse

@property (nonatomic, strong) HYUserCashAccountInfo *cashAccountInfo;

@end
