//
//  HYFlightOrderCabinInfoCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightFillOrderCabinInfoCell.h"
#import "HYFlightRTRules.h"
#import "HYFlightRefundView.h"

@interface HYFlightFillOrderCabinInfoCell ()
{
    UILabel *_discountLab;
    UILabel *_priceLab;
    UILabel *_cabinsLab;
    UILabel *_fuelTaxLab;
    UILabel *_airportTaxLab;
}

@property (nonatomic, strong) HYFlightRefundView *ruleView;
@end

@implementation HYFlightFillOrderCabinInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _isExpand = NO;
        _cabinsLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 4, 120, 18)];
        _cabinsLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_cabinsLab setFont:[UIFont systemFontOfSize:14]];
        _cabinsLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_cabinsLab];
        
        _discountLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 4, 40, 18)];
        _discountLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_discountLab setFont:[UIFont systemFontOfSize:14]];
        _discountLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_discountLab];
        
        UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 42, 18)];
        priceLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [priceLab setFont:[UIFont systemFontOfSize:14]];
        priceLab.backgroundColor = [UIColor clearColor];
        priceLab.text = @"机票价";
        [self.contentView addSubview:priceLab];
        
        UILabel *priceType = [[UILabel alloc] initWithFrame:CGRectMake(84, 30, 15, 18)];
        priceType.textColor = [UIColor colorWithRed:250.0/255.0
                                              green:113.0/255.0
                                               blue:17.0/255.0
                                              alpha:1.0];
        [priceType setFont:[UIFont systemFontOfSize:14]];
        priceType.backgroundColor = [UIColor clearColor];
        priceType.text = @"￥";
        [self.contentView addSubview:priceType];
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(96, 30, 75, 18)];
        _priceLab.textColor = [UIColor colorWithRed:250.0/255.0
                                              green:113.0/255.0
                                               blue:17.0/255.0
                                              alpha:1.0];
        [_priceLab setFont:[UIFont boldSystemFontOfSize:18]];
        _priceLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_priceLab];
        
        //两个便签是反着写的
        UILabel *fuelLab = [[UILabel alloc] initWithFrame:CGRectMake(170, 30, 26, 18)];
        fuelLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [fuelLab setFont:[UIFont systemFontOfSize:13]];
        fuelLab.backgroundColor = [UIColor clearColor];
        fuelLab.text = @"机建";
        [self.contentView addSubview:fuelLab];
        
        _fuelTaxLab = [[UILabel alloc] initWithFrame:CGRectMake(195, 30, 60, 18)];
        _fuelTaxLab.textColor = [UIColor colorWithRed:250.0/255.0
                                                green:113.0/255.0
                                                 blue:17.0/255.0
                                                alpha:1.0];
        [_fuelTaxLab setFont:[UIFont systemFontOfSize:13]];
        _fuelTaxLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_fuelTaxLab];
        
        UILabel *airportLab = [[UILabel alloc] initWithFrame:CGRectMake(245, 30, 50, 18)];
        airportLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [airportLab setFont:[UIFont systemFontOfSize:13]];
        airportLab.backgroundColor = [UIColor clearColor];
        airportLab.text = @"燃油";
        [self.contentView addSubview:airportLab];
        _airportTaxLab = [[UILabel alloc] initWithFrame:CGRectMake(270, 30, 50, 18)];
        _airportTaxLab.textColor = [UIColor colorWithRed:250.0/255.0
                                                   green:113.0/255.0
                                                    blue:17.0/255.0
                                                   alpha:1.0];
        [_airportTaxLab setFont:[UIFont systemFontOfSize:13]];
        _airportTaxLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_airportTaxLab];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(25, 50, 110, 30);
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
        [btn setTitle:@"查看退改签" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ico_arrow_unfold"]
             forState:UIControlStateNormal];
        
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn setTitleColor:[UIColor colorWithRed:23.0/255.0
                                           green:126.0/255.0
                                            blue:184.0/255.0
                                           alpha:1.0]
                  forState:UIControlStateNormal];
        [btn addTarget:self
                action:@selector(checkCabinRules:)
      forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
    
    return self;
}

//-(void)drawRect:(CGRect)rect
//{
//    CGRect bounds = self.frame;
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    CGContextMoveToPoint(ctx, 0, bounds.size.height - 10);
//    UIImage *suihua = [UIImage imageNamed:@"flight_suihua"];
//    CGFloat width = suihua.size.width;
//    
//    for (int i = 0; i < 10; i++) {
//        [suihua drawAtPoint:CGPointMake(width * i, bounds.size.height -15)];
//    }
//    
//    CGContextFillPath(ctx);
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark private methods
- (void)checkCabinRules:(id)sender
{
    UIButton *btn = (UIButton *)sender;

    self.isExpand = !self.isExpand;
    
    if ([self.delegate respondsToSelector:@selector(cellExpand:)])
    {
        [self.delegate cellExpand:self.isExpand];
    }
    
    if (self.isExpand)
    {
        [btn setTitle:@"收起退改签" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ico_arrow_packup"]
             forState:UIControlStateNormal];
        [self.ruleView setHidden:NO];
    }
    else
    {
        [self.ruleView setHidden:YES];
        [btn setTitle:@"查看退改签" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ico_arrow_unfold"]
             forState:UIControlStateNormal];
    }
}

#pragma mark setter/getter
- (void)setCabin:(HYFlightSKU *)cabin
{
    if (cabin != _cabin)
    {
        _cabin = cabin;
        _cabinsLab.text = cabin.expandedResponse.cabinName;
        
        if (cabin.expandedResponse.discount.floatValue < 10)
        {
            NSNumber *nDic = [NSNumber numberWithFloat:cabin.expandedResponse.discount.floatValue];
            _discountLab.text = [NSString stringWithFormat:@"%@折", nDic];
        }
        
        //机建和燃油是反着写
        _priceLab.text = [NSString stringWithFormat:@"%0.2f",cabin.price.floatValue];
        _airportTaxLab.text = [NSString stringWithFormat:@"￥%0.2f",cabin.expandedResponse.fuelTax];
        _fuelTaxLab.text = [NSString stringWithFormat:@"￥%0.2f",cabin.expandedResponse.airportTax];
    }
}

- (HYFlightRefundView *)ruleView
{
    if (!_ruleView)
    {
        CGFloat h = 0;
        if (self.rules.changeHeight > 0)
        {
            h += (self.rules.changeHeight+26);
        }
        
        if (self.rules.refundHeight > 0)
        {
            h += (self.rules.refundHeight+26);
        }
        
        if (self.rules.remarkHeight > 0)
        {
            h += (self.rules.remarkHeight+26);
        }
        
        _ruleView = [[HYFlightRefundView alloc] initWithFrame:TFRectMakeFixWidth(40, 76, 270, h)];
        _ruleView.backgroundColor = [UIColor clearColor];
        _ruleView.rules = self.rules;
        [self.contentView addSubview:_ruleView];
    }
    
    return _ruleView;
}

@end
