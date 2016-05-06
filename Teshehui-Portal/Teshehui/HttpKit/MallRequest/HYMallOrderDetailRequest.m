//
//  HYMallOrderDetailRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-6-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderDetailRequest.h"
#import "HYUserInfo.h"

@implementation HYMallOrderDetailRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/getOrderDetail.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
        self.version = @"1.0.1";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (_order_code.length > 0)
        {
            [newDic setObject:self.order_code forKey:@"orderCode"];
        }
        
        NSString *userid = [HYUserInfo getUserInfo].userId;
        if (userid.length > 0)
        {
            [newDic setObject:userid forKey:@"userId"];
        }
        [newDic setObject:self.businessType forKey:@"businessType"];
    }
    
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallOrderDetailResponse *respose = [[HYMallOrderDetailResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
