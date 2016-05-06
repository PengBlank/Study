//
//  HYQRCodeGetCityListRequest.m
//  Teshehui
//
//  Created by HYZB on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYQRCodeGetCityListRequest.h"

@implementation HYQRCodeGetCityListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/merchant/merchant_city_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYQRCodeGetCityListResponse *respose = [[HYQRCodeGetCityListResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
