//
//  HYHotelOrderListResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderListResponse.h"
#import "HYHotelOrderDetail.h"



@interface HYHotelOrderListResponse ()

@property (nonatomic, strong) NSArray *orderList;

@end

@implementation HYHotelOrderListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
//        NSDictionary *dic = GETOBJECTFORKEY(dictionary, @"result", [NSDictionary class]);
        NSArray *dataSource = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
//        NSInteger count = [GETOBJECTFORKEY(dataSource, @"count", [NSString class]) integerValue];
//        NSArray *list = GETOBJECTFORKEY(dataSource, @"order_list", [NSArray class]);
        
        NSMutableArray *orders = [[NSMutableArray alloc] init];
        for (NSDictionary *data in dataSource)
        {
            NSError *error = nil;
            HYHotelOrderDetail *orderDetail = [[HYHotelOrderDetail alloc] initWithDictionary:data error:&error];
            [orders addObject:orderDetail];
        }
        
        self.orderList = [orders copy];
    }
    
    return self;
}

@end