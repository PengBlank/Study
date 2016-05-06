//
//  HYEnterpriseMemberListPublicResponse.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYEnterpriseMemberListPublicResponse.h"

@implementation HYEnterpriseMemberListPublicResponse
- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            NSArray *array = GETOBJECTFORKEY(self.jsonDic, @"items", [NSArray class]);
            
            if ([array count] > 0)
            {
                NSMutableArray *muArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
                for (NSDictionary *data in array)
                {
                    HYEtMemberForPb *a = [[HYEtMemberForPb alloc] initWithData:data];
                    [muArray addObject:a];
                }
                
                self.memberList = [muArray copy];
            }
        }
    }
    
    return self;
}

@end

@implementation HYEtMemberForPb

- (id)initWithData:(NSDictionary *)data
{
    if (self = [super init]) {
        self.user_id = GETOBJECTFORKEY(data, @"user_id", [NSString class]);
        self.real_name = GETOBJECTFORKEY(data, @"real_name", [NSString class]);
    }
    
    return self;
}

@end
