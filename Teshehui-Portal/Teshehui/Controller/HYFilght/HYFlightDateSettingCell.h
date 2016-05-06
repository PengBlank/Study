//
//  HYFlightDateSettingCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@protocol HYFlightDateSettingCellDelegate <NSObject>

@optional
- (void)startDateSetting;
- (void)backDateSetting;

@end

@interface HYFlightDateSettingCell : HYBaseLineCell

@property (nonatomic, weak) id<HYFlightDateSettingCellDelegate> delegate;
@property (nonatomic, assign) BOOL singleWay;

@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *backDate;
@property (nonatomic, copy) NSString *backTime;

@end


/*
 single-way
 round-trip
*/