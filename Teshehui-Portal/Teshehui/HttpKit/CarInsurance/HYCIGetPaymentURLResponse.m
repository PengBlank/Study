//
//  HYCIGetPaymentURLResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIGetPaymentURLResponse.h"

@implementation HYCIGetPaymentURLResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.paymentURL = GETOBJECTFORKEY(data, @"paymentUrl", NSString);
    }
    return self;
}

@end
