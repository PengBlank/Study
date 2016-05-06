//
//  HYMyDesirePoolRequest.m
//  Teshehui
//
//  Created by HYZB on 15/11/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyDesirePoolRequest.h"
#import "HYMyDesirePoolResponse.h"

@implementation HYMyDesirePoolRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"wish/getWishList.action"];
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
    if (self.status) {
        [data setObject:self.status forKey:@"status"];
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
    HYMyDesirePoolResponse *response = [[HYMyDesirePoolResponse alloc] initWithJsonDictionary:info];
    return response;
}

@end
