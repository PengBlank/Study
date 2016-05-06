//
//  PrepayPBInfo.h
//  Teshehui
//
//  Created by macmini5 on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  实体店余额充值页面model

#import <Foundation/Foundation.h>

@interface PrepayPBInfo : NSObject

@property (nonatomic, strong) NSString *merchantName;               // 商家名
@property (nonatomic, strong) NSString *merchantLogo;               // 商家logo
@property (nonatomic, strong) NSString *balance;                    // 会员的账户余额

@property (nonatomic, strong) NSMutableArray *rechargePackages;     // 套餐列表

@end
