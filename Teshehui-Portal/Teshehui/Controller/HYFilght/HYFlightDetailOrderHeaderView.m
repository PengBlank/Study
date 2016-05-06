//
//  HYFlightDetailOrderHeaderView.m
//  Teshehui
//
//  Created by Kris on 15/9/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightDetailOrderHeaderView.h"
#import "PTDateFormatrer.h"

@interface HYFlightDetailOrderHeaderView ()
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
    
    UILabel *_returnAmountHeaderLab;
    
    UIImageView *_stopFilghtView;
    
    NSString *_startCityName;
    NSString *_startCityPortName;
    NSString *_endCityName;
    NSString *_endCityPortName;
    
    
    UILabel *_oStatusLab;
    UILabel *_oNOLab;
    UILabel *_oCreateTimeLab;
    UILabel *_oPriceLab;
    UILabel *_oPriceDesLab;
    UILabel *_oPointLab;
    // 新增返现金额字段
    UILabel *_returnAmountLab;
    UILabel *_returnStatusNameLab;
    UILabel *_returnStatusNameHeaderLab;
    
    //航班信息
    UILabel *_fCityInfoLab;
    UILabel *_flightNOLab;
    UILabel *_fStartDateLab;
    UILabel *_fOrgAirport;
    UILabel *_fArrAirport;
    UILabel *_priceLab;
}

@end

@implementation  HYFlightDetailOrderHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc] initWithFrame:TFRectMakeFixWidth(0, 10, 320, 35)];
        bgView.backgroundColor = [UIColor colorWithRed:33.0/255.0
                                                 green:181.0/255.0
                                                  blue:255.0/255.0
                                                 alpha:1.0];
        [self addSubview:bgView];
        
        //订单编号banner
        UILabel *_nLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(75, 10, 80, 16)];
        _nLab.textColor = [UIColor whiteColor];
        [_nLab setFont:[UIFont systemFontOfSize:TFScalePoint(13)]];
        _nLab.backgroundColor = [UIColor clearColor];
        _nLab.textAlignment = NSTextAlignmentLeft;
        _nLab.text = @"订单编号:";
        [bgView addSubview:_nLab];
        
        _oNOLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(135, 10, 140, 16)];
        _oNOLab.textColor = [UIColor whiteColor];
        [_oNOLab setFont:[UIFont systemFontOfSize:TFScalePoint(13)]];
        _oNOLab.backgroundColor = [UIColor clearColor];
        _oNOLab.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:_oNOLab];
//        UIImageView *plane = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"flight_plane"]];
//        plane.frame = TFRectMake(30, 10, 15, 15);
//        [bgView addSubview:plane];
        
