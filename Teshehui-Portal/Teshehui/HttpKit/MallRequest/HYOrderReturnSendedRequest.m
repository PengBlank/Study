//
//  HYOrderReturnSendedRequest.m
//  Teshehui
//
//  Created by RayXiang on 14-9-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYOrderReturnSendedRequest.h"

@implementation HYOrderReturnSendedRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/order/return_sended"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.request_id > 0)
        {
            [newDic setObject:_request_id forKey:@"request_id"];
        }
        if (self.express_company > 0)
        {
            [newDic setObject:_express_company forKey:@"express_company"];
        }
        if (self.invoice_no > 0)
        {
            [newDic setObject:_invoice_no forKey:@"invoice_no"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYOrderReturnSendedResponse *respose = [[HYOrderReturnSendedResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
