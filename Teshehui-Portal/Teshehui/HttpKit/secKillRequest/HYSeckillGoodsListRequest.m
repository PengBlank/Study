//
//  HYSeckillGoodsListRequest.m
//  Teshehui
//
//  Created by HYZB on 15/12/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSeckillGoodsListRequest.h"
#import "HYSeckillGoodsListResponse.h"

@implementation HYSeckillGoodsListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"seckill/getSeckillActivityProductList.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    if (self.userId) {
        [data setObject:self.userId forKey:@"userId"];
    }
    if (self.activityId) {
        [data setObject:self.activityId forKey:@"activityId"];
    }
    if (self.pageNo) {
        [data setObject:self.pageNo forKey:@"pageNo"];
    }
    if (self.pageSize) {
        [data setObject:self.pageSize forKey:@"pageSize"];
    }
    
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYSeckillGoodsListResponse *response = [[HYSeckillGoodsListResponse alloc] initWithJsonDictionary:info];
    return response;
}

@end
