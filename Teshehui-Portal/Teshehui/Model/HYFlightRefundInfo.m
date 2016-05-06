//
//  HYFlightRefundInfo.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightRefundInfo.h"

@implementation HYFlightRefundInfo

//- (id)initWithDataInfo:(NSDictionary *)data
//{
//    self = [super init];
//    
//    if (self)
//    {
//        self.ticket_no = GETOBJECTFORKEY(data, @"ticket_no", [NSString class]);
//        self.passengers = GETOBJECTFORKEY(data, @"passengers", [NSString class]);
//        
//        self.passenger_count = [GETOBJECTFORKEY(data, @"passenger_count", [NSString class]) intValue];
//        self.pay_total = [GETOBJECTFORKEY(data, @"pay_total", [NSString class]) floatValue];
//        self.status = [GETOBJECTFORKEY(data, @"status", [NSString class]) intValue];
//    }
//    
//    return self;
//}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"returnId"}];
}

@end
