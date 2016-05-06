//
//  HYMallStoreListRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallStoreListRequest.h"

@implementation HYMallStoreListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"index/getMoreProgramContent.action"];
        self.httpMethod = @"POST";  //需要缓存
        self.pageSize = 10;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] && self.boardCode)
    {
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageSize]
                   forKey:@"pageSize"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageNo]
                   forKey:@"pageNo"];
        [newDic setObject:self.boardCode
                   forKey:@"boardCode"];
    }
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallStoreListResponse *respose = [[HYMallStoreListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
