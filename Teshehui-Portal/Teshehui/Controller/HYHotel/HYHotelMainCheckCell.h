//
//  HYHotelMainDateCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@interface HYHotelMainCheckCell : HYBaseLineCell

@property (nonatomic, copy) NSString *checkInDate;
@property (nonatomic, copy) NSString *checkInweekDay;
@property (nonatomic, copy) NSString *checkOutDate;
@property (nonatomic, copy) NSString *checkOutweekDay;
@property (nonatomic, assign) NSInteger day;

@end
