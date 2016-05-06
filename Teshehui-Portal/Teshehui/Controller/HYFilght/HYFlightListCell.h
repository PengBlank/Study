//
//  HYFlightListCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYFlightListSummary.h"

@protocol HYFlightListCellDelegate;
@interface HYFlightListCell : HYBaseLineCell

@property (nonatomic, weak) id<HYFlightListCellDelegate> delegate;
@property (nonatomic, strong) HYFlightListSummary *flight;

@end


@protocol HYFlightListCellDelegate <NSObject>

@optional
//- (void)didUpdateFlightPrice:(HYCabins *)cabin;

@end