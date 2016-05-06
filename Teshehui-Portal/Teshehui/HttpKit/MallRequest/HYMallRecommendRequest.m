//
//  HYMallRecommendRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallRecommendRequest.h"

@implementation HYMallRecommendRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"index/changeABatchProduct.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageSize]
                   forKey:@"pageSize"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageNo]
                   forKey:@"pageNo"];
        
        if (self.boardCode)
        {
            [newDic setObject:self.boardCode
                       forKey:@"boardCode"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallRecommendResponse *respose = [[HYMallRecommendResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
