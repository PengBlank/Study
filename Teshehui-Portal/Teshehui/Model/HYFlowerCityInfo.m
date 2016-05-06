//
//  HYFlowerCityInfo.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerCityInfo.h"

@implementation HYFlowerCityInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.adressid = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.name = GETOBJECTFORKEY(data, @"name", [NSString class]);
        self.parent_id = GETOBJECTFORKEY(data, @"parent_id", [NSString class]);
        self.updated = GETOBJECTFORKEY(data, @"updated", [NSString class]);
    }
    
    return self;
}

@end
