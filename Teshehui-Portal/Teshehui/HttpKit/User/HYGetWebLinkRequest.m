//
//  HYAboutRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetWebLinkRequest.h"
#import "HYGetWebLinkResponse.h"

@implementation HYGetWebLinkRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.httpMethod = @"POST";
    }
    
    return self;
}

#pragma mark setter/getter
- (NSString *)interfaceURL
{
    NSString *url = nil;
    switch (self.type)
    {
        case HelpInfo:
            url = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/help/gethelp"];
            break;
        case Introduction:
            url = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/enterprise/getCompany"];
            break;
        case CoyprightInfo:
            url = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/enterprise/getCopyright"];
            break;
        case AttentionInfo:
            url = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/enterprise/getContact"];
            break;
        case InsuranceInfo:
            url = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/enterprise/getInsurance"];
            break;
        case RealnameConfirm:
            url = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/default/get_copywriting"];
            break;
        case InviteCodeInfo:
            url = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/default/get_copywriting"];
            break;
        default:
            break;
    }
    
    return url;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (InviteCodeInfo == self.type)
    {
        NSString *key = @"how_to_get_invitation_code";
        [newDic setObject:key forKey:@"copywriting_key"];
    }
    if (InsuranceInfo == self.type)
    {
        if (self.cardNum)
        {
            [newDic setObject:self.cardNum forKey:@"card"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetWebLinkResponse *respose = [[HYGetWebLinkResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
