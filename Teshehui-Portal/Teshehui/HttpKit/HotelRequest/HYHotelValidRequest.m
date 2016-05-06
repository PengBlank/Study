//
//  HYHotelValidRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelValidRequest.h"
#import "HYHotelValidResponse.h"
#import "JSONKit_HY.h"

@implementation HYHotelValidRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"product/getProductSKUStock.action"];
        self.httpMethod = @"POST";
        self.version = @"1";
        self.businessType = @"03";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.productSKUId length] > 0 &&
        [self.latestArrivalTime length] > 0 &&
        self.roomNumber> 0 &&
        self.customerNumber > 0)
    {
        [newDic setObject:self.productSKUId forKey:@"productSKUId"];
        
        [newDic setObject:self.businessType forKey:@"businessType"];
        
        [newDic setObject:self.version forKey:@"version"];
        
        //可订检查请求扩展参数
        NSMutableDictionary *expandedRequest = [NSMutableDictionary dictionary];
        
        [expandedRequest setObject:self.latestArrivalTime forKey:@"latestArrivalTime"];
        [expandedRequest setObject:self.roomNumber forKey:@"roomNumber"];
        [expandedRequest setObject:self.customerNumber forKey:@"customerNumber"];
        
        if ([expandedRequest count] > 0)
        {
            NSString *json = [expandedRequest JSONString];
            [newDic setObject:json forKey:@"expandedRequest"];
        }
        
        
//        [newDic setObject:self.hotelProductId
//                   forKey:@"hotelProductId"];
//        [newDic setObject:self.latestArrivalTime
//                   forKey:@"latestArrivalTime"];
//        [newDic setObject:self.hotelRoomTypeId
//                   forKey:@"hotelRoomTypeId"];
//        [newDic setObject:self.startDate forKey:@"startDate"];
//        [newDic setObject:self.endDate forKey:@"endDate"];
//        [newDic setObject:[NSString stringWithFormat:@"%d", self.roomNumber]
//                   forKey:@"roomNumber"];
//        [newDic setObject:[NSString stringWithFormat:@"%d", self.customerNumber]
//                   forKey:@"customerNumber"];
//    }
//    if (self.shippingMethodId.length > 0)
//    {
//        [newDic setObject:_shippingMethodId forKey:@"shippingMethodId"];
//    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"酒店可订请求缺少必须参数");
    }
#endif
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYHotelValidResponse *respose = [[HYHotelValidResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
