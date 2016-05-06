//
//  HYCancelFavoriteGoodsRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCancelFavoriteGoodsRequest.h"

@implementation HYCancelFavoriteGoodsRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"collect/deleteUserCollect.action"];
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
        [newDic setObject:self.businessType forKey:@"businessType"];
        if (self.userid)
        {
            [newDic setObject:self.userid
                       forKey:@"userId"];
        }
        if (self.goods_id)
        {
            [newDic setObject:self.goods_id
                       forKey:@"productId"];
        }
    }
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCancelFavoriteGoodsResponse *respose = [[HYCancelFavoriteGoodsResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
