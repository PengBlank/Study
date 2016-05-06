//
//  SceneBookDetailInfo.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/12.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface SceneBookDetailRequest : CQBaseRequest

@property (nonatomic, weak) NSString *merId;//:"asfasdfasdfdasfasd",     商家id

@property (nonatomic, weak) NSString *merchantName ;//:"湖南菜",          商家名称
@property (nonatomic, weak) NSString *cardNo ;//:"10008" ,                        会员卡号
@property (nonatomic, strong) NSString *mobile ;//:"15817226738",            手机号
@property (nonatomic, strong) NSString *userName ;//:"张三",                       用户名
//@property (nonatomic, weak) NSString *userId ;//:"张三",                       用户名
@property (nonatomic, weak) NSString *amount ;//:120,                               金额
@property (nonatomic, weak) NSString *coupon ;//:20,                                现金券
@property (nonatomic, weak) NSString *productName ;//:"Scene" ,            订单类型（不用改直接写Scene)
@property (nonatomic, weak) NSString *packId ;//:"1",                                 套餐Id
@property (nonatomic, weak) NSString *packageName ;//:"品味一场无与伦比的盛宴",        套餐名称
@property (nonatomic, weak) NSString *packagePerson ;//:2,                              就餐人数
@property (nonatomic, weak) NSString *packageCount; //：1,                              份数
@property (nonatomic, weak) NSString *useDate ;//:"2016-4-11" ,                         就餐时间
@property (nonatomic, weak) NSString *cityName ;//:"深圳"                                    城市名

@end
