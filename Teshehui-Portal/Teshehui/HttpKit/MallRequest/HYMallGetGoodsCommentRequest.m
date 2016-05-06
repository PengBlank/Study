//
//  HYMallGetGoodsCommentRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGetGoodsCommentRequest.h"

@implementation HYMallGetGoodsCommentRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"comment/queryProductComment.action"];
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
        if ([self.goods_id length] > 0)
        {
            [newDic setObject:self.goods_id forKey:@"productId"];
        }
        
        //if ([self.page length] > 0)
        {
            [newDic setObject:[NSNumber numberWithInteger:_page] forKey:@"pageNo"];
        }
        
        //if ([self.num_per_page length] > 0)
        {
            [newDic setObject:[NSNumber numberWithInteger:_num_per_page] forKey:@"pageSize"];
        }
        if (self.userid.length > 0)
        {
            [newDic setObject:_userid forKey:@"userId"];
        }
        [newDic setObject:self.businessType forKey:@"businessType"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallGetGoodsCommentResponse *respose = [[HYMallGetGoodsCommentResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
