//
//  CQCalendarView.m
//  Teshehui
//
//  Created by ChengQian on 13-10-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQCalendarView.h"
#import "NSDate+CalendarView.h"
#import "CQCalendarMonthView.h"
#import "HYCalendarScrollView.h"

@interface CQCalendarView ()

@property (nonatomic, strong) NSMutableArray *monthViews;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end

@implementation CQCalendarView
{
    BOOL _isFristSelect;
    CGFloat _dayViewHeight;
    NSDateComponents *_visibleMonth;
    HYCalendarScrollView *_scrollView;
}

- (id)initWithFrame:(CGRect)frame defDate:(NSDate *)defDate
{
    return [self initWithFrame:frame start:defDate end:nil];
}

- (id)initWithFrame:(CGRect)frame start:(NSDate *)start end:(NSDate *)end
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isFristSelect = YES;
        self.startDate = start;
        self.endDate = end;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _dayViewHeight = 37;
    _monthViews = [[NSMutableArray alloc] init];
    
    CGRect rect = self.frame;
    _scrollView = [[HYCalendarScrollView alloc] initWithFrame:rect];
    
    _visibleMonth = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSCalendarCalendarUnit fromDate:[NSDate date]];
    _visibleMonth.day = 1;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM yyyy";
    
    CGFloat origin_y = 20;
    for (int i=0; i<6; i++)
    {
        NSDateComponents *offsetMonth = [_visibleMonth copy];
        offsetMonth.month = offsetMonth.month + i;
        offsetMonth = [offsetMonth.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSCalendarCalendarUnit fromDate:offsetMonth.date];
        NSDate *date = [offsetMonth.calendar dateFromComponents:offsetMonth];
        // Create and position the month view
        CQCalendarMonthView *monthView = [[CQCalendarMonthView alloc] initWithMonth:offsetMonth
                                                                              width:TFScalePoint(300)
                                                                       dayViewClass:[[self class] dayViewClass]
                                                                      dayViewHeight:37
                                                                              start:self.startDate
                                                                                end:self.endDate];
        formatter.dateFormat = @"MMMM yyyy";
        monthView.headerView.titleLabel.text = [formatter stringFromDate:date];
        CGRect frame = monthView.frame;
        monthView.frame = CGRectMake(10, origin_y, frame.size.width, frame.size.height);
        [_monthViews addObject:monthView];
        [_scrollView addSubview:monthView];
        
        origin_y += (frame.size.height+20);
    }
    
    [self addSubview:_scrollView];
    
    rect.size.height = origin_y;
    [_scrollView setContentSize:rect.size];
}

+ (Class)monthViewClass {
    return [CQCalendarMonthView class];
}

+ (Class)dayViewClass {
    return [CQCalendarDayView class];
}


- (CQCalendarDayView*)dayViewForTouches:(NSSet*)touches {
    if (touches.count != 1) {
        return nil;
    }
    
    UITouch *touch = [touches anyObject];
    
    // Check if the touch is within the month container
    if (!CGRectContainsPoint(self.frame, [touch locationInView:self])) {
        return nil;
    }
    
    // Work out which day view was touched. We can't just use hit test on a root view because the month views can overlap
    for (CQCalendarMonthView *monthView in self.monthViews) {
        UIView *view = [monthView hitTest:[touch locationInView:monthView] withEvent:nil];
        if (view == nil)
        {
            continue;
        }
        
        while (view != monthView) {
            if ([view isKindOfClass:[CQCalendarDayView class]]) {
                return (CQCalendarDayView*)view;
            }
            
            view = view.superview;
        }
    }
    
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CQCalendarDayView *touchedView = [self dayViewForTouches:touches];
    
    if (touchedView == nil || touchedView.selectionState == CQCalendarDayViewOutdateToday) {
        return;
    }
    
    //重置日期设置
    if (_isFristSelect)//&& self.startDate && ![self.startDate isEqualToDate:touchedView.dayAsDate])
    {
        BOOL reset = NO;
        for (CQCalendarMonthView *monthView in self.monthViews)
        {
            NSDateComponents *today = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarCalendarUnit fromDate:self.startDate];
            CQCalendarDayView *dayView = [monthView dayViewForDay:today];
            if (dayView)
            {
                reset = YES;
                dayView.descText = nil;
                dayView.selectionState = CQCalendarDayViewNotSelected;
            }
            
            if (self.endDate )//&& ![self.endDate isEqualToDate:touchedView.dayAsDate])
            {
                reset = NO;
                NSDateComponents *endToday = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarCalendarUnit fromDate:self.endDate];
                
                CQCalendarDayView *dayView = [monthView dayViewForDay:endToday];
                if (dayView)
                {
                    reset = YES;
                    dayView.descText = nil;
                    dayView.selectionState = CQCalendarDayViewNotSelected;
                }
            }
            
            if (reset)
            {
                break;
            }
        }
        
        self.startDate = touchedView.dayAsDate;
    }
    
    //更新状态
    /*
    if (self.endDate && [self.endDate compare:touchedView.dayAsDate]==NSOrderedAscending)
    {
        for (CQCalendarMonthView *monthView in self.monthViews)
        {
            NSDateComponents *today = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarCalendarUnit fromDate:self.endDate];
            
            CQCalendarDayView *dayView = [monthView dayViewForDay:today];
            if (dayView)
            {
                dayView.descText = nil;
                dayView.selectionState = CQCalendarDayViewNotSelected;
                break;
            }
        }
        
        self.endDate = touchedView.dayAsDate;
        touchedView.descText = @"返回";
    }
    else if (self.startDate && ![self.startDate isEqualToDate:touchedView.dayAsDate])
    {
        for (CQCalendarMonthView *monthView in self.monthViews)
        {
            NSDateComponents *today = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarCalendarUnit fromDate:self.startDate];
            
            CQCalendarDayView *dayView = [monthView dayViewForDay:today];
            if (dayView)
            {
                dayView.descText = nil;
                dayView.selectionState = CQCalendarDayViewNotSelected;
            }
        }
        self.startDate = touchedView.dayAsDate;
        touchedView.descText = @"出发";
    }
     */
    
    touchedView.selectionState = CQCalendarDayViewSelected;
    
    if (_isFristSelect)
    {
        _isFristSelect = NO;
        touchedView.descText = @"出发";
    }
    else
    {
        touchedView.descText = @"返回";
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CQCalendarDayView *touchedView = [self dayViewForTouches:touches];

        if (touchedView == nil || touchedView.selectionState == CQCalendarDayViewOutdateToday) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectDate:)])
    {
        [self.delegate didSelectDate:touchedView];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

@end
