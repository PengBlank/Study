//
//  HYFlightCitySettingCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightCitySettingCell.h"

@interface HYFlightCitySettingCell ()
{
    UILabel *_startCity;
    UILabel *_arrCity;
    BOOL _switch;
}
@end

@implementation HYFlightCitySettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _switch = NO;
        UIImage *selectBg = [[UIImage imageNamed:@"btn_flightnavigation_pressed"] stretchableImageWithLeftCapWidth:20
                                                                                                      topCapHeight:0];
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setBackgroundImage:selectBg
                            forState:UIControlStateHighlighted];
        startBtn.frame = TFRectMake(0, 20, 150, 44);
        [startBtn addTarget:self
                     action:@selector(orgCitySetting:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:startBtn];
        
        UIButton *dstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dstBtn setBackgroundImage:selectBg
                          forState:UIControlStateHighlighted];
        dstBtn.frame = TFRectMake(182, 20, 138, 44);
        [dstBtn addTarget:self
                   action:@selector(dstCitySetting:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:dstBtn];
        
        _startCity = [[UILabel alloc] initWithFrame:TFRectMake(25, 38, 80, 18)];
        _startCity.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_startCity setFont:[UIFont systemFontOfSize:16]];
        _startCity.backgroundColor = [UIColor clearColor];
        _startCity.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_startCity];
        
        _arrCity = [[UILabel alloc] initWithFrame:TFRectMake(230, 38, 80, 18)];
        _arrCity.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_arrCity setFont:[UIFont systemFontOfSize:16]];
        _arrCity.backgroundColor = [UIColor clearColor];
        _arrCity.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_arrCity];
        
        UIButton *transBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        transBtn.frame = TFRectMake(138, 10, 44, 44);
        [transBtn setImage:[UIImage imageNamed:@"fightSearch_exchange"]
                  forState:UIControlStateNormal];
//        [transBtn setImage:[UIImage imageNamed:@"btn_trans_pressed"]
//                  forState:UIControlStateHighlighted];
        [transBtn addTarget:self
                     action:@selector(transformFilghCity:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:transBtn];
        
        UIImage *startIcon = [UIImage imageNamed:@"flightSearch_startPlane"];
        UIImageView *startView = [[UIImageView alloc] initWithFrame:TFRectMake(14, 5, 15, 15)];
        startView.image = startIcon;
        [self.contentView addSubview:startView];
        
        UILabel *startCity = [UILabel new];
        startCity.text = @"出发城市";
        startCity.frame = TFRectMake(35, 8, 50, 10);
        startCity.font = [UIFont systemFontOfSize:TFScalePoint(11)];
        startCity.textColor = [UIColor grayColor];
        [self.contentView addSubview:startCity];
        
        UIImage *arriveIcon = [UIImage imageNamed:@"flightSearch_endPlane"];
        UIImageView *arriveView = [[UIImageView alloc] initWithFrame:TFRectMake(240, 5, 15, 15)];
        arriveView.image = arriveIcon;
        [self.contentView addSubview:arriveView];
        
        UILabel *endCity = [UILabel new];
        endCity.text = @"到达城市";
        endCity.frame = TFRectMake(260, 8, 50, 10);
        endCity.font = [UIFont systemFontOfSize:TFScalePoint(11)];
        endCity.textColor = [UIColor grayColor];
        [self.contentView addSubview:endCity];
        
//        UIImage *arrIcon = [UIImage imageNamed:@"icon_arrow"];
//        UIImageView *arrView1 = [[UIImageView alloc] initWithFrame:TFRectMake(120, 17, 10, 10)];
//        arrView1.image = arrIcon;
//        [self.contentView addSubview:arrView1];
//        
//        UIImageView *arrView2 = [[UIImageView alloc] initWithFrame:TFRectMake(300, 17, 10, 10)];
//        arrView2.image = arrIcon;
//        [self.contentView addSubview:arrView2];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark private methods
- (void)transformFilghCity:(id)sender
{
    CGRect frame = _startCity.frame;
    _switch = !_switch;
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _startCity.frame = _arrCity.frame;
                         _arrCity.frame = frame;
                     }completion:^(BOOL finished) {
                         if (finished)
                         {
                             if ([b_self.delegate respondsToSelector:@selector(transformflightCity)])
                             {
                                 [b_self.delegate transformflightCity];
                             }
                         }
                     }];
}

- (void)orgCitySetting:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(setflightOrgCity)])
    {
        [self.delegate setflightOrgCity];
    }
}

- (void)dstCitySetting:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(setflightDstCity)])
    {
        [self.delegate setflightDstCity];
    }
}

#pragma mark setter/getter
- (void)setOrgCity:(HYFlightCity *)orgCity
{
    if (_orgCity != orgCity)
    {
        _orgCity = orgCity;
        if (_switch)
        {
            _arrCity.text = orgCity.cityName;
        }
        else
        {
            _startCity.text = orgCity.cityName;
        }
    }
}

- (void)setDstCity:(HYFlightCity *)dstCity
{
    if (_dstCity != dstCity)
    {
        _dstCity = dstCity;
        if (_switch)
        {
            _startCity.text = dstCity.cityName;
        }
        else
        {
            _arrCity.text = dstCity.cityName;
        }
    }
}
@end
