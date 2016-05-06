//
//  SceneOrderDetailModel.h
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/11.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
// 场景订单详情model

#import <Foundation/Foundation.h>

@interface SceneOrderDetailModel : NSObject

/** 套餐id */
@property (nonatomic, copy) NSString *packId;
/** 套餐名 */
@property (nonatomic, copy) NSString *packageName;
/** 商家id */
@property (nonatomic, copy) NSString *merId;
/** 订单流水号 o2o订单号 */
@property (nonatomic, copy) NSString *o2oTradeNo;
/** 商家名称 */
@property (nonatomic, copy) NSString *merchantName;

/** 商家地址 */
@property (nonatomic, copy) NSString *merchantAddress;
/** 商家电话 */
@property (nonatomic, copy) NSString *merchantMobile;
/** 价格 */
@property (nonatomic, copy) NSString *amount;
/** 现金券 */
@property (nonatomic, copy) NSString *coupon;
/** 就餐时间*/
//@property (nonatomic, copy) NSString *createdon;
/** 就餐时间 */
@property (nonatomic, copy) NSString *useDate;

/** 状态 */
@property (nonatomic, copy) NSString *status;
/** 图片地址 */
@property (nonatomic, copy) NSString *url;
/** 份数 */
@property (nonatomic, copy) NSString *packageCount;
/** 联系人 */
@property (nonatomic, copy) NSString *userName;
/** 联系电话 */
@property (nonatomic, copy) NSString *mobile;

/** 消费码 */
@property (nonatomic, copy) NSString *validCode;
/** 消费时间 */
@property (nonatomic, copy) NSString *validTime;
/** 经度 */
@property (nonatomic, assign) CGFloat longitude;
/** 纬度 */
@property (nonatomic, assign) CGFloat latitude;


@end
