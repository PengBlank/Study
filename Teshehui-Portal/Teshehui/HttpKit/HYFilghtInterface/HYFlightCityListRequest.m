//
//  HYFlightCityListRequest.m
//  Teshehui
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightCityListRequest.h"

@implementation HYFlightCityListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kFlightRequestBaseURL, @"api/city/lists"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlightCityListResponse *respose = [[HYFlightCityListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
