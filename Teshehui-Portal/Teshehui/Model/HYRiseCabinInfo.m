//
//  HYRiseCabinInfo.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYRiseCabinInfo.h"

@interface HYRiseCabinInfo ()

@property (nonatomic, copy) NSString *statusDesc;

@end

@implementation HYRiseCabinInfo

//- (id)initWithDataInfo:(NSDictionary *)data
//{
//    self = [super init];
//    
//    if (self)
//    {
//        self.cabinID = [GETOBJECTFORKEY(data, @"id", [NSString class]) integerValue];
//        self.passengers = GETOBJECTFORKEY(data, @"passengers", [NSString class]);
//        self.to_cabin_type = GETOBJECTFORKEY(data, @"to_cabin_type", [NSString class]);
//        self.to_cabin = GETOBJECTFORKEY(data, @"to_cabin", [NSString class]);
//        self.to_cabin_name = GETOBJECTFORKEY(data, @"cabin_name", [NSString class]);
//        NSString *pay_total = GETOBJECTFORKEY(data, @"pay_total", [NSString class]);
//        self.pay_total = [pay_total floatValue];
//        
//        NSString *p_points = GETOBJECTFORKEY(data, @"points", [NSString class]);
//        self.points = [p_points intValue];
//        
//        NSString *status = GETOBJECTFORKEY(data, @"status", [NSString class]);
//        self.status = [status intValue];
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
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"riseId"}];
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
                _statusDesc = @"升舱处理中";
                break;
            case 4:
                _statusDesc = @"升舱成功";
                break;
            case 8:
                _statusDesc = @"升舱失败";
                break;
            case 16:
                _statusDesc = @"升舱取消";
                break;
            default:
                break;
        }
    }
    return _statusDesc;
}
@end
