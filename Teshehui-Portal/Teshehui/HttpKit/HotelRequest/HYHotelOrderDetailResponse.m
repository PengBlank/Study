//
//  HYHotelOrderDetailResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderDetailResponse.h"

@implementation HYHotelOrderDetailResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
//        NSDictionary *dic = GETOBJECTFORKEY(dictionary, @"result", [NSDictionary class]);
        NSDictionary *dic = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
//        self.orderDetail = [[HYHotelOrderDetail alloc] initWithDataInfo:dic];
        NSError *error = nil;
        
        self.orderDetail = [[HYHotelOrderDetail alloc]initWithDictionary:dic error:&error];
    }
    
    return self;
}

@end
