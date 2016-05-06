//
//  TravelTicketsListModel.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// 接口返回的数据模型
@interface TravelTicketsListModel : NSObject

@property (nonatomic, copy) NSString    *merId;   // 景点id
@property (nonatomic, copy) NSString    *merchantLogo;   // 背景图片
@property (nonatomic, copy) NSString    *serverDate;     // 服务器时间
@property (nonatomic, copy) NSString    *touristName;    // 景点名称
@property (nonatomic, strong) NSArray   *tickets;        // 门票列表

@end

// 接口返回的数据模型其中的门票模型　
@interface TravelSightInfo : NSObject

// 这是V2接口
@property (nonatomic, copy) NSString   *sId;              // ？？景点ID
@property (nonatomic, copy) NSString   *tId;              // 票ID
@property (nonatomic, copy) NSString   *ticketName;       // 票名
@property (nonatomic, copy) NSString   *days;             // 使用天数
@property (nonatomic, copy) NSString   *adultPrice;       // 成人原价
@property (nonatomic, copy) NSString   *childPrice;       // 儿童原价
@property (nonatomic, copy) NSString   *tshAdultPrice;    // 特奢汇成人价
@property (nonatomic, copy) NSString   *tshAdultCoupon;   // 特奢汇现金券
@property (nonatomic, copy) NSString   *tshChildPrice;    // 特奢汇儿童价
@property (nonatomic, copy) NSString   *tshChildCoupon;   // 特奢汇儿童现金券

@end