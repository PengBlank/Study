//
//  HYDeletePassengerRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYDeletePassengerRequest.h"

@implementation HYDeletePassengerRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/deleteContact.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.passenger_id length] > 0)
    {
        if ([self.user_id length] > 0)
        {
            [newDic setObject:self.user_id forKey:@"user_id"];
        }
        [newDic setObject:self.passenger_id forKey:@"contactId"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPassengerListResponse *respose = [[HYPassengerListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
