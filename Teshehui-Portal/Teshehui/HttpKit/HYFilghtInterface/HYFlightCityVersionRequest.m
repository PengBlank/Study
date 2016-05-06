//
//  HYFlightCityVersionRequest.m
//  Teshehui
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightCityVersionRequest.h"
#import "HYFlightCityVersionResponse.h"

@implementation HYFlightCityVersionRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kFlightRequestBaseURL, @"api/city_version"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlightCityVersionResponse *respose = [[HYFlightCityVersionResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
