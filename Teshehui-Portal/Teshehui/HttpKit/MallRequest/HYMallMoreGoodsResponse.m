//
//  HYMallMoreGoodsResponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallMoreGoodsResponse.h"
#import "HYMallHomeItem.h"

@implementation HYMallMoreGoodsResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        NSArray *items = GETOBJECTFORKEY(data, @"programPOList", NSArray);
        if (items.count > 0)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (id obj in items)
            {
                HYMallHomeItem *goods = [[HYMallHomeItem alloc] initWithDictionary:obj
                                                                             error:nil];
                [muArray addObject:goods];
            }
            
            self.products = [muArray copy];
        }
    }
    
    return self;
}

@end
