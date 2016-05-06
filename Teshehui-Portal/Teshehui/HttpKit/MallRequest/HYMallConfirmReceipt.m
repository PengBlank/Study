//
//  HYMallConfirmReceipt.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallConfirmReceipt.h"

@implementation HYMallConfirmReceipt

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/order/confirm_order"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.order_id length] > 0)
        {
            [newDic setObject:self.order_id forKey:@"order_id"];
        }
    }
    
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallConfirmReceiptResponse *respose = [[HYMallConfirmReceiptResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
