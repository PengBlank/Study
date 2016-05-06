//
//  HYTaxiOrderListResponse.m
//  Teshehui
//
//  Created by HYZB on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiOrderListResponse.h"
#import "HYTaxiOrder.h"
#import "HYTaxiOrderListExpandedModel.h"


@implementation HYTaxiOrderListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *items = GETOBJECTFORKEY(data, @"items", [NSArray class]);
        for (NSDictionary *dict in items) {
            HYTaxiOrder *model = [[HYTaxiOrder alloc] initWithDictionary:dict error:nil];
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
