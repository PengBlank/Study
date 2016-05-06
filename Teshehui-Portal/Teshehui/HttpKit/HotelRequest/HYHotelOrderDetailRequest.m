//
//  HYHotelOrderDetailRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderDetailRequest.h"

@implementation HYHotelOrderDetailRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
//        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kHotelRequestBaseURL, @"json/orders/order_detail/"];
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/getOrderDetail.action"];
        self.httpMethod = @"POST";
        self.businessType = @"03";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.orderId length] > 0)
    {
        if ([self.userId length] > 0)
        {
            [newDic setObject:self.userId forKey:@"userId"];
        }
        [newDic setObject:self.orderId forKey:@"orderId"];
        [newDic setObject:self.businessType forKey:@"businessType"];
        if (self.employeeId.length > 0)
        {
            [newDic setObject:self.employeeId forKey:@"employeeId"];
        }
        if ([self.is_enterprise length] > 0)
        {
            [newDic setObject:self.is_enterprise forKey:@"isEnterprise"];
        }
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"酒店订单详情请求缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYHotelOrderDetailResponse *respose = [[HYHotelOrderDetailResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
