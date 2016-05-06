//
//  HYHotelInvoiceModel.h
//  Teshehui
//
//  Created by apple on 15/3/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYHotelInvoiceMethod.h"

@interface HYHotelInvoiceModel : NSObject

@property (nonatomic, copy) NSString *invoice_title;        //发票抬头
@property (nonatomic, copy) NSString *invoice_person_name;  //邮寄联系人姓名
@property (nonatomic, copy) NSString *invoice_phone;        //手机
@property (nonatomic, copy) NSString *invoice_postal_code;  //邮编
@property (nonatomic, copy) NSString *invoice_address;      //寄送地址
@property (nonatomic, copy) NSString *invoice_address_id;      //寄送地址
@property (nonatomic, copy) NSString *invoice_description;  //描述
@property (nonatomic, copy) NSString *shippingMethodId;
@property (nonatomic, strong) HYHotelInvoiceMethod *method; //配送方式

//@property (nonatomic, copy) NSString *invoiceTitle;
//@property (nonatomic, copy) NSString *invoiceContent;
//@property (nonatomic, copy) NSString *userAddressId;
//@property (nonatomic, copy) NSString *deliveryId;

- (NSString *)completeValidate;

- (NSString *)orderDetailDisplay;

@end
