//
//  HYFlightSummaryView.m
//  Teshehui
//
//  Created by ChengQian on 14-6-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightSummaryView.h"
#import "PTDateFormatrer.h"

@interface HYFlightSummaryView ()
{
    UILabel *_orgCityLab;
    UILabel *_dstCityLab;
    UILabel *_orgAirportLab;
    UILabel *_dstAirportLab;
    
    UILabel *_filghtNameLab;
    
    UILabel *_orgTimeLab;
    UILabel *_orgDateLab;
    
    UILabel *_dstTimeLab;
    UILabel *_dstDateLab;
    
    UIImageView *_stopFilghtView;
    
    NSString *_startCityName;
    NSString *_startCityPortName;
    NSString *_endCityName;
    NSString *_endCityPortName;
}

@end

@implementation HYFlightSummaryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIView *bgView = [[UIView alloc] initWithFrame:TFRectMakeFixWidth(0, 10, 320, 35)];
        bgView.backgroundColor = [UIColor colorWithRed:33.0/255.0
                                                 green:181.0/255.0
                                                  blue:255.0/255.0
                                                 alpha:1.0];
        [self addSubview:bgView];
        
        //banner
        UIImageView *plane = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"flight_plane"]];
        plane.frame = TFRectMakeFixWidth(15, 10, 15, 15);
        [bgView addSubview:plane];
        
        _orgDateLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(35, 7.5, 80, 20)];
        _orgDateLab.font = [UIFont systemFontOfSize:14];
        _orgDateLab.backgroundColor = [UIColor clearColor];
        _orgDateLab.textColor = [UIColor whiteColor];
        _orgDateLab.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:_orgDateLab];
        
        _filghtNameLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(115, 7.5, 180, 20)];
        _filghtNameLab.font = [UIFont systemFontOfSize:14];
        _filghtNameLab.backgroundColor = [UIColor clearColor];
        _filghtNameLab.textColor = [UIColor whiteColor];
        _filghtNameLab.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:_filghtNameLab];
        
        //城市
        _orgCityLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(0, 60, 110, 20)];
        _orgCityLab.font = [UIFont boldSystemFontOfSize:14];
        _orgCityLab.textColor = [UIColor blackColor];
        _orgCityLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_orgCityLab];
        
        _orgAirportLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(0, 83, 110, 20)];
        _orgAirportLab.font = [UIFont systemFontOfSize:12];
        _orgAirportLab.backgroundColor = [UIColor clearColor];
        _orgAirportLab.textColor = [UIColor colorWithWhite:0.1
                                                     alpha:1.0];
        _orgAirportLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_orgAirportLab];
        
        _dstCityLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(210, 60, 110, 20)];
        _dstCityLab.font = [UIFont boldSystemFontOfSize:14];
        _dstCityLab.textColor = [UIColor blackColor];
        _dstCityLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dstCityLab];
        
        _dstAirportLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(210, 83, 100, 20)];
        _dstAirportLab.backgroundColor = [UIColor clearColor];
        _dstAirportLab.font = [UIFont systemFontOfSize:12];
        _dstAirportLab.textColor = [UIColor colorWithWhite:0.1
                                                     alpha:1.0];
        _dstAirportLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dstAirportLab];
        
        UIView *imageViewLeftLine = [UIView new];
        imageViewLeftLine.frame = TFRectMakeFixWidth(118, 93, 25, 1);
        imageViewLeftLine.backgroundColor = [UIColor
                                             colorWithRed:210.0/255.0 green:216.0/255.0 blue:220.0/255.0 alpha:1.0f];
        [self addSubview:imageViewLeftLine];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(148, 85, 16, 16)];
        imageView.image = [UIImage imageNamed:@"flight_plane2"];
        [self addSubview:imageView];
        
        UIView *imageViewRightLine = [UIView new];
        imageViewRightLine.frame = TFRectMakeFixWidth(175, 93, 25, 1);
        imageViewRightLine.backgroundColor = [UIColor
                                             colorWithRed:210.0/255.0 green:216.0/255.0 blue:220.0/255.0 alpha:1.0f];
        [self addSubview:imageViewRightLine];
        
        _stopFilghtView = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(140, 106, 32, 16)];
        _stopFilghtView.image = [UIImage imageNamed:@"stop_flight"];
        [self addSubview:_stopFilghtView];
        
        _orgTimeLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(0, 105, 110, 30)];
        _orgTimeLab.backgroundColor = [UIColor clearColor];
        _orgTimeLab.font = [UIFont systemFontOfSize:22];
        _orgTimeLab.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        _orgTimeLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_orgTimeLab];
        
        _dstTimeLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(210, 105, 140, 30)];
        _dstTimeLab.backgroundColor = [UIColor clearColor];
        _dstTimeLab.font = [UIFont systemFontOfSize:22];
        _dstTimeLab.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        _dstTimeLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dstTimeLab];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:TFRectMakeFixWidth(0, 110, 320, 2)];
