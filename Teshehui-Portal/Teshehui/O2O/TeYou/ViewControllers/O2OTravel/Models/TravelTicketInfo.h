//
//  TravelTicketInfo.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelTicketInfo : NSObject

@property (nonatomic, copy) NSString            *adultTickets;  // 成人数
@property (nonatomic, copy) NSString            *childTickets;  // 儿童数
@property (nonatomic, copy) NSString            *days;          // 可用天数
@property (nonatomic, copy) NSString            *ticketName;    // 票名
@property (nonatomic, copy) NSString            *coupon;        // 订单的现金券数
@property (nonatomic, copy) NSString            *price;         // 订单那价格
@property (nonatomic, copy) NSString            *tId;           // 票Id

@property (nonatomic, strong) NSMutableArray    *tourists;      // 景点数组 touristName景点名 isCheck是否划线(0不划线，1划线)


@end
