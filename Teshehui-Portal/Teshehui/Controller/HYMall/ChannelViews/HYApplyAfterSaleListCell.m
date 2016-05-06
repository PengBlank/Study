//
//  HYApplyAfterSaleListCell.m
//  Teshehui
//
//  Created by Kris on 15/10/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYApplyAfterSaleListCell.h"
#import "UIImageView+WebCache.h"

@interface HYApplyAfterSaleListCell ()
{
    UIImageView *_imageView;
    UILabel *_priceLab;
    UILabel *_pointLab;
    
    UILabel *_quantityLab;
    UILabel *_specLab;
    
    UIButton *_salesServiceBtn;  //售后服务
}
@end

@implementation HYApplyAfterSaleListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _specLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 40, TFScalePoint(120), 16)];
        _specLab.font = [UIFont systemFontOfSize:12];
        _specLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _specLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_specLab];
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 60, TFScalePoint(130), 16)];
        _priceLab.font = [UIFont systemFontOfSize:12];
        _priceLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _priceLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_priceLab];
        
        _quantityLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLab.frame), 60, 120, 16)];
        _quantityLab.font = [UIFont systemFontOfSize:12];
        _quantityLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _quantityLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_quantityLab];
        
        _salesServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _salesServiceBtn.frame = CGRectMake(ScreenRect.size.width-80, 80, 70, 30);
        [_salesServiceBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_salesServiceBtn setTitleColor:[UIColor blackColor]
                               forState:UIControlStateNormal];
        [_salesServiceBtn addTarget:self
                             action:@selector(didRequestSalesService:)
                   forControlEvents:UIControlEventTouchUpInside];
        [_salesServiceBtn setBackgroundImage:[[UIImage imageNamed:@"mall_afterSaleType"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [self.contentView addSubview:_salesServiceBtn];

        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:10.];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(84, 10, 230, 34);
}

- (void)didRequestSalesService:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didRequestReturnGoods:withOrderCode:)])
    {
        [self.delegate didRequestReturnGoods:self.returnOrder withOrderCode:_goodsInfo.orderCode];
    }
}

#pragma mark setter/getter
- (void)setReturnOrder:(HYMallOrderItem *)returnOrder
{
    _returnOrder = returnOrder;
    
    self.textLabel.text = returnOrder.productName;
    NSNumber *pPrice = [NSNumber numberWithFloat:returnOrder.price.floatValue];
    _priceLab.text = [NSString stringWithFormat:@"价格:¥%@+%@现金券", pPrice,returnOrder.points];
   
    _quantityLab.text = [NSString stringWithFormat:@"数量：%ld", returnOrder.quantity];
    _specLab.text = returnOrder.specification;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:returnOrder.thumbnailPicUrl]
                  placeholderImage:nil];
    
    [_salesServiceBtn setTitle:@"申请售后" forState:UIControlStateNormal];
    [_salesServiceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_salesServiceBtn setEnabled:returnOrder.isCanApplyAfterSale ? YES:NO];
}

-(void)setGoodsInfo:(HYMallChildOrder *)goodsInfo
{
    _goodsInfo = goodsInfo;
}

@end
