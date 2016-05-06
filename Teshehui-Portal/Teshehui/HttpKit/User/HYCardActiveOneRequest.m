//
//  HYCardActiveOneRequest.m
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCardActiveOneRequest.h"

@implementation HYCardActiveOneRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/activateUserStepOne.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        self.memberCardNumber.length > 0&&
        self.memberCardPassword.length > 0)
    {
        [newDic setObject:self.memberCardNumber forKey:@"memberCardNumber"];
        [newDic setObject:self.memberCardPassword forKey:@"memberCardPassword"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCardActiveOneResponse *respose = [[HYCardActiveOneResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
