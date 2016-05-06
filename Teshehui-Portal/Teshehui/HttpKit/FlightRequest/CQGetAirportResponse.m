//
//  CQGetAirportResponse.m
//  ComeHere
//
//  Created by ChengQian on 13-11-17.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQGetAirportResponse.h"

@implementation CQGetAirportResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        self.PortName = GETOBJECTFORKEY(dictionary, @"PortName", [NSString class]);
    }
    
    return self;
}

@end
