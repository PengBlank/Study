//
//  HYActivityGoodsResponse.m
//  Teshehui
//
//  Created by RayXiang on 14-8-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYActivityGoodsResponse.h"
#import "HYActivityGoods.h"

@interface HYActivityGoodsResponse()
@property (nonatomic, strong) NSArray *goodsArray;
@end

@implementation HYActivityGoodsResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSDictionary *pageData = GETOBJECTFORKEY(data, @"pagePO", [NSDictionary class]);
        NSArray *array = GETOBJECTFORKEY(pageData, @"items", [NSArray class]);
        if (array)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in array)
            {
                HYActivityGoods *city = [[HYActivityGoods alloc] initWithJsonData:dic];
                [muArray addObject:city];
            }
            
            self.goodsArray = [muArray copy];
        }
        
    }
    
    return self;
}

@end
