//
//  HYFlightCancelCell.m
//  Teshehui
//
//  Created by Kris on 15/9/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightCancelCell.h"

//typedef void(^CancelOrderBlock) (NSIndexPath *);

@interface HYFlightCancelCell ()
{
    UILabel *_fCityInfoLab;
    UILabel *_flightNOLab;
    UILabel *_fStartDateLab;
    UILabel *_fOrgAirport;
    UILabel *_fArrAirport;
    UILabel *_priceLab;
    
    UILabel *_oPriceLab;
    UILabel *_oPriceDesLab;
}

//@property (nonatomic, copy) CancelOrderBlock block;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation HYFlightCancelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        UILabel *_sLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 80, 16)];
//        _sLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
//        [_sLab setFont:[UIFont systemFontOfSize:14]];
//        _sLab.backgroundColor = [UIColor clearColor];
//        _sLab.textAlignment = NSTextAlignmentLeft;
//        _sLab.text = @"起飞日期:";
//        [self.contentView addSubview:_sLab];
//        
//        _fStartDateLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, TFScalePoint(220), 16)];
//        _fStartDateLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
//        [_fStartDateLab setFont:[UIFont systemFontOfSize:14]];
//        _fStartDateLab.backgroundColor = [UIColor clearColor];
//        _fStartDateLab.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:_fStartDateLab];
//        
//        _oPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 22, 100, 16)];
////        _oPriceLab.textColor = [UIColor colorWithRed:255.0f/255.0
////                                               green:154.0f/255.0f
////                                                blue:19.0f/255.0f
////                                               alpha:1.0];
//        [_oPriceLab setFont:[UIFont systemFontOfSize:14]];
//        _oPriceLab.backgroundColor = [UIColor clearColor];
//        _oPriceLab.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:_oPriceLab];
//        
//        _oPriceDesLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_oPriceLab.frame), 22, 200, 16)];
////        _oPriceDesLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
//        [_oPriceDesLab setFont:[UIFont systemFontOfSize:12]];
//        _oPriceDesLab.backgroundColor = [UIColor clearColor];
//        _oPriceDesLab.textAlignment = NSTextAlignmentLeft;
//        _oPriceDesLab.lineBreakMode = NSLineBreakByCharWrapping;
//        [self.contentView addSubview:_oPriceDesLab];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(14, 3, 70, 30);
      
        [_cancelBtn setBackgroundImage:[[UIImage imageNamed:@"flght_cancelOrder"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:11];

        [self.contentView addSubview:_cancelBtn];
    }
    return self;
}

#pragma mark private methods
- (void)cancelOrder:(UIButton *)seder
{
    if ([self.delegate respondsToSelector:@selector(cancelFilghtOrder:)])
    {
        [self.delegate cancelFilghtOrder:self.order];
    }
}


#pragma mark getter and setter
//- (void)setOrder:(HYFlightOrder *)order
//{
//    if (order != _order)
//    {
//        _order = order;
//        HYFlightOrderItem *item = [order.orderItems objectAtIndex:0];
//        
//        NSString *oPrice = [NSString stringWithFormat:@"机票价￥%0.0f",item.price];
//        NSMutableAttributedString *_oPriceAttr = [[NSMutableAttributedString alloc]initWithString:oPrice];
//        [_oPriceAttr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, oPrice.length-3)];
//        _oPriceLab.attributedText = _oPriceAttr;
//        
//        NSString *priceStr = [NSString stringWithFormat:@"机建￥%0.0f燃油税￥%0.0f", item.airportTax ,item.fuelTax];
//        NSString *airportTax = [NSString stringWithFormat:@"￥%0.0f", item.airportTax];
//        NSString *fuelTax = [NSString stringWithFormat:@"￥%0.0f", item.fuelTax];
//        NSMutableAttributedString *_priceAttr = [[NSMutableAttributedString alloc]initWithString:priceStr];
//        [_priceAttr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, airportTax.length)];
//        [_priceAttr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2+airportTax.length+3, fuelTax.length)];
//        _oPriceDesLab.attributedText = _priceAttr;
//        
//        //起飞日期
//        _fStartDateLab.text = item.flightDate;
//    }
//}

- (void)setOrderStatus:(NSInteger)orderStatus
{
    _orderStatus = orderStatus;
    if (_orderStatus == 1)
    {
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self
                       action:@selector(cancelOrder:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    else if (_orderStatus==512||  //已取消
              _orderStatus==8192)//退款成功
    {
        [_cancelBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self
                       action:@selector(cancelOrder:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    
}

@end
