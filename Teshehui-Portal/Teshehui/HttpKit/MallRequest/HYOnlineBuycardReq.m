//
//  HYOnlineBuycardReq.m
//  Teshehui
//
//  Created by HYZB on 14/11/4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYOnlineBuycardReq.h"

@implementation HYOnlineBuycardReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/buy_card_online.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.cardPrice length] > 0)
        {
            [newDic setObject:self.cardPrice forKey:@"cardPrice"];
        }
        
        if ([self.productSkuCode length] > 0)
        {
            [newDic setObject:self.productSkuCode forKey:@"productSkuCode"];
        }
        
        if ([self.birthday length] > 0)
        {
            [newDic setObject:self.birthday forKey:@"birthday"];
        }
        
        if ([self.hasPolicy length] > 0)
        {
            [newDic setObject:self.hasPolicy forKey:@"hasPolicy"];
        }
        
        if ([self.idCardNum length] > 0)
        {
            [newDic setObject:self.idCardNum forKey:@"idCardNum"];
        }
        
        if ([self.idCardType length] > 0)
        {
            [newDic setObject:self.idCardType forKey:@"idCardType"];
        }
        
        if ([self.invitationCode length] > 0)
        {
            [newDic setObject:self.invitationCode
                       forKey:@"invitationCode"];
        }
        
        if ([self.name length] > 0)
        {
            [newDic setObject:self.name forKey:@"name"];
        }
        
        if ([self.phone length]>0)
        {
            [newDic setObject:self.phone forKey:@"phone"];
        }
        
        if ([self.policyType length]>0)
        {
            [newDic setObject:self.policyType forKey:@"policyType"];
        }
        
        if ([self.sex length]>0)
        {
            [newDic setObject:self.sex forKey:@"sex"];
        }
        
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYOnlineBuyCardResp *respose = [[HYOnlineBuyCardResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end
