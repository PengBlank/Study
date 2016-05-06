//
//  HYGetMslselectionRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetMslselectionRequest.h"
#import "HYGetMslselectionResponse.h"
#import "HYUserInfo.h"

@implementation HYGetMslselectionRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/queryRegion.action"];
        self.httpMethod = @"POST";
//        self.businessType = @"";
        self.version = @"1.0.1";
        //判断用户登陆情况
        HYUserInfo *userinfo = [HYUserInfo getUserInfo];
        if (userinfo.userId)
        {
            self.userid = userinfo.userId;
        }
        else
        {
            return nil;
        }
        
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.pid length] > 0)
        {
            [newDic setObject:self.pid forKey:@"parentId"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetMslselectionResponse *respose = [[HYGetMslselectionResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
