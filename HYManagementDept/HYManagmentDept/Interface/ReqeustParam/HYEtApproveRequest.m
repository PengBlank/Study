//
//  HYEtApproveRequest.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYEtApproveRequest.h"

@implementation HYEtApproveRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/approval_member_apply"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.user_id length] > 0) {
            
            [newDic setObject:self.user_id forKey:@"id"];
        }
        if ([self.desc length] > 0) {
            
            [newDic setObject:self.desc forKey:@"desc"];
        }
        [newDic setObject:[NSNumber numberWithInteger:_status] forKey:@"status"];
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYEtApproveResponse *respose = [[HYEtApproveResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end

@implementation HYEtApproveResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
//            self.number = GETOBJECTFORKEY(self.jsonDic, @"number", [NSString class]);
//            self.count = [self.jsonDic objectForKey:@"count"] ;
        }
    }
    
    return self;
}

@end
