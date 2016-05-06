//
//  HYExpensiveExplainRequest.m
//  Teshehui
//
//  Created by apple on 15/4/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYExpensiveExplainRequest.h"

@implementation HYExpensiveExplainRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL,@"api/default/get_official_img"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.img_key length] > 0)
        {
            [newDic setObject:self.img_key forKey:@"img_key"];
        }
    }
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYExpensiveExplainResponse *respose = [[HYExpensiveExplainResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
