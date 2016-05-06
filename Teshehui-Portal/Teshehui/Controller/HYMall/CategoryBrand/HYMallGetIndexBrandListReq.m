//
//  HYMallGetIndexBrandListReq.m
//  Teshehui
//
//  Created by Kris on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallGetIndexBrandListReq.h"
#import "HYMallGetIndexBrandListResponse.h"

@implementation HYMallGetIndexBrandListReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"index/getIndexBrandList.action"];
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
        
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallGetIndexBrandListResponse *respose = [[HYMallGetIndexBrandListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
