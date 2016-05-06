//
//  HYMallGetAllBrandListReq.m
//  Teshehui
//
//  Created by Kris on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallGetAllBrandListReq.h"
#import "HYMallGetAllBrandListResponse.h"

@implementation HYMallGetAllBrandListReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"index/allBrandListSearch.action"];
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
    HYMallGetAllBrandListResponse *respose = [[HYMallGetAllBrandListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
