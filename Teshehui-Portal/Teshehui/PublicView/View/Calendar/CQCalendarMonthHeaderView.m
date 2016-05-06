//
//  CQCalendarView.h
//  Teshehui
//
//  Created by ChengQian on 13-10-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQCalendarMonthHeaderView.h"


@interface CQCalendarMonthHeaderView ()

@end


@implementation CQCalendarMonthHeaderView


#pragma mark - Memory management

- (void)dealloc {
}


#pragma mark - Initialisation

// Designated initialiser
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        // Initialise properties
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 20)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_titleLabel];
        
        NSArray *day = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
        
        CGFloat w = frame.size.width/7;
        CGFloat h = 35;
        for (int i=0; i<7; i++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0+i*w, 29, w, h)];
            label.text = [day objectAtIndex:i];
//            label.backgroundColor = [UIColor colorWithRed:220.0f/255.0f
//                                                    green:220.0/255.0f
//                                                     blue:220.0/255.0f
//                                                    alpha:1.0f];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor grayColor];
            label.font = [UIFont boldSystemFontOfSize:14];
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
        }
    }
    
    return self;
}

#pragma mark - UIView methods

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if ([self isMemberOfClass:[CQCalendarMonthHeaderView class]]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        CGContextSetLineWidth(context, 0.5);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:205.0/255.0 alpha:1.0].CGColor);
        CGContextMoveToPoint(context, 0.0, self.bounds.size.height - 0.5*0.5);
        CGContextAddLineToPoint(context, self.bounds.size.width - 0.5*0.5, self.bounds.size.height - 0.5*0.5);
        CGContextStrokePath(context);
        
        CGContextRestoreGState(context);
    }
}

@end
