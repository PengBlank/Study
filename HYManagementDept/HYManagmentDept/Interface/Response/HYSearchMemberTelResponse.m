//
//  HYSearchMemberTelResponse.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSearchMemberTelResponse.h"

@implementation HYSearchMemberTelResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        self.tel = GETOBJECTFORKEY(self.jsonDic, @"tel", [NSString class]);
    }
    
    return self;
}

@end
