//
//  CQGetFilghtDynamicDetailRequest.m
//  ComeHere
//
//  Created by ChengQian on 13-11-12.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQGetFilghtDynamicDetailRequest.h"
#import "CQGetFilghtDynamicDetailResponse.h"

@implementation CQGetFilghtDynamicDetailRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://dynamic.bnx6688.com/DynamicDetail/";
        self.httpMethod = @"GET";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.DynamicID length] > 0)
        {
            [newDic setObject:self.DynamicID
                       forKey:@"DynamicID"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    CQGetFilghtDynamicDetailResponse *respose = [[CQGetFilghtDynamicDetailResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
