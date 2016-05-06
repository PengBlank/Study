//
//  HYFlowerDetailRequest.m
//  Teshehui
//
//  Created by ichina on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerDetailRequest.h"
#import "HYFlowerDetailResponse.h"

@implementation HYFlowerDetailRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"product/getProductInfo.action"];
        self.httpMethod = @"POST";
        self.businessType = @"04";
        
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.productId length] > 0)
        {
            [newDic setObject:self.productId forKey:@"productId"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlowerDetailResponse *respose = [[HYFlowerDetailResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
