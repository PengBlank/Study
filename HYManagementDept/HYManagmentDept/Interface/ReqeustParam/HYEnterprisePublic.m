//
//  HYEnterprisePublic.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYEnterprisePublic.h"

@implementation HYEnterprisePublicSingleRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/single_allocation_to_enterprise"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.number length] > 0)
        {
            [newDic setObject:self.number forKey:@"number"];
        }
        
        if ([self.user_id length] > 0) {
            
            [newDic setObject:self.user_id forKey:@"user_id"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYEnterprisePublicResponse *respose = [[HYEnterprisePublicResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end

@implementation HYEnterprisePublicRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/allocation_to_enterprise"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.start_number length] > 0)
        {
            [newDic setObject:self.start_number forKey:@"start_number"];
        }
        
        if ([self.end_number length] > 0)
        {
            [newDic setObject:self.end_number forKey:@"end_number"];
        }
        
        if ([self.user_id length] > 0) {
            
            [newDic setObject:self.user_id forKey:@"user_id"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYEnterprisePublicResponse *respose = [[HYEnterprisePublicResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYEnterprisePublicResponse
- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            self.number = GETOBJECTFORKEY(self.jsonDic, @"number", [NSString class]);
            id count = [self.jsonDic objectForKey:@"count"];
            if ([count respondsToSelector:@selector(integerValue)])
            {
                self.count = [count integerValue];
            }
        }
    }
    
    return self;
}
@end
