//
//  HYContinueInsuranceResponse.m
//  Teshehui
//
//  Created by HYZB on 15/3/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYContinueInsuranceResponse.h"

@implementation HYContinueInsuranceResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.order_id = GETOBJECTFORKEY(data, @"orderId", [NSString class]);
        self.order_no = GETOBJECTFORKEY(data, @"orderCode", [NSString class]);
        self.order_name = GETOBJECTFORKEY(data, @"orderName", [NSString class]);
        self.pay_total = GETOBJECTFORKEY(data, @"orderTotalAmount", [NSString class]);
    }
    return self;
}
@end
