//
//  HYFlightDateSettingCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightDateSettingCell.h"

@interface HYFlightDateSettingCell ()
{
    UIImageView *_startDateView;
    UIImageView *_arrDateView;
    
    UILabel *_startDateLab;
    UILabel *_startTimeLab;
    UILabel *_arrDateLab;
    UILabel *_arrTimeLab;
    UILabel *_dateLabel;
    
    UIButton *_startDateBtn;
    UIButton *_backDateBtn;
}
@end

@implementation HYFlightDateSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        UIImage *date = [UIImage imageNamed:@"flightSearch_date"];
//        UIImageView *dateImgView = [[UIImageView alloc]initWithImage:date];
//        dateImgView.frame = TFRectMake(5, 5, 15, 15);
//        [self.contentView addSubview:dateImgView];
        
        
        
        
        
        _startDateView = [[UIImageView alloc] initWithFrame:TFRectMake(14, 13, 18, 18)];
        _startDateView.image = [UIImage imageNamed:@"flightSearch_date"];
        [self.contentView addSubview:_startDateView];
        
        _startDateLab = [[UILabel alloc] initWithFrame:TFRectMake(10, 50, 100, 18)];
        _startDateLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_startDateLab setFont:[UIFont systemFontOfSize:16]];
        _startDateLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_startDateLab];
        
//        _startTimeLab = [[UILabel alloc] initWithFrame:TFRectMake(190, 28, 100, 18)];
//        _startTimeLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
//        [_startTimeLab setFont:[UIFont systemFontOfSize:14]];
//        _startTimeLab.backgroundColor = [UIColor clearColor];
//        _startTimeLab.textAlignment = NSTextAlignmentRight;
//        [self.contentView addSubview:_startTimeLab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark setter/getter
- (void)setSingleWay:(BOOL)singleWay
{
    if (_singleWay != singleWay)
    {
        _singleWay = singleWay;
        
        NSArray *views = [self.contentView subviews];
        for (UIView *v in views)
        {
            [v removeFromSuperview];
        }
        
        if (!singleWay)
        {
            UIImage *selectBg = [[UIImage imageNamed:@"btn_flightnavigation_pressed"] stretchableImageWithLeftCapWidth:20
                                                                                                          topCapHeight:0];
            
            _startDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _startDateBtn.frame = TFRectMake(0, 0, 160, 68);
            [_startDateBtn setBackgroundImage:selectBg
                                    forState:UIControlStateHighlighted];
            [_startDateBtn addTarget:self
                             action:@selector(startDateEvent:)
                   forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_startDateBtn];
            
            _backDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _backDateBtn.frame = TFRectMake(160, 0, 160, 68);
            [_backDateBtn setBackgroundImage:selectBg
                                   forState:UIControlStateHighlighted];
            [_backDateBtn addTarget:self
                            action:@selector(backDateEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_backDateBtn];
            
            
            UIImage *line = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
                                                                                     topCapHeight:4];
            UIImageView *lline = [[UIImageView alloc] initWithFrame:TFRectMake(160, 0, 1, 68)];
            lline.image = line;
            [self.contentView addSubview:lline];

            _startDateView = [[UIImageView alloc] initWithFrame:TFRectMake(14, 13, 12, 12)];
            _startDateView.image = [UIImage imageNamed:@"flightSearch_date"];
            [self.contentView addSubview:_startDateView];
            
            UILabel *startDate = [UILabel new];
            startDate.textColor = [UIColor grayColor];
            startDate.text = @"出发日期";
            startDate.frame = TFRectMake(35, 14, 50, 10);
            startDate.font = [UIFont systemFontOfSize:TFScalePoint(11)];
            [self.contentView addSubview:startDate];
            
            _startDateLab = [[UILabel alloc] initWithFrame:TFRectMake(40, 35, 100, 18)];
            _startDateLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
            [_startDateLab setFont:[UIFont systemFontOfSize:16]];
            _startDateLab.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_startDateLab];
        
            
            _arrDateView = [[UIImageView alloc] initWithFrame:TFRectMake(174, 13, 12, 12)];
            _arrDateView.image = [UIImage imageNamed:@"flightSearch_date"];
            [self.contentView addSubview:_arrDateView];
            
            UILabel *endDate = [UILabel new];
            endDate.textColor = [UIColor grayColor];
            endDate.text = @"到达日期";
            endDate.frame = TFRectMake(195, 14, 50, 10);
            endDate.font = [UIFont systemFontOfSize:TFScalePoint(11)];
            [self.contentView addSubview:endDate];
            
            _arrDateLab = [[UILabel alloc] initWithFrame:TFRectMake(204, 35, 100, 18)];
            _arrDateLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
            [_arrDateLab setFont:[UIFont systemFontOfSize:16]];
            _arrDateLab.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_arrDateLab];
//            

        }
        else
        {
            UIImage *selectBg = [[UIImage imageNamed:@"btn_flightnavigation_pressed"] stretchableImageWithLeftCapWidth:20
                                                                                                          topCapHeight:0];
            
            _startDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _startDateBtn.frame = TFRectMake(0, 0, 320, 68);
            [_startDateBtn setBackgroundImage:selectBg
                                     forState:UIControlStateHighlighted];
            [_startDateBtn addTarget:self
                              action:@selector(startDateEvent:)
                    forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_startDateBtn];
            

            _dateLabel = [UILabel new];
            _dateLabel.textColor = [UIColor grayColor];
            _dateLabel.text = @"出发日期";
            _dateLabel.frame = TFRectMake(35, 14, 50, 10);
            _dateLabel.font = [UIFont systemFontOfSize:TFScalePoint(11)];
            [self.contentView addSubview:_dateLabel];
            
            _startDateView = [[UIImageView alloc] initWithFrame:TFRectMake(14, 13, 12, 12)];
            _startDateView.image = [UIImage imageNamed:@"flightSearch_date"];
            [self.contentView addSubview:_startDateView];
            
            _startDateLab = [[UILabel alloc] initWithFrame:TFRectMake(15, 35, 100, 18)];
            _startDateLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
            [_startDateLab setFont:[UIFont systemFontOfSize:16]];
            _startDateLab.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_startDateLab];
        }
    }
}

#pragma mark private methods
- (void)startDateEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(startDateSetting)])
    {
        [self.delegate startDateSetting];
    }
}

- (void)backDateEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(backDateSetting)])
    {
        [self.delegate backDateSetting];
    }
}

#pragma mark setter/getter
- (void)setStartDate:(NSString *)startDate
{
    if (_startDate != startDate)
    {
        _startDate = [startDate copy];
    }
    
//    _startDateLab.text = startDate;
}

- (void)setStartTime:(NSString *)startTime
{
    if (_startTime != startTime)
    {
        _startDate = [startTime copy];
    }
    _startDateLab.text = startTime;
}

- (void)setBackDate:(NSString *)backDate
{
    if (_backDate != backDate)
    {
        _backDate = [backDate copy];
    }
//    _arrDateLab.text = backDate;
}

- (void)setBackTime:(NSString *)backTime
{
    if (_backTime != backTime)
    {
        _backTime = [backTime copy];
    }
    _arrDateLab.text = backTime;
}

@end
