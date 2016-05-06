//
//  CQGetFilghtDynamic.m
//  ComeHere
//
//  Created by ChengQian on 13-11-12.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQGetFilghtDynamicRequest.h"
#import "CQGetFilghtDynamicResponse.h"

@implementation CQGetFilghtDynamicRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://dynamic.bnx6688.com/DynamicList/";
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.UserID length] > 0)
        {
            [newDic setObject:self.UserID
                       forKey:@"UserID"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    CQGetFilghtDynamicResponse *respose = [[CQGetFilghtDynamicResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
