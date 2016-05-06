//
//  HYHotelValidRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店房间是否可以订查询接口
 */

#import "CQBaseRequest.h"

@interface HYHotelValidRequest : CQBaseRequest

//必须参数
@property (nonatomic, copy) NSString *hotelProductId;  //酒店ID
@property (nonatomic, copy) NSString *hotelRoomTypeId; //酒店房型唯一标识ID
//@property (nonatomic, copy) NSString *startDate;  //入住时间
//@property (nonatomic, copy) NSString *endDate;  //离店时间
@property (nonatomic, copy) NSString *latestArrivalTime;
@property (nonatomic, copy) NSString *roomNumber;
@property (nonatomic, copy) NSString *customerNumber;
@property (nonatomic, copy) NSString *productSKUId;

//@property (nonatomic, copy) NSString *shippingMethodId;

@end

/*
 hotelRoomRatePlanId	String
 latestArrivalTime	date
 roomNumber	Integer
 customerNumber	Integer
*/