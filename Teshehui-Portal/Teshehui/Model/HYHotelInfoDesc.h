//
//  HYHotelInfoDesc.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelInfoDetail.h"
#import "HYHotelTraffic.h"
#import "HYHotelService.h"

@interface HYHotelInfoDesc : HYHotelInfoDetail

@property (nonatomic, copy) NSString *Roomquantity;   //INT	房间数量
@property (nonatomic, copy) NSString *Brief;   //STRING 摘要、简介
@property (nonatomic, copy) NSString *HotelDesc;   //STRING	详细说明
@property (nonatomic, copy) NSString *ServiceBrief;   //STRING	酒店设施摘要

@property (nonatomic, strong) NSArray *serviceList;  //酒店的设施列表
@property (nonatomic, strong) NSArray *trafficList;  //酒店的周边交通列表

@end
