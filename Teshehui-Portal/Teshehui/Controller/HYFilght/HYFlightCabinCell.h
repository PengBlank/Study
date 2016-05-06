//
//  HYFlightCabinCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYFlightSKU.h"
#import "HYFlightListCell.h"

@interface HYFlightCabinCell : HYBaseLineCell

@property (nonatomic, weak) id<HYFlightListCellDelegate> delegate;
@property (nonatomic, strong) HYFlightSKU *cabin;

@end
