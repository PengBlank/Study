//
//  HYMallAddFavoriteRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallAddFavoriteRequest.h"

@implementation HYMallAddFavoriteRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"collect/addUserCollect.action"];
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
        if (self.goodsId.length > 0)
        {
            [newDic setObject:self.goodsId
                       forKey:@"productId"];
        }
        if (self.userid.length > 0)
        {
            [newDic setObject:self.userid forKey:@"userId"];
        }
        [newDic setObject:self.businessType forKey:@"businessType"];
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallAddFavoriteResponse *respose = [[HYMallAddFavoriteResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
