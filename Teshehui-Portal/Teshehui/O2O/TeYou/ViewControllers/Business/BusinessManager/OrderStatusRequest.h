//
//  OrderStatusRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface OrderStatusRequest : CQBaseRequest

@property (nonatomic,strong) NSString       *UserId;
@property (nonatomic,strong) NSString       *Coupon;
@property (nonatomic,strong) NSString       *O2O_Order_Number;
@property (nonatomic,strong) NSString       *C2B_Order_Number;
@property (nonatomic,strong) NSString       *CardNo;

@end
