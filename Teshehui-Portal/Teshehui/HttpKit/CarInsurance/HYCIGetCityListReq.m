//
//  HYCIGetCityListParam.m
//  Teshehui
//
//  Created by HYZB on 15/7/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIGetCityListReq.h"
#import "HYCIGetCityListResp.h"

@implementation HYCIGetCityListParam @end


@implementation HYCIGetCityListReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"insurance/car/getRegionList.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
    }
    
    return self;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCIGetCityListResp *respose = [[HYCIGetCityListResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end