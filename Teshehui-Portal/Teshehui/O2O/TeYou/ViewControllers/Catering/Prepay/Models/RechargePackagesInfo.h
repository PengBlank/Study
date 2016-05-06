//
//  RechargePackagesInfo.h
//  Teshehui
//
//  Created by macmini5 on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  充值套餐列表model

#import <Foundation/Foundation.h>

@interface RechargePackagesInfo : NSObject

//@property (nonatomic, strong) NSString *rpId;
//@property (nonatomic, strong) NSString *mer_id;

@property (nonatomic, strong) NSString *amount;             // 套餐列表的充值金额
@property (nonatomic, strong) NSString *givenAmount;        // 套餐列表的赠送金额(要扣除的现金券)

@end
