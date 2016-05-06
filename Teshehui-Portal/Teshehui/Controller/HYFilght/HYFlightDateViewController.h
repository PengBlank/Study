//
//  HYFlightDateViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightBaseViewController.h"

@protocol HYFlightDateViewControllerDelegate <NSObject>

@optional

- (void)didSelectStartDate:(NSString *)start
                      week:(NSString *)week;

- (void)didSelectStartDate:(NSString *)start
                     sWeek:(NSString *)sWeek
                  backDate:(NSString *)backDate
                     bWeek:(NSString *)bWeek;

@end

/**
 *  机票日期选择界面
 */
@interface HYFlightDateViewController : HYFlightBaseViewController

@property (nonatomic, weak) id<HYFlightDateViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL singleWay;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@end
