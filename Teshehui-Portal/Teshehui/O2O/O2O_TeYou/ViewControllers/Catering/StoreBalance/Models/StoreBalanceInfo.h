//
//  StoreBalanceInfo.h
//  Teshehui
//
//  Created by macmini5 on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  实体店余额页面Model

#import <Foundation/Foundation.h>

@interface StoreBalanceInfo : NSObject

@property (nonatomic, strong) NSString *merId;          // 商家id
@property (nonatomic, strong) NSString *merchantName;   // 商家名
@property (nonatomic, strong) NSString *balance;        // 余额
@property (nonatomic, strong) NSString *merchantLogo;   // 商家logo
@property (nonatomic, strong) NSString *enableCharge;   // 是否充值 0否 1是

@end
