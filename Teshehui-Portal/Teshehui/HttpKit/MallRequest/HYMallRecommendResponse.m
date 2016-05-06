//
//  HYMallRecommendResponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallRecommendResponse.h"
#import "HYMallHomeItem.h"

@implementation HYMallRecommendResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.boradInfo = [[HYMallHomeBoard alloc] initWithDictionary:data
                                                               error:nil];
    }
    
    return self;
}

@end
