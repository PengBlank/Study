//
//  HYQRCodeGetShopDetailRequest.m
//  Teshehui
//
//  Created by HYZB on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYQRCodeGetShopDetailRequest.h"

@implementation HYQRCodeGetShopDetailRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kMallRequestBaseURL, @"api/merchant/get_merchant_info"];
        self.httpMethod = @"GET";
        self.repIsJsonData = NO;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:[NSNumber numberWithInteger:self.merchant_id]
                   forKey:@"merchant_id"];
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYQRCodeGetShopDetailResponse *respose = [[HYQRCodeGetShopDetailResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
