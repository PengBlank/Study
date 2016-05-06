//
//  HYMallCartShopUpdateResponse.m
//  Teshehui
//
//  Created by ichina on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCartShopUpdateResponse.h"

@implementation HYMallCartShopUpdateResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSString *result = GETOBJECTFORKEY(dictionary, @"data", [NSString class]) ;
        _isUpdate = [result boolValue];
    }
    
    return self;
}


@end
