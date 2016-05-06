//
//  HYFlightAlertedInfo.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightAlertedInfo.h"

@interface HYFlightAlertedInfo ()

@property (nonatomic, copy) NSString *statusDesc;

@end


@implementation HYFlightAlertedInfo
/*
- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.alertID = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.org_airport = GETOBJECTFORKEY(data, @"org_airport", [NSString class]);
        self.dst_airport = GETOBJECTFORKEY(data, @"dst_airport", [NSString class]);
        self.flight_no = GETOBJECTFORKEY(data, @"flight_no", [NSString class]);
        self.flight_date = GETOBJECTFORKEY(data, @"flight_date", [NSString class]);
        self.passengers = GETOBJECTFORKEY(data, @"passengers", [NSString class]);
        self.cabin_type = GETOBJECTFORKEY(data, @"cabin_type", [NSString class]);
        self.cabin_code = GETOBJECTFORKEY(data, @"cabin_code", [NSString class]);
        self.cabin_name = GETOBJECTFORKEY(data, @"cabin_name", [NSString class]);
        NSString *pay_total = GETOBJECTFORKEY(data, @"pay_total", [NSString class]);
        self.pay_total = [pay_total floatValue];
        
        NSString *p = GETOBJECTFORKEY(data, @"points", [NSString class]);
        self.points = [p intValue];

        NSString *status = GETOBJECTFORKEY(data, @"status", [NSString class]);
        self.status = [status intValue];
    }
    
    return self;
}*/

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"alterId"}];
}

- (NSString *)statusDesc
{
    if (!_statusDesc)
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
                _statusDesc = @"改签处理中";
                break;
            case 4:
                _statusDesc = @"改签成功";
                break;
            case 8:
                _statusDesc = @"改签失败";
                break;
            case 16:
                _statusDesc = @"改签取消";
                break;
            default:
                break;
        }
    }
    return _statusDesc;
}

@end
