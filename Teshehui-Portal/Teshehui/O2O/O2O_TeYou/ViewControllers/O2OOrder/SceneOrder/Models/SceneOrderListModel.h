//
//  SceneOrderListModel.h
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  场景订单列表数据model

#import <Foundation/Foundation.h>

@interface SceneOrderListModel : NSObject

/** 按钮*/
@property (nonatomic, strong) UIButton *btn;

/** 套餐id */
@property (nonatomic, copy) NSString *packId;
/** 订单编号 */
//@property (nonatomic, copy) NSString *orderNum;
/** 套餐名 */
@property (nonatomic, copy) NSString *packageName;
/** 商家id */
@property (nonatomic, copy) NSString *merId;
/** 价格 */
@property (nonatomic, copy) NSString *amount;
/** 现金券*/
@property (nonatomic, copy) NSString *coupon;
/** 订单状态 0已使用1可使用2未付款3已取消4退款中5已退款*/
@property (nonatomic, copy) NSString *status;
/** 份数 */
@property (nonatomic, copy) NSString *packageCount;
/** 时间 */
@property (nonatomic, copy) NSString *createdon;
/** 图片url */
@property (nonatomic, copy) NSString *url;

// 以下为去支付的时候会用到的
/** 商家名 */
@property (nonatomic, copy) NSString *merchantName;
/** 消费码 */
@property (nonatomic, copy) NSString *validCode;
/** O2O订单流水号 */
@property (nonatomic, copy) NSString *o2oTradeNo;  // 就是orderNum
/** C2B订单流水号 */
@property (nonatomic, copy) NSString *c2bTradeNo;
/** C2B订单流id */
@property (nonatomic, copy) NSString *c2bOrderId;

@end
