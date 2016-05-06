//
//  HYFlightOrderCabinInfoCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYFlightSKU.h"
#import "HYFlightRTRules.h"

@protocol HYFlightOrderCabinInfoCellDelegate;
@interface HYFlightFillOrderCabinInfoCell : HYBaseLineCell

@property (nonatomic, assign) id<HYFlightOrderCabinInfoCellDelegate> delegate;
@property (nonatomic, strong) HYFlightSKU *cabin;
@property (nonatomic, strong) HYFlightRTRules *rules;
@property (nonatomic, assign) BOOL isExpand;

@end



@protocol HYFlightOrderCabinInfoCellDelegate <NSObject>

@optional
- (void)cellExpand:(BOOL)expand;

@end