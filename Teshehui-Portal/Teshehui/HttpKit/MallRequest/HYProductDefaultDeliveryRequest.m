//
//  HYProductDefaultDeliveryRequest.m
//  Teshehui
//
//  Created by HYZB on 15/12/31.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYProductDefaultDeliveryRequest.h"
#import "HYUserInfo.h"

@implementation HYProductDefaultDeliveryRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"delivery/batchQueryStoreProductDelivery.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    NSString *userId = [HYUserInfo getUserInfo].userId;
    if (userId) {
        [data setObject:userId forKey:@"userId"];
    }
    if (self.userAddressId) {
        [data setObject:self.userAddressId forKey:@"userAddressId"];
    }
    if (self.productStoreList) {
        
        [data setObject:self.productStoreList forKey:@"productStoreList"];
    }
    
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYProductDefaultDeliveryResponse *respose = [[HYProductDefaultDeliveryResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYProductDefaultDeliveryResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary]) {
        NSArray *array = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        self.companyList = [HYMallDefaultProductDeliveryModel arrayOfModelsFromDictionaries:array];
    }
    return self;
}


@end
