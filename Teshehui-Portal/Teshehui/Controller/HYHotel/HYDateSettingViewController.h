//
//  CQDateSettingViewController.h
//  Teshehui
//
//  Created by ChengQian on 13-10-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYCustomNavItemViewController.h"

@protocol CQDateSettingViewControllerDelegate;
@interface HYDateSettingViewController : HYCustomNavItemViewController

@property (nonatomic, assign) id<CQDateSettingViewControllerDelegate> delegate;

@property (nonatomic, strong) NSDate *checkInDate;
@property (nonatomic, strong) NSDate *checkOutDate;

@end


@protocol CQDateSettingViewControllerDelegate <NSObject>

@optional
- (void)didSelectCheckInDate:(NSString *)checkInDate
                 checkInWeek:(NSString *)checkInWeek
                CheckOutDate:(NSString *)checkOutDate
                checkOutWeek:(NSString *)checkOutWeek;

@end