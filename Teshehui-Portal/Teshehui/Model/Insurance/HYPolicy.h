//
//  HYPolicy.h
//  Teshehui
//
//  Created by HYZB on 15/3/31.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYPolicy : JSONModel

@property (nonatomic, copy) NSString *renewal;
@property (nonatomic, copy) NSString *expiredDay;
@property (nonatomic, copy) NSString *renewalFee;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *policyType;
@property (nonatomic, copy) NSString *insuranceTypeCode;
@property (nonatomic, copy) NSString *insuranceTypeName;
@property (nonatomic, copy) NSString *insuranceProvision;

@end
