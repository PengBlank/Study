//
//  HYSeckillActivityListReq.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSeckillActivityListReq.h"

@implementation HYSeckillActivityListReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"seckill/getSeckillActivityList.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
        self.limit = 3;
        self.page = 1;
        self.pageSize = 20;
    }
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (self.userId) {
        [data setObject:self.userId forKey:@"userId"];
    }
    [data setObject:@(_limit) forKey:@"limit"];
    [data setObject:@(_page) forKey:@"pPageNo"];
    [data setObject:@(_pageSize) forKey:@"pPageSize"];
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    return [[HYSeckillActivityListResp alloc] initWithJsonDictionary:info];
}

@end
