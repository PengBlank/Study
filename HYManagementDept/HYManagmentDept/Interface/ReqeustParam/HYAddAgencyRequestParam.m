//
//  HYAddAgencyRequestParam.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAddAgencyRequestParam.h"

@implementation HYAddAgencyRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_member_edit"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.company_id length] > 0)
        {
            [newDic setObject:self.company_id forKey:@"company_id"];
        }
        
        if ([self.agency_name length] > 0)
        {
            [newDic setObject:self.agency_name forKey:@"agency_name"];
        }
        
        if ([self.agency_tel length] > 0)
        {
            [newDic setObject:self.agency_tel forKey:@"agency_tel"];
        }
        
        if ([self.agency_address length] > 0)
        {
            [newDic setObject:self.agency_address forKey:@"agency_address"];
        }
        
        if ([self.agency_bank_accout length] > 0)
        {
            [newDic setObject:self.agency_bank_accout forKey:@"agency_bank_accout"];
        }
        
        if ([self.agency_bank_name length] > 0)
        {
            [newDic setObject:self.agency_bank_name forKey:@"agency_bank_name"];
        }
        
        if ([self.agency_payee length] > 0)
        {
            [newDic setObject:self.agency_payee forKey:@"agency_payee"];
        }
        
        if ([self.status length] > 0) {
            [newDic setObject:self.status forKey:@"status"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAddAgencyResponse *respose = [[HYAddAgencyResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
