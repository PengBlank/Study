//
//  HYFlowerDelOrderRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-6-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerDelOrderRequest.h"

@implementation HYFlowerDelOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/deleteOrder.action"];
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
        
        if ([self.userId length] > 0) {
            [newDic setObject:self.userId forKey:@"userId"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlowerDelOrderResponse *respose = [[HYFlowerDelOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
