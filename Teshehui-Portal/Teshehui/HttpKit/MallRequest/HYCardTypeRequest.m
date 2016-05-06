//
//  HYCardTypeRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCardTypeRequest.h"

@implementation HYCardTypeRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/user/queryCertifacate.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
        self.applicationType = @"01";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *dict = [super getJsonDictionary];
    if (self.applicationType.length > 0)
    {
        [dict setObject:self.applicationType forKey:@"applicationType"];
    }
    return dict;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCardTypeResponse *respose = [[HYCardTypeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
