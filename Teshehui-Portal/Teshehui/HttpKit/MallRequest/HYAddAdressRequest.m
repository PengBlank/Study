//
//  HYAddAdressRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAddAdressRequest.h"
#import "HYAddAdressResponse.h"

@implementation HYAddAdressRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/addAddressDetail.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
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
        
        if (self.isDefault)
        {
            [newDic setObject:@(self.isDefault) forKey:@"isDefault"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAddAdressResponse *respose = [[HYAddAdressResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
