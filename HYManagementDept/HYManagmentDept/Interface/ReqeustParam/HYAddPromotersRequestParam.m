//
//  HYAddPromotersRequestParam.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAddPromotersRequestParam.h"

@implementation HYAddPromotersRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/promoters_adding"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.number length] > 0) {
            
            [newDic setObject:self.number forKey:@"number"];
        }
        if ([self.code length] > 0) {
            
            [newDic setObject:self.code forKey:@"code"];
        }
        if ([self.proportion length] > 0) {
            
            [newDic setObject:self.proportion forKey:@"proportion"];
        }
        if ([self.tel length] > 0) {
            
            [newDic setObject:self.tel forKey:@"tel"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAddPromotersResponse *respose = [[HYAddPromotersResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
