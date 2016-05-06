//
//  HYMallApplaudRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallApplaudRequest.h"

@implementation HYMallApplaudRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"praise/addPraise.action"];
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
        if (self.goodsId)
        {
            [newDic setObject:self.goodsId
                       forKey:@"productId"];
        }
        if (self.userid.length > 0)
        {
            [newDic setObject:_userid
                       forKey:@"userId"];
        }
        if (self.productName.length > 0)
        {
            [newDic setObject:_productName
                       forKey:@"productName"];
        }
        [newDic setObject:self.businessType forKey:@"businessType"];
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallApplaudResponse *respose = [[HYMallApplaudResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
