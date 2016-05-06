//
//  HYCardActiveTwoRequest.m
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCardActiveTwoRequest.h"

@implementation HYCardActiveTwoRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/activateUserStepTwo.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        self.memberCardNumber.length > 0&&
        self.mobilePhone.length > 0)
    {
        [newDic setObject:self.memberCardNumber forKey:@"memberCardNumber"];
        [newDic setObject:self.mobilePhone forKey:@"mobilePhone"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCardActiveTwoResponse *respose = [[HYCardActiveTwoResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
