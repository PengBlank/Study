//
//  HYMallGuessFavoriteResponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGuessFavoriteResponse.h"
#import "HYProductListSummary.h"

@implementation HYMallGuessFavoriteResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *list = GETOBJECTFORKEY(data, @"productList", [NSArray class]);
        
        if ([list count] > 0)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (id obj in list)
            {
                HYProductListSummary *goods = [[HYProductListSummary alloc] initWithJsonData:obj];
                [muArray addObject:goods];
            }
            
            self.recommendGoods = [muArray copy];
        }
    }
    
    return self;
}


@end
