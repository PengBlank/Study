//
//  HYHotelInvoiceMethod.m
//  Teshehui
//
//  Created by apple on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYHotelInvoiceMethod.h"

@implementation HYHotelInvoiceMethod

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.shippingMethodId = GETOBJECTFORKEY(data, @"shippingMethodId", NSString);
        self.shippingMethodName = GETOBJECTFORKEY(data, @"shippingMethodName", NSString);
        self.shippingMethodFee = [GETOBJECTFORKEY(data, @"shippingMethodFee", NSString) floatValue];
    }
    
    return self;
}

- (NSString *)shippingDisplay
{
    return [NSString stringWithFormat:@"%@ ￥%@", self.shippingMethodName, @(self.shippingMethodFee)];
}

@end
