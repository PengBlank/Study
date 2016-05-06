//
//  HYHotelRoomView.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYAdvanceBookingDelegate.h"
#import "HYHotelRoom.h"
#import "HYHotelSKU.h"
#import "HYPopUpView.h"

@interface HYHotelRoomView : HYPopUpView

@property (nonatomic, weak) id<HYAdvanceBookingDelegate>delegate;

- (id)initWithRoomInfo:(HYHotelSKU *)roomInfo;
//- (void)showWithAnimation:(BOOL)animation;

@end
