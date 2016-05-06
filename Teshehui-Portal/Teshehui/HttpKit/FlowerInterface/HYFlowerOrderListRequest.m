//
//  HYFlowerOrderListRequest.m
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerOrderListRequest.h"
#import "HYFlowerOrderListResponse.h"

@implementation HYFlowerOrderListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/orderList.action"];
        self.httpMethod = @"POST";
        self.businessType = @"04";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageNo]
                   forKey:@"pageNo"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageSize]
                   forKey:@"pageSize"];
        
        if ([self.type length] > 0)
        {
            [newDic setObject:self.type forKey:@"type"];
        }
        
        if ([self.employeeId length] > 0)
        {
            [newDic setObject:self.employeeId forKey:@"employeeId"];
        }
        
        if ([self.userId length] > 0)
        {
            [newDic setObject:self.userId forKey:@"userId"];
        }
        
        if (self.startTime > 0)
        {
            [newDic setObject:self.startTime
                       forKey:@"startTime"];
        }
        
        if (self.endTime > 0)
        {
            [newDic setObject:self.endTime
                       forKey:@"endTime"];
        }
        
        [newDic setObject:[NSNumber numberWithInt:self.isEnterprise]
                   forKey:@"isEnterprise"];
        
        [newDic setObject:self.businessType
                   forKey:@"businessType"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlowerOrderListResponse *respose = [[HYFlowerOrderListResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
