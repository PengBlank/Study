//
//  HYCommentAddOneStepReq.m
//  Teshehui
//
//  Created by HYZB on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYCommentAddOneStepReq.h"
#import "HYCommentAddOneStepResponse.h"

@implementation HYCommentAddOneStepReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"comment/getReviewProductList.action"];
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
        if ([_orderCode length] > 0)
        {
            [newDic setObject:_orderCode forKey:@"orderCode"];
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
    HYCommentAddOneStepResponse *respose = [[HYCommentAddOneStepResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
