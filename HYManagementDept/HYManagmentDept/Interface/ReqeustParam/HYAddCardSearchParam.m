//
//  HYAddCardSearchParam.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAddCardSearchParam.h"

@implementation HYAddCardSearchParam
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_search_card"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.number.length > 0)
        {
            [newDic setObject:self.number
                       forKey:@"number"];
        }
        if (self.end_number.length > 0)
        {
            [newDic setObject:self.end_number forKey:@"end_number"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAddCardSearchResponse *respose = [[HYAddCardSearchResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
