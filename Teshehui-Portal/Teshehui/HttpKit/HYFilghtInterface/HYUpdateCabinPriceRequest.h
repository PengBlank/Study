//
//  HYUpdateCabinPriceRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-4-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYUpdateCabinPriceResponse.h"


@interface HYUpdateCabinPriceRequest : CQBaseRequest

@property (nonatomic, copy) NSString *org_city;  //出发城市三字码
@property (nonatomic, copy) NSString *dst_city;  //到达城市三字码
@property (nonatomic, copy) NSString *cabin_code;
@property (nonatomic, copy) NSString *flight_date;  //搜索航班日期(时间戳)
@property (nonatomic, copy) NSString *flight_no;

@end
