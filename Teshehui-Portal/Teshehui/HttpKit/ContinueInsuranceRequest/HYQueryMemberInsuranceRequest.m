//
//  HYQueryMemberInsurance.m
//  Teshehui
//
//  Created by Kris on 15/6/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYQueryMemberInsuranceRequest.h"
#import "HYQueryMemberInsuranceResponse.h"

@implementation HYQueryMemberInsuranceRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/queryMemberInsurance.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.userId length] > 0) {
            
            [newDic setObject:self.userId forKey:@"userId"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYQueryMemberInsuranceResponse *respose = [[HYQueryMemberInsuranceResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
