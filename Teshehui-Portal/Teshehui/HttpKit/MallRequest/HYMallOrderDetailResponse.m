//
//  HYMallOrderDetailResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-6-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderDetailResponse.h"

@implementation HYMallOrderDetailResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
//        NSError *error = [NSError new];
        self.orderDetail = [[HYMallChildOrder alloc] initWithDictionary:data error:nil];
//        NSLog(@"%@",error);
    }
    
    return self;
}


@end
