//
//  HYSingleAddCardResponse.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-19.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSingleAddCardResponse.h"

@interface HYSingleAddCardResponse()
@property (nonatomic, strong) NSString* number;
@end

@implementation HYSingleAddCardResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            self.number = GETOBJECTFORKEY(self.jsonDic, @"number", [NSString class]);
        }
    }
    
    return self;
}

@end
