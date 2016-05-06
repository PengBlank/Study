//
//  HYFlowerCancelOrderRequest.m
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerCancelOrderRequest.h"
#import "HYFlowerCancelOrderResponse.h"

@implementation HYFlowerCancelOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/cancelOrder.action"];
        self.httpMethod = @"POST";
        self.businessType = @"04";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.orderNo length] > 0)
        {
            [newDic setObject:self.orderNo forKey:@"orderCode"];
        }
        
        if ([self.userID length] > 0) {
            [newDic setObject:self.userID forKey:@"userId"];
        }
        
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlowerCancelOrderResponse *respose = [[HYFlowerCancelOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
