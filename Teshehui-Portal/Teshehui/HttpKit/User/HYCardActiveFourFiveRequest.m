//
//  HYCardActiveFourFiveRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCardActiveFourFiveRequest.h"

@implementation HYCardActiveFourFiveRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/activateUserStepFourAndFive.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.memberCardNumber)
        {
            [newDic setObject:self.memberCardNumber forKey:@"memberCardNumber"];
        }
        
        if (self.realName.length > 0)
        {
            [newDic setObject:self.realName forKey:@"realName"];
        }
        if (self.gender)
        {
            [newDic setObject:self.gender forKey:@"gender"];
        }
        
        
        if (self.certificateCode)
        {
            [newDic setObject:self.certificateCode
                       forKey:@"certificateCode"];
        }
        
        if ([self.birthday length] > 0)
        {
            [newDic setObject:self.birthday forKey:@"birthday"];
        }
        [newDic setObject:@(_activeType) forKey:@"activeType"];
        
        if (self.certificateNumber > 0)
        {
            [newDic setObject:self.certificateNumber forKey:@"certificateNumber"];
        }
        if ([self.password length] > 0)
        {
            [newDic setObject:self.password forKey:@"password"];
        }
        if ([self.isBuyPolicy length] > 0)
        {
            [newDic setObject:self.isBuyPolicy forKey:@"isBuyPolicy"];
        }
        if ([self.policyType length] > 0)
        {
            [newDic setObject:self.policyType forKey:@"policyType"];
        }
        
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCardActiveFourFiveResponse *respose = [[HYCardActiveFourFiveResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
