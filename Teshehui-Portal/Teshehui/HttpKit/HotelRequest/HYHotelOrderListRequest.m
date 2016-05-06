//
//  HYHotelOrderListRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderListRequest.h"
#import "HYHotelOrderListResponse.h"

@implementation HYHotelOrderListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/orderList.action"];
        self.httpMethod = @"POST";
        _pageSize = @"10";
        _pageNo = @"1";
        _isEnterprise = @"0";
        self.businessType = @"03";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.userId length] > 0)
        {
            [newDic setObject:self.userId forKey:@"userId"];
        }
        [newDic setObject:self.pageSize forKey:@"pageSize"];
        [newDic setObject:self.pageNo forKey:@"pageNo"];
        
        
        if ([self.isEnterprise length] > 0)
        {
            [newDic setObject:self.isEnterprise forKey:@"isEnterprise"];
        }
        
        if ([self.businessType length] > 0)
        {
            [newDic setObject:self.businessType forKey:@"businessType"];
        }
        
        if ([self.employeeId length] > 0)
        {
            [newDic setObject:self.employeeId forKey:@"employeeId"];
        }
        
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"酒店订单列表请求缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYHotelOrderListResponse *respose = [[HYHotelOrderListResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
