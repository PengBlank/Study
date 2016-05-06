//
//  HYSearchHotKeyRequest.m
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSearchHotKeyRequest.h"

@implementation HYSearchHotKeyRequest
- (instancetype)init
{
    if (self = [super init])
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL,@"product/queryHotKeywordList.action"];
        self.httpMethod = @"POST";
        //self.postType = KeyValue;
        //self.interfaceType = JAVA;
        self.number = 5;
        self.liveServiceNumber = 10;
    }
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
//    [data setObject:@(_number) forKey:@"number"];
//    [data setObject:@(_liveServiceNumber) forKey:@"liveServiceNumber"];
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    return [[HYSearchHotKeyResponse alloc] initWithJsonDictionary:info];
}

@end
