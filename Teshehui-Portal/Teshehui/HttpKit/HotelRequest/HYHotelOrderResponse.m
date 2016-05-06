//
//  HYHotelOrderResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderResponse.h"

@interface HYHotelOrderResponse ()

@property (nonatomic, strong) NSArray *orders;

@end

@implementation HYHotelOrderResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
//        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *data = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        if (data)
        {
            //服务器返回的数据 json格式发变化，修改版本1.3.0   14-8-25
            NSMutableArray *mu = [NSMutableArray array];
            for (NSDictionary *dict in data)
            {
                HYHotelOrderBase *order = [[HYHotelOrderBase alloc] initWithDictionary:dict
                                                                                 error:nil];
                [mu addObject:order];
            }
            if ([mu count] > 0)
            {
                self.orders = [mu copy];
            }
//            NSDictionary *orderData = GETOBJECTFORKEY(data, @"Order", [NSDictionary class]);
//            self.order = [[HYHotelOrderBase alloc] initWithDataInfo:orderData];
//            NSString *pay_total = [orderData objectForKey:@"pay_total"];
//            if (!pay_total)
//            {
//                NSDictionary *orderBookInfo = GETOBJECTFORKEY(data, @"OrderBookingInfo", NSDictionary);
//                pay_total = GETOBJECTFORKEY(orderBookInfo, @"pay_total", NSString);
//                self.order.pay_total = [pay_total floatValue];
//            }
        }
    }
    
    return self;
}

@end
