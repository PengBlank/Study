//
//  HYFlightListCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightListCell.h"
//#import "HYStrikeThroughLabel.h"
#import "PTDateFormatrer.h"

@interface HYFlightListCell ()
{
    UILabel *_depTimeLab;
    UILabel *_arrTimeLab;
    UILabel *_orgCityLab;
    UILabel *_dstCityLab;
    UILabel *_flightNOLab;
    UILabel *_discountLab;
    UILabel *_returnMoneyLab;
    UILabel *_pointLab;
    UILabel *_priceLab;
    UILabel *_priceType;
    UILabel *_planeLabe;
    UILabel *_airlineLab;
    UILabel *_cabinsLab;
    UILabel *_ticketCountLab;
    UIButton *_expandBtn;
    
    UIImageView *_stopFilghtView;
}

@property (nonatomic, strong) UIButton *updatePriceBtn;
@property (nonatomic, strong) UIActivityIndicatorView *animationView;

@end

@implementation HYFlightListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *arrIcon = [UIImage imageNamed:@"icon_arrow"];
        UIImageView *arrView1 = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(300, 32.5, 10, 10)];
        arrView1.image = arrIcon;
        [self.contentView addSubview:arrView1];
        
        _depTimeLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(10, 13, 55, 18)];
        _depTimeLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_depTimeLab setFont:[UIFont boldSystemFontOfSize:18]];
        _depTimeLab.backgroundColor = [UIColor clearColor];
        _depTimeLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_depTimeLab];
        
        _arrTimeLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(10, 32, 55, 18)];
        _arrTimeLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_arrTimeLab setFont:[UIFont systemFontOfSize:14]];
        _arrTimeLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_arrTimeLab];
        
        _orgCityLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(90, 13, 148, 18)];
        _orgCityLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_orgCityLab setFont:[UIFont systemFontOfSize:14]];
        _orgCityLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_orgCityLab];
        
        _stopFilghtView = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(218, 14, 32, 16)];
        _stopFilghtView.image = [UIImage imageNamed:@"stop_flight"];
        [self.contentView addSubview:_stopFilghtView];
        
        _dstCityLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(90, 32, 148, 18)];
        _dstCityLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_dstCityLab setFont:[UIFont systemFontOfSize:14]];
        _dstCityLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_dstCityLab];
        
        _priceType = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(250, 16, 12, 18)];
        _priceType.textColor = [UIColor colorWithRed:184.0/255.0
                                               green:0/255.0
                                                blue:3.0/255.0
                                               alpha:1.0];
        [_priceType setFont:[UIFont systemFontOfSize:14]];
        _priceType.backgroundColor = [UIColor clearColor];
        _priceType.text = @"￥";
        [self.contentView addSubview:_priceType];
        
        _priceLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(252, 16, 48, 18)];
        _priceLab.textColor = [UIColor colorWithRed:184.0/255.0
                                              green:0/255.0
                                               blue:3.0/255.0
                                              alpha:1.0];
        [_priceLab setFont:[UIFont boldSystemFontOfSize:18]];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_priceLab];
        
        _returnMoneyLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(232, 40, 70, 18)];
        _returnMoneyLab.textColor = [UIColor colorWithRed:251.0/255.0
                                                    green:113.0/255.0
                                                     blue:6.0/255.0
                                                    alpha:1.0];
        [_returnMoneyLab setFont:[UIFont systemFontOfSize:12]];
        _returnMoneyLab.backgroundColor = [UIColor clearColor];
        _returnMoneyLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_returnMoneyLab];
        
        // 现金券
        _pointLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(232, 55, 80, 18)];
        _pointLab.textColor = [UIColor colorWithRed:251.0/255.0
                                              green:113.0/255.0
                                               blue:6.0/255.0
                                              alpha:1.0];
        [_pointLab setFont:[UIFont systemFontOfSize:12]];
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_pointLab];
        
