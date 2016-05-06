//
//  HYHotelInvoiceModel.m
//  Teshehui
//
//  Created by apple on 15/3/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYHotelInvoiceModel.h"

@implementation HYHotelInvoiceModel

- (NSString *)completeValidate
{
    NSString *error = nil;
    if (!self.invoice_title)
    {
        error = @"请输入发票抬头";
    }
    else if (!self.invoice_description)
    {
        error = @"请输入发票明细";
    }
    else if (!self.invoice_address)
    {
        error = @"请输入收件人地址";
    }
//    else if (!self.invoice_phone)
//    {
//        error = @"请输入收件人电话";
//    }
    else if (!self.method.shippingMethodId)
    {
        error = @"请选择配送方式";
    }
    return error;
}

- (NSString *)orderDetailDisplay
{
    return [NSString stringWithFormat:@"%@ %@", _invoice_title, _invoice_description];
    return nil;
}

@end
