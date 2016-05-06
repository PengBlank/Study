//
//  HYApplyAfterSaleServiceListReq.m
//  Teshehui
//
//  Created by Kris on 15/10/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYApplyAfterSaleServiceListReq.h"
#import "HYApplyAfterSaleServiceListResponse.h"

@implementation HYApplyAfterSaleServiceListReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"afterSeller/getOrderList2Return.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([_pageNo length] > 0)
        {
            [newDic setObject:_pageNo forKey:@"pageNo"];
        }
        
        if ([_pageSize length] > 0)
        {
            [newDic setObject:_pageSize forKey:@"pageSize"];
        }
        if ([_orderCode length] > 0)
        {
            [newDic setObject:_orderCode forKey:@"orderCode"];
        }
    }
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYApplyAfterSaleServiceListResponse *respose = [[HYApplyAfterSaleServiceListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
