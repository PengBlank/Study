//
//  HYHotelSearchResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYHotelSearchResponse : CQBaseResponse

@property (nonatomic, readonly, strong) NSArray *hotelList;

@property (nonatomic, readonly, assign) NSInteger total;
@property (nonatomic, readonly, assign) NSInteger currendPage;

@end
