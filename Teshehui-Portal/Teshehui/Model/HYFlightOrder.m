//
//  HYFlightOrder.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightOrder.h"
#import "NSDate+Addition.h"


@interface HYFlightOrder ()

@property (nonatomic, copy) NSString *statusDesc;
@property (nonatomic, copy) NSString *createTime;
@end

@implementation HYFlightOrder

/*
- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.orderID = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.user_id = GETOBJECTFORKEY(data, @"user_id", [NSString class]);
        self.order_no = GETOBJECTFORKEY(data, @"order_no", [NSString class]);
        self.chinapay_tn = GETOBJECTFORKEY(data, @"chinapay_tn", [NSString class]);
        self.ticket_no = GETOBJECTFORKEY(data, @"ticket_no", [NSString class]);
        self.tel = GETOBJECTFORKEY(data, @"tel", [NSString class]);
        self.org_airport = GETOBJECTFORKEY(data, @"org_airport", [NSString class]);
        self.dst_airport = GETOBJECTFORKEY(data, @"dst_airport", [NSString class]);
        self.org_city_name = GETOBJECTFORKEY(data, @"org_city_name", [NSString class]);
        self.dst_city_name = GETOBJECTFORKEY(data, @"dst_city_name", [NSString class]);
        self.org_airport_name = GETOBJECTFORKEY(data, @"org_airport_name", [NSString class]);
        self.dst_airport_name = GETOBJECTFORKEY(data, @"dst_airport_name", [NSString class]);
        self.org_airport_terminal = GETOBJECTFORKEY(data, @"org_airport_terminal", [NSString class]);
        self.dst_airport_terminal = GETOBJECTFORKEY(data, @"dst_airport_terminal", [NSString class]);
        self.flight_date = GETOBJECTFORKEY(data, @"flight_date", [NSString class]);
        self.airline_name = GETOBJECTFORKEY(data, @"airline_name", [NSString class]);
        self.flight_no = GETOBJECTFORKEY(data, @"flight_no", [NSString class]);
        self.cabin = GETOBJECTFORKEY(data, @"cabin", [NSString class]);
        self.cabin_type = GETOBJECTFORKEY(data, @"cabin_type", [NSString class]);
        self.arr_time = GETOBJECTFORKEY(data, @"arr_time", [NSString class]);
        self.dep_time = GETOBJECTFORKEY(data, @"dep_time", [NSString class]);
        self.source = [GETOBJECTFORKEY(data, @"source", [NSString class]) intValue];
        
        NSArray *tickets = [self.ticket_no componentsSeparatedByString:@"|"];
        
        NSArray *passengers = GETOBJECTFORKEY(data, @"passengers", [NSArray class]);
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        NSInteger index = 0;
        for (NSDictionary *d in passengers)
        {
            HYPassengers *p = [[HYPassengers alloc] initWithDataInfo:d];
            p.tripDate = self.arr_time;
            
            //处理电子票号
            if (index < [tickets count])
            {
                p.ticketNO = [tickets objectAtIndex:index];
            }
            [muArray addObject:p];
            index++;
        }
        self.passengers = [muArray copy];
        
        self.status = [GETOBJECTFORKEY(data, @"status", [NSString class]) intValue];
        self.createTimestamp = [GETOBJECTFORKEY(data, @"create_time", [NSString class]) doubleValue];
        self.passenger_count = [GETOBJECTFORKEY(data, @"passenger_count", [NSString class]) intValue];
        self.cabin_price = [GETOBJECTFORKEY(data, @"cabin_price", [NSString class]) floatValue];
        self.cabin_fd_price = [GETOBJECTFORKEY(data, @"cabin_fd_price", [NSString class]) floatValue];
        self.points = [GETOBJECTFORKEY(data, @"points", [NSString class]) floatValue];
        self.airport_tax = [GETOBJECTFORKEY(data, @"airport_tax", [NSString class]) floatValue];
        self.fuel_tax = [GETOBJECTFORKEY(data, @"fuel_tax", [NSString class]) floatValue];
        self.pay_total = [GETOBJECTFORKEY(data, @"pay_total", [NSString class]) floatValue];
        self.is_allow_pnr = [GETOBJECTFORKEY(data, @"is_allow_pnr", [NSString class]) intValue];
        self.is_buy_insurance = [GETOBJECTFORKEY(data, @"is_buy_insurance", [NSString class]) intValue];
        
        //改签
//        NSDictionary *alertedInfo = GETOBJECTFORKEY(data, @"alerted_info", [NSDictionary class]);
//        if ([alertedInfo count] > 0)
//        {
//            self.hasAlteredInfo = YES;
//            self.alteredInfo = [[HYFlightAlertedInfo alloc] initWithDataInfo:alertedInfo];
//        }
        
//        //升舱
//        NSDictionary *cabinInfo = GETOBJECTFORKEY(data, @"rise_cabin_info", [NSDictionary class]);
//        if ([cabinInfo count] > 0)
//        {
//            self.hasRiseCabinInfo = YES;
//            self.cabinInfo = [[HYRiseCabinInfo alloc] initWithDataInfo:cabinInfo];
//        }
        
        NSDictionary *journeyInfo = GETOBJECTFORKEY(data, @"journey_info", [NSDictionary class]);
        if ([journeyInfo count] > 0)
        {
            self.hasJourney = YES;
            self.journeyInfo = [[HYFlightJourneyInfo alloc] initWithDataInfo:journeyInfo];
        }
}
    
    return self;
}
 */