//        _orgDateLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(50, 7.5, 80, 20)];
//        _orgDateLab.font = [UIFont systemFontOfSize:14];
//        _orgDateLab.backgroundColor = [UIColor clearColor];
//        _orgDateLab.textColor = [UIColor whiteColor];
//        _orgDateLab.textAlignment = NSTextAlignmentCenter;
//        [bgView addSubview:_orgDateLab];
//        
//        _filghtNameLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(95, 7.5, 180, 20)];
//        _filghtNameLab.font = [UIFont systemFontOfSize:14];
//        _filghtNameLab.backgroundColor = [UIColor clearColor];
//        _filghtNameLab.textColor = [UIColor whiteColor];
//        _filghtNameLab.textAlignment = NSTextAlignmentRight;
//        [bgView addSubview:_filghtNameLab];
        
        //插入订单的信息cell
        // Initialization code
        UILabel *_sLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 60, 80, 16)];
        _sLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_sLab setFont:[UIFont systemFontOfSize:13]];
        _sLab.backgroundColor = [UIColor clearColor];
        _sLab.textAlignment = NSTextAlignmentLeft;
        _sLab.text = @"订单状态:";
        [self addSubview:_sLab];
        
        _oStatusLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 60, 140, 16)];
        _oStatusLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_oStatusLab setFont:[UIFont systemFontOfSize:13]];
        _oStatusLab.backgroundColor = [UIColor clearColor];
        _oStatusLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_oStatusLab];
   
        UILabel *_tLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 87, 80, 16)];
        _tLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_tLab setFont:[UIFont systemFontOfSize:13]];
        _tLab.backgroundColor = [UIColor clearColor];
        _tLab.textAlignment = NSTextAlignmentLeft;
        _tLab.text = @"下单时间:";
        [self addSubview:_tLab];
        
        _oCreateTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 87, 160, 16)];
        _oCreateTimeLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_oCreateTimeLab setFont:[UIFont systemFontOfSize:13]];
        _oCreateTimeLab.backgroundColor = [UIColor clearColor];
        _oCreateTimeLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_oCreateTimeLab];
        
        UILabel *_pLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 113, 80, 16)];
        _pLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_pLab setFont:[UIFont systemFontOfSize:13]];
        _pLab.backgroundColor = [UIColor clearColor];
        _pLab.textAlignment = NSTextAlignmentLeft;
        _pLab.text = @"订单金额:";
        [self addSubview:_pLab];
        
        _oPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 113, 140, 16)];
        _oPriceLab.textColor = [UIColor colorWithRed:255.0f/255.0
                                               green:154.0f/255.0f
                                                blue:19.0f/255.0f
                                               alpha:1.0];
        [_oPriceLab setFont:[UIFont systemFontOfSize:13]];
        _oPriceLab.backgroundColor = [UIColor clearColor];
        _oPriceLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_oPriceLab];
        
        _oPriceDesLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 125, 200, 32)];
        _oPriceDesLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_oPriceDesLab setFont:[UIFont systemFontOfSize:12]];
        _oPriceDesLab.backgroundColor = [UIColor clearColor];
        _oPriceDesLab.textAlignment = NSTextAlignmentLeft;
        _oPriceDesLab.lineBreakMode = NSLineBreakByCharWrapping;
        _oPriceDesLab.numberOfLines = 2;
        [self addSubview:_oPriceDesLab];
        
        _returnAmountHeaderLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 159, 40, 16)];
        _returnAmountHeaderLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_returnAmountHeaderLab setFont:[UIFont systemFontOfSize:13]];
        _returnAmountHeaderLab.backgroundColor = [UIColor clearColor];
        _returnAmountHeaderLab.textAlignment = NSTextAlignmentLeft;
        _returnAmountHeaderLab.text = @"返现:";
        [self addSubview:_returnAmountHeaderLab];
        
        _returnAmountLab = [[UILabel alloc] initWithFrame:CGRectMake(58, 159, 80, 16)];
        _returnAmountLab.textColor = [UIColor colorWithRed:255.0f/255.0
                                               green:154.0f/255.0f
                                                blue:19.0f/255.0f
                                               alpha:1.0];
        [_returnAmountLab setFont:[UIFont systemFontOfSize:13]];
        _returnAmountLab.backgroundColor = [UIColor clearColor];
        _returnAmountLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_returnAmountLab];
        
        _returnStatusNameHeaderLab = [[UILabel alloc] initWithFrame:CGRectMake(150, 159, 60, 16)];
        _returnStatusNameHeaderLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_returnStatusNameHeaderLab setFont:[UIFont systemFontOfSize:12]];
        _returnStatusNameHeaderLab.backgroundColor = [UIColor clearColor];
        _returnStatusNameHeaderLab.textAlignment = NSTextAlignmentLeft;
        _returnStatusNameHeaderLab.text = @"返现状态:";
        [self addSubview:_returnStatusNameHeaderLab];
        
        _returnStatusNameLab = [[UILabel alloc] initWithFrame:CGRectMake(210, 159, 80, 16)];
        _returnStatusNameLab.textColor = [UIColor colorWithRed:56/255.0
                                                     green:184/255.0f
                                                      blue:254/255.0f
                                                     alpha:1.0];
        [_returnStatusNameLab setFont:[UIFont systemFontOfSize:13]];
        _returnStatusNameLab.backgroundColor = [UIColor clearColor];
        _returnStatusNameLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_returnStatusNameLab];
        
        UILabel *_pointLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 185, 80, 16)];
        _pointLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_pointLab setFont:[UIFont systemFontOfSize:13]];
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.textAlignment = NSTextAlignmentLeft;
        _pointLab.text = @"赠送现金券:";
        [self addSubview:_pointLab];
        
        _oPointLab = [[UILabel alloc] initWithFrame:CGRectMake(94, 185, 140, 16)];
        _oPointLab.textColor = [UIColor colorWithRed:255.0f/255.0
                                               green:154.0f/255.0f
                                                blue:19.0f/255.0f
                                               alpha:1.0];
        [_oPointLab setFont:[UIFont systemFontOfSize:16]];
        _oPointLab.backgroundColor = [UIColor clearColor];
        _oPointLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_oPointLab];
        
