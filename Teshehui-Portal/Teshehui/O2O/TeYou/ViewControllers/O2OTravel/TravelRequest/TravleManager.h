//
//  TravleManager.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravleManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, copy) NSString *touristName; //景点名称
@property (nonatomic, copy) NSString *savePrice; // 节省金额
@property (nonatomic, copy) NSString *totalPrice; // 总现金
@property (nonatomic, copy) NSString *totalCoupon;
@property (nonatomic, copy) NSString *totalAdultCount; // 成人总票数
@property (nonatomic, copy) NSString *totalChildCount;
@property (nonatomic, copy) NSString *sid; //景点ID
@property (nonatomic, copy) NSString *tid; //票ID
@property (nonatomic, copy) NSString *tiketName; //票名
@property (nonatomic, copy) NSString *orderDate; //购票时间
@end
