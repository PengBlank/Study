//
//  HYMallAfterSaleDetailRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallAfterSaleDetailRequest.h"
#import "HYMallAfterSaleDetailResponse.h"

@implementation HYMallAfterSaleDetailRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/afterSeller/getReturnFlowDetail.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
        self.businessType = @"01";
        self.version = @"1.0.1";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:self.flowCode forKey:@"returnFlowCode"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallAfterSaleDetailResponse *respose = [[HYMallAfterSaleDetailResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
