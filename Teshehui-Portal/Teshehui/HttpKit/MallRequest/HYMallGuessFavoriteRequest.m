//
//  HYMallGuessFavoriteRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGuessFavoriteRequest.h"

@implementation HYMallGuessFavoriteRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"recommend/queryRecommendProduct.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.userId)
        {
            [newDic setObject:self.userId
                       forKey:@"userId"];
        }
        if (self.productCode)
        {
            [newDic setObject:self.productCode
                       forKey:@"productCode"];
        }
        if (self.brandCode)
        {
            [newDic setObject:self.brandCode
                       forKey:@"brandCode"];
        }
        if (self.categoryCode)
        {
            [newDic setObject:self.categoryCode
                       forKey:@"categoryCode"];
        }
        
        [newDic setObject:[NSNumber numberWithInteger:self.maxRows]
                   forKey:@"maxRows"];
        
        if (self.recType)
        {
            [newDic setObject:self.recType
                       forKey:@"recType"];
        }
        
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallGuessFavoriteResponse *respose = [[HYMallGuessFavoriteResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
