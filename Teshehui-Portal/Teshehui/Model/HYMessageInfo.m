//
//  HYMessageInfo.m
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMessageInfo.h"

@implementation HYMessageInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.content = GETOBJECTFORKEY(data, @"content", [NSString class]);
        self.add_time = GETOBJECTFORKEY(data, @"add_time", [NSString class]);
    }
    
    return self;
}

@end
