//
//  HYGetPaymentTypeRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetPaymentTypeRequest.h"

@implementation HYGetPaymentTypeRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"pay/queryThirdpartyPayType.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetPaymentTypeResponse *respose = [[HYGetPaymentTypeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
