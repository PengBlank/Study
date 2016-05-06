//
//  HYFlowerCancelOrderResponse.m
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerCancelOrderResponse.h"

@implementation HYFlowerCancelOrderResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSString *result = GETOBJECTFORKEY(dictionary, @"data", [NSString class]);
        self.result = result;
        
    }
    return self;
}

@end
