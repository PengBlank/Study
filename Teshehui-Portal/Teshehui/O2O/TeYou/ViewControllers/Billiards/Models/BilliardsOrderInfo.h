//
//  BilliardsOrderInfo.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BilliardsMerchantInfo.h"
@interface BilliardsOrderInfo : NSObject

@property (nonatomic,assign) NSInteger  actionType;  //0标示购买酒水 1标示去付款 2标示是查看订单详情 其他标示评论&分享

@property (nonatomic,strong) NSString  *OrderId;
//@property (nonatomic,strong) NSString  *RateByHour;
//@property (nonatomic,strong) NSString  *RateCoupon;

@property (nonatomic,strong) NSString  *RateByHourCoupon;

@property (nonatomic,strong) NSString  *OrderAmount;
@property (nonatomic,strong) NSString  *OrderCoupon;
@property (nonatomic,strong) NSString  *StartTime;
@property (nonatomic,strong) NSString  *EndTime;
@property (nonatomic,strong) NSString  *OrderStatus;
@property (nonatomic,strong) NSString  *PayType;
@property (nonatomic,strong) NSString  *MerchantName;
@property (nonatomic,strong) NSString  *MerchantId;
@property (nonatomic,strong) NSString  *TableName;
@property (nonatomic,strong) NSString  *TableStatus;
@property (nonatomic,strong) NSString  *BallTableId;
@property (nonatomic,strong) NSString  *MerchantLogo;
@property (nonatomic,strong) NSString  *TableNo;
@property (nonatomic,strong) NSString  *PayStatus; //用于判断是否评论过
@property (nonatomic,strong) NSString  *OrderNum;
@property (nonatomic,strong) NSString  *PcOrderNum;




//@property (nonatomic,strong) NSMutableArray        *BuyModelList;
//@property (nonatomic,strong) NSMutableArray        *DiscountList;
//@property (nonatomic,strong) BilliardsMerchantInfo *MercInfo;
//@property (nonatomic,strong) BilliardsOrderInfo    *BallTable;


@end
