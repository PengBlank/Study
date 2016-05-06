//
//  HYFlowerTypeListResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerTypeListResponse.h"

@implementation HYFlowerTypeListResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.flowerInfo = [[HYFlowerTypeInfo alloc] initWithDictionary:data error:nil];
    }
    
    return self;
}

@end
