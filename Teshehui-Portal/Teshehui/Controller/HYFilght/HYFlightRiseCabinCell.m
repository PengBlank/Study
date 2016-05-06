//
//  HYFlightRiseCabinCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightRiseCabinCell.h"


@interface HYFlightRiseCabinCell ()
{
    UILabel *_passengerLab;
    UILabel *_cabinLab;
    UILabel *_priceLab;
    UILabel *_pointLab;
    UILabel *_statusLab;
}

@end

@implementation HYFlightRiseCabinCell

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
        descLab.text = @"升舱信息";
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
        _sLab.text = @"乘机人:";
        [self.contentView addSubview:_sLab];
        
        _passengerLab = [[UILabel alloc] initWithFrame:CGRectMake(104, 52, CGRectGetWidth(ScreenRect)-110, 16)];
        _passengerLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_passengerLab setFont:[UIFont systemFontOfSize:16]];
        _passengerLab.backgroundColor = [UIColor clearColor];
        _passengerLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_passengerLab];
        
        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 80, CGRectGetWidth(ScreenRect)-6, 1.0)];
        line2.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line2];
        
        UILabel *_nLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 92, 80, 16)];
        _nLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_nLab setFont:[UIFont systemFontOfSize:16]];
        _nLab.backgroundColor = [UIColor clearColor];
        _nLab.textAlignment = NSTextAlignmentLeft;
        _nLab.text = @"舱位类型:";
        [self.contentView addSubview:_nLab];
        
        _cabinLab = [[UILabel alloc] initWithFrame:CGRectMake(104, 92, 140, 16)];
        _cabinLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_cabinLab setFont:[UIFont systemFontOfSize:16]];
        _cabinLab.backgroundColor = [UIColor clearColor];
        _cabinLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_cabinLab];
        
        UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 120, CGRectGetWidth(ScreenRect)-6, 1.0)];
        line3.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line3];
        
        UILabel *_tLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 132, 80, 16)];
        _tLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_tLab setFont:[UIFont systemFontOfSize:16]];
        _tLab.backgroundColor = [UIColor clearColor];
        _tLab.textAlignment = NSTextAlignmentLeft;
        _tLab.text = @"差价金额:";
        [self.contentView addSubview:_tLab];
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(104, 132, 140, 16)];
        _priceLab.textColor = [UIColor colorWithRed:255.0f/255.0
                                              green:154.0f/255.0f
                                               blue:19.0f/255.0f
                                              alpha:1.0];
        [_priceLab setFont:[UIFont systemFontOfSize:16]];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_priceLab];
        
        UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 160, CGRectGetWidth(ScreenRect)-6, 1.0)];
        line4.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line4];
        
        UILabel *statusLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 172, 80, 16)];
        statusLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [statusLab setFont:[UIFont systemFontOfSize:16]];
        statusLab.backgroundColor = [UIColor clearColor];
        statusLab.textAlignment = NSTextAlignmentLeft;
        statusLab.text = @"升舱状态:";
        [self.contentView addSubview:statusLab];
        
        _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(104, 172, 140, 16)];
        _statusLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_statusLab setFont:[UIFont systemFontOfSize:16]];
        _statusLab.backgroundColor = [UIColor clearColor];
        _statusLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_statusLab];
        
        UIImageView *line5 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 200, CGRectGetWidth(ScreenRect)-6, 1.0)];
        line5.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line5];
        
        UILabel *pointLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 212, 100, 16)];
        pointLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [pointLab setFont:[UIFont systemFontOfSize:16]];
        pointLab.backgroundColor = [UIColor clearColor];
        pointLab.textAlignment = NSTextAlignmentLeft;
        pointLab.text = @"赠送现金券:";
        [self.contentView addSubview:pointLab];
        
        _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 212, 140, 16)];
        _pointLab.textColor = [UIColor colorWithRed:255.0f/255.0
                                              green:154.0f/255.0f
                                               blue:19.0f/255.0f
                                              alpha:1.0];
        [_pointLab setFont:[UIFont systemFontOfSize:16]];
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_pointLab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark setter/getter
- (void)setRiseCabin:(HYRiseCabinInfo *)riseCabin
{
    if (riseCabin != _riseCabin)
    {
        /*
         @property (nonatomic, copy) NSString *passengers;
         @property (nonatomic, copy) NSString *to_cabin_type;
         @property (nonatomic, copy) NSString *to_cabin;
         @property (nonatomic, assign) float pay_total;
         @property (nonatomic, assign) NSInteger status;
         */
        _riseCabin = riseCabin;

        _passengerLab.text = riseCabin.passengers;
        _cabinLab.text = riseCabin.toCabinType;
        _priceLab.text = [NSString stringWithFormat:@"￥%0.2f", riseCabin.payTotal];
        _pointLab.text = [NSString stringWithFormat:@"%ld", (long)riseCabin.points];
        _statusLab.text = riseCabin.statusDesc;
    }
}

@end
