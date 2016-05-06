//
//  HYHotelRoomTypeCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYAdvanceBookingDelegate.h"
#import "SKSTableViewCell.h"
#import "HYHotelRoom.h"

@interface HYHotelRoomTypeCell : SKSTableViewCell

@property (nonatomic, weak) id<HYAdvanceBookingDelegate>delegate;
//@property (nonatomic, strong) HYHotelRoom *roomInfo;
@property (nonatomic, strong) HYHotelSKU *roomInfo;

@end
