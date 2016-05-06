//
//  HYEmployeeFloghtOrderCell.m
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYEmployeeFlightOrderCell.h"
#import "HYPassengers.h"

@interface HYEmployeeFlightOrderCell ()

@property (nonatomic, strong) UILabel *flightNameLabel;
@property (nonatomic, strong) UILabel *regionTimeLabel;
@property (nonatomic, strong) UILabel *passengerLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation HYEmployeeFlightOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat x = 20;
        CGFloat y = 12;
        CGFloat h = 15;
        CGFloat w = ScreenRect.size.width - 2 * x;
        CGRect rect = CGRectMake(x, y, w, h);
        
        self.flightNameLabel = [[UILabel alloc] initWithFrame:rect];
        self.flightNameLabel.backgroundColor = [UIColor clearColor];
        [self configureLabel:_flightNameLabel];
        [self.contentView addSubview:_flightNameLabel];
        
        rect.origin.y = CGRectGetMaxY(rect) + 6;
        rect.size.height = 30;
        self.regionTimeLabel = [[UILabel alloc] initWithFrame:rect];
        self.regionTimeLabel.backgroundColor = [UIColor clearColor];
        [self configureLabel:_regionTimeLabel];
        _regionTimeLabel.font = [UIFont systemFontOfSize:12.0];
        _regionTimeLabel.backgroundColor = [UIColor clearColor];
        _regionTimeLabel.numberOfLines = 0;
        [self.contentView addSubview:_regionTimeLabel];
        
        rect.origin.y = CGRectGetMaxY(rect) + 6;
        rect.size.height = 15;
        self.passengerLabel = [[UILabel alloc] initWithFrame:rect];
        self.passengerLabel.backgroundColor = [UIColor clearColor];
        [self configureLabel:_passengerLabel];
        _passengerLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_passengerLabel];
        
        rect.origin.y = CGRectGetMaxY(rect) + 8;
        rect.size.width = 200;
        self.priceLabel = [[UILabel alloc] initWithFrame:rect];
        _priceLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_priceLabel];
        
        //按钮右下角浮动
        w = 90;
        h = 20;
        x = ScreenRect.size.width - 8 - w;
        y = CGRectGetHeight(self.frame) - 5 - h;
        rect = CGRectMake(x, y, w, h);
        self.statusLabel = [[UILabel alloc] initWithFrame:rect];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _statusLabel.font = [UIFont systemFontOfSize:14.0];
        _statusLabel.backgroundColor = [UIColor redColor];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_statusLabel];
    }
    return self;
}

- (void)configureLabel:(UILabel *)label
{
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark setter/getter
- (void)setOrder:(HYFlightOrder *)order
{
    if (order != _order)
    {
        _order = order;
        HYFlightOrderItem *item = [order.orderItems objectAtIndex:0];
        //航班名
        self.flightNameLabel.text = item.airlineName;
        
        //时间地点
        NSString *flightDate = [NSString stringWithFormat:@"%@(%@-%@) - %@(%@)",
                                item.orgAirportName,
                                item.flightDate,
                                item.takeOffTime,
                                item.dstAirportName,
                                item.arrivalTime];
        self.regionTimeLabel.text = flightDate;
        
        //乘机人
        NSMutableString *passenger = [NSMutableString stringWithString:@"乘机人:"];
        if (_order.guests.count > 0)
        {
            for (HYFlightGuest  *pa in _order.guests)
            {
                [passenger appendFormat:@"%@、", pa.name];
            }
            [passenger deleteCharactersInRange:NSMakeRange(passenger.length-1, 1)];
        }
        self.passengerLabel.text = passenger;
        
        //价格
        
        //升舱处理中 而且 待付款
        BOOL riseCabinStatus = (order.status == 1024 && order.cabinInfo.status == 1);
        
        //改签处理中 而且 待付款
        BOOL alterdedStatus  = (order.status == 32 && order.alteredInfo.status == 1);
        
        //行程单
        BOOL invoiceStatus  = (order.journeyInfo.status == 2);
        
        CGFloat price = order.orderPayAmount;
//        CGFloat point = order.points;

        if (riseCabinStatus)
        {
            price += order.cabinInfo.payTotal;
//            point += order.cabinInfo.points;
        }
        else if (alterdedStatus)
        {
            price += order.alteredInfo.payTotal;
//            point += order.alteredInfo.points;
        }
        
        if (invoiceStatus)
        {
            price += order.journeyInfo.payTotal;
//            point += order.journeyInfo.points;
        }
        
        self.priceLabel.text = [NSString stringWithFormat:@"¥%0.2f",
                                price];
        
        _statusLabel.text = order.orderShowStatus;
        _statusLabel.hidden = order.orderShowStatus.length > 0 ? NO : YES;
    }
}

#pragma mark - Selection configure
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
        self.statusLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setSelected:highlighted animated:animated];
    if (highlighted)
    {
        self.statusLabel.backgroundColor = [UIColor redColor];
    }
}

@end
