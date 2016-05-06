//
//  HYMeituanOrderListCell.m
//  Teshehui
//
//  Created by HYZB on 2014/12/17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMeituanOrderListCell.h"

@interface HYMeituanOrderListCell ()

@property (nonatomic, strong) UILabel *orderIDLab;
@property (nonatomic, strong) UILabel *statusLab;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *pointLab;
@property (nonatomic, strong) UILabel *pointStatusLab;

@end

@implementation HYMeituanOrderListCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 9, 11)];
        accessoryView.image = [UIImage imageNamed:@"group_order_price.png"];
        [self.contentView addSubview:accessoryView];
        
        UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50, TFScalePoint(300), 1)];
        line1.image = [UIImage imageNamed:@"line_cell_top.png"];
        [self.contentView addSubview:line1];

        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 123, TFScalePoint(300), 1)];
        line2.image = [UIImage imageNamed:@"line_cell_top.png"];
        [self.contentView addSubview:line2];
        
        _orderIDLab = [[UILabel alloc] initWithFrame:CGRectMake(32, 15, TFScalePoint(200), 16)];
        _orderIDLab.font = [UIFont systemFontOfSize:13];
        _orderIDLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _orderIDLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_orderIDLab];
        
        _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(266), 15, 52, 16)];
        _statusLab.font = [UIFont systemFontOfSize:16];
        _statusLab.textColor = [UIColor colorWithRed:239.0/255.0
                                               green:80.0/255.0
                                                blue:12.0/255.0
                                               alpha:1.0];
        _statusLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_statusLab];
        
        _descLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, TFScalePoint(260), 44)];
        _descLab.font = [UIFont systemFontOfSize:16];
        _descLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _descLab.lineBreakMode = NSLineBreakByCharWrapping;
        _descLab.numberOfLines = 2;
        _descLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_descLab];
        
        _countLab = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(260)+24, 78, 34, 20)];
        _countLab.font = [UIFont boldSystemFontOfSize:18];
        _countLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _countLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_countLab];
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(132, 132, ScreenRect.size.width-142, 16)];
        _priceLab.font = [UIFont systemFontOfSize:15];
        _priceLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _priceLab.textAlignment = NSTextAlignmentRight;
        _priceLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_priceLab];
        
        _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(120, 158, ScreenRect.size.width-130, 16)];
        _pointLab.font = [UIFont systemFontOfSize:15];
        _pointLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _pointLab.textAlignment = NSTextAlignmentRight;
        _pointLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_pointLab];
//        
//        _pointStatusLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 44, 110, 16)];
//        _pointStatusLab.font = [UIFont systemFontOfSize:12];
//        _pointStatusLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
//        _pointStatusLab.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_pointStatusLab];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark setter/getter
- (void)setOrderInfo:(HYGroupOrderInfo *)orderInfo
{
    if (orderInfo != _orderInfo)
    {
        _orderInfo = orderInfo;
        
        self.orderIDLab.text = [NSString stringWithFormat:@"订单编号%@", orderInfo.thirdOrderId];
        self.descLab.text = orderInfo.orderDetail.itemName;
        self.statusLab.text = orderInfo.orderStatus;
        self.countLab.text = [NSString stringWithFormat:@"x%@", orderInfo.orderDetail.itemNumber];
        
        //price
        if ([self.priceLab respondsToSelector:@selector(setAttributedText:)])
        {
            NSString *priceDesc = [NSString stringWithFormat:@"订单总额:¥%.2f元", orderInfo.orderAmount];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceDesc];
            
            [attributedString addAttribute:NSFontAttributeName
                                     value:[UIFont systemFontOfSize:13.0]
                                     range:NSMakeRange(0, 5)];
            
            [attributedString addAttribute:NSFontAttributeName
                                     value:[UIFont systemFontOfSize:15.0]
                                     range:NSMakeRange(5, attributedString.length-6)];
            
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor colorWithRed:161.0/255.0
                                                           green:0
                                                            blue:0
                                                           alpha:1.0]
                                     range:NSMakeRange(5, attributedString.length-6)];
            
            [attributedString addAttribute:NSFontAttributeName
                                     value:[UIFont systemFontOfSize:13.0]
                                     range:NSMakeRange(attributedString.length-1, 1)];
            
            [self.priceLab setAttributedText:attributedString];
        }
        else
        {
            NSString *priceDesc = [NSString stringWithFormat:@"¥%.2f起", orderInfo.orderAmount];
            self.priceLab.text = priceDesc;
        }
        
        //point
        self.pointLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        NSString *priceDesc = [NSString stringWithFormat:@"赠送现金券数:%d", orderInfo.points];
        if (!orderInfo.whetherTebi && orderInfo.points>0 && ([self.pointLab respondsToSelector:@selector(setAttributedText:)]))
        {
            priceDesc = [NSString stringWithFormat:@"%@(待赠送)", priceDesc];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceDesc];
            
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor colorWithRed:161.0/255.0
                                                           green:0
                                                            blue:0
                                                           alpha:1.0]
                                     range:NSMakeRange(attributedString.length-5, 5)];
            
            [self.pointLab setAttributedText:attributedString];
        }
        else
        {
            
            self.pointLab.text = priceDesc;
        }
    }
}

@end
