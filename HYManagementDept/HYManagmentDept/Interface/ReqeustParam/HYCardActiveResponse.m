//
//  HYCardActiveResponse.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-31.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYCardActiveResponse.h"

@implementation HYCardActiveResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        //self.jsonDic...
        if ([dictionary.allKeys containsObject:@"status"])
        {
            self.status = [GETOBJECTFORKEY(dictionary, @"status", [NSString class]) intValue];
        }
        self.activeInfo = [[HYCardActiveInfo alloc] initWithData:self.jsonDic];
    }
    
    return self;
}

@end
