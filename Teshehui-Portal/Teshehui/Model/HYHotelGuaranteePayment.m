//
//  HYHotelGuaranteePayment.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelGuaranteePayment.h"

@implementation HYHotelGuaranteePayment

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.GuaranteeCode = GETOBJECTFORKEY(data, @"GuaranteeCode", [NSString class]);
        self.Start = GETOBJECTFORKEY(data, @"Start", [NSString class]);
        self.End = GETOBJECTFORKEY(data, @"End", [NSString class]);
        self.Amount = GETOBJECTFORKEY(data, @"Amount", [NSString class]);
        self.CurrencyCode = GETOBJECTFORKEY(data, @"CurrencyCode", [NSString class]);
    }
    
    return self;
}

@end
