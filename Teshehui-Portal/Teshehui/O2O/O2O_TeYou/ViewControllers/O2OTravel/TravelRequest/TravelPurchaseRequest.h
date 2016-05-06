//
//  TravelPurchaseRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface TravelPurchaseRequest : CQBaseRequest

//　基础数据
//@property (nonatomic, strong) NSString *userId;用户id
@property (nonatomic, strong) NSString *merId;       // 景区id即商家id
@property (nonatomic, strong) NSString *mobile;       // 用户手机号
@property (nonatomic, strong) NSString *cardNo;      // 会员号
@property (nonatomic, strong) NSString *priceType;   // 价格类型（1特奢汇价2原价）
@property (nonatomic, strong) NSString *merchantName;// 商家名即景区名
@property (nonatomic, strong) NSString *userName;    // 会员名
@property (nonatomic, strong) NSString *userDate;    // 票使用日期（2015-12-10）

// 门票数据
@property (nonatomic, strong) NSArray *tickets;

@end

@interface TravelPurchaseRequestTicket : NSObject

// 门票数据　post的时候用这个实体组装数组
@property (nonatomic, strong) NSString *ticketName;  // :票名
@property (nonatomic, strong) NSString *days;        // 可用天数
@property (nonatomic, strong) NSString *adultTickets;// 成人数
@property (nonatomic, strong) NSString *childTickets;// 儿童数
@property (nonatomic, strong) NSString *price;       // 票的原价（单个票的总价，不是票的单价）
@property (nonatomic, strong) NSString *tshPrice;    // 特奢汇价（单个票的总价，不是票的单价）
@property (nonatomic, strong) NSString *coupon;      // 票的现金券
@property (nonatomic, strong) NSString *tId;         // 票ID

@end