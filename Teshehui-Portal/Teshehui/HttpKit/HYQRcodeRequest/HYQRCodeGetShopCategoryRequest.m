//
//  HYQRCodeGetShopCategoryRequest.m
//  Teshehui
//
//  Created by Kris on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYQRCodeGetShopCategoryRequest.h"

@implementation HYQRCodeGetShopCategoryRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/merchant/merchantCategory"];
//        self.interfaceURL = [NSString stringWithFormat:@"http://portal.t.teshehui.com/v2/api/merchant/merchantCategory"];
        self.httpMethod = @"POST";
        self.postType = JSON;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (_cityName.length > 0)
        {
            [newDic setObject:[NSString stringWithFormat:@"%@", self.cityName]
                       forKey:@"region_name"];
        }
    }
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYQRCodeGetShopCategoryResponse *respose = [[HYQRCodeGetShopCategoryResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
