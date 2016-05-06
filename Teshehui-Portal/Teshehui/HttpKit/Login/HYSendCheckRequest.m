//
//  HYSendCheckRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYSendCheckRequest.h"
#import "HYSendCheckResponse.h"

@implementation HYSendCheckRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/buy_card_online_send_sms.action"];
        self.httpMethod = @"POST";
    }
    
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
//        if ([self.code length] > 0)
//        {
//            [newDic setObject:self.code forKey:@"code"];
//        }
        
        if ([self.phone_mob length] > 0)
        {
            [newDic setObject:self.phone_mob forKey:@"phoneMob"];
        }
        
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYSendCheckResponse *respose = [[HYSendCheckResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
