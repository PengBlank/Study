//
//  HYHYUserInfoEditResponse.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYHYUserInfoEditResponse.h"

@interface HYHYUserInfoEditResponse ()

@property (nonatomic, assign) BOOL result;  //1：成功  0：失败

@end

@implementation HYHYUserInfoEditResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            self.result = [GETOBJECTFORKEY(self.jsonDic, @"data", [NSString class]) boolValue];
        }
    }
    
    return self;
}

@end