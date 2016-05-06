//
//  HYCIQueryCarTypeListReq.m
//  Teshehui
//
//  Created by HYZB on 15/7/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIQueryCarTypeListReq.h"

@implementation HYCIQueryCarTypeListParam @end

@implementation HYCIQueryCarTypeListReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"insurance/car/queryCarTypeList.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
    }
    
    return self;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCIQueryCarTypeListResp *respose = [[HYCIQueryCarTypeListResp alloc]initWithJsonDictionary:info];
    return respose;
}


@end
