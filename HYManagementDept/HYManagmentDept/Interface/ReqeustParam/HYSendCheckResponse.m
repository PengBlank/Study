//
//  HYSendCheckResponse.m
//  Teshehui
//
//  Created by ichina on 14-3-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYSendCheckResponse.h"

@implementation HYSendCheckResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *err = GETOBJECTFORKEY(dictionary, @"error_msg", [NSDictionary class]);
        self.rspDesc = GETOBJECTFORKEY(err, @"msg", [NSString class]);
    }
    
    return self;
}

@end
