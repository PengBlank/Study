//
//  TYBilliardsOrderInfo.h
//  Teshehui
//
//  Created by wujianming on 15/11/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface TYBilliardsOrderInfo : NSObject

@property (nonatomic, copy  ) NSString *OrId;
@property (nonatomic, copy  ) NSString *OrderNum;
@property (nonatomic, copy  ) NSString *PcOrderNum;
@property (nonatomic, copy  ) NSString *MerchantName;
@property (nonatomic, copy  ) NSString *OrderStatus;
@property (nonatomic, copy  ) NSString *PayType;
@property (nonatomic, copy  ) NSString *TableName;
@property (nonatomic, copy  ) NSString *TableNo;
@property (nonatomic, copy  ) NSString *TableId;
@property (nonatomic, copy  ) NSString *StartTime;
@property (nonatomic, copy  ) NSString *EndTime;

@property (nonatomic, copy  ) NSString *RateByHourCoupon;  //开台时段会员价

@property (nonatomic, copy  ) NSString *RateAmount; //桌球租台费用
@property (nonatomic, copy  ) NSString *RateTableCoupon; //桌球租台现金券

@property (nonatomic, copy  ) NSString *StandAmount; //看台费用
@property (nonatomic, copy  ) NSString *BentoAmount; //外卖费用
@property (nonatomic, copy  ) NSString *MasterFee; //陪练费用

@property (nonatomic, copy  ) NSString *DrinkCoupon; //酒水现金券费用
@property (nonatomic, copy  ) NSString *DrinkAmount; //酒水人民币费用

@property (nonatomic, copy  ) NSString *OrderAmount; //订单总人民币
@property (nonatomic, copy  ) NSString *OrderCoupon; //订单总现金券


@property (nonatomic, strong) NSArray    *DrinksList;







@property (nonatomic, copy  ) NSString   *RateCostPrice; //租台原价 二次迭代增加属性

//@property (nonatomic, copy  ) NSString *RateByHour;
//@property (nonatomic, copy  ) NSString *RateCoupon;

@end
