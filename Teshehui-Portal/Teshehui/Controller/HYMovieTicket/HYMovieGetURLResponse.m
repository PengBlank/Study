//
//  HYMovieGetURLResponse.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/7.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMovieGetURLResponse.h"

@implementation HYMovieGetURLResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.URL = GETOBJECTFORKEY(data, @"url", NSString);
    }
    return self;
}

@end
