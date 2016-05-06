//
//  HYTaxiCallCarAgainReq.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiCallCarAgainReq.h"

@implementation HYTaxiCallCarAgainReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"traffic/didi/callCarAgain.action"];
        self.httpMethod = @"POST";
        self.businessType = @"22";
    }
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.didiOrderId) {
        [dict setObject:self.didiOrderId forKey:@"didiOrderId"];
    }
    if (self.carTypeCode) {
        [dict setObject:self.carTypeCode forKey:@"carTypeCode"];
    }
    
    return dict;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYTaxiCallCarAgainResp *respose = [[HYTaxiCallCarAgainResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end
