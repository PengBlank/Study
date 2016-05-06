//
//  HYMyDesireDetailRequest.m
//  Teshehui
//
//  Created by HYZB on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyDesireDetailRequest.h"
#import "HYMyDesireDetailResponse.h"

@implementation HYMyDesireDetailRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"wish/getWishDetail.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    if (self.userId) {
        [data setObject:self.userId forKey:@"userId"];
    }
    if (self.desire_id) {
        [data setObject:@(self.desire_id) forKey:@"id"];
    }
    
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMyDesireDetailResponse *response = [[HYMyDesireDetailResponse alloc] initWithJsonDictionary:info];
    return response;
}

@end
