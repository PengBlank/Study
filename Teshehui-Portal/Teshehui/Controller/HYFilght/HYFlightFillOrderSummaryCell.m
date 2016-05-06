//
//  HYFlightOrderSummaryCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightFillOrderSummaryCell.h"
#import "PTDateFormatrer.h"

@interface HYFlightFillOrderSummaryCell ()
{
    UILabel *_startTimeLab;
    UILabel *_arrTimeLab;
    UILabel *_orgTerminalLab;
    UILabel *_dstTerminalLab;
}

@end

@implementation HYFlightFillOrderSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _startTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 4, 80, 22)];
        _startTimeLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_startTimeLab setFont:[UIFont boldSystemFontOfSize:18]];
        _startTimeLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_startTimeLab];
        
        _arrTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 80, 22)];
        _arrTimeLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_arrTimeLab setFont:[UIFont boldSystemFontOfSize:18]];
        _arrTimeLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_arrTimeLab];
        
        _orgTerminalLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 6, 180, 18)];
        _orgTerminalLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_orgTerminalLab setFont:[UIFont systemFontOfSize:14]];
        _orgTerminalLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_orgTerminalLab];
        
        _dstTerminalLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 32, 180, 18)];
        _dstTerminalLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_dstTerminalLab setFont:[UIFont systemFontOfSize:14]];
        _dstTerminalLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_dstTerminalLab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark setter/getter
- (void)setFlight:(HYFlightDetailInfo *)flight
{
    if (_flight != flight)
    {
        _flight = flight;
        
        
        NSDate *startdate = [PTDateFormatrer dateFromString:flight.startDatetime format:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *enddate = [PTDateFormatrer dateFromString:flight.endDatetime format:@"yyyy-MM-dd HH:mm:ss"];
        NSString *stardatestr = [PTDateFormatrer stringFromDate:startdate format:@"HH:mm"];
        NSString *enddatestr = [PTDateFormatrer stringFromDate:enddate format:@"HH:mm"];
        _startTimeLab.text = stardatestr;
        _arrTimeLab.text = enddatestr;
        
        NSMutableString *org_airport_name = [NSMutableString string];
        
        if ([flight.startCityName length] > 0)
        {
            [org_airport_name appendString:flight.startCityName];
        }
        
        if ([flight.startAirportName length] > 0)
        {
            [org_airport_name appendString:flight.startAirportName];
        }
        
        if ([flight.startAirportTerminal length] > 0)
        {
            [org_airport_name appendString:flight.startAirportTerminal];
        }
        
        _orgTerminalLab.text = org_airport_name;
        
        NSMutableString *dst_airport_name = [NSMutableString string];
        if ([flight.endCityName length] > 0)
        {
            [dst_airport_name appendString:flight.endCityName];
        }
        
        if ([flight.endAirportName length] > 0)
        {
            [dst_airport_name appendString:flight.endAirportName];
        }
        
        if ([flight.endAirportTerminal length] > 0)
        {
            [dst_airport_name appendString:flight.endAirportTerminal];
        }
        
        _dstTerminalLab.text = dst_airport_name;
    }
}

@end
