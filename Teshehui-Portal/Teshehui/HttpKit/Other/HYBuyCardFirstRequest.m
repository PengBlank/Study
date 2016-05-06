//
//  HYBuyCardFirstRequest.m
//  Teshehui
//
//  Created by Kris on 15/9/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBuyCardFirstRequest.h"
#import "HYBuyCardFirstStepResponse.h"

@implementation HYBuyCardFirstRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/buy_card_online_check_sms_code.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.phone length] > 0)
        {
            [newDic setObject:self.phone forKey:@"phoneMob"];
        }
        
        if ([self.phone_code length] > 0)
        {
            [newDic setObject:self.phone_code forKey:@"checkCode"];
        }
        
        if ([self.invitationCode length] > 0) {
            [newDic setObject:self.invitationCode forKey:@"invitationCode"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYBuyCardFirstStepResponse *respose = [[HYBuyCardFirstStepResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
