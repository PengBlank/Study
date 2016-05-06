//
//  HYindemnityProgress.m
//  Teshehui
//
//  Created by HYZB on 15/4/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYIndemnityProgress.h"
#import "NSDate+Addition.h"

@implementation HYIndemnityProgress

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        self.desc = GETOBJECTFORKEY(data, @"audit_desc", [NSString class]);
        self.time = GETOBJECTFORKEY(data, @"audit_time", [NSString class]);
    }
    
    return self;
}

- (NSString *)timeDesc
{
    if (!_timeDesc && self.time)
    {
        NSDate *time = [NSDate dateWithTimeIntervalSince1970:self.time.doubleValue];
        _timeDesc = [time timeDescriptionFull];
    }
    return _timeDesc;
}

@end
