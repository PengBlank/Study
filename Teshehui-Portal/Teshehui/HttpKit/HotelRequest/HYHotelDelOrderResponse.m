//
//  HYHotelDelOrderResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-6-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelDelOrderResponse.h"

@implementation HYHotelDelOrderResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
//        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
       int status = [GETOBJECTFORKEY(dictionary, @"status", [NSString class]) intValue];
        self.succ = (status == 200);
    }
    
    return self;
}

@end
