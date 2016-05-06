//
//  HYHotelInfoSwitchCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelInfoCell.h"

@protocol HYHotelInfoSwitchCellDelegate <NSObject>

@optional
- (void)swithShowInfo:(BOOL)traffic;

@end
@interface HYHotelInfoSwitchCell : HYHotelInfoCell

@property (nonatomic, weak) id<HYHotelInfoSwitchCellDelegate> delegate;

@end
