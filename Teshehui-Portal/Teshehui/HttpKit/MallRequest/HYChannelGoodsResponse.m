//
//  HYChannelGoodsResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChannelGoodsResponse.h"
#import "HYMallChannelGoods.h"

@implementation HYChannelGoodsResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        NSArray *items = GETOBJECTFORKEY(data, @"items", NSArray);
        if (items.count > 0)
        {
            NSMutableArray *goods = [NSMutableArray array];
            for (NSDictionary *item in items)
            {
                HYMallChannelGoods *good = [[HYMallChannelGoods alloc] initWithDictionary:item error:nil];
                [goods addObject:good];
            }
            self.goodsList = goods;
        }
    }
    return self;
}

@end
