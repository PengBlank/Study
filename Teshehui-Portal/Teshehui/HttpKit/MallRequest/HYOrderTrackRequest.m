//
//  HYOrderTrackRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYOrderTrackRequest.h"
#import "HYOrderTrackResponse.h"

@implementation HYOrderTrackRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/order/getOrderExpress.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
        self.businessType = @"01";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:self.userId forKey:@"userId"];
        if (self.order_code.length > 0)
        {
            [newDic setObject:self.order_code forKey:@"orderCode"];
        }
    }
    
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYOrderTrackResponse *respose = [[HYOrderTrackResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
