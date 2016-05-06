//
//  HYOnlinePurchaseRequest.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-11-4.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYOnlinePurchaseRequest.h"

@implementation HYOnlinePurchaseRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"online_card/buy_card"];
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
        if ([self.name length] > 0)
        {
            [newDic setObject:self.name forKey:@"name"];
        }
        if ([self.id_card_type length] > 0)
        {
            [newDic setObject:self.id_card_type forKey:@"id_card_type"];
        }
        if ([self.id_card_num length] > 0)
        {
            [newDic setObject:self.id_card_num forKey:@"id_card_num"];
        }
        if ([self.sex length] > 0)
        {
            [newDic setObject:self.sex forKey:@"sex"];
        }
        if ([self.birthday length] > 0)
        {
            [newDic setObject:self.birthday forKey:@"birthday"];
        }
        if ([self.phone length] > 0)
        {
            [newDic setObject:self.phone forKey:@"phone"];
        }
        if ([self.phone_code length] > 0)
        {
            [newDic setObject:self.phone_code forKey:@"phone_code"];
        }
        if ([self.invitation_code length] > 0)
        {
            [newDic setObject:self.invitation_code forKey:@"invitation_code"];
        }
    }
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYOnlinePurchaseResponse *respose = [[HYOnlinePurchaseResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
