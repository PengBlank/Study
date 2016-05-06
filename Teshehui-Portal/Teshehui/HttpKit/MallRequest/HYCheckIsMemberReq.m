//
//  HYCheckIsMemberReq.m
//  Teshehui
//
//  Created by HYZB on 15/3/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCheckIsMemberReq.h"

@implementation HYCheckIsMemberReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/red_packet/check_is_member"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *dict = [super getJsonDictionary];
    
    if (self.type)
    {
        [dict setObject:self.type forKey:@"type"];
    }
    if (self.user_name)
    {
        [dict setObject:self.user_name forKey:@"user_name"];
    }
    
    return dict;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    CQBaseResponse *respose = [[CQBaseResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
