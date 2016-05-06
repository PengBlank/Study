//
//  HYSearchSuggestRequest.m
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSearchSuggestRequest.h"

@implementation HYSearchSuggestRequest

//http://192.168.0.250:6080/tshSch-web

- (instancetype)init
{
    if (self = [super init])
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"product/suggest.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
        self.size = 10;
    }
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *dict = [super getJsonDictionary];
    if (_key) {
        [dict setObject:_key forKey:@"keyword"];
    }
    if (_size > 0)
    {
        [dict setObject:[NSNumber numberWithInteger:_size] forKey:@"maxSize"];
    }
    return dict;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    return [[HYSearchSuggestResponse alloc] initWithJsonDictionary:info];
}

@end