//        UIImageView *delayInsuranceGive = [[UIImageView alloc] initWithFrame:CGRectMake(0, TFScalePoint(150), TFScalePoint(80), TFScalePoint(90))];
//        delayInsuranceGive.image = [UIImage imageNamed:@"flight_Zeng"];
//        [self addSubview:delayInsuranceGive];
        //航班信息：城市
        _orgCityLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(0, 230, 110, 20)];
        _orgCityLab.font = [UIFont boldSystemFontOfSize:14];
        _orgCityLab.textColor = [UIColor blackColor];
        _orgCityLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_orgCityLab];
        
        _orgAirportLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(0, 255, 110, 20)];
        _orgAirportLab.font = [UIFont systemFontOfSize:11];
        _orgAirportLab.backgroundColor = [UIColor clearColor];
        _orgAirportLab.textColor = [UIColor colorWithWhite:0.1
                                                     alpha:1.0];
        _orgAirportLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_orgAirportLab];
        
        _dstCityLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(210, 230, 110, 20)];
        _dstCityLab.font = [UIFont boldSystemFontOfSize:14];
        _dstCityLab.textColor = [UIColor blackColor];
        _dstCityLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dstCityLab];
        
        _dstAirportLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(210, 255, 100, 20)];
        _dstAirportLab.backgroundColor = [UIColor clearColor];
        _dstAirportLab.font = [UIFont systemFontOfSize:11];
        _dstAirportLab.textColor = [UIColor colorWithWhite:0.1
                                                     alpha:1.0];
        _dstAirportLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dstAirportLab];
        
        UIView *imageViewLeftLine = [UIView new];
        imageViewLeftLine.frame = TFRectMakeFixWidth(118, 240, 25, 1);
        imageViewLeftLine.backgroundColor = [UIColor
                                             colorWithRed:210.0/255.0 green:216.0/255.0 blue:220.0/255.0 alpha:1.0f];
        [self addSubview:imageViewLeftLine];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(148, 233, 16, 16)];
        imageView.image = [UIImage imageNamed:@"flight_plane2"];
        [self addSubview:imageView];
        
        UIView *imageViewRightLine = [UIView new];
        imageViewRightLine.frame = TFRectMakeFixWidth(175, 240, 25, 1);
        imageViewRightLine.backgroundColor = [UIColor
                                              colorWithRed:210.0/255.0 green:216.0/255.0 blue:220.0/255.0 alpha:1.0f];
        [self addSubview:imageViewRightLine];
        
        _stopFilghtView = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(144, 232, 32, 19)];
        _stopFilghtView.image = [UIImage imageNamed:@"stop_flight"];
        [self addSubview:_stopFilghtView];
        
        _orgTimeLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(0, 275, 110, 30)];
        _orgTimeLab.backgroundColor = [UIColor clearColor];
        _orgTimeLab.font = [UIFont systemFontOfSize:18];
        _orgTimeLab.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        _orgTimeLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_orgTimeLab];
        
        _dstTimeLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(210, 275, 140, 30)];
        _dstTimeLab.backgroundColor = [UIColor clearColor];
        _dstTimeLab.font = [UIFont systemFontOfSize:18];
        _dstTimeLab.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        _dstTimeLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dstTimeLab];
        
    }
    return self;
}

//画的小点点
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat lengths[] = {2,1};
    //画上面的点点
    CGContextMoveToPoint(ctx, 20, 215);
    CGContextSetLineDash(ctx, 0, lengths, 2);
    CGContextAddLineToPoint(ctx, bounds.size.width - 20, 215);
    [[UIColor colorWithRed:220.0/255.0 green:227.0/255.0 blue:230.0/255.0 alpha:1.0f]set];
    
    //画下面的点点
    CGContextMoveToPoint(ctx, 20, 315);
    CGContextSetLineDash(ctx, 0, lengths, 2);
    CGContextAddLineToPoint(ctx, bounds.size.width - 20, 315);
    
    
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
        
        [_stopFilghtView setHidden:(flightSummary.stopTimes <= 0)];
    }
}

- (void)setOrder:(HYFlightOrder *)order
{
    if (order != _order)
    {
        _order = order;
        HYFlightOrderItem *item = [order.orderItems objectAtIndex:0];
        _oNOLab.text = order.orderCode;
        _oCreateTimeLab.text = order.creationTime;
        
        CGFloat price = order.orderPayAmount;
        CGFloat point = order.orderTbAmount;
        
        NSString *priceStr = [NSString stringWithFormat:@"(票价￥%0.2f+机建￥%0.2f+燃油税￥%0.2f)", item.price, item.airportTax ,item.fuelTax];
        if ([order hasJourney])
        {
//            point += order.journeyInfo.points;
//            price += order.journeyInfo.payTotal;
            
            priceStr = [NSString stringWithFormat:@"(票价￥%0.2f+机建￥%0.2f+燃油税￥%0.2f+行程单￥%0.2f)", item.price, item.airportTax ,item.fuelTax, order.journeyInfo.payTotal];
        }
        
        _oPriceLab.text = [NSString stringWithFormat:@"￥%0.2f", price];
        
        _oPriceDesLab.text = priceStr;
        
        int i = [order.returnAmount intValue];
        if (order.returnAmount && i != 0) {
            
            _returnAmountLab.hidden = NO;
            _returnAmountHeaderLab.hidden = NO;
            _returnStatusNameLab.hidden = NO;
            _returnStatusNameHeaderLab.hidden = NO;
            _returnAmountLab.text = [NSString stringWithFormat:@"￥%@", order.returnAmount];
        } else {
            
            _returnAmountLab.hidden = YES;
            _returnAmountHeaderLab.hidden = YES;
            _returnStatusNameLab.hidden = YES;
            _returnStatusNameHeaderLab.hidden = YES;
        }
        
        if (order.returnStatusName) {
            _returnStatusNameLab.text = order.returnStatusName;
        }
        _oPointLab.text = [NSString stringWithFormat:@"%0.0f", point];
        
        //航班信息
        _orgCityLab.text = item.orgCityName;
        _orgAirportLab.text = item.orgAirportName;
        _orgTimeLab.text = item.takeOffTime;
        
        _dstCityLab.text = item.dstCityName;
        _dstAirportLab.text = item.dstAirportName;
        _dstTimeLab.text = item.arrivalTime;

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
    
    BOOL hidden = (order.stopTime.floatValue <= 0);
    [_stopFilghtView setHidden:hidden];
    _oStatusLab.text = order.orderShowStatus;
}
@end

