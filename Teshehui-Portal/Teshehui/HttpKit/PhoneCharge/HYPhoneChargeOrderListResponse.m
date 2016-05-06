//
//  HYPhoneChargeOrderListResponse.m
//  Teshehui
//
//  Created by HYZB on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYPhoneChargeOrderListResponse.h"
#import "HYPhoneChargeOrderListModel.h"

@implementation HYPhoneChargeOrderListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *items = GETOBJECTFORKEY(data, @"items", [NSArray class]);
        for (NSDictionary *dict in items)
        {
            HYPhoneChargeOrderListModel *model = [[HYPhoneChargeOrderListModel alloc] initWithDictionary:dict error:nil];
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
