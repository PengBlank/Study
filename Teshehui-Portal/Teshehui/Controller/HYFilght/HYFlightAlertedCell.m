//
//  HYFlightAlertedCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightAlertedCell.h"

@interface HYFlightAlertedCell ()
{
    UILabel *_oStatusLab;
    UILabel *_oNOLab;
    UILabel *_oCreateTimeLab;
    UILabel *_oPriceLab;
    UILabel *_oPointLab;
}

@end

@implementation HYFlightAlertedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *descLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 12, 80, 16)];
        descLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [descLab setFont:[UIFont systemFontOfSize:17]];
        descLab.backgroundColor = [UIColor clearColor];
        descLab.textAlignment = NSTextAlignmentLeft;
        descLab.text = @"改签信息";
        [self.contentView addSubview:descLab];
        
        UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(ScreenRect), 1.0)];
        line1.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line1];
        
        UILabel *_sLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 52, 80, 16)];
        _sLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_sLab setFont:[UIFont systemFontOfSize:16]];
        _sLab.backgroundColor = [UIColor clearColor];
        _sLab.textAlignment = NSTextAlignmentLeft;
        _sLab.text = @"改签状态:";
        [self.contentView addSubview:_sLab];
        
        _oStatusLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 52, 140, 16)];
        _oStatusLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_oStatusLab setFont:[UIFont systemFontOfSize:16]];
        _oStatusLab.backgroundColor = [UIColor clearColor];
        _oStatusLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_oStatusLab];
        
        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 80, CGRectGetWidth(ScreenRect)-6, 1.0)];
        line2.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line2];
        
        UILabel *_nLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 92, 80, 16)];
        _nLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_nLab setFont:[UIFont systemFontOfSize:16]];
        _nLab.backgroundColor = [UIColor clearColor];
        _nLab.textAlignment = NSTextAlignmentLeft;
        _nLab.text = @"航班编号:";
        [self.contentView addSubview:_nLab];
        
        _oNOLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 92, 140, 16)];
        _oNOLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_oNOLab setFont:[UIFont systemFontOfSize:16]];
        _oNOLab.backgroundColor = [UIColor clearColor];
        _oNOLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_oNOLab];
        
        UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 120, CGRectGetWidth(ScreenRect)-6, 1.0)];
        line3.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line3];
        
        UILabel *_tLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 132, 80, 16)];
        _tLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_tLab setFont:[UIFont systemFontOfSize:16]];
        _tLab.backgroundColor = [UIColor clearColor];
        _tLab.textAlignment = NSTextAlignmentLeft;
        _tLab.text = @"起飞时间:";
        [self.contentView addSubview:_tLab];
        
        _oCreateTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 132, 160, 16)];
        _oCreateTimeLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_oCreateTimeLab setFont:[UIFont systemFontOfSize:16]];
        _oCreateTimeLab.backgroundColor = [UIColor clearColor];
        _oCreateTimeLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_oCreateTimeLab];
        
        UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 160, CGRectGetWidth(ScreenRect)-6, 1.0)];
        line4.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line4];
        
        UILabel *_pLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 172, 80, 16)];
        _pLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_pLab setFont:[UIFont systemFontOfSize:16]];
        _pLab.backgroundColor = [UIColor clearColor];
        _pLab.textAlignment = NSTextAlignmentLeft;
        _pLab.text = @"差价金额:";
        [self.contentView addSubview:_pLab];
        
        _oPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 172, 140, 16)];
        _oPriceLab.textColor = [UIColor colorWithRed:255.0f/255.0
                                               green:154.0f/255.0f
                                                blue:19.0f/255.0f
                                               alpha:1.0];
        [_oPriceLab setFont:[UIFont systemFontOfSize:16]];
        _oPriceLab.backgroundColor = [UIColor clearColor];
        _oPriceLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_oPriceLab];
        
        UIImageView *line5 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 200, CGRectGetWidth(ScreenRect)-6, 1.0)];
        line5.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line5];
        
        UILabel *_pointLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 212, 100, 16)];
        _pointLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_pointLab setFont:[UIFont systemFontOfSize:16]];
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.textAlignment = NSTextAlignmentLeft;
        _pointLab.text = @"赠送现金券:";
        [self.contentView addSubview:_pointLab];
        
        _oPointLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 212, 140, 16)];
        _oPointLab.textColor = [UIColor colorWithRed:255.0f/255.0
                                               green:154.0f/255.0f
                                                blue:19.0f/255.0f
                                               alpha:1.0];
        [_oPointLab setFont:[UIFont systemFontOfSize:16]];
        _oPointLab.backgroundColor = [UIColor clearColor];
        _oPointLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_oPointLab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark setter/getter
- (void)setAlertInfo:(HYFlightAlertedInfo *)alertInfo
{
    if (alertInfo != _alertInfo)
    {
        /*
         @property (nonatomic, copy) NSString *alertID;
         @property (nonatomic, copy) NSString *org_airport;
         @property (nonatomic, copy) NSString *dst_airport;
         @property (nonatomic, copy) NSString *flight_no;
         @property (nonatomic, copy) NSString *flight_date;
         @property (nonatomic, copy) NSString *passengers;
         @property (nonatomic, copy) NSString *cabin_type;
         @property (nonatomic, copy) NSString *cabin_name;
         @property (nonatomic, copy) NSString *cabin_code;
         @property (nonatomic, assign) float pay_total;
         @property (nonatomic, assign) float points;
         @property (nonatomic, assign) NSInteger status;
         @property (nonatomic, readonly, copy) NSString *statusDesc;
         */
        _alertInfo = alertInfo;
        
        _oNOLab.text = alertInfo.flightNo;
        _oCreateTimeLab.text = alertInfo.flightDate;
        _oPriceLab.text = [NSString stringWithFormat:@"￥%0.2f", alertInfo.payTotal];
        _oPointLab.text = [NSString stringWithFormat:@"%ld", (long)alertInfo.points];
    }
    
    _oStatusLab.text = alertInfo.statusDesc;
}

@end
