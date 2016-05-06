//
//  HYFlowerGetProAdressResquest.m
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerGetProAdressResquest.h"
#import "HYFlowerGetProAdressResponse.h"

@implementation HYFlowerGetProAdressResquest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kFlowerRequestBaseURL, @"api/products/AreaCagegory"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlowerGetProAdressResponse *respose = [[HYFlowerGetProAdressResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
