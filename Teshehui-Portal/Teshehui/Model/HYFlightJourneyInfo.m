//
//  HYFlightJourneyInfo.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightJourneyInfo.h"

@interface HYFlightJourneyInfo ()
@property (nonatomic, copy) NSString *statusDesc;
@end

@implementation HYFlightJourneyInfo

/*
- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.journeyID = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.passengers = GETOBJECTFORKEY(data, @"passengers", [NSString class]);
        self.contact = GETOBJECTFORKEY(data, @"contact", [NSString class]);
        self.tel = GETOBJECTFORKEY(data, @"tel", [NSString class]);
        self.zip_code = GETOBJECTFORKEY(data, @"zip_code", [NSString class]);
        self.city = GETOBJECTFORKEY(data, @"city", [NSString class]);
        self.address = GETOBJECTFORKEY(data, @"address", [NSString class]);
        self.item_no = GETOBJECTFORKEY(data, @"item_no", [NSString class]);
        self.shipment = GETOBJECTFORKEY(data, @"shipment", [NSString class]);
        self.express_no = GETOBJECTFORKEY(data, @"express_no", [NSString class]);
        
        NSString *pay_total = GETOBJECTFORKEY(data, @"pay_total", [NSString class]);
        self.pay_total = [pay_total floatValue];
        NSString *point = GETOBJECTFORKEY(data, @"points", [NSString class]);
        self.point = [point floatValue];;
        
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
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"journeyId"}];
}

#pragma mark setter/getter
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
                _statusDesc = @"处理中";
                break;
            case 2:
                _statusDesc = @"待付款";
                break;
            case 4:
                _statusDesc = @"已付款,处理中";
                break;
            case 8:
                _statusDesc = @"已寄出";
                break;
            case 16:
                _statusDesc = @"寄送取消";
                break;
            default:
                break;
        }
    }
    return _statusDesc;
}

@end
