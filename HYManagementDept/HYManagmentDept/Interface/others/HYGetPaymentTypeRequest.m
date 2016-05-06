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
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"order/payments"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
    }
    
    return self;
}


- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.order_no length] > 0)
        {
            [newDic setObject:self.order_no forKey:@"order_no"];
        }
        
        if ([self.order_type length] > 0)
        {
            [newDic setObject:self.order_type forKey:@"order_type"];
        }
    }
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetPaymentTypeResponse *respose = [[HYGetPaymentTypeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
