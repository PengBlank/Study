//
//  HYInactiveBatchMigrateResponse.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYInactiveBatchMigrateResponse.h"

@implementation HYInactiveBatchMigrateResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSNumber *count = GETOBJECTFORKEY(self.jsonDic, @"count", [NSNumber class]);
        self.count = [count integerValue];
    }
    
    return self;
}

@end
