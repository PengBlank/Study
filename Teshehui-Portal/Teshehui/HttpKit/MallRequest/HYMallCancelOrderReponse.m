//
//  HYMallCancelOrderReponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCancelOrderReponse.h"

@implementation HYMallCancelOrderReponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        self.status = [GETOBJECTFORKEY(dictionary, @"status", [NSString class]) intValue];
    }
    
    return self;
}

@end
