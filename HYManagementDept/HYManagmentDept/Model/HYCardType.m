//
//  HYCardType.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-11-3.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYCardType.h"

@implementation HYCardType

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.card_name = GETOBJECTFORKEY(data, @"card_name", [NSString class]);
        self.card_id = [GETOBJECTFORKEY(data, @"card_id", [NSString class]) floatValue];
    }
    
    return self;
}

@end
