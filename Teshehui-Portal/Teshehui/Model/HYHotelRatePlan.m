//
//  HYHotelRatePlan.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelRatePlan.h"
#import "PTDateFormatrer.h"
#import "NSDate+Addition.h"

NSString *const HotelRatePlanCrip = @"00001";
NSString *const HOtelRatePlanElong = @"00002";

@implementation HYHotelRatePlan

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.infoSource = GETOBJECTFORKEY(data, @"infoSource", [NSString class]);
        self.code = GETOBJECTFORKEY(data, @"code", [NSString class]);
        self.roomRatePlanName = GETOBJECTFORKEY(data, @"roomRatePlanName", [NSString class]);
        self.status = [GETOBJECTFORKEY(data, @"status", [NSString class]) boolValue];
        self.totalFee = [GETOBJECTFORKEY(data, @"totalFee", [NSString class]) floatValue];
        self.averageFee = [GETOBJECTFORKEY(data, @"averageFee", [NSString class]) floatValue];
        self.averageOldFee = [GETOBJECTFORKEY(data, @"averageOldFee", [NSString class]) floatValue];
        self.stock = [GETOBJECTFORKEY(data, @"stock", [NSString class]) intValue];
        self.isInstantConfirmation = [GETOBJECTFORKEY(data, @"isInstantConfirmation", [NSString class]) integerValue];
        self.paymentTypeCode = GETOBJECTFORKEY(data, @"paymentTypeCode", [NSString class]);
        self.productTypeCode = [GETOBJECTFORKEY(data, @"productTypeCode", [NSString class]) integerValue];
        self.roomTypeId = GETOBJECTFORKEY(data, @"roomTypeId", [NSString class]);
        self.minAmount = [GETOBJECTFORKEY(data, @"minAmount", [NSString class]) intValue];
        self.minDays = [GETOBJECTFORKEY(data, @"minDays", [NSString class]) intValue];
        self.maxDays = [GETOBJECTFORKEY(data, @"maxDays", [NSString class]) intValue];
        NSString *guaranteeFee = GETOBJECTFORKEY(data, @"guaranteeFee", [NSString class]);
        self.guaranteeFee = [guaranteeFee doubleValue];
        self.isGuaranteeFeeCancel = [GETOBJECTFORKEY(data, @"isGuaranteeFeeCancel", [NSString class]) integerValue];
        self.guaranteeFeeCancelTime = GETOBJECTFORKEY(data, @"guaranteeFeeCancelTime", [NSString class]);
        self.point = [GETOBJECTFORKEY(data, @"points", [NSString class]) floatValue];
        
        self.createdTime = GETOBJECTFORKEY(data, @"createdTime", [NSString class]);
    }
    
    return self;
}

- (BOOL)isPrePay
{
    return (self.productTypeCode>=3);
}
 

@end
