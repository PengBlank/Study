//
//  HYMallAdressListRequest.m
//  Teshehui
//
//  Created by ichina on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetAdressListRequest.h"
#import "HYGetAdressListResponse.h"

@implementation HYGetAdressListRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/queryAddresses.action"];
        self.httpMethod = @"POST";
        self.version = @"1.0.1";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.userId)
        {
            [newDic setObject:self.userId
                       forKey:@"userId"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetAdressListResponse *respose = [[HYGetAdressListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
