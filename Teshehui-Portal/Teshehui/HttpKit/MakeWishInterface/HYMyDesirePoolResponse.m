//
//  HYMyDesirePoolResponse.m
//  Teshehui
//
//  Created by HYZB on 15/11/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyDesirePoolResponse.h"
#import "HYMyDesirePoolModel.h"


@implementation HYMyDesirePoolResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *items = GETOBJECTFORKEY(data, @"items", [NSArray class]);
        for (NSDictionary *dict in items) {
            HYMyDesirePoolModel *model = [[HYMyDesirePoolModel alloc] initWithDictionary:dict error:nil];
            [self.dataList addObject:model];
        }
    }
    return self;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
