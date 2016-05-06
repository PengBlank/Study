//
//  HYFilghtSearchRequest.h
//  ComeHere
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 机票查询界面
 */

#import "CQBaseRequest.h"

@interface HYFilghtSearchRequest : CQBaseRequest

//必须字段
@property (nonatomic, copy) NSString *flight_date;  //搜索航班日期(时间戳)
@property (nonatomic, copy) NSString *org_city;  //出发城市三字码
@property (nonatomic, copy) NSString *dst_city;  //到达城市三字码

//可选字段
@property (nonatomic, copy) NSString *airline;  //航空公司二字码

@end
