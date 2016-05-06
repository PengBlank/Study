//
//  HYFlightOrderInvoiceInfoCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightOrderInvoiceInfoCell.h"

@interface HYFlightOrderInvoiceInfoCell ()
{
    UILabel *_userLab;
    UILabel *_phoneLab;
    UILabel *_addressLab;
    UILabel *_expressNOLab;
    UILabel *_expressLab;
    UILabel *_statusLab;
}

@end

@implementation HYFlightOrderInvoiceInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *descLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 12, 120, 18)];
        descLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [descLab setFont:[UIFont systemFontOfSize:17]];
        descLab.backgroundColor = [UIColor clearColor];
        descLab.textAlignment = NSTextAlignmentLeft;
        descLab.text = @"行程单配送";
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
        _sLab.text = @"联系人:";
        [self.contentView addSubview:_sLab];
        
        _userLab = [[UILabel alloc] initWithFrame:CGRectMake(104, 52, 140, 16)];
        _userLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_userLab setFont:[UIFont systemFontOfSize:16]];
        _userLab.backgroundColor = [UIColor clearColor];
        _userLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_userLab];
        
        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 80, CGRectGetWidth(ScreenRect)-6, 1.0)];
        line2.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line2];
        
        UILabel *_nLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 92, 80, 16)];
        _nLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_nLab setFont:[UIFont systemFontOfSize:16]];
        _nLab.backgroundColor = [UIColor clearColor];
        _nLab.textAlignment = NSTextAlignmentLeft;
        _nLab.text = @"联系电话:";
        [self.contentView addSubview:_nLab];
        
        _phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(104, 92, 140, 16)];
        _phoneLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_phoneLab setFont:[UIFont systemFontOfSize:16]];
        _phoneLab.backgroundColor = [UIColor clearColor];
        _phoneLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_phoneLab];
        
        UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 120, CGRectGetWidth(ScreenRect)-6, 1.0)];
        line3.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line3];
        
        UILabel *_tLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 132, 80, 16)];
        _tLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_tLab setFont:[UIFont systemFontOfSize:16]];
        _tLab.backgroundColor = [UIColor clearColor];
        _tLab.textAlignment = NSTextAlignmentLeft;
        _tLab.text = @"快递公司:";
        [self.contentView addSubview:_tLab];
        
        _expressLab = [[UILabel alloc] initWithFrame:CGRectMake(104, 132, 140, 16)];
        _expressLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_expressLab setFont:[UIFont systemFontOfSize:16]];
        _expressLab.backgroundColor = [UIColor clearColor];
        _expressLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_expressLab];
        
        UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 160, CGRectGetWidth(ScreenRect)-6, 1.0)];
        line4.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line4];
        
        UILabel *_pLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 172, 80, 16)];
        _pLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_pLab setFont:[UIFont systemFontOfSize:16]];
        _pLab.backgroundColor = [UIColor clearColor];
        _pLab.textAlignment = NSTextAlignmentLeft;
        _pLab.text = @"快递单号:";
        [self.contentView addSubview:_pLab];
        
        _expressNOLab = [[UILabel alloc] initWithFrame:CGRectMake(104, 172, 140, 16)];
        _expressNOLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_expressNOLab setFont:[UIFont systemFontOfSize:16]];
        _expressNOLab.backgroundColor = [UIColor clearColor];
        _expressNOLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_expressNOLab];
        
        UIImageView *line5 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 200, CGRectGetWidth(ScreenRect)-6, 1.0)];
        line5.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line5];
        
        UILabel *_pointLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 212, 80, 16)];
        _pointLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_pointLab setFont:[UIFont systemFontOfSize:16]];
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.textAlignment = NSTextAlignmentLeft;
        _pointLab.text = @"状态:";
        [self.contentView addSubview:_pointLab];
        
        _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(104, 212, 140, 16)];
        _statusLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_statusLab setFont:[UIFont systemFontOfSize:16]];
        _statusLab.backgroundColor = [UIColor clearColor];
        _statusLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_statusLab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark setter/getter
- (void)setJourney:(HYFlightJourneyInfo *)journey
{
    if (journey != _journey)
    {
        _journey = journey;
        _userLab.text = journey.contact;
        _phoneLab.text = journey.tel;
        _addressLab.text = [NSString stringWithFormat:@"%@%@%@", journey.province, journey.city, journey.address];
        _expressLab.text = journey.shipment;
        _expressNOLab.text = journey.expressNo;
        _statusLab.text = journey.statusDesc;
    }
}
@end
