//
//  HYPassengerResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPassengerResponse.h"

@interface HYPassengerResponse ()

@property (nonatomic, strong) NSArray *passengerList;

@end

@implementation HYPassengerResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *p = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.passenger = [[HYPassengers alloc] initWithDataInfo:p];
        NSString *message = GETOBJECTFORKEY(dictionary, @"message", [NSString class]);
        self.message = message;
    }
    
    return self;
}

@end
