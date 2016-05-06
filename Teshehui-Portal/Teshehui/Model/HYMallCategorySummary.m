//
//  HYMallCategorySummary.m
//  Teshehui
//
//  Created by HYZB on 15/1/21.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallCategorySummary.h"

@implementation HYMallCategorySummary

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.cate_id = GETOBJECTFORKEY(data, @"cate_id", [NSString class]);
        self.cate_name = GETOBJECTFORKEY(data, @"cate_name", [NSString class]);
        self.img = GETOBJECTFORKEY(data, @"img", [NSString class]);
    }
    
    return self;
}

@end
