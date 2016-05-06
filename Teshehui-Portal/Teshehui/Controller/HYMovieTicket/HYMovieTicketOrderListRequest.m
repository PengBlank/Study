//
//  HYMovieTicketOrderListRequest.m
//  Teshehui
//
//  Created by HYZB on 16/2/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMovieTicketOrderListRequest.h"
#import "HYMovieTicketOrderListResponse.h"

@implementation HYMovieTicketOrderListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/queryOrderList.action"];
        self.httpMethod = @"POST";
        self.businessType = @"60";
    }
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    if (self.userId)
    {
        [data setObject:self.userId forKey:@"userId"];
    }
    
    if (self.pageNo)
    {
        [data setObject:@(self.pageNo) forKey:@"pageNo"];
    }
    
    if (self.pageSize)
    {
        [data setObject:@(self.pageSize) forKey:@"pageSize"];
    }
    
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    return [[HYMovieTicketOrderListResponse alloc] initWithJsonDictionary:info];
}


@end
