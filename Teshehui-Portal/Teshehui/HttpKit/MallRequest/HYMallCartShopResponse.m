//
//  HYMallCartShopResponse.m
//  Teshehui
//
//  Created by ichina on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCartShopResponse.h"

@implementation HYMallCartShopResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *result = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *products = GETOBJECTFORKEY(result, @"productStoreArray", [NSArray class]);
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (id obj in products)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *d = (NSDictionary *)obj;
                HYMallCartShopInfo *CartShopInfo = [[HYMallCartShopInfo alloc] initWithDataInfo:d];
                [muArray addObject:CartShopInfo];
            }
        }
        
        if ([muArray count] > 0)
        {
            self.productsArray = [muArray copy];
        }
    }
    
    return self;
}
@end
