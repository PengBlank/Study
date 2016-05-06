

//
//  HYPointLogInfo.m
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPointLogInfo.h"

@implementation HYPointLogInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.created = GETOBJECTFORKEY(data, @"created", [NSString class]);
        self.points = GETOBJECTFORKEY(data, @"points", [NSString class]);
        self.logs = GETOBJECTFORKEY(data, @"logs", [NSString class]);
    }
    
    return self;
}

@end
