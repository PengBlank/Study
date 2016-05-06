//
//  HYFlightCitySettingCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYFlightCity.h"

@protocol HYFlightCitySettingCellDelegate <NSObject>

@optional
- (void)setflightOrgCity;
- (void)setflightDstCity;
- (void)transformflightCity;
@end

@interface HYFlightCitySettingCell : HYBaseLineCell

@property (nonatomic, weak) id<HYFlightCitySettingCellDelegate> delegate;
@property (nonatomic, strong) HYFlightCity *orgCity;
@property (nonatomic, strong) HYFlightCity *dstCity;

@end
