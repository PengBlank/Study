//
//  HYModifyPasswordRespone.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYModifyPasswordRespone.h"

@implementation HYModifyPasswordRespone

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.success = [GETOBJECTFORKEY(data, @"code", [NSString class]) boolValue];
        self.msg = GETOBJECTFORKEY(data, @"msg", [NSString class]);
    }
    
    return self;
}

@end
