//
//  HYHotelDetailResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYHotelInfoDetail.h"

@interface HYHotelDetailResponse : CQBaseResponse

@property (nonatomic, readonly, strong) HYHotelInfoDetail *hotelDetail;

@end
