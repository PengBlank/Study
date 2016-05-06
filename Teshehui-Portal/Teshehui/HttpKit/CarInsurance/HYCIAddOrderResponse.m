//
//  HYCIAddOrderResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIAddOrderResponse.h"
#import "HYCIOrderDetail.h"

@implementation HYCIAddOrderResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *orderlist = GETOBJECTFORKEY(data, @"orderList", NSArray);
        if (orderlist.count > 0)
        {
            NSDictionary *orderinfo = [orderlist objectAtIndex:0];
            self.order = [[HYCIOrderDetail alloc] initWithDictionary:orderinfo error:nil];
        }
    }
    
    return self;
}


@end
