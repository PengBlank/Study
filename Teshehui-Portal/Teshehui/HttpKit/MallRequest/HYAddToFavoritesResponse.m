//
//  HYAddToFavoritesResponse.m
//  Teshehui
//
//  Created by Kris on 15/12/28.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAddToFavoritesResponse.h"

@implementation HYAddToFavoritesResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        _message = GETOBJECTFORKEY(dictionary, @"message", [NSString class]);
    }
    return self;
}

@end