//        _discountLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(240, 32, 50, 18)];
//        _discountLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//        [_discountLab setFont:[UIFont systemFontOfSize:14]];
//        _discountLab.backgroundColor = [UIColor clearColor];
//        _discountLab.textAlignment = NSTextAlignmentRight;
//        [self.contentView addSubview:_discountLab];
        
        _airlineLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(10, 57, 30, 18)];
        _airlineLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_airlineLab setFont:[UIFont systemFontOfSize:12]];
        _airlineLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_airlineLab];
        
        _flightNOLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(37, 57, 50, 18)];
        _flightNOLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_flightNOLab setFont:[UIFont systemFontOfSize:12]];
        _flightNOLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_flightNOLab];
        
        _planeLabe = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(96, 57, 26, 18)];
        _planeLabe.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_planeLabe setFont:[UIFont systemFontOfSize:12]];
        _planeLabe.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_planeLabe];

        _cabinsLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(120, 52, 70, 18)];
        _cabinsLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_cabinsLab setFont:[UIFont systemFontOfSize:12]];
        _cabinsLab.backgroundColor = [UIColor clearColor];
        _cabinsLab.textAlignment = NSTextAlignmentCenter;
        [_cabinsLab setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:_cabinsLab];
        
        _ticketCountLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(180, 57, 38, 18)];
        _ticketCountLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_ticketCountLab setFont:[UIFont systemFontOfSize:12]];
        _ticketCountLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_ticketCountLab];
        
        //展开按钮
        /*
        _expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _expandBtn.frame = CGRectMake(137, 60, 60, 40);
        [_expandBtn setImage:[UIImage imageNamed:@"btn_commoneexhibitiondown"]
                    forState:UIControlStateNormal];
        [_expandBtn addTarget:self
                       action:@selector(expandableCell:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_expandBtn];
         */
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpdateWithAnimation:(BOOL)animation
{
    if (animation)
    {
        [_updatePriceBtn setHidden:YES];
        [self.animationView setHidden:NO];
        [self.animationView startAnimating];
    }
    else
    {
        [_updatePriceBtn setHidden:NO];
        [_animationView stopAnimating];
        [_animationView setHidden:YES];
    }
}

#pragma mark private methods
- (void)updatePriceEvent:(id)sender
{
    [self setUpdateWithAnimation:YES];
    
    if ([self.delegate respondsToSelector:@selector(didUpdateFlightPrice:)])
    {
//        self.flight.cheapCabins.isLoadingPrice = YES;
//        [self.delegate didUpdateFlightPrice:self.flight.cheapCabins];
    }
}

#pragma mark setter/getter
- (UIActivityIndicatorView *)animationView
{
    if (!_animationView)
    {
        _animationView = [[UIActivityIndicatorView alloc] initWithFrame:TFRectMakeFixWidth(260, 33, 24, 24)];
        _animationView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.contentView addSubview:_animationView];
    }
    
    return _animationView;
}

