//
//  HYCIGetCarFillInfoListReq.m
//  Teshehui
//
//  Created by HYZB on 15/7/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIGetCarFillInfoListReq.h"

@implementation HYCIGetCarFillInfoListReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"insurance/car/getCarInfoInputList.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
    }
    
    return self;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCIGetCarFillInfoListResp *respose = [[HYCIGetCarFillInfoListResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end
