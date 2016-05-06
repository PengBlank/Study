//
//  HYDelAdressRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-3.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYDelAddressRequest.h"
#import "HYDelAddressResponse.h"

@implementation HYDelAddressRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/deleteAddress.action"];
        self.httpMethod = @"POST";
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
            [newDic setObject:self.addr_id forKey:@"addressId"];
        }
        
        if ([self.user_id length] > 0)
        {
            [newDic setObject:self.user_id forKey:@"userId"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYDelAddressResponse *respose = [[HYDelAddressResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
