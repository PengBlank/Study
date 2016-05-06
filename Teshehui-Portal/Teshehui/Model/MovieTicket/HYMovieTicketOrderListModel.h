//
//  HYMovieTicketOrderListModel.h
//  Teshehui
//
//  Created by HYZB on 16/2/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYMovieTicketOrderListModel : JSONModel

@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *thirdOrderCode;
@property (nonatomic, copy) NSString *singlePrice;
@property (nonatomic, assign) NSInteger counts;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, assign) NSInteger ticketStatus;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *moblie;
@property (nonatomic, copy) NSString *cashCoupon;
@property (nonatomic, copy) NSString *orderTradeAmount;

/*
 Long orderId;     //       订单ID
 String  orderCode;  //本地订单号
 String  thirdOrderCode;//第三方订单号
 String singlePrice;           // 单价
 Long  counts;             //   购票数量
 String  cityName;      //  城市名称
 Integer  ticketStatus; // 票品
 String  cinemaName; // 影院名称
 Integer orderStatus;  //  订单状态1 处理中   2下单成功   3 下单失败
 Long  userId  ;      // 用户名称
 String  userName  ;   // 用户姓名
 String  moblie;      //  购票电话
 private String  cashCoupon; //现金券
 private String orderTradeAmount;    //订单金额
 */

@end
