//
//  NSDate+CalendarView.m
//  Teshehui
//
//  Created by ChengQian on 13-10-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "NSDate+CalendarView.h"

@implementation NSDate (CalendarView)

- (NSDateComponents*)dslCalendarView_dayWithCalendar:(NSCalendar*)calendar {
    return [calendar components:NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:self];
}

- (NSDateComponents*)dslCalendarView_monthWithCalendar:(NSCalendar*)calendar {
    return [calendar components:NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
}

@end
