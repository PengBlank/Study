//
//  CQCalendarMonthView.h
//  Teshehui
//
//  Created by ChengQian on 13-10-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQCalendarDayView.h"
#import "CQCalendarMonthHeaderView.h"

@interface CQCalendarMonthView : UIView

@property (nonatomic, copy, readonly) NSDateComponents *month;
@property (nonatomic, strong, readonly) NSSet *dayViews;
@property (nonatomic, strong, readonly) CQCalendarMonthHeaderView *headerView;


// Designated initialiser
- (id)initWithMonth:(NSDateComponents*)month
              width:(CGFloat)width
       dayViewClass:(Class)dayViewClass
      dayViewHeight:(CGFloat)dayViewHeight
              start:(NSDate *)start
                end:(NSDate *)end;

- (CQCalendarDayView*)dayViewForDay:(NSDateComponents*)day;
//- (void)updateDaySelectionStatesForRange:(DSLCalendarRange*)range;

@end
