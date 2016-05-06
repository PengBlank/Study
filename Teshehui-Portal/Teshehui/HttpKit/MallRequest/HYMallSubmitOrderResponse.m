//
//  HYMallFinishOrderResponse.m
//  Teshehui
//
//  Created by ichina on 14-3-13.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallSubmitOrderResponse.h"

@implementation HYMallSubmitOrderResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        HYMallOrderSummary *orderList = [[HYMallOrderSummary alloc] initWithDictionary:data error:nil];
        self.orderList = orderList;
//        NSMutableArray *orderList = [[NSMutableArray alloc] init];
//        for (NSDictionary *data in array)
//        {
//            HYMallOrderSummary *order = [[HYMallOrderSummary alloc] initWithDictionary:data error:nil];
//            [orderList addObject:order];
//        }
//        
//        if ([orderList count] > 0)
//        {
//            self.orderList = [orderList copy];
//        }
    }
    
    return self;
}

@end
