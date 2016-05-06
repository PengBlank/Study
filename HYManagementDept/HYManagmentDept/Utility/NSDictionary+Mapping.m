//
//  NSDictionary+Mapping.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-16.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "NSDictionary+Mapping.h"

@implementation NSDictionary (Mapping)

- (NSDictionary *)dictionaryWithMap:(NSDictionary *)map
{
    NSMutableDictionary *m = [self mutableCopy];
    for (NSString *k in map) {
        id value = [m objectForKey:k];
        if (value)
        {
            [m setObject:value forKey:map[k]];
        }
    }
    return m;
}

@end
