//
//  HYMovieTicketOrderListResponse.m
//  Teshehui
//
//  Created by HYZB on 16/2/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMovieTicketOrderListResponse.h"
#import "HYMovieTicketOrderListModel.h"
#import "HYMovieTicketOrderListFrame.h"

@implementation HYMovieTicketOrderListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *items = GETOBJECTFORKEY(data, @"items", [NSArray class]);
        for (NSDictionary *dict in items)
        {
            HYMovieTicketOrderListModel *model = [[HYMovieTicketOrderListModel alloc] initWithDictionary:dict error:nil];
            HYMovieTicketOrderListFrame *frame = [[HYMovieTicketOrderListFrame alloc] init];
            frame.model = model;
            [self.dataList addObject:frame];
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
