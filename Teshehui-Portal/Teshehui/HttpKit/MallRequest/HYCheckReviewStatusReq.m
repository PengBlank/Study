//
//  HYCheckReviewStatusReq.m
//  Teshehui
//
//  Created by HYZB on 15/5/20.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCheckReviewStatusReq.h"

@implementation HYCheckReviewStatusResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.version = GETOBJECTFORKEY(data, @"version", [NSString class]);
        self.startTime = [GETOBJECTFORKEY(data, @"startTime", [NSString class]) doubleValue];
        self.endTime = [GETOBJECTFORKEY(data, @"endTime", [NSString class]) doubleValue];
        self.reviewStatus = [GETOBJECTFORKEY(data, @"status", [NSString class]) boolValue];
    }
    
    return self;
}

@end

@implementation HYCheckReviewStatusReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kShowHandBaseURL, @"iosVersion/queryVersionStatus"];
        self.httpMethod = @"GET";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.version length] > 0)
        {
            [newDic setObject:self.version forKey:@"version"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCheckReviewStatusResp *respose = [[HYCheckReviewStatusResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end
