//
//  HYContinueInsuranceRequest.m
//  Teshehui
//
//  Created by HYZB on 15/3/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYContinueInsuranceRequest.h"
#import "HYContinueInsuranceResponse.h"

@implementation HYContinueInsuranceRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/card_upgrade.action"];
        
        self.httpMethod = @"POST";
        
        //        self.bunessType = 4;
        //        self.cateId = @"17";
        //        self.level = 4;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {   
        if ([self.userName length] > 0) {
            
            [newDic setObject:self.userName forKey:@"userName"];
        }
        
        if ([self.price length] > 0) {
            
            [newDic setObject:self.price forKey:@"price"];
        }
        
        if ([self.productSkuCode length] > 0) {
            
            [newDic setObject:self.productSkuCode forKey:@"productSkuCode"];
        }
        
        if ([self.orderType length] > 0) {
            
            [newDic setObject:self.orderType forKey:@"orderType"];
        }
        
        if ([self.policyType length] > 0) {
            
            [newDic setObject:self.policyType forKey:@"policyType"];
        }
        
        if ([self.hasPolicy length] > 0) {
            
            [newDic setObject:self.hasPolicy forKey:@"hasPolicy"];
        }
        
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYContinueInsuranceResponse *respose = [[HYContinueInsuranceResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
