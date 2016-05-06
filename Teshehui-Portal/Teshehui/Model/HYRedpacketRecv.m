//
//  HYRedpacketRecv.m
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRedpacketRecv.h"

@implementation HYRedpacketRecv

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.total_amount   = [GETOBJECTFORKEY(data, @"total_amount", [NSString class]) intValue];
        self.title  = GETOBJECTFORKEY(data, @"title", [NSString class]);
        self.get_time  = GETOBJECTFORKEY(data, @"get_time", [NSString class]);
        self.status = [GETOBJECTFORKEY(data, @"status", NSString) integerValue];
        self.phone_mob = GETOBJECTFORKEY(data, @"phone_mob", NSString);
    }
    
    return self;
}

@end
