//
//  HYMallRemindDeliverRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallRemindDeliverRequest.h"
#import "HYUserInfo.h"

@implementation HYMallRemindDeliverRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/remindDeliver.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
        self.version = @"1.0.1";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        NSString *userid = [HYUserInfo getUserInfo].userId;
        if (userid.length > 0)
        {
            [newDic setObject:userid forKey:@"userId"];
        }
        if (self.order_id.length > 0)
        {
            [newDic setObject:self.order_id
                       forKey:@"orderId"];
        }
        if (self.order_code.length > 0)
        {
            [newDic setObject:self.order_code forKey:@"orderCode"];
        }
    }
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallRemindDeliverResponse *respose = [[HYMallRemindDeliverResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
