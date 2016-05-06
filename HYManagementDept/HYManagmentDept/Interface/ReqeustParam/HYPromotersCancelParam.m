//
//  HYPromotersCancelParam.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromotersCancelParam.h"

@implementation HYPromotersCancelParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/promoters_cancel"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.pid length] > 0) {
            
            [newDic setObject:self.pid forKey:@"pid"];
        }
        if ([self.user_id length] > 0) {
            
            [newDic setObject:self.user_id forKey:@"user_id"];
        }
        if ([self.verify_code length] > 0) {
            
            [newDic setObject:self.verify_code forKey:@"verify_code"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPromotersCancelResponse *respose = [[HYPromotersCancelResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
