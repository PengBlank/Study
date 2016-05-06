//
//  CQCalendarMonthView.m
//  Teshehui
//
//  Created by ChengQian on 13-10-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQCalendarMonthView.h"
#import "NSDate+CalendarView.h"

@interface CQCalendarMonthView ()

@property (nonatomic, strong) NSMutableDictionary *dayViewsDictionary;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end

@implementation CQCalendarMonthView
{
    CGFloat _dayViewHeight;
    __strong Class _dayViewClass;
    CGFloat _column;
}

#pragma mark - Memory management

- (void)dealloc {
}


#pragma mark - Initialisation

// Designated initialiser
- (id)initWithMonth:(NSDateComponents*)month
              width:(CGFloat)width
       dayViewClass:(Class)dayViewClass
      dayViewHeight:(CGFloat)dayViewHeight
              start:(NSDate *)start
                end:(NSDate *)end;
{
    self = [super initWithFrame:CGRectMake(0, 0, width, dayViewHeight)];
    if (self != nil) {
        // Initialise properties
        self.backgroundColor = [UIColor whiteColor];
        _month = [month copy];
        _dayViewHeight = dayViewHeight;
        _dayViewsDictionary = [[NSMutableDictionary alloc] init];
        _dayViewClass = dayViewClass;
        self.startDate = start;
        self.endDate = end;
                
        //monthHeader
        _headerView = [[CQCalendarMonthHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, 64)];
        _headerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_headerView];
        
        [self createDayViews];
    }
    
    return self;
}

- (void)createDayViews {
    NSInteger const numberOfDaysPerWeek = 7;
    
    NSDateComponents *day = [[NSDateComponents alloc] init];
    day.calendar = self.month.calendar;
    day.day = 1;
    day.month = self.month.month;
    day.year = self.month.year;
    
    NSDate *firstDate = [day.calendar dateFromComponents:day];
    day = [firstDate dslCalendarView_dayWithCalendar:self.month.calendar];
    
    NSInteger numberOfDaysInMonth = [day.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[day date]].length;
    
    NSInteger startColumn = day.weekday - day.calendar.firstWeekday;
    if (startColumn < 0) {
        startColumn += numberOfDaysPerWeek;
    }
    
    NSArray *columnWidths = [self calculateColumnWidthsForColumnCount:numberOfDaysPerWeek];
    
    _column = [columnWidths count];
    
    CGPoint nextDayViewOrigin = CGPointZero;
    nextDayViewOrigin.y = _headerView.frame.size.height;
    for (NSInteger column = 0; column < startColumn; column++) {
        nextDayViewOrigin.x += [[columnWidths objectAtIndex:column] floatValue];
    }
    
    //取出 今天，明天，后天
    NSDate *t = [NSDate date];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSCalendarCalendarUnit fromDate:t];
    
    NSInteger thisMonthday = [today.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:t].length;
    NSDateComponents *tmday = [today copy];
    tmday.day += 1;
    if (tmday.day > thisMonthday) {
        tmday.month += 1;
        tmday.day = 1;
    }
    
    NSDateComponents *atmday = [today copy];
    atmday.day += 2;
    if (atmday.day > thisMonthday) {
        atmday.month += 1;
        atmday.day -= thisMonthday;
    }

    NSDateComponents *startToday = nil;
    if (self.startDate)
    {
        startToday = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarCalendarUnit fromDate:self.startDate];
    }
    
    NSDateComponents *endToday = nil;
    if (self.endDate)
    {
        endToday = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarCalendarUnit fromDate:self.endDate];
    }

    do {
        for (NSInteger column = startColumn; column < numberOfDaysPerWeek; column++) {
            if (day.day <= numberOfDaysInMonth && day.month == self.month.month)
            {
                CGRect dayFrame = CGRectZero;
                dayFrame.origin = nextDayViewOrigin;
                dayFrame.size.width = [[columnWidths objectAtIndex:column] floatValue];
                dayFrame.size.height = _dayViewHeight;
                
                CQCalendarDayView *dayView = [[_dayViewClass alloc] initWithFrame:dayFrame];
                dayView.day = day;
                
                //以过的日期
                if (today.month==day.month &&
                    today.year==day.year && day.day < today.day)
                {
                    dayView.selectionState = CQCalendarDayViewOutdateToday;
                }
                
                if (startToday &&
                    startToday.day==day.day &&
                    startToday.month==day.month &&
                    startToday.year==day.year)
                {
                    dayView.labelText = [NSString stringWithFormat:@"%d", (int)day.day];
                    dayView.descText = [NSString stringWithFormat:@"出发"];
                    dayView.selectionState = CQCalendarDayViewSelected;
                }
                else if (endToday &&
                         endToday.day==day.day &&
                         endToday.month==day.month &&
                         endToday.year==day.year)
                {
                    dayView.labelText = [NSString stringWithFormat:@"%d", (int)day.day];
                    dayView.descText = [NSString stringWithFormat:@"返回"];
                    dayView.selectionState = CQCalendarDayViewSelected;
                }
                else if (today.day==day.day &&
                    today.month==day.month &&
                    today.year==day.year)
                {
                    dayView.labelText = @"今天";
                    dayView.selectionState = CQCalendarDayViewNearToday;
                }
                else if (tmday.day==day.day &&
                         tmday.month==day.month &&
                         tmday.year==day.year)
                {
                    dayView.labelText = @"明天";
                    dayView.selectionState = CQCalendarDayViewNearToday;
                }
                else if (atmday.day==day.day &&
                         atmday.month==day.month &&
                         atmday.year==day.year)
                {
                    dayView.labelText = @"后天";
                    dayView.selectionState = CQCalendarDayViewNearToday;
                }
                else
                {
                    dayView.labelText = [NSString stringWithFormat:@"%d", (int)day.day];
                }
                
                switch (column) {
                    case 0:
                        dayView.positionInWeek = CQCalendarDayViewStartOfWeek;
                        break;
                    case numberOfDaysPerWeek - 1:
                        dayView.positionInWeek = CQCalendarDayViewEndOfWeek;
                        break;
                    default:
                        dayView.positionInWeek = CQCalendarDayViewMidWeek;
                        break;
                }
                
                [self.dayViewsDictionary setObject:dayView forKey:[self dayViewKeyForDay:day]];
                [self addSubview:dayView];
            }
            
            day.day += 1;
            nextDayViewOrigin.x += [[columnWidths objectAtIndex:column] floatValue];
        }
        
        nextDayViewOrigin.x = 0;
        nextDayViewOrigin.y += _dayViewHeight;
        startColumn = 0;
    } while (day.day <= numberOfDaysInMonth);
    
    CGRect fullFrame = CGRectZero;
    fullFrame.size.height = nextDayViewOrigin.y;
    for (NSNumber *width in columnWidths) {
        fullFrame.size.width += width.floatValue;
    }
    self.frame = fullFrame;
}

