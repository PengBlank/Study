//
//  HYHYFlowerFinishOrderResponse.m
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerFinishOrderResponse.h"

@implementation HYFlowerFinishOrderResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *datas = GETOBJECTFORKEY(dictionary, @"data", NSArray);
        if (datas.count > 0)
        {
            NSDictionary *data = datas[0];
            self.orderInfo = [[HYFlowerOrderInfo alloc]initWithDataInfo:data];
        }
    }
    
    return self;
}

@end
