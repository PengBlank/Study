//
//  HYFlightDelOrderRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-6-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightDelOrderRequest.h"

@implementation HYFlightDelOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/deleteOrder.action"];
        self.httpMethod = @"POST";
        self.businessType = @"02";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.order_id length] > 0 )
    {
        if (self.user_id.length > 0)
        {
            [newDic setObject:self.user_id forKey:@"userId"];
        }
        
        [newDic setObject:self.order_id forKey:@"orderId"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlightDelOrderResponse *respose = [[HYFlightDelOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
