//
//  HYOrderTrackResponse.m
//  Teshehui
//
//  Created by ichina on 14-3-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYOrderTrackResponse.h"

@implementation HYOrderTrackResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary* dic = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.trackInfo = [[HYMallLogisticsInfo alloc] initWithDictionary:dic error:nil];
    }
    
    return self;
}

@end
