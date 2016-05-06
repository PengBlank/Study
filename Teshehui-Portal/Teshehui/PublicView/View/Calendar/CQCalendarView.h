//
//  CQCalendarView.h
//  Teshehui
//
//  Created by ChengQian on 13-10-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQCalendarDayView.h"

@protocol CQCalendarViewDelegate;

@interface CQCalendarView : UIView

@property (nonatomic, weak) id<CQCalendarViewDelegate>delegate;
@property (nonatomic, copy) NSDateComponents *visibleMonth;


+ (Class)monthViewClass;
+ (Class)dayViewClass;

- (id)initWithFrame:(CGRect)frame defDate:(NSDate *)defDate;
- (id)initWithFrame:(CGRect)frame start:(NSDate *)start end:(NSDate *)end;
@end

@protocol CQCalendarViewDelegate <NSObject>

@optional
- (void)didSelectDate:(CQCalendarDayView *)dayView;
- (void)calendarView:(CQCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents*)month duration:(NSTimeInterval)duration;
- (void)calendarView:(CQCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents*)month;
- (BOOL)calendarView:(CQCalendarView *)calendarView shouldAnimateDragToMonth:(NSDateComponents*)month;


@end