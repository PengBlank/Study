//
//  HYGetOrderReturnDetailRequest.m
//  Teshehui
//
//  Created by RayXiang on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYOrderReturnDetailRequest.h"

@implementation HYOrderReturnDetailRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/order/order_return_detail"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.return_id.length > 0)
        {
            [newDic setObject:_return_id forKey:@"return_id"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYOrderReturnDetailResponse *respose = [[HYOrderReturnDetailResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
