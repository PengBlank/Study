//
//  HYHotelOrder.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderBase.h"
#import "NSDate+Addition.h"

@interface HYHotelOrderBase ()
@property (nonatomic, copy) NSString *orderStatusDesc;
@end

@implementation HYHotelOrderBase

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

/*
- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.hOrderID = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.hOrder_no = GETOBJECTFORKEY(data, @"order_no", [NSString class]);
        self.user_id = GETOBJECTFORKEY(data, @"user_id", [NSString class]);
        self.retry_time = GETOBJECTFORKEY(data, @"retry_time", [NSString class]);
        self.updated = GETOBJECTFORKEY(data, @"updated", [NSString class]);
        self.rate_plan_category = [GETOBJECTFORKEY(data, @"rate_plan_category", [NSString class]) integerValue];
        
        NSString *cTime = GETOBJECTFORKEY(data, @"created", [NSString class]);
        NSDate *cDate = [NSDate dateWithTimeIntervalSince1970:cTime.longLongValue];
        self.created = [cDate timeDescription];
        
        NSString *status = GETOBJECTFORKEY(data, @"status", [NSString class]);
        self.status = status.intValue;
        
        NSString *contract = GETOBJECTFORKEY(data, @"contract", [NSString class]);
        self.contract = contract.intValue;
        
        self.user_name = GETOBJECTFORKEY(data, @"user_name", [NSString class]);
        self.order_type = [GETOBJECTFORKEY(data, @"order_type", [NSString class]) integerValue];
//        self.amount_before_tax = [GETOBJECTFORKEY(data, @"amount_before_tax", [NSString class]) floatValue];
        
       
        //新加字段
        self.orderCode = GETOBJECTFORKEY(data, @"orderCode", [NSString class]);
        self.orderId = GETOBJECTFORKEY(data, @"orderId", [NSString class]);
        self.orderTotalAmount = GETOBJECTFORKEY(data, @"orderTotalAmount", [NSString class]);
        self.productTypeCode = GETOBJECTFORKEY(data, @"productTypeCode", [NSString class]);
        
        
    }
    
    return self;
}
 */

- (NSString *)orderStatusDesc
{
    switch (self.status)
    {
        case User_Delete:
            _orderStatusDesc = @"已删除";
            break;
        case Pending_Local:
            _orderStatusDesc = @"待处理";
            break;
        case Pending_Ramote:
            _orderStatusDesc = @"待处理";
            break;
        case Processing:
            _orderStatusDesc = @"确认中";
            break;
        case Confirmed:
            _orderStatusDesc = @"已确认";
            break;
        case Cancel:
            _orderStatusDesc = @"已取消";
            break;
        case Sucesse:
            _orderStatusDesc = @"已成功";
            break;
        case Failed:
            _orderStatusDesc = @"下单失败";
            break;
        case Unpaid:
            _orderStatusDesc = @"待付款";
            break;
        case Paid:
            _orderStatusDesc = @"已付款";
            break;
        default:
            break;
    }
    
    return _orderStatusDesc;
}

- (BOOL)isPrePay
{
    return ([self.productTypeCode intValue] == 3);
}
/*
订单添加返回增加：
productTypeCode 产品类型，未知：0，现付1，担保2，预付3 只适应于酒店
*/
@end