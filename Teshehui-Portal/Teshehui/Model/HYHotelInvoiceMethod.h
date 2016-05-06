//
//  HYHotelInvoiceMethod.h
//  Teshehui
//
//  Created by apple on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYHotelInvoiceMethod : NSObject

@property (nonatomic, strong) NSString *shippingMethodId;
@property (nonatomic, strong) NSString *shippingMethodName;
@property (nonatomic, assign) CGFloat shippingMethodFee;

@property (nonatomic, strong) NSString *shippingDisplay;

- (id)initWithDataInfo:(NSDictionary *)data;

@end
