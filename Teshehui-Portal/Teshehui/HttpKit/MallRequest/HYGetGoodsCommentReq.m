//
//  HYGetGoodsCommentReq.m
//  Teshehui
//
//  Created by HYZB on 15/10/19.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYGetGoodsCommentReq.h"
#import "HYGetCommentResponse.h"

@implementation HYGetGoodsCommentReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"comment/getProductCommentList.action"];
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
        if (self.orderCode)
        {
            [newDic setObject:self.orderCode forKey:@"orderCode"];
        }
        
        if (self.productSkuCode)
        {
            [newDic setObject:self.productSkuCode forKey:@"productSkuCode"];
        }
        if ([_pageNo length] > 0)
        {
            [newDic setObject:_pageNo forKey:@"pageNo"];
        }
        if ([_pageSize length] > 0)
        {
            [newDic setObject:_pageSize forKey:@"pageSize"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetCommentResponse *respose = [[HYGetCommentResponse alloc]initWithJsonDictionary:info];
    return respose;
}



@end
