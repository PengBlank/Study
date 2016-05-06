//
//  HYFlightOrderAirlineCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightOrderAirlineCell.h"

@interface HYFlightOrderAirlineCell ()
{
    UILabel *_fCityInfoLab;
    UILabel *_flightNOLab;
    UILabel *_fStartDateLab;
    UILabel *_fOrgAirport;
    UILabel *_fArrAirport;
    UILabel *_priceLab;
}

@end

@implementation HYFlightOrderAirlineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _fCityInfoLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, 180, 16)];
        _fCityInfoLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_fCityInfoLab setFont:[UIFont systemFontOfSize:16]];
        _fCityInfoLab.backgroundColor = [UIColor clearColor];
        _fCityInfoLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_fCityInfoLab];
        
        _flightNOLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenRect.size.width-120, 12, 110, 14)];
        _flightNOLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_flightNOLab setFont:[UIFont systemFontOfSize:13]];
        _flightNOLab.backgroundColor = [UIColor clearColor];
        _flightNOLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_flightNOLab];
        
        UILabel *_sLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 34, 80, 16)];
        _sLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_sLab setFont:[UIFont systemFontOfSize:14]];
        _sLab.backgroundColor = [UIColor clearColor];
        _sLab.textAlignment = NSTextAlignmentLeft;
        _sLab.text = @"起飞日期:";
        [self.contentView addSubview:_sLab];
        
        _fStartDateLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 34, TFScalePoint(220), 16)];
        _fStartDateLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_fStartDateLab setFont:[UIFont systemFontOfSize:14]];
        _fStartDateLab.backgroundColor = [UIColor clearColor];
        _fStartDateLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_fStartDateLab];
        
        UILabel *_eLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 58, 80, 16)];
        _eLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_eLab setFont:[UIFont systemFontOfSize:14]];
        _eLab.backgroundColor = [UIColor clearColor];
        _eLab.textAlignment = NSTextAlignmentLeft;
        _eLab.text = @"起降机场:";
        [self.contentView addSubview:_eLab];
        
        _fOrgAirport = [[UILabel alloc] initWithFrame:CGRectMake(80, 58, TFScalePoint(220), 16)];
        _fOrgAirport.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_fOrgAirport setFont:[UIFont systemFontOfSize:14]];
        _fOrgAirport.backgroundColor = [UIColor clearColor];
        _fOrgAirport.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_fOrgAirport];
        
        _fArrAirport = [[UILabel alloc] initWithFrame:CGRectMake(80, 78, TFScalePoint(220), 16)];
        _fArrAirport.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_fArrAirport setFont:[UIFont systemFontOfSize:14]];
        _fArrAirport.backgroundColor = [UIColor clearColor];
        _fArrAirport.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_fArrAirport];
        
        UILabel *_pLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 98, 80, 16)];
        _pLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_pLab setFont:[UIFont systemFontOfSize:14]];
        _pLab.backgroundColor = [UIColor clearColor];
        _pLab.textAlignment = NSTextAlignmentLeft;
        _pLab.text = @"票面价:";
        [self.contentView addSubview:_pLab];
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 98, TFScalePoint(100), 16)];
        _priceLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_priceLab setFont:[UIFont systemFontOfSize:14]];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_priceLab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark setter/getter
- (void)setOrder:(HYFlightOrder *)order
{
    if (order != _order)
    {
        _order = order;
        HYFlightOrderItem *item = [order.orderItems objectAtIndex:0];
        _fCityInfoLab.text = [NSString stringWithFormat:@"%@-%@", item.orgCityName, item.dstCityName];
        _flightNOLab.text = [NSString stringWithFormat:@"航班号:%@", item.flightNo];
        _fStartDateLab.text = [NSString stringWithFormat:@"%@ %@", item.flightDate, item.takeOffTime];
        
        NSMutableString *org_airport_name = [NSMutableString string];
        if ([item.orgAirportName length] > 0)
        {
            [org_airport_name appendString:item.orgAirportName];
        }
        
        if ([item.orgAirportTerminal length] > 0)
        {
            [org_airport_name appendString:item.orgAirportTerminal];
        }
        
        NSMutableString *dst_airport_name = [NSMutableString string];
        if ([item.dstAirportName length] > 0)
        {
            [dst_airport_name appendString:item.dstAirportName];
        }
        
        if ([item.dstAirportTerminal length] > 0)
        {
            [dst_airport_name appendString:item.dstAirportTerminal];
        }
        
        _fOrgAirport.text = [NSString stringWithFormat:@"%@(%@)", org_airport_name, item.takeOffTime];
        _fArrAirport.text = [NSString stringWithFormat:@"%@(%@)", dst_airport_name, item.arrivalTime];
        _priceLab.text = [NSString stringWithFormat:@"%@", @(item.parPrice)];
    }
}

@end
