//
//  HYProductDetailGuessYouLikeReq.m
//  Teshehui
//
//  Created by Kris on 16/4/11.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYProductDetailGuessYouLikeReq.h"
#import "HYProductDetailGuessYouLikeResponse.h"

@implementation HYProductDetailGuessYouLikeReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"index/guessYouLikeBrandListSearch.action"];
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
        if (self.brandCode)
        {
            [newDic setObject:self.brandCode
                       forKey:@"boardCode"];
        }
        
        if (self.categoryCode)
        {
            [newDic setObject:self.categoryCode
                       forKey:@"categoryCode"];
        }
        
        if (self.productCode)
        {
            [newDic setObject:self.productCode
                       forKey:@"productCode"];
        }
        
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
    HYProductDetailGuessYouLikeResponse *respose = [[HYProductDetailGuessYouLikeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
