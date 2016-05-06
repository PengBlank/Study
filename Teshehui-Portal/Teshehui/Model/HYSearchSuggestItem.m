//
//  HYSearchSuggestItem.m
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSearchSuggestItem.h"

@implementation HYSearchSuggestItem

- (id)initWithDataInfo:(NSDictionary *)data
{
    if (self = [super init])
    {
        self.display = GETOBJECTFORKEY(data, @"display", [NSString class]);
        self.matchValue = GETOBJECTFORKEY(data, @"matchValue", [NSString class]);
        self.type = [GETOBJECTFORKEY(data, @"type", [NSString class]) integerValue];
    }
    return self;
}

@end
