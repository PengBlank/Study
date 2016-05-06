//
//  TYOrderNumModel.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// 这是确认支付后，接口返回的订单数据
@interface TYOrderNumModel : NSObject

@property (nonatomic, copy) NSString   *c2b_order_id;   // C2B的订单ID
@property (nonatomic, copy) NSString   *c2b_trade_no;   // C2B的订单流水
@property (nonatomic, copy) NSString   *o2o_trade_no;   // O2O的订单流水
@property (nonatomic, copy) NSString   *orderDate;      // 购票时间
@property (nonatomic, copy) NSString   *merId;          // 景区id（用于生成二维码的信息，以前是sId即景点id）
@property (nonatomic, copy) NSString   *tId;            // 票id（即订单id，用于生成二维码的信息）
@property (nonatomic, copy) NSArray    *tickets;        // 生成的票数组，用来判断是否出票成功或者显示票数据

@end
