//
//  CQGetAirlinesResponse.m
//  ComeHere
//
//  Created by ChengQian on 13-11-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQGetAirlinesResponse.h"

@implementation CQGetAirlinesResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        self.AirLines = GETOBJECTFORKEY(dictionary, @"AirLines", [NSString class]);
    }
    
    return self;
}

@end
