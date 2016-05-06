//
//  HYAddCardSearchResponse.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAddCardSearchResponse.h"

@implementation HYAddCardSearchResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            self.numbers = GETOBJECTFORKEY(self.jsonDic, @"items", [NSArray class]);
        }
    }
    
    return self;
}

@end
