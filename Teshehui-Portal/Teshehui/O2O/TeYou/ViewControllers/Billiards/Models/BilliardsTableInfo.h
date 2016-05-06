//
//  BilliardsTableInfo.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BilliardsTableInfo : NSObject

@property (nonatomic,strong) NSString       *MerchantName;
@property (nonatomic,strong) NSString       *MerchantLogo;
@property (nonatomic,strong) NSString       *TableName;
@property (nonatomic,strong) NSString       *RateByHour;
@property (nonatomic,strong) NSString       *RateCoupon;
@property (nonatomic,strong) NSString       *TableStatus;
@property (nonatomic,strong) NSString       *OrderId;
@property (nonatomic,strong) NSString       *OrderNum;
@property (nonatomic,strong) NSString       *OrderAmount;
@property (nonatomic,strong) NSString       *OrderCoupon;
@property (nonatomic,strong) NSString       *PayType;
@property (nonatomic,strong) NSString       *StartTime;
@property (nonatomic,strong) NSString       *EndTime;
@property (nonatomic,strong) NSString       *OrderStatus;

@property (nonatomic,strong) NSString       *TableId; // 球台ID
@property (nonatomic,strong) NSString       *MerchantId;

@property (nonatomic,strong) NSString       *RateCostPrice; //原价
@property (nonatomic,strong) NSString       *StandAmount; //看台费用
@property (nonatomic,strong) NSString       *BentoAmount; //外卖费用
@property (nonatomic,strong) NSString       *PcOrderNum; //

@property (nonatomic,strong) NSMutableArray *DiscountList;
@end

@interface DiscountInfo : NSObject  //折扣信息
@property (nonatomic,strong) NSString  *GoodsName;
@property (nonatomic,strong) NSString  *Num;
@property (nonatomic,strong) NSString  *PayAmount;
@property (nonatomic,strong) NSString  *Coupon;
@property (nonatomic,strong) NSString  *DrinkAmount;
@property (nonatomic,strong) NSString  *DrinkCoupon;

@end