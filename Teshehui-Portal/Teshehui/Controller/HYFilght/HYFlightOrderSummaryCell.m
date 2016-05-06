//
//  HYFlightOrderSummary.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightOrderSummaryCell.h"
#import "HYFlightDetailOrderHeaderView.h"

@interface HYFlightOrderSummaryCell ()
{
    UILabel *_oStatusLab;
    UILabel *_oNOLab;
    UILabel *_oCreateTimeLab;
    UILabel *_oPriceLab;
    UILabel *_oPriceDesLab;
    UILabel *_oPointLab;
    
    UILabel *_fStartDateLab;
    
    HYFlightDetailOrderHeaderView *_bigView;
}

@end

@implementation HYFlightOrderSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _bigView = [HYFlightDetailOrderHeaderView new];
        _bigView.frame = CGRectMake(0, 0, TFScalePoint(320), 320);
        [self.contentView addSubview:_bigView];
        
        UILabel *_sLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 330, 80, 16)];
        _sLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_sLab setFont:[UIFont systemFontOfSize:14]];
        _sLab.backgroundColor = [UIColor clearColor];
        _sLab.textAlignment = NSTextAlignmentLeft;
        _sLab.text = @"起飞日期:";
        [self.contentView addSubview:_sLab];
        
        _fStartDateLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 330, TFScalePoint(220), 16)];
        _fStartDateLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_fStartDateLab setFont:[UIFont systemFontOfSize:14]];
        _fStartDateLab.backgroundColor = [UIColor clearColor];
        _fStartDateLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_fStartDateLab];
        
        _oPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 352, 120, 16)];
        //        _oPriceLab.textColor = [UIColor colorWithRed:255.0f/255.0
        //                                               green:154.0f/255.0f
        //                                                blue:19.0f/255.0f
        //                                               alpha:1.0];
        [_oPriceLab setFont:[UIFont systemFontOfSize:14]];
        _oPriceLab.backgroundColor = [UIColor clearColor];
        _oPriceLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_oPriceLab];
        
        _oPriceDesLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_oPriceLab.frame), 352, 200, 16)];
        //        _oPriceDesLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_oPriceDesLab setFont:[UIFont systemFontOfSize:12]];
        _oPriceDesLab.backgroundColor = [UIColor clearColor];
        _oPriceDesLab.textAlignment = NSTextAlignmentLeft;
        _oPriceDesLab.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_oPriceDesLab];
//        UILabel *_sLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, 80, 16)];
//        _sLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//        [_sLab setFont:[UIFont systemFontOfSize:15]];
//        _sLab.backgroundColor = [UIColor clearColor];
//        _sLab.textAlignment = NSTextAlignmentLeft;
//        _sLab.text = @"订单状态:";
//        [self.contentView addSubview:_sLab];
//        
//        _oStatusLab = [[UILabel alloc] initWithFrame:CGRectMake(94, 10, 140, 16)];
//        _oStatusLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//        [_oStatusLab setFont:[UIFont systemFontOfSize:15]];
//        _oStatusLab.backgroundColor = [UIColor clearColor];
//        _oStatusLab.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:_oStatusLab];
//        
//        UILabel *_nLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 36, 80, 16)];
//        _nLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//        [_nLab setFont:[UIFont systemFontOfSize:15]];
//        _nLab.backgroundColor = [UIColor clearColor];
//        _nLab.textAlignment = NSTextAlignmentLeft;
//        _nLab.text = @"订单编号:";
//        [self.contentView addSubview:_nLab];
//        
//        _oNOLab = [[UILabel alloc] initWithFrame:CGRectMake(94, 36, 140, 16)];
//        _oNOLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//        [_oNOLab setFont:[UIFont systemFontOfSize:15]];
//        _oNOLab.backgroundColor = [UIColor clearColor];
//        _oNOLab.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:_oNOLab];
//        
//        UILabel *_tLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 62, 80, 16)];
//        _tLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//        [_tLab setFont:[UIFont systemFontOfSize:15]];
//        _tLab.backgroundColor = [UIColor clearColor];
//        _tLab.textAlignment = NSTextAlignmentLeft;
//        _tLab.text = @"订单时间:";
//        [self.contentView addSubview:_tLab];
//        
//        _oCreateTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(94, 62, 160, 16)];
//        _oCreateTimeLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//        [_oCreateTimeLab setFont:[UIFont systemFontOfSize:15]];
//        _oCreateTimeLab.backgroundColor = [UIColor clearColor];
//        _oCreateTimeLab.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:_oCreateTimeLab];
//        
//        UILabel *_pLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 88, 80, 16)];
//        _pLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//        [_pLab setFont:[UIFont systemFontOfSize:15]];
//        _pLab.backgroundColor = [UIColor clearColor];
//        _pLab.textAlignment = NSTextAlignmentLeft;
//        _pLab.text = @"订单金额:";
//        [self.contentView addSubview:_pLab];
//        
//        _oPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(94, 88, 140, 16)];
//        _oPriceLab.textColor = [UIColor colorWithRed:255.0f/255.0
//                                               green:154.0f/255.0f
//                                                blue:19.0f/255.0f
//                                               alpha:1.0];
//        [_oPriceLab setFont:[UIFont systemFontOfSize:15]];
//        _oPriceLab.backgroundColor = [UIColor clearColor];
//        _oPriceLab.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:_oPriceLab];
//        
//        _oPriceDesLab = [[UILabel alloc] initWithFrame:CGRectMake(94, 100, 200, 32)];
//        _oPriceDesLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
//        [_oPriceDesLab setFont:[UIFont systemFontOfSize:12]];
//        _oPriceDesLab.backgroundColor = [UIColor clearColor];
//        _oPriceDesLab.textAlignment = NSTextAlignmentLeft;
//        _oPriceDesLab.lineBreakMode = NSLineBreakByCharWrapping;
//        _oPriceDesLab.numberOfLines = 2;
//        [self.contentView addSubview:_oPriceDesLab];
//        
//        UILabel *_pointLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 134, 80, 16)];
//        _pointLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//        [_pointLab setFont:[UIFont systemFontOfSize:15]];
//        _pointLab.backgroundColor = [UIColor clearColor];
//        _pointLab.textAlignment = NSTextAlignmentLeft;
//        _pointLab.text = @"赠送现金券:";
//        [self.contentView addSubview:_pointLab];
//        
//        _oPointLab = [[UILabel alloc] initWithFrame:CGRectMake(94, 134, 140, 16)];
//        _oPointLab.textColor = [UIColor colorWithRed:255.0f/255.0
//                                               green:154.0f/255.0f
//                                                blue:19.0f/255.0f
//                                               alpha:1.0];
//        [_oPointLab setFont:[UIFont systemFontOfSize:16]];
//        _oPointLab.backgroundColor = [UIColor clearColor];
//        _oPointLab.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:_oPointLab];
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
        _oNOLab.text = order.orderCode;
        _oCreateTimeLab.text = order.creationTime;
        
        //取消订单上面的
        NSString *oPrice = [NSString stringWithFormat:@"机票价￥%0.2f",item.price];
        NSMutableAttributedString *_oPriceAttr = [[NSMutableAttributedString alloc]initWithString:oPrice];
        [_oPriceAttr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, oPrice.length-3)];
        _oPriceLab.attributedText = _oPriceAttr;
        
        NSString *priceStr2 = [NSString stringWithFormat:@"机建￥%0.2f 燃油税￥%0.2f", item.airportTax ,item.fuelTax];
        NSString *airportTax = [NSString stringWithFormat:@"￥%0.2f", item.airportTax];
        NSString *fuelTax = [NSString stringWithFormat:@"￥%0.2f", item.fuelTax];
        NSMutableAttributedString *_priceAttr = [[NSMutableAttributedString alloc]initWithString:priceStr2];
        [_priceAttr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, airportTax.length)];
        [_priceAttr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2+airportTax.length+4, fuelTax.length)];
        _oPriceDesLab.attributedText = _priceAttr;
        
        //起飞日期
        _fStartDateLab.text =[NSString stringWithFormat:@"%@  %@",item.flightDate,item.takeOffTime];
    }
    
    _oStatusLab.text = order.orderShowStatus;
    
     _bigView.order = _order;
}

@end
