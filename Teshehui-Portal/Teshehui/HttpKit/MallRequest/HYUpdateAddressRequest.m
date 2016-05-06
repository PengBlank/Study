//
//  HYUpdateAdressRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-3.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYUpdateAddressRequest.h"
#import "HYUpdateAdressResponse.h"

@implementation HYUpdateAddressRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/updateAddressDetail.action"];
        self.httpMethod = @"POST";
//        self.version = @"1.0.1";
        self.businessType = @"01";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.addr_id length] > 0)
        {
            [newDic setObject:self.addr_id forKey:@"addrId"];
        }
        
        if ([self.consignee length] > 0)
        {
            [newDic setObject:self.consignee forKey:@"consignee"];
        }
        
        if ([self.region_id length] > 0)
        {
            [newDic setObject:self.region_id forKey:@"regionId"];
        }
        
        if ([self.region_name length] > 0)
        {
            [newDic setObject:self.region_name forKey:@"regionName"];
        }
        
        if ([self.address length] > 0)
        {
            [newDic setObject:self.address forKey:@"address"];
        }
        
        if ([self.zipcode length] > 0)
        {
            [newDic setObject:self.zipcode forKey:@"zipcode"];
        }
        
        if ([self.phone_mob length] > 0)
        {
            [newDic setObject:self.phone_mob forKey:@"phoneMobile"];
        }
        
        if ([self.phone_tel length] > 0)
        {
            [newDic setObject:self.phone_tel forKey:@"phoneTel"];
        }
        
        [newDic setObject:@(_isDefault) forKey:@"isDefault"];
    }
    
    return newDic;
}

- (void)setAddressInfo:(HYAddressInfo *)addressInfo
{
    _addressInfo = addressInfo;
    self.addr_id = addressInfo.addr_id;
    self.consignee = addressInfo.consignee;
    self.region_id = addressInfo.areaId;
    self.region_name = addressInfo.areaName;
    self.address = addressInfo.address;
    self.phone_mob = addressInfo.phoneMobile;
    self.isDefault = addressInfo.isDefault;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYUpdateAdressResponse *respose = [[HYUpdateAdressResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
