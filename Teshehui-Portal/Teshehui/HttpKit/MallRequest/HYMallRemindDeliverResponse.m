//
//  HYMallRemindDeliverResponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallRemindDeliverResponse.h"

@implementation HYMallRemindDeliverResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSNumber *result = GETOBJECTFORKEY(dictionary, @"data", [NSNumber class]);
        self.result = [result boolValue];
    }
    
    return self;
}

@end
