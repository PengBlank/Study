//
//  HYCardActiveFiveRequest.m
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCardActiveFiveRequest.h"

@implementation HYCardActiveFiveRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/activateUserStepFive.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:self.memberCardNumber forKey:@"memberCardNumber"];
        
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
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCardActiveFiveResponse *respose = [[HYCardActiveFiveResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
