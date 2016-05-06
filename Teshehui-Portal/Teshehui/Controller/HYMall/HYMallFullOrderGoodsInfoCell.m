//
//  HYMallFullOrderGoodsInfoCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallFullOrderGoodsInfoCell.h"
#import "UIImageView+WebCache.h"

// 01   普通类型    06    海淘类型（String）
NSString *const kAbroadBuy = @"06";

@interface HYMallFullOrderGoodsInfoCell ()
{
    UIImageView *_imageView;
    UILabel *_priceLab;
    UILabel *_pointLab;
    
    UILabel *_tPriceLab;
    UILabel *_tPointLab;
    
    UILabel *_quantityLab;
    
    UIImageView *_abroadBuyTagImg;
}
@end

@implementation HYMallFullOrderGoodsInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        UIImageView *abroadBuyTagImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 25)];
        abroadBuyTagImg.image = [UIImage imageNamed:@"icon_tag_abroadbuy"];
        _abroadBuyTagImg = abroadBuyTagImg;
        _abroadBuyTagImg.hidden = YES;
        [_imageView addSubview:abroadBuyTagImg];
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 44, 110, 16)];
        _priceLab.font = [UIFont systemFontOfSize:12];
        _priceLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _priceLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_priceLab];
        
        _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenRect.size.width-120, 44, 100, 16)];
        _pointLab.font = [UIFont systemFontOfSize:12];
        _pointLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _pointLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_pointLab];
        
        _quantityLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 60, 120, 16)];
        _quantityLab.font = [UIFont systemFontOfSize:12];
        _quantityLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _quantityLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_quantityLab];
        
        UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(ScreenRect.size.width-120, 74, 30, 16)];
        total.font = [UIFont systemFontOfSize:12];
        total.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        total.backgroundColor = [UIColor clearColor];
        total.text = @"小计:";
        [self.contentView addSubview:total];
        
        _tPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenRect.size.width-88, 74, 80, 16)];
        _tPriceLab.font = [UIFont systemFontOfSize:12];
        _tPriceLab.textColor = [UIColor colorWithRed:161.0/255.0
                                               green:0
                                                blue:0
                                               alpha:1.0];
        _tPriceLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_tPriceLab];
        
        _tPointLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenRect.size.width-120, 90, 120, 16)];
        _tPointLab.font = [UIFont systemFontOfSize:12];
        _tPointLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _tPointLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_tPointLab];
        
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:10.];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(84, 10, self.frame.size.width-90, 34);
}

#pragma mark setter/getter
//- (void)setSupplierType:(NSString *)supplierType
//{
//    if ([supplierType isEqualToString:kAbroadBuy])
//    {
//        _abroadBuyTagImg.hidden = NO;
//    }
//    else
//    {
//        _abroadBuyTagImg.hidden = YES;
//    }
//}

- (void)setGoodsInfo:(HYMallCartProduct *)goodsInfo
{
    if (goodsInfo != _goodsInfo)
    {
        _goodsInfo = goodsInfo;
        self.textLabel.text = goodsInfo.productName;
        _priceLab.text = [NSString stringWithFormat:@"价格：¥%@", goodsInfo.salePrice];
        _pointLab.text = [NSString stringWithFormat:@"现金券：%@", goodsInfo.salePoints];
        _quantityLab.text = [NSString stringWithFormat:@"数量：%d", goodsInfo.quantity.intValue];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:goodsInfo.productSKUPicUrl]
                   placeholderImage:nil];
        
        NSInteger point = goodsInfo.subTotalPoints.integerValue;
        CGFloat price = goodsInfo.salePrice.floatValue * goodsInfo.quantity.integerValue;
        _tPointLab.text = [NSString stringWithFormat:@"消费现金券：%ld", point];
        _tPriceLab.text = [NSString stringWithFormat:@"¥%0.2f", price];
        
        if ([goodsInfo.supplierType isEqualToString:kAbroadBuy])
        {
            _abroadBuyTagImg.hidden = NO;
        }
        else
        {
            _abroadBuyTagImg.hidden = YES;
        }
    }
}

@end
