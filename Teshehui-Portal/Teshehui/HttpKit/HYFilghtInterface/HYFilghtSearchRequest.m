//
//  HYFilghtSearchRequest.m
//  ComeHere
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFilghtSearchRequest.h"
#import "HYFilghtSearchResponse.h"

@implementation HYFilghtSearchRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://air.teshehui.com/api/Flight/list";
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.flight_date length] > 0 &&
        [self.org_city length] > 0 &&
        [self.dst_city length] > 0)
    {
        [newDic setObject:self.flight_date forKey:@"flight_date"];
        [newDic setObject:self.org_city forKey:@"org_city"];
        [newDic setObject:self.dst_city forKey:@"dst_city"];
        
        if ([self.airline length] > 0)
        {
            [newDic setObject:self.airline forKey:@"airline"];
        }
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"机票查询请求缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFilghtSearchResponse *respose = [[HYFilghtSearchResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
