//
//  HYFlowerDetailResponse.m
//  Teshehui
//
//  Created by ichina on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerDetailResponse.h"

@implementation HYFlowerDetailResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *result = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.flowerDetailInfo = [[HYFlowerDetailInfo alloc] initWithDictionary:result];
    }
    
    return self;
}

@end