- (BOOL)hasRiseCabinInfo
{
    return self.cabinInfo != nil;
}

- (BOOL)hasAlteredInfo
{
    return self.alteredInfo != nil;
}

- (BOOL)hasJourney
{
    return self.journeyInfo != nil;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"orderItemPOList": @"orderItems",
                                 @"guestPOList": @"guests",
                                 @"ticketReturnPO": @"refundInfo",
                                 @"ticketAlertedPO": @"alteredInfo",
                                 @"ticketRiseCabinPO":@"cabinInfo",
                                 @"ticketJourneyPO": @"journeyInfo"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

/*
 0	待处理（取消订单）
 1	 待付款（取消订单）
 2	 已付款待出票（取消订单）
 4	出票处理中
 8	出票成功（申请退票，申请改签，申请升舱，打印行程单）
 16	出票失败（取消订单）
 32	 改签处理中
 64	已改签（申请退票，打印行程单）
 128	退票处理中
 256	已退票
 512	已取消
 1024	升舱处理中
 2048	已升舱（申请退票，打印行程单）
 4096	退款处理中
 8192	退款成功
 */

#pragma mark setter/getter
- (NSString *)createTime
{
    if (!_createTime)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.createTimestamp];
        _createTime = [date timeDescriptionFull];
    }
    
    return _createTime;
}

- (NSString *)statusDesc
{
    if (self.status < 0)
    {
        _statusDesc = @"已删除";
    }
    else
    {
        switch (self.status)
        {
            case 0:
                _statusDesc = @"待处理";
                break;
            case 1:
                _statusDesc = @"待付款";
                break;
            case 2:
                _statusDesc = @"已付款待出票";
                break;
            case 4:
                _statusDesc = @"出票处理中";
                break;
            case 8:
                _statusDesc = @"出票成功";
                break;
            case 16:
                _statusDesc = @"出票失败";
                break;
            case 32:
                _statusDesc = @"改签处理中";
                break;
            case 64:
                _statusDesc = @"已改签";
                break;
            case 128:
                _statusDesc = @"退票处理中";
                break;
            case 256:
                _statusDesc = @"已退票";
                break;
            case 512:
                _statusDesc = @"已取消";
                break;
            case 1024:
                _statusDesc = @"升舱处理中";
                break;
            case 2048:
                _statusDesc = @"已升舱";
                break;
            case 4096:
                _statusDesc = @"退款处理中";
                break;
            case 8192:
                _statusDesc = @"退款成功";
                break;
            default:
                break;
        }
    }
    
    return _statusDesc;
}


@end


