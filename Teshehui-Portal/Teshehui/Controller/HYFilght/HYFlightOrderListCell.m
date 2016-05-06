//
//  HYFlightOrderListCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-3.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightOrderListCell.h"
#import "HYUserInfo.h"

@interface HYFlightOrderListCell ()
{
    UILabel *_orderNameLab;
    UILabel *_createLab;
    UILabel *_startLab;
    UILabel *_arrLab;
    UILabel *_sTimeLab;
    UILabel *_dTimeLab;
    UILabel *_statusLab;
    UILabel *_airlineLab;
    
    UIImageView *_statusImageView;
}

@end

@implementation HYFlightOrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        HYUserInfo *user = [HYUserInfo getUserInfo];
        
        CGFloat org_y = 0;
        
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TFScalePoint(230), 30, 60, 30)];
        _statusImageView.layer.masksToBounds = YES;
        _statusImageView.layer.cornerRadius = 8.0;
        
        _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 60, 20)];
        _statusLab.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        [_statusLab setFont:[UIFont boldSystemFontOfSize:11]];
        _statusLab.backgroundColor = [UIColor clearColor];
        _statusLab.textAlignment = NSTextAlignmentCenter;
        [_statusImageView addSubview:_statusLab];
        [self.contentView addSubview:_statusImageView];
        
        //起飞时间
        _createLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 60, 140, 16)];
        _createLab.textColor = [UIColor grayColor];
        [_createLab setFont:[UIFont systemFontOfSize:11]];
        _createLab.backgroundColor = [UIColor clearColor];
        _createLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_createLab];
        
        //起飞时间后的航班
        _airlineLab = [[UILabel alloc] initWithFrame:CGRectMake(146, 60, 120, 16)];
        _airlineLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [_airlineLab setFont:[UIFont systemFontOfSize:11]];
        _airlineLab.backgroundColor = [UIColor clearColor];
        _airlineLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_airlineLab];
        
        //如果为企业员工
        if (user.userType == Enterprise_User)
        {
            _orderNameLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 32, 140, 16)];
            _orderNameLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
            [_orderNameLab setFont:[UIFont systemFontOfSize:16]];
            _orderNameLab.backgroundColor = [UIColor clearColor];
            _orderNameLab.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_orderNameLab];
            
            org_y = 24;
        }
        
        //起飞地点
        _startLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, TFScalePoint(170), 18)];
        _startLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_startLab setFont:[UIFont systemFontOfSize:16]];
        _startLab.adjustsFontSizeToFitWidth = YES;
        _startLab.clipsToBounds = YES;
        _startLab.minimumScaleFactor = 8.0f;
        _startLab.backgroundColor = [UIColor clearColor];
        _startLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_startLab];
        
        //到达地点
        _arrLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, TFScalePoint(170), 18)];
        _arrLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_arrLab setFont:[UIFont systemFontOfSize:16]];
        _arrLab.backgroundColor = [UIColor clearColor];
        _arrLab.textAlignment = NSTextAlignmentLeft;
        _arrLab.clipsToBounds = YES;
        [self.contentView addSubview:_arrLab];
        
        //起飞时间
        _sTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, 200, 16)];
        _sTimeLab.textColor = [UIColor blackColor];
        [_sTimeLab setFont:[UIFont boldSystemFontOfSize:15]];
        _sTimeLab.backgroundColor = [UIColor clearColor];
        _sTimeLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_sTimeLab];
        
        //到达时间
        _dTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 35, 200, 16)];
        _dTimeLab.textColor = [UIColor blackColor];
        [_dTimeLab setFont:[UIFont boldSystemFontOfSize:15]];
        _dTimeLab.backgroundColor = [UIColor clearColor];
        _dTimeLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_dTimeLab];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark setter/getter
- (void)setFlightOrder:(HYFlightOrder *)flightOrder
{
    if (flightOrder != _flightOrder)
    {
        _flightOrder = flightOrder;
        HYFlightOrderItem *item = [flightOrder.orderItems objectAtIndex:0];
        _createLab.text = [NSString stringWithFormat:@"起飞日期:%@", item.flightDate];
        _airlineLab.text = [NSString stringWithFormat:@"%@ %@", item.airlineName, item.flightNo];
        _sTimeLab.text = item.takeOffTime;
        _dTimeLab.text = item.arrivalTime;
        
        NSMutableString *org_airport_name = [NSMutableString string];
        
        if ([item.orgCityName length] > 0)
        {
            [org_airport_name appendString:item.orgCityName];
        }
        
        if ([item.orgAirportName length] > 0)
        {
            [org_airport_name appendString:item.orgAirportName];
        }
        
        if ([item.orgAirportTerminal length] > 0)
        {
            [org_airport_name appendString:item.orgAirportTerminal];
        }
        
        _startLab.text = org_airport_name;
        
        NSMutableString *dst_airport_name = [NSMutableString string];
        if ([item.dstCityName length] > 0)
        {
            [dst_airport_name appendString:item.dstCityName];
        }
        
        if ([item.dstAirportName length] > 0)
        {
            [dst_airport_name appendString:item.dstAirportName];
        }
        
        if ([item.dstAirportTerminal length] > 0)
        {
            [dst_airport_name appendString:item.dstAirportTerminal];
        }
        _arrLab.text = dst_airport_name;
        
        HYUserInfo *user = [HYUserInfo getUserInfo];
        if (user.userType == Enterprise_User)
        {
            NSString *userName = flightOrder.buyerNick;
            if (flightOrder.orderType==0 && [userName length] <= 0)
            {
                userName = @"当前账号";
            }
            
            _orderNameLab.text = [NSString stringWithFormat:@"下单人：%@", userName];
        }
        
        //几种不同的状态图片
        NSString *orderShowStatus = _flightOrder.orderShowStatus;
        if ([orderShowStatus isEqualToString:@"已取消"])
        {
            _statusImageView.image = [[UIImage imageNamed:@"flight_hasbeenCancelled"] stretchableImageWithLeftCapWidth:5 topCapHeight:10];
        }else
        {
            _statusImageView.image = [[UIImage imageNamed:@"person_buttom_orange3_normal"]
                                      stretchableImageWithLeftCapWidth:10
                                      topCapHeight:10];
        }
    }
    
    _statusLab.text = flightOrder.orderShowStatus;
   
    
}
@end
