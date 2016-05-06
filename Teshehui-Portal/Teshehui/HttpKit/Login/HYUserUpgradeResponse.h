//
//  HYUserUpgradeResponse.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/18.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYUserUpgradeResponse : CQBaseResponse

@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *orderAmount;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *userId;

@end
