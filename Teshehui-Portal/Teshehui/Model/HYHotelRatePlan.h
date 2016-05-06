//
//  HYHotelRatePlan.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

typedef enum _HotelRoomStatus
{
    Open      = 1,  //可售
    OnRequest    ,  //房源紧张
    Close        ,  //不可售
}HotelRoomStatus;

NSString *const HotelRatePlanCrip;
NSString *const HOtelRatePlanElong;

@interface HYHotelRatePlan : NSObject<CQResponseResolve>

@property (nonatomic, strong) NSString *infoSource; //00001:crip, 00002:elong
@property (nonatomic, copy) NSString *code;  //酒店房型产品编码
@property (nonatomic, copy) NSString *roomTypeId;  //酒店房型唯一标识ID
@property (nonatomic, copy) NSString *roomRatePlanName;	//房型产品名
@property (nonatomic, assign) BOOL status;  //产品是否可售
@property (nonatomic, assign) CGFloat totalFee;  //double	总价
@property (nonatomic, assign) CGFloat point;  //double	总价
@property (nonatomic, assign) CGFloat averageFee;  //String	日均价
@property (nonatomic, assign) CGFloat averageOldFee;  //String	促销前日均价
@property (nonatomic, assign) int stock;  //剩余房量
@property (nonatomic, assign) NSInteger isInstantConfirmation;  //是否支持及时确认，未知0，是1，否2
@property (nonatomic, copy) NSString *paymentTypeCode;  //String	现付前台付
@property (nonatomic, assign) NSInteger productTypeCode;    //未知0, 现付1, 担保2, 预付3
@property (nonatomic, assign) int minAmount;  //Integer	最少预定数
@property (nonatomic, assign) int minDays;  //Integer	最少入住天数
@property (nonatomic, assign) int maxDays;  //Integer	最大入住天数
@property (nonatomic, assign) double guaranteeFee;  //担保金额
@property (nonatomic, assign) NSInteger isGuaranteeFeeCancel;  //担保金订单是否可取消，0：未知，1是，2否
@property (nonatomic, copy) NSString *guaranteeFeeCancelTime;  //String	担保金订单取消最迟时间
@property (nonatomic, copy) NSString *createdTime;  //String	信息创建时间

//@property (nonatomic, assign) double payable;  //int	应付款

//- (NSString *)lateArriveTime;
- (BOOL)isPrePay;
@end

/*
 roomRatePlanId	String	产品唯一标识符
 roomRatePlanName	String	房型产品名
 status	boolean	产品是否可售
 totalFee	double	总价
 averageFee	String	日均价
 averageOldFee	String	促销前日均价
 stock	String	剩余房量
 isInstantConfirmation	Boolean	是否支持及时确认
 paymentType	String	现付前台付
 minAmount	Integer	最少预定数
 minDays	Integer	最少入住天数
 maxDays	Integer	最大入住天数
 isGuarantee	Boolean	是否需要担保
 guaranteeFee	Double	担保金额
 isGuaranteeFeeCancel	Boolean	担保金订单是否可取消
 guaranteeFeeCancelTime	String	担保金订单取消最迟时间
 createdTime	String	信息创建时间
 updatedTime	String	信息最近更新时间
 payable	int	应付款
 */
