//
//  HYUserInfoEditRequestParma.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYUserInfoEditRequestParma.h"

@implementation HYUserInfoEditRequestParma

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_member_edit"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.user_name length] > 0)
        {
            [newDic setObject:self.user_name forKey:@"user_name"];
        }
        
        if ([self.password length] > 0)
        {
            [newDic setObject:self.password forKey:@"password"];
        }
        
        if ([self.im_qq length] > 0) {
            
            [newDic setObject:self.im_qq forKey:@"im_qq"];
        }
        
        if ([self.email length] > 0) {
            
            [newDic setObject:self.email forKey:@"email"];
        }
        
        if ([self.real_name length] > 0) {
            
            [newDic setObject:self.real_name forKey:@"real_name"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYHYUserInfoEditResponse *respose = [[HYHYUserInfoEditResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
