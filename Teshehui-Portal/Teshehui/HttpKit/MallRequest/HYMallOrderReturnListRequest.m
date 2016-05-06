//
//  HYMallOrderReturnListRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderReturnListRequest.h"

@implementation HYMallOrderReturnListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/afterSeller/getReturnFlowList.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
        self.businessType = @"01";
        self.version = @"1.0.1";
    }
    
    return self;
}

//- (NSMutableDictionary *)getDataDictionary
//{
//    NSMutableDictionary *data = [NSMutableDictionary dictionary];
//    
//    
//    return data;
//}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.page]
                   forKey:@"pageNo"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.num_per_page]
                   forKey:@"pageSize"];
        [newDic setObject:@(_refund_type) forKey:@"operationType"];
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallOrderReturnListResponse *respose = [[HYMallOrderReturnListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