- (NSArray*)calculateColumnWidthsForColumnCount:(NSInteger)columnCount {
    static NSCache *widthsCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        widthsCache = [[NSCache alloc] init];
    });
    
    NSMutableArray *columnWidths = [widthsCache objectForKey:@(columnCount)];
    if (columnWidths == nil) {
        CGFloat width = floorf(self.bounds.size.width / (CGFloat)columnCount);
        
        columnWidths = [[NSMutableArray alloc] initWithCapacity:columnCount];
        for (NSInteger column = 0; column < columnCount; column++) {
            [columnWidths addObject:@(width)];
        }
        
        CGFloat remainder = self.bounds.size.width - (width * columnCount);
        CGFloat padding = 1;
        if (remainder > columnCount) {
            padding = ceilf(remainder / (CGFloat)columnCount);
        }
        
        for (NSInteger column = 0; column < columnCount; column++) {
            [columnWidths replaceObjectAtIndex:column withObject:@(width + padding)];
            
            remainder -= padding;
            if (remainder < 1) {
                break;
            }
        }
        
        [widthsCache setObject:columnWidths forKey:@(columnCount)];
    }
    
    return columnWidths;
}

#pragma mark - Properties

- (NSSet*)dayViews {
    return [NSSet setWithArray:self.dayViewsDictionary.allValues];
}

- (NSString*)dayViewKeyForDay:(NSDateComponents*)day {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
    });
    
    return [formatter stringFromDate:[day date]];
}


- (CQCalendarDayView*)dayViewForDay:(NSDateComponents*)day {
    return [self.dayViewsDictionary objectForKey:[self dayViewKeyForDay:day]];
}
@end