//        lineView.backgroundColor = [UIColor colorWithRed:29.0/255.0
//                                                   green:127.0/255.0
//                                                    blue:191.0/255.0
//                                                   alpha:1.0];
//        [self addSubview: lineView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat lengths[] = {2,1};
    CGContextMoveToPoint(ctx, 20, 140);
    CGContextSetLineDash(ctx, 0, lengths, 2);
    CGContextAddLineToPoint(ctx, 300, 140);
    [[UIColor colorWithRed:220.0/255.0 green:227.0/255.0 blue:230.0/255.0 alpha:1.0f]set];
    
    CGContextStrokePath(ctx);
}


#pragma mark setter/getter
- (void)setFlightSummary:(HYFlightListSummary *)flightSummary
{
    if (flightSummary != _flightSummary)
    {
        _flightSummary = flightSummary;
        
        NSMutableString *org_airport_name = [NSMutableString string];
        
        if ([flightSummary.startCityName length] > 0)
        {
            _startCityName = flightSummary.startCityName;
            _orgCityLab.text = _startCityName;
//            [org_airport_name appendString:flightSummary.startCityName];
        }
        
        if ([flightSummary.startPortName length] > 0)
        {
            [org_airport_name appendString:flightSummary.startPortName];
        }
        
        if ([flightSummary.startTerminal length] > 0)
        {
            [org_airport_name appendString:flightSummary.startTerminal];
//            _startCityPortName = flightSummary.startPortName;
            _orgAirportLab.text = org_airport_name;
        }
        
//        _orgAirportLab.text = org_airport_name;
        
        NSMutableString *dst_airport_name = [NSMutableString string];
        if ([flightSummary.endCityName length] > 0)
        {
            _endCityName = flightSummary.endCityName;
            _dstCityLab.text = _endCityName;
//            [dst_airport_name appendString:flightSummary.endCityName];
        }
        
        if ([flightSummary.endPortName length] > 0)
        {
            _endCityPortName = flightSummary.endCityName;
            _dstAirportLab.text = _endCityPortName;
            [dst_airport_name appendString:flightSummary.endPortName];
        }
        
        if ([flightSummary.endTerminal length] > 0)
        {
            [dst_airport_name appendString:flightSummary.endTerminal];
        }
        
        _dstAirportLab.text = dst_airport_name;
        
        NSDate *startdate = [PTDateFormatrer dateFromString:flightSummary.startDatetime format:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *enddate = [PTDateFormatrer dateFromString:flightSummary.endDatetime format:@"yyyy-MM-dd HH:mm:ss"];
        NSString *stardatestr = [PTDateFormatrer stringFromDate:startdate format:@"HH:mm"];
        NSString *enddatestr = [PTDateFormatrer stringFromDate:enddate format:@"HH:mm"];
        _orgTimeLab.text = stardatestr;
        _dstTimeLab.text = enddatestr;
        
        _orgDateLab.text = flightSummary.flightDate;
        
        NSMutableString *flightDesc = [NSMutableString string];
        if (flightSummary.airlineName)
        {
            [flightDesc appendString:flightSummary.airlineName];
        }
//        
//        if (flightSummary.airlineCode)
//        {
//            [flightDesc appendString:flightSummary.airlineCode];
//        }
//        
        if (flightSummary.flightNo)
        {
            [flightDesc appendString:flightSummary.flightNo];
        }
        
        if (flightSummary.planeType)
        {
            NSString *str = [NSString stringWithFormat:@" 机型%@", self.flightSummary.planeType];
            
            [flightDesc appendString:str];
        }
        _filghtNameLab.text = flightDesc;
        
        [_stopFilghtView setHidden:flightSummary.stopTimes <= 0];
    }
}

@end
