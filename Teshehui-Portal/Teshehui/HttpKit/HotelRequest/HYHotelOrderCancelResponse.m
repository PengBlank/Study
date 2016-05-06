//
//  HYHotelOrderCancelResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderCancelResponse.h"

@interface HYHotelOrderCancelResponse ()

@property (nonatomic, strong) HYHotelOrderBase *order;

@end

@implementation HYHotelOrderCancelResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"result", [NSDictionary class]);
        if (data)
        {
            self.order = [[HYHotelOrderBase alloc] initWithDictionary:data error:nil];
        }
    }
    
    return self;
}

@end
