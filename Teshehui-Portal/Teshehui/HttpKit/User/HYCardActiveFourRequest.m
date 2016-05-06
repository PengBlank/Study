//
//  HYCardActiveFourRequest.m
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCardActiveFourRequest.h"

@implementation HYCardActiveFourRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/activateUserStepFour.action"];
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
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
     HYCardActiveFourResponse *respose = [[HYCardActiveFourResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
