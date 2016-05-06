//
//  HYLoginResponse.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYLoginResponse.h"

@interface HYLoginResponse ()

@property (nonatomic, strong) HYUserInfo *userInfo;  //用户信息

@end

@implementation HYLoginResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            NSDictionary *userInfo = GETOBJECTFORKEY(self.jsonDic, @"rows", [NSDictionary class]);
            self.userInfo = [[HYUserInfo alloc] initWithData:userInfo];
        }
    }
    
    return self;
}

@end
