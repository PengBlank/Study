//
//  HYCardTypeRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCardTypeRequest.h"

@implementation HYCardTypeRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"api/users/get_id_card_type"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"b)	证件类型列表请求缺少必须参数");
    }
#endif
    return newDic;
}


- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCardTypeResponse *respose = [[HYCardTypeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
