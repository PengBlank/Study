//
//  HYCIGetPaymentURLRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIGetPaymentURLRequest.h"
#import "HYCIGetPaymentURLResponse.h"
#import "JSONKit_HY.h"

@implementation HYCIGetPaymentURLRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"insurance/car/getInsurancePaymentUrl.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
        self.userId = @"3756";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        if (_sessionid.length > 0)
        {
            [data setObject:self.sessionid forKey:@"sessionId"];
        }
        if (_insuredName.length >0)
        {
            [data setObject:self.insuredName forKey:@"insuredName"];
        }
        if (_policyNo.length > 0)
        {
            [data setObject:self.policyNo forKey:@"bizPolicyNo"];
        }
        
        NSString *jsondata = [data JSONString];
        
        if ([jsondata length] > 0)
        {
            [newDic setObject:jsondata forKey:@"data"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCIGetPaymentURLResponse *respose = [[HYCIGetPaymentURLResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
