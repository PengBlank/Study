//
//  HYMallGoodDetailResponse.m
//  Teshehui
//
//  Created by ichina on 14-2-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGoodDetailResponse.h"

@implementation HYMallGoodDetailResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *dic = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        if (dic && [dic count]>0)
        {
            self.goodDetailInfo = [[HYMallGoodsDetail alloc] initWithDictionary:dic];
        }
    }
    
    return self;
}


@end
