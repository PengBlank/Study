//
//  HYAgencyDataInfo.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-19.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyDataInfo.h"

@implementation HYAgencyDataInfo

- (id)initWithData:(NSDictionary *)data
{
    if (self = [super init]) {
        self.m_id = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.name = GETOBJECTFORKEY(data, @"name", [NSString class]);
    }
    return self;
}

@end
