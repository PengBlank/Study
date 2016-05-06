//
//  NSDate+CalendarView.h
//  Teshehui
//
//  Created by ChengQian on 13-10-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CalendarView)

- (NSDateComponents*)dslCalendarView_dayWithCalendar:(NSCalendar*)calendar;
- (NSDateComponents*)dslCalendarView_monthWithCalendar:(NSCalendar*)calendar;

@end
