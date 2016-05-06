//
//  HYHotelDetailReuqest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 7.	酒店信息 – 图片、地址、房间价格计划等
 */

#import "CQBaseRequest.h"

@interface HYHotelDetailReuqest : CQBaseRequest

//必须字段
@property (nonatomic, copy) NSString *hotelId;  //酒店ID
@property (nonatomic, copy) NSString *startDate;  //入住时间
@property (nonatomic, copy) NSString *endDate;  //离店时间
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *productId;
//可选字段

@end
