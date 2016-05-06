//
//  HYGetFavoriteGoodsListRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetFavoriteGoodsListRequest.h"

@implementation HYGetFavoriteGoodsListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"collect/queryUserCollect.action"];
        self.httpMethod = @"POST";
        self.num_per_page = 10;
        self.businessType = @"01";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.page]
                   forKey:@"pageNo"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.num_per_page]
                   forKey:@"pageSize"];
        
        if (self.userid.length > 0)
        {
            [newDic setObject:self.userid forKey:@"userId"];
        }
        if (self.productid.length > 0)
        {
            [newDic setObject:self.productid forKey:@"productId"];
        }
    }
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetFavoriteGoodsListResponse *respose = [[HYGetFavoriteGoodsListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
