//
//  HYGetAllPassengerRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetAllPassengerListRequest.h"

@implementation HYGetAllPassengerListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/queryContactList.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPassengerListResponse *respose = [[HYPassengerListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
