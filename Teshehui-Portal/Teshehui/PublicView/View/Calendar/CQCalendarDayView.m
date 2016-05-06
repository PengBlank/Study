//
//  CQCalendarDayView.m
//  Teshehui
//
//  Created by ChengQian on 13-10-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQCalendarDayView.h"
#import "NSDate+CalendarView.h"

@implementation CQCalendarDayView
{
    __strong NSCalendar *_calendar;
    __strong NSDate *_dayAsDate;
    __strong NSDateComponents *_day;
}


#pragma mark - Initialisation

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor whiteColor];
        _positionInWeek = CQCalendarDayViewMidWeek;
    }
    
    return self;
}

#pragma mark Properties

- (void)setSelectionState:(CQCalendarDayViewSelectionState)selectionState {
    
    if (_selectionState != selectionState)
    {
        _selectionState = selectionState;
        [self setNeedsDisplay];
    }
}

- (void)setDay:(NSDateComponents *)day {
    _calendar = [day calendar];
    _dayAsDate = [day date];
    _day = nil;
}

- (NSDateComponents*)day {
    if (_day == nil) {
        _day = [_dayAsDate dslCalendarView_dayWithCalendar:_calendar];
    }
    
    return _day;
}

- (NSDate*)dayAsDate {
    return _dayAsDate;
}

- (void)setInCurrentMonth:(BOOL)inCurrentMonth {
    _inCurrentMonth = inCurrentMonth;
    [self setNeedsDisplay];
}


#pragma mark UIView methods

- (void)drawRect:(CGRect)rect {
    if ([self isMemberOfClass:[CQCalendarDayView class]]) {
        // If this isn't a subclass of DSLCalendarDayView, use the default drawing
        [self drawBackground];
//        [self drawBorders];
        [self drawDayNumber];
    }
}


#pragma mark Drawing

- (void)drawBackground {
    if (self.selectionState == CQCalendarDayViewNotSelected)
    {
//        if (self.isInCurrentMonth) {
//            [[UIColor colorWithWhite:225.0/255.0 alpha:1.0] setFill];
//        }
//        else {
//            [[UIColor colorWithWhite:225.0/255.0 alpha:1.0] setFill];
//        }
//        UIRectFill(self.bounds);
    }
    else
    {
        switch (self.selectionState)
        {
            case CQCalendarDayViewNotSelected:
                break;
            case CQCalendarDayViewSelected:
            {
                [[UIImage imageNamed:@"tag_blue_bg"] drawInRect:self.bounds];
            }
                break;
            default:
                break;
        }
    }
}

- (void)drawBorders {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:255.0/255.0 alpha:1.0].CGColor);
    CGContextMoveToPoint(context, 0.5, self.bounds.size.height - 0.5);
    CGContextAddLineToPoint(context, 0.5, 0.5);
    CGContextAddLineToPoint(context, self.bounds.size.width - 0.5, 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    if (self.isInCurrentMonth) {
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:205.0/255.0 alpha:1.0].CGColor);
    }
    else {
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:185.0/255.0 alpha:1.0].CGColor);
    }
    CGContextMoveToPoint(context, self.bounds.size.width - 0.5, 0.0);
    CGContextAddLineToPoint(context, self.bounds.size.width - 0.5, self.bounds.size.height - 0.5);
    CGContextAddLineToPoint(context, 0.0, self.bounds.size.height - 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawDayNumber
{
    if (self.selectionState == CQCalendarDayViewSelected)
    {
        [[UIColor whiteColor] set];
        
        BOOL isIOS7 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0);
        UIFont *textFont = isIOS7 ? [UIFont fontWithName:@"HelveticaNeue-light" size:12.0] : [UIFont systemFontOfSize:12.0];
        CGSize textSize = [_labelText sizeWithFont:textFont];
        
        CGRect textRect = CGRectMake(ceilf(CGRectGetMidX(self.bounds) - (textSize.width / 2.0)), ceilf(CGRectGetMidY(self.bounds) - (textSize.height / 2.0))-8, textSize.width, textSize.height);
        [_labelText drawInRect:textRect withFont:textFont];
        
        if (_descText)
        {
            textSize = [_descText sizeWithFont:textFont];
            textRect = CGRectMake(ceilf(CGRectGetMidX(self.bounds) - (textSize.width / 2.0)), ceilf(CGRectGetMidY(self.bounds) - (textSize.height / 2.0))+8, textSize.width, textSize.height);
            [_descText drawInRect:textRect withFont:textFont];
        }
    }
    else
    {
        if (self.selectionState == CQCalendarDayViewOutdateToday)
        {
            [[UIColor colorWithWhite:180.0f/255.0f alpha:1.0f] set];
        }
        else if (self.selectionState == CQCalendarDayViewNearToday)
        {
            [[UIColor colorWithRed:238.0f/255.0f
                             green:144.0f/255.0f
                              blue:18.0f/255.0f
                             alpha:1.0f] set];
        }
        else
        {
            [[UIColor blackColor] set];
        }
        
        BOOL isIOS7 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0);
        UIFont *textFont = isIOS7 ? [UIFont fontWithName:@"HelveticaNeue-light" size:15.0] : [UIFont systemFontOfSize:15.0];
        CGSize textSize = [_labelText sizeWithFont:textFont];
        
        CGRect textRect = CGRectMake(ceilf(CGRectGetMidX(self.bounds) - (textSize.width / 2.0)), ceilf(CGRectGetMidY(self.bounds) - (textSize.height / 2.0)), textSize.width, textSize.height);
        [_labelText drawInRect:textRect withFont:textFont];
    }
}


@end
