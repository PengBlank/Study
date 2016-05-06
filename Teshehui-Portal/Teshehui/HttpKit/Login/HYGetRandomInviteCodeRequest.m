//
//  HYGetRandomInviteCodeRequest.m
//  Teshehui
//
//  Created by Kris on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYGetRandomInviteCodeRequest.h"
#import "HYGetRandomInviteCodeResponse.h"

@implementation HYGetRandomInviteCodeRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/users/rand_invitation_code"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *json = [super getJsonDictionary];
    return json;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetRandomInviteCodeResponse *respose = [[HYGetRandomInviteCodeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
