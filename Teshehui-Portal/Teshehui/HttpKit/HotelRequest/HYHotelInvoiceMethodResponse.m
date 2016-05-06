//
//  HYHotelInvoiceMethodResponse.m
//  Teshehui
//
//  Created by apple on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYHotelInvoiceMethodResponse.h"
#import "HYHotelInvoiceMethod.h"

@implementation HYHotelInvoiceMethodResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSArray *datas = GETOBJECTFORKEY(dictionary, @"data", NSArray);
        NSMutableArray *objs = [NSMutableArray array];
        
        for (NSDictionary *dict in datas)
        {
            HYHotelInvoiceMethod *method = [[HYHotelInvoiceMethod alloc] initWithDataInfo:dict];
            [objs addObject:method];
        }
        
        self.shipMethods = objs;
    }
    return self;
}

@end
