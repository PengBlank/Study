//
//  CQCalendarDayView.h
//  Teshehui
//
//  Created by ChengQian on 13-10-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    CQCalendarDayViewNotSelected = 0,
    CQCalendarDayViewSelected,  //当前选中
    CQCalendarDayViewNearToday,
    CQCalendarDayViewOutdateToday
} typedef CQCalendarDayViewSelectionState;

enum {
    CQCalendarDayViewStartOfWeek = 0,
    CQCalendarDayViewMidWeek,
    CQCalendarDayViewEndOfWeek,
} typedef CQCalendarDayViewPositionInWeek;

@interface CQCalendarDayView : UIView

@property (nonatomic, copy) NSDateComponents *day;
@property (nonatomic, assign) CQCalendarDayViewPositionInWeek positionInWeek;
@property (nonatomic, assign) CQCalendarDayViewSelectionState selectionState;
@property (nonatomic, copy) NSString *labelText;
@property (nonatomic, copy) NSString *descText;
@property (nonatomic, assign, getter = isInCurrentMonth) BOOL inCurrentMonth;

@property (nonatomic, strong, readonly) NSDate *dayAsDate;

@end
