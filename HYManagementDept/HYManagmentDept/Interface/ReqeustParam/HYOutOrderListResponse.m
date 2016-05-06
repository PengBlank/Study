//
//  HYOutOrderListResponse.m
//  HYManagmentDept
//
//  Created by Ray on 14-12-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYOutOrderListResponse.h"

@implementation HYOutOrderListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *items = GETOBJECTFORKEY(self.jsonDic, @"items", [NSArray class]);
        NSMutableArray *objArray = [NSMutableArray array];
        for (NSDictionary *dict in items)
        {
            HYOutOrder *order = [[HYOutOrder alloc] initWithDataInfo:dict];
            [objArray addObject:order];
        }
        self.dataArray = [objArray copy];
    }
    
    return self;
}

@end
