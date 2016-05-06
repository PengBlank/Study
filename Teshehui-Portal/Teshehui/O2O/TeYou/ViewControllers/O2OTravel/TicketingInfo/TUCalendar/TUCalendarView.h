//
//  TUCalendarView.h
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUCalendarHeader.h"
#import "TUCalendarContentView.h"
#import "TUCalendarHeaderView.h"
#import "TUCalendarDataCache.h"
#import "TUCalendarUtil.h"

@class TUCalendarView;

@protocol TUCalendarDataSource <NSObject>

- (BOOL)calendarHaveEvent:(TUCalendarView *)calendar date:(NSDate *)date;
- (void)calendarDidDateSelected:(TUCalendarView *)calendar date:(NSString *)dateString;
@optional
- (void)calendarDidLoadPreviousPage;
- (void)calendarDidLoadNextPage;
@end

@interface TUCalendarView : NSObject<UIScrollViewDelegate>

@property (weak, nonatomic) TUCalendarHeaderView *headerView;
@property (weak, nonatomic) TUCalendarContentView *contentView;

@property (weak, nonatomic) id<TUCalendarDataSource> dataSource;
@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) NSDate *currentDateSelected;

@property (strong, nonatomic ,readonly) NSDate *dateLimit;
@property (strong, nonatomic) NSDate *dateServer;
@property (strong, nonatomic) NSDate *dateSelected;
@property (assign, nonatomic) NSInteger limitDays;  // 限制使用的天数
@property (strong, nonatomic) NSString *dayFormat;

@property (strong, nonatomic, readonly) TUCalendarDataCache *dataCache;

- (NSCalendar *)defaultCalendar;

- (void)reloadData;
- (void)loadPreviousPage;
- (void)loadNextPage;

- (void)repositionViews;
- (void)reloadLayout;
@end
