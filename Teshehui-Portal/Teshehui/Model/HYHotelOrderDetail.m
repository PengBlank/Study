//
//  HYHotelOrderDetail.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderDetail.h"
#import "NSDate+Addition.h"

@interface HYHotelOrderDetail ()

@property (nonatomic, copy) NSString *checkInTimeDesc;
@property (nonatomic, copy) NSString *checkInDay;

@end

@implementation HYHotelOrderDetail

- (NSString *)payTypeDesc
{
    NSString *desc = _payType;
    if ([_payType isEqualToString:@"C"])
    {
        desc = @"到店付款";
    }else if ([_payType isEqualToString:@"P"])
    {
        desc = @"预付款";
    }
    return desc;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (NSString *)hotelName
{
    if (self.orderItemPOList.count > 0)
    {
        HYHotelOrderItemPO *item = [self.orderItemPOList objectAtIndex:0];
        return item.productName;
    }
    return nil;
}

- (NSString *)personName
{
    if (self.guestPOList.count > 0)
    {
        HYHotelGuestPO *guest = [self.guestPOList objectAtIndex:0];
        return guest.name;
    }
    return nil;
}

- (NSString *)startTimeSpanDate
{
    NSArray *dates = [self.startTimeSpan componentsSeparatedByString:@" "];
    if (dates.count > 1)
    {
        return dates[0];
    }
    else
    {
        return self.startTimeSpan;
    }
}

- (NSString *)endTimeSpanDate
{
    NSArray *dates = [self.endTimeSpan componentsSeparatedByString:@" "];
    if (dates.count > 1)
    {
        return dates[0];
    }
    else
    {
        return self.endTimeSpan;
    }
}

/*
- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super initWithDataInfo:data];
    
    if (self)
    {
        self.hOrderID = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.hOrder_no = GETOBJECTFORKEY(data, @"order_no", [NSString class]);
        self.user_id = GETOBJECTFORKEY(data, @"user_id", [NSString class]);
        self.retry_time = GETOBJECTFORKEY(data, @"retry_time", [NSString class]);
        self.updated = GETOBJECTFORKEY(data, @"updated", [NSString class]);
        
        NSString *cTime = GETOBJECTFORKEY(data, @"created", [NSString class]);
        NSDate *cDate = [NSDate dateWithTimeIntervalSince1970:cTime.longLongValue];
        self.created = [cDate timeDescription];
        
        NSString *status = GETOBJECTFORKEY(data, @"status", [NSString class]);
        self.status = status.intValue;
        
        NSString *contract = GETOBJECTFORKEY(data, @"contract", [NSString class]);
        self.contract = contract.intValue;
        
        self.points = GETOBJECTFORKEY(data, @"points", [NSString class]);
        self.city_id = GETOBJECTFORKEY(data, @"city_id", [NSString class]);
        
        NSString *pay = GETOBJECTFORKEY(data, @"pay_type", [NSString class]);
        HotelPayType payType = Offline_Pay;
        if ([pay isEqualToString:@"P"])
        {
            payType = Online_Pay;
        }
        else if ([pay isEqualToString:@"C"])
        {
            payType = Offline_Pay;
        }
        
        self.pay_type = payType;
        
        self.guarantee_type = GETOBJECTFORKEY(data, @"guarantee_type", [NSString class]);
        
        if ([self.guarantee_type isEqualToString:@"CreditCard"])
        {
            self.guarantee_info = @"信用卡担保";
        }
        else if ([self.guarantee_type isEqualToString:@"Phone "])
        {
            self.guarantee_info = @"手机担保";
        }
        
        self.amount_percent = GETOBJECTFORKEY(data, @"guarantee_type", [NSString class]);

        self.city_id = GETOBJECTFORKEY(data, @"city_id", [NSString class]);
        
        self.city_name = GETOBJECTFORKEY(data, @"city_name", [NSString class]);
        self.hotel_id = GETOBJECTFORKEY(data, @"hotel_id", [NSString class]);
        self.hotel_name = GETOBJECTFORKEY(data, @"hotel_name", [NSString class]);
        self.room_id = GETOBJECTFORKEY(data, @"room_id", [NSString class]);
        self.room_name = GETOBJECTFORKEY(data, @"room_name", [NSString class]);
        
        NSString *roomTotal = GETOBJECTFORKEY(data, @"number_of_units", [NSString class]);
        self.number_of_units = [NSString stringWithFormat:@"%@间", roomTotal];
        
        NSString *checkTime = GETOBJECTFORKEY(data, @"start_time_span", [NSString class]);
        NSDate *sDate = [NSDate dateWithTimeIntervalSince1970:checkTime.longLongValue];
        self.start_time_span = [sDate timeDescription];
        
        NSString *endTime = GETOBJECTFORKEY(data, @"end_time_span", [NSString class]);
        NSDate *eDate = [NSDate dateWithTimeIntervalSince1970:endTime.longLongValue];
        self.end_time_span = [eDate timeDescription];

        //计算出入住时间
        NSInteger intervalDay = ((NSInteger)((endTime.longLongValue-checkTime.longLongValue-86400) / 86400)) + 1;
        self.checkInDay = [NSString stringWithFormat:@"%d晚", intervalDay];
        
        NSString *cin = [sDate loaclDescription];
        NSString *cout = [eDate loaclDescription];
        self.checkInTimeDesc = [NSString stringWithFormat:@"%@-%@", cin, cout];
        
        NSString *arrTime = GETOBJECTFORKEY(data, @"late_arrival_time", [NSString class]);
        NSDate *arrDate = [NSDate dateWithTimeIntervalSince1970:arrTime.longLongValue];
        self.late_arrival_time = [arrDate timeDescriptionFull];
        
        self.address = GETOBJECTFORKEY(data, @"address", [NSString class]);
        self.telephone = GETOBJECTFORKEY(data, @"telephone", [NSString class]);
        self.person_name = GETOBJECTFORKEY(data, @"person_name", [NSString class]);
        self.contact_person_surname = GETOBJECTFORKEY(data, @"contact_person_surname", [NSString class]);
        self.phone_number = GETOBJECTFORKEY(data, @"phone_number", [NSString class]);
        self.special_request = GETOBJECTFORKEY(data, @"special_request", [NSString class]);
        
        NSString *lat = GETOBJECTFORKEY(data, @"LAT", [NSString class]);
        self.LAT = [lat floatValue];
        
        NSString *lon = GETOBJECTFORKEY(data, @"LON", [NSString class]);
        self.LON = [lon floatValue];
        
        NSString *glat = GETOBJECTFORKEY(data, @"GLAT", [NSString class]);
        self.GLAT = [glat floatValue];
        
        NSString *glon = GETOBJECTFORKEY(data, @"GLON", [NSString class]);
        self.GLON = [glon floatValue];
        
        NSString *gdlat = GETOBJECTFORKEY(data, @"GDLAT", [NSString class]);
        self.GDLAT = [gdlat floatValue];
        
        NSString *gdlon = GETOBJECTFORKEY(data, @"GDLON", [NSString class]);
        self.GDLON = [gdlon floatValue];
        
        //发票
        BOOL hasInvoice = (GETOBJECTFORKEY(data, @"invoice_title", NSString)) != nil;
        if (hasInvoice)
        {
            HYHotelInvoiceModel *invoiceModel = [[HYHotelInvoiceModel alloc] init];
            invoiceModel.invoice_title = GETOBJECTFORKEY(data, @"invoice_title", NSString);
            invoiceModel.invoice_person_name = GETOBJECTFORKEY(data, @"invoice_person_name", NSString);
            invoiceModel.invoice_phone = GETOBJECTFORKEY(data, @"invoice_phone", NSString);
            invoiceModel.invoice_postal_code = GETOBJECTFORKEY(data, @"invoice_postal_code", NSString);
            invoiceModel.invoice_address = GETOBJECTFORKEY(data, @"invoice_address", NSString);
            invoiceModel.invoice_description = GETOBJECTFORKEY(data, @"invoice_description", NSString);
            invoiceModel.shippingMethodId = GETOBJECTFORKEY(data, @"shipping_method_id", NSString);
            HYHotelInvoiceMethod *method = [[HYHotelInvoiceMethod alloc] init];
            method.shippingMethodId = GETOBJECTFORKEY(data, @"shipping_method_id", NSString);
            method.shippingMethodFee = [GETOBJECTFORKEY(data, @"shipping_method_fee", NSString) floatValue];
            method.shippingMethodName = GETOBJECTFORKEY(data, @"shipping_method_name", NSString);
            invoiceModel.method = method;
            self.invoiceModel = invoiceModel;
        }
    }
    
    return self;
}
*/
- (BOOL)isPrePay
{
    return ([[self.orderItemPOList[0] ratePlanCategory] intValue] == 501
            || [[self.orderItemPOList[0] ratePlanCategory] intValue] == 502
            || [self.productTypeCode intValue] == 3);
}



#pragma mark setter/getter

//- (NSString *)payTypeDesc
//{
//    if (self.pay_type == Online_Pay)
//    {
//        return @"在线支付";
//    }
//    return @"到店支付";
//}

@end
