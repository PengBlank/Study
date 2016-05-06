//
//  HYFlowerOrderListResponse.m
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerOrderListResponse.h"

@implementation HYFlowerOrderListResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *result = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (id obj in result)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = (NSDictionary *)obj;
                HYFlowerOrderSummary *orderList = [[HYFlowerOrderSummary alloc] initWithJson:dic];
                [muArray addObject:orderList];
            }
        }
        
        if ([muArray count] > 0)
        {
            self.orderList = [muArray copy];
        }
    }
    return self;
}

@end
