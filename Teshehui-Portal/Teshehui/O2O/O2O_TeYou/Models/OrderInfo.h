//
//  OrderInfo.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/19.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfo : NSObject

@property (nonatomic,assign) NSInteger      ActionType; //操作类型  0 标示去支付   1 标示去评价
@property (nonatomic,assign) NSInteger      UserId;

@property (nonatomic,strong) NSString       *UserName;
@property (nonatomic,strong) NSString       *CardNo;
@property (nonatomic,strong) NSString       *MerchantId;
@property (nonatomic,strong) NSString       *MerchantsName;
//@property (nonatomic,strong) NSString       *MerchantName;
@property (nonatomic,strong) NSString       *MerchantsLogo;
@property (nonatomic,strong) NSString       *OrderNo;

@property (nonatomic,strong) NSString       *O2O_Order_Number;
@property (nonatomic,strong) NSString       *C2B_Order_Number;
@property (nonatomic,strong) NSString       *C2B_Order_ID;
@property (nonatomic,strong) NSString       *CreateOn;
@property (nonatomic,strong) NSString       *Coupon;
@property (nonatomic,strong) NSString       *Amount;

@property (nonatomic,strong) NSString       *Pay_Way;
@property (nonatomic,strong) NSString       *OrderType;
@property (nonatomic,strong) NSString       *AmountType;
@property (nonatomic,strong) NSString       *Status;

@property (nonatomic,strong) NSString       *Is_Coupon;  //判断订单是不是纯现金券类型
@property (nonatomic,strong) NSString       *IsComment;  //是否评论标示

@property (nonatomic,assign) NSInteger       isRechargeCost;  //是否是充值消费
@property (nonatomic,strong) NSString       *balance;  //实体店余额


@end
