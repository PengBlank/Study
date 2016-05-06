//
//  HYCardActiveThreeRequest.m
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCardActiveThreeRequest.h"

@implementation HYCardActiveThreeRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/activateUserStepThree.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        self.memberCardNumber.length > 0&&
        self.checkCode.length > 0)
    {
        [newDic setObject:self.memberCardNumber forKey:@"memberCardNumber"];
        [newDic setObject:self.checkCode forKey:@"checkCode"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCardActiveThreeResponse *respose = [[HYCardActiveThreeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
