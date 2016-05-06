//
//  HYMallOrderListGoodsCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderListGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "HYMallOrderSummary.h"
#import "HYUserInfo.h"

#import "HYMallReturnsInfo.h"

@interface HYMallOrderListGoodsCell ()
{
    UIImageView *_imageView;
    UILabel *_priceLab;
    UILabel *_pointLab;
    UILabel *_quantityLab;
    UILabel *_specLab;  //规格
    
    UILabel *_childOrderCodeLabel;
    UILabel *_childOrderStatusLabel;
    UILabel *_totalFeeLabel;
    
    UIButton *_salesServiceBtn;  //售后服务
    
    UIImageView *_indicator;
}
@end

@implementation HYMallOrderListGoodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithRed:249.0/256.0
                                                           green:251.0/253.0
                                                            blue:253.0/256.0 alpha:1.0f];
        
        _childOrderCodeLabel = [UILabel new];
        _childOrderCodeLabel.frame = CGRectMake(70, 10, 250, 15);
        _childOrderCodeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_childOrderCodeLabel];
        
        _childOrderStatusLabel = [UILabel new];
        _childOrderStatusLabel.frame = CGRectMake(70, 30, 250, 15);
        _childOrderStatusLabel.font = [UIFont systemFontOfSize:13];
        _childOrderStatusLabel.text = [NSString
                                       stringWithFormat:@"状态："];
        [self.contentView addSubview:_childOrderStatusLabel];
        
        _totalFeeLabel = [UILabel new];
        _totalFeeLabel.frame = CGRectMake(70, 50, 250, 15);
        _totalFeeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_totalFeeLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(210), 10, 100, 16)];
        _priceLab.font = [UIFont systemFontOfSize:14];
        _priceLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_priceLab];
        
        _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(210), 28, 100, 16)];
        _pointLab.font = [UIFont systemFontOfSize:14];
        _pointLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_pointLab];
        
        _quantityLab = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(220), 46, 90, 16)];
        _quantityLab.font = [UIFont systemFontOfSize:14];
        _quantityLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _quantityLab.backgroundColor = [UIColor clearColor];
        _quantityLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_quantityLab];
        
        _specLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 46, 140, 16)];
        _specLab.font = [UIFont systemFontOfSize:14];
        _specLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _specLab.backgroundColor = [UIColor clearColor];
        _specLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_specLab];

        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:10.];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textLabel.numberOfLines = 0;
        
        self.imageView.clipsToBounds = YES;
        
        UIImage *arrIcon = [UIImage imageNamed:@"cell_indicator"];
        UIImageView *arrView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-10 - 7, self.frame.size.height/2 - 6, 7, 12)];
        arrView.image = arrIcon;
        arrView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:arrView];
        _indicator = arrView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(84, 10, TFScalePoint(140), 34);
}

#pragma mark - private methods
- (void)handleIndemnity:(id)sender
{
    if (self.showReturnGoods)
    {
        if ([self.delegate respondsToSelector:@selector(didRequestReturnGoods: inOrder:)])
        {
            [self.delegate didRequestReturnGoods:self.goodsInfo inOrder:self.order];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(didHandleIndemnity:inOrder:)])
        {
            [self.delegate didHandleIndemnity:self.goodsInfo inOrder:self.order];
        }
    }
}

#pragma mark setter/getter
- (void)setGoodsInfo:(HYMallOrderItem *)goodsInfo
{
    _goodsInfo = goodsInfo;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:goodsInfo.pictureMiddleUrl]
                  placeholderImage:nil];
}

-(void)setChildOrderInfo:(HYMallChildOrder *)childOrderInfo
{
    _childOrderInfo = childOrderInfo;
    
    //根据子订单的个数创建label
    if (_childOrderInfo.orderCode)
    {
        _childOrderCodeLabel.text = [NSString
                                     stringWithFormat:@"子订单：%@",_childOrderInfo.orderCode];
    }
    if (_childOrderInfo.orderShowStatus)
    {
        _childOrderStatusLabel.text = [NSString
                                     stringWithFormat:@"状态：%@",_childOrderInfo.orderShowStatus];
    }
    if (_childOrderInfo.orderActualAmount
        && _childOrderInfo.orderTbAmount)
    {
        _totalFeeLabel.text = [NSString
                               stringWithFormat:@"金额：￥%@+%@现金券(含运费)",_childOrderInfo.orderActualAmount,_childOrderInfo.orderTbAmount];
    }

}

@end
