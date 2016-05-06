//
//  HYOutOrderListRequest.m
//  HYManagmentDept
//
//  Created by Ray on 14-12-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYOutOrderListRequest.h"

@implementation HYOutOrderListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_outstanding_orders"];
        self.httpMethod = @"POST";
        self.postType = JSON;
        _page = 1;
        _num_per_page = 20;
        
    }
    
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.order_no)
        {
            [newDic setObject:_order_no forKey:@"order_no"];
        }
        if (self.start_time)
        {
            [newDic setObject:_start_time forKey:@"start_time"];
        }
        if (self.end_time)
        {
            [newDic setObject:_end_time forKey:@"end_time"];
        }
        [newDic setObject:[NSNumber numberWithInteger:_type] forKey:@"type"];
        
        [newDic setObject:[NSNumber numberWithInteger:_page] forKey:@"page"];
        [newDic setObject:[NSNumber numberWithInteger:_num_per_page] forKey:@"num_per_page"];
    }
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYOutOrderListResponse *respose = [[HYOutOrderListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
