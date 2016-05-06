//
//  HYMallOrderListResponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderListResponse.h"

@implementation HYMallOrderListResponse
- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *orderData = GETOBJECTFORKEY(dictionary, @"data", NSArray);
        self.ordersArray = [HYMallOrderDetail arrayOfModelsFromDictionaries:orderData];
        /*NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSDictionary* dic = [data objectForKey:@"page"];
        _pageInfo = [dic copy];
        NSArray* result = [data objectForKey:@"orders"];
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (id obj in result)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *d = (NSDictionary *)obj;
                HYMallOrderDetail *orderInfo = [[HYMallOrderDetail alloc] initWithDataInfo:d];
                [muArray addObject:orderInfo];
            }
        }
        
        if ([muArray count] > 0)
        {
            self.ordersArray = [muArray copy];
        }*/
    }
    
    return self;
}

@end
