//
//  HYTaxiGetDidiOrderInfoResp.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiGetDidiOrderInfoResp.h"

@implementation HYTaxiGetDidiOrderInfoResp

-(id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        if (data)
        {
            self.orderView = [[HYTaxiOrderView alloc] initWithDictionary:data error:nil];
        }
    }
    return self;
}
@end
