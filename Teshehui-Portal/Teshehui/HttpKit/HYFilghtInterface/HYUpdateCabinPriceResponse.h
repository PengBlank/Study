//
//  HYUpdateCabinPriceResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-4-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYUpdateCabinPriceResponse : CQBaseResponse

@property (nonatomic, assign) CGFloat price;  //舱位实时价格
@property (nonatomic, assign) CGFloat points;  //赠送现金券
@property (nonatomic, assign) BOOL support_journey;  //是否支持打印行程单 0否 1是

@end
