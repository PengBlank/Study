//
//  HYSeckillGoodsListResponse.m
//  Teshehui
//
//  Created by HYZB on 15/12/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSeckillGoodsListResponse.h"
#import "HYSeckillGoodsListModel.h"

@implementation HYSeckillGoodsListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        HYSeckillActivityModel *activity = [[HYSeckillActivityModel alloc] initWithDictionary:data error:nil];
        NSDictionary *listData = GETOBJECTFORKEY(data, @"seckillActivityProductPOList", NSDictionary);
        NSArray *items = GETOBJECTFORKEY(listData, @"items", NSArray);
        for (NSDictionary *dict in items) {
            HYSeckillGoodsListModel *model = [[HYSeckillGoodsListModel alloc] initWithDictionary:dict error:nil];
            [self.dataList addObject:model];
        }
        self.activity = activity;
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
