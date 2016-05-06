//
//  HYRowDataResponse.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYRowDataResponse.h"

@interface HYRowDataResponse ()
//@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation HYRowDataResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            self.total = [GETOBJECTFORKEY(self.jsonDic, @"total", [NSString class]) integerValue];
            self.page = [GETOBJECTFORKEY(self.jsonDic, @"page", [NSString class]) integerValue];
        }
    }
    
    return self;
}

@end
