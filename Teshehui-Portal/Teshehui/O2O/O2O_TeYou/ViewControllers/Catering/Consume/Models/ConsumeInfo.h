//
//  ConsumeInfo.h
//  Teshehui
//
//  Created by macmini5 on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsumeInfo : NSObject

@property (nonatomic, strong) NSString *amount;     // 金额
@property (nonatomic, strong) NSString *o2otradeNo; // 关联的o2o的订单号
@property (nonatomic, strong) NSString *type;       // 支付方式0支付宝1银联2微信3余额4现金券5复合支付6实体店余额支付
@property (nonatomic, strong) NSString *payWay;     // 微信充值
@property (nonatomic, strong) NSString *createdon;  // 时间

@end
