//
//  HYAgencyCountResponse.m
//  HYManagmentDept
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 回亿资本. All rights reserved.
//

#import "HYAgencyCountResponse.h"
#import "HYAgencySummary.h"

@implementation HYAgencyCountResponse
- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *items = GETOBJECTFORKEY(self.jsonDic, @"items", [NSArray class]);
        NSMutableArray *objArray = [NSMutableArray array];
        for (NSDictionary *dict in items)
        {
            HYAgencySummary *order = [[HYAgencySummary alloc] initWithDict:dict];
            [objArray addObject:order];
        }
        self.dataArray = [objArray copy];
    }
    
    return self;
}
@end
