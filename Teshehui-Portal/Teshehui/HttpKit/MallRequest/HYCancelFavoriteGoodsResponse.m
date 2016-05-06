//
//  HYCancelFavoriteGoodsResponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCancelFavoriteGoodsResponse.h"

@implementation HYCancelFavoriteGoodsResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSNumber *result = GETOBJECTFORKEY(data, @"result", [NSNumber class]);
        self.result = [result boolValue];
    }
    
    return self;
}

@end