- (UIButton *)updatePriceBtn
{
    if (!_updatePriceBtn)
    {
        _updatePriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updatePriceBtn setFrame:TFRectMakeFixWidth(250, 25, 40, 40)];
        
        UIImage *bgImage = [[UIImage imageNamed:@"reserve_disable_bg"] stretchableImageWithLeftCapWidth:5
                                                                                           topCapHeight:0];
        
        [_updatePriceBtn setBackgroundImage:bgImage
                                   forState:UIControlStateNormal];
        [_updatePriceBtn setTitle:@"获取特价" forState:UIControlStateNormal];
        [_updatePriceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        [_updatePriceBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_updatePriceBtn.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [_updatePriceBtn.titleLabel setNumberOfLines:2];
        [_updatePriceBtn addTarget:self
                            action:@selector(updatePriceEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_updatePriceBtn];
    }
    
    return _updatePriceBtn;
}

- (void)setFlight:(HYFlightListSummary *)flight
{
    if (flight != _flight)
    {
        _flight = flight;
        
        /// 起飞时间结束时间
        NSDate *startdate = [PTDateFormatrer dateFromString:_flight.startDatetime format:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *enddate = [PTDateFormatrer dateFromString:_flight.endDatetime format:@"yyyy-MM-dd HH:mm:ss"];
        NSString *stardatestr = [PTDateFormatrer stringFromDate:startdate format:@"HH:mm"];
        NSString *enddatestr = [PTDateFormatrer stringFromDate:enddate format:@"HH:mm"];
        _depTimeLab.text = stardatestr;
        _arrTimeLab.text = enddatestr;
        
        /// 起飞机场
        //这里不拼接城市信息
        NSString *orgTer = _flight.startPortName;
        if ([_flight.startTerminal length] > 0)
        {
            orgTer = [NSString stringWithFormat:@"%@%@", _flight.startPortName, _flight.startTerminal];
        }
        _orgCityLab.text = orgTer;
        
        /// 经停信息
        [_stopFilghtView setHidden:YES];
        if (flight.stopTimes > 0)
        {
            CGFloat width = [orgTer sizeWithFont:_orgCityLab.font].width;
            
            _stopFilghtView.frame = CGRectMake(_orgCityLab.frame.origin.x+width+6, 14, 32, 16);
            [_stopFilghtView setHidden:NO];
        }
        
        /// 终点机场
        NSString *dstTer = _flight.endPortName;
        if ([_flight.endTerminal length] > 0)
        {
            dstTer = [NSString stringWithFormat:@"%@%@", _flight.endPortName, _flight.endTerminal];
        }
        _dstCityLab.text = dstTer;
        
        /// 折扣值
        if (_flight.discount.floatValue < 10)
        {
            NSNumber *n_disc = [NSNumber numberWithFloat:_flight.discount.floatValue];
            _discountLab.text = [NSString stringWithFormat:@"%@折", n_disc] ;
        }
        
        _planeLabe.text = _flight.planeType;
        _airlineLab.text = _flight.airlineName;
        _cabinsLab.text = _flight.cabinName;

        _ticketCountLab.text = [NSString stringWithFormat:@"%ld张", _flight.stock] ;
        _flightNOLab.text = _flight.flightNo;
        
//        [_expandBtn setHidden:([flight.Cabins count]<=0)];
    }
    _priceType.text = @"¥";

    _priceLab.text = [NSString stringWithFormat:@"%@", _flight.price];
    
    int i = _flight.returnAmount.intValue;
    if (_flight.returnAmount && i != 0) {
        
         _returnMoneyLab.hidden = NO;
         _returnMoneyLab.text = [NSString stringWithFormat:@"返现:¥%@", _flight.returnAmount];
    } else {
        
         _returnMoneyLab.hidden = YES;
        _pointLab.frame = _returnMoneyLab.frame;
    }
    
    _pointLab.text = [NSString stringWithFormat:@"送%ld现金券", _flight.points];
    [_updatePriceBtn setHidden:YES];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = _priceLab.frame;
    CGSize size = [_priceLab.text sizeWithFont:_priceLab.font
                             constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame)/2,
                                                          frame.size.height)];
    
    //距右边25像素
    frame.origin.x = CGRectGetWidth(self.frame) - 25 - size.width;
    frame.size.width = size.width;
    _priceLab.frame = frame;
    
    frame = _priceType.frame;
    frame.origin.x = CGRectGetMinX(_priceLab.frame) - CGRectGetWidth(frame);
    _priceType.frame = frame;
    
    frame = _orgCityLab.frame;
    CGFloat maxwidth = 0;
    if (_flight.stopTimes == 0)
    {
        maxwidth = CGRectGetMinX(_priceType.frame) - CGRectGetMinX(_orgCityLab.frame);
    }
    else
    {
        maxwidth = CGRectGetMinX(_priceType.frame) - CGRectGetMinX(_orgCityLab.frame) - CGRectGetWidth(_stopFilghtView.frame);
    }
    size = [_orgCityLab.text sizeWithFont:_orgCityLab.font
                        constrainedToSize:CGSizeMake(maxwidth, CGRectGetHeight(_orgCityLab.frame))];
    frame.size.width = size.width;
    _orgCityLab.frame = frame;
    
    if (_flight.stopTimes > 0)
    {
        _stopFilghtView.frame = CGRectMake(CGRectGetMaxX(_orgCityLab.frame), 14, 32, 16);
    }
}

@end
