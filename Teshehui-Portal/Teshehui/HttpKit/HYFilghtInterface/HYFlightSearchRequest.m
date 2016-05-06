//
//  HYFlightSearchRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightSearchRequest.h"
#import "JSONKit_HY.h"

@implementation HYFlightSearchRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"product/searchProduct.action"];
        self.httpMethod = @"POST";
        self.businessType = @"02";
        self.pageSize = 20;
        self.pageNo = 1;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.flightDate length] > 0 &&
        [self.startCityId length] > 0 &&
        [self.endCityId length] > 0)
    {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        
        [tempDic setObject:self.flightDate forKey:@"flightDate"];
        [tempDic setObject:self.startCityId forKey:@"startCityId"];
        [tempDic setObject:self.endCityId forKey:@"endCityId"];
        
        if ([self.isSupportChild length] > 0)
        {
            [tempDic setObject:self.isSupportChild forKey:@"isSupportChild"];
        }
        
        if ([self.cabinType count] > 0)
        {
            [tempDic setObject:self.cabinType
                        forKey:@"cabinType"];
        }
        
        NSString *expands = [tempDic JSONString];
        
        if (expands)
        {
            [newDic setObject:expands
                       forKey:@"expandedRequest"];
        }
        
        [newDic setObject:[NSNumber numberWithInteger:self.pageSize]
                   forKey:@"pageSize"];
        [newDic setObject:[NSNumber numberWithInteger:self.pageNo]
                   forKey:@"pageNo"];
        
        if ([self.businessType length] > 0)
        {
            [newDic setObject:self.businessType forKey:@"businessType"];
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
    HYFlightSearchResponse *respose = [[HYFlightSearchResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
