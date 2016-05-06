//
//  HYActivityCategory.m
//  Teshehui
//
//  Created by RayXiang on 14-8-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYActivityCategory.h"

@implementation HYActivityCategory

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.m_id = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.category_name = GETOBJECTFORKEY(data, @"category_name", [NSString class]);
        self.img = GETOBJECTFORKEY(data, @"img", [NSString class]);
    }
    
    return self;
}

@end
