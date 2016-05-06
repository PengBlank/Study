//
//  HYGetHelpResponse.m
//  Teshehui
//
//  Created by ichina on 14-3-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetHelpResponse.h"

@implementation HYGetHelpResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary* dic = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        _helpDic = [NSDictionary dictionaryWithDictionary:dic];
    }
    return self;
}

@end
