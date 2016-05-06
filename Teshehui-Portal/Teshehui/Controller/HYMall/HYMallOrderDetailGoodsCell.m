//
//  HYMallOrderDetailGoodsCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderDetailGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "HYMallReturnsInfo.h"

@interface HYMallOrderDetailGoodsCell ()
{
    UIImageView *_imageView;
    UILabel *_priceLab;
    UILabel *_pointLab;
    
    UILabel *_quantityLab;
    UILabel *_specLab;
    
    UIButton *_salesServiceBtn;  //售后服务
    
    UIImageView *_abroadBuyTagImg;
}
@end

@implementation HYMallOrderDetailGoodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        UIImageView *abroadBuyTagImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 25)];
        abroadBuyTagImg.image = [UIImage imageNamed:@"icon_tag_abroadbuy"];
        _abroadBuyTagImg = abroadBuyTagImg;
        _abroadBuyTagImg.hidden = YES;
        [_imageView addSubview:abroadBuyTagImg];
    
//        _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenRect.size.width-140, 44, 120, 16)];
//        _pointLab.font = [UIFont systemFontOfSize:12];
//        _pointLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
//        _pointLab.backgroundColor = [UIColor clearColor];
//        _pointLab.textAlignment = NSTextAlignmentRight;
//        [self.contentView addSubview:_pointLab];
        _specLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 50, TFScalePoint(200), 16)];
        _specLab.font = [UIFont systemFontOfSize:12];
        _specLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _specLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_specLab];
 
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 70, TFScalePoint(150), 16)];
        _priceLab.font = [UIFont systemFontOfSize:12];
        _priceLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _priceLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_priceLab];
        
        _quantityLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLab.frame), 70, 120, 16)];
        _quantityLab.font = [UIFont systemFontOfSize:12];
        _quantityLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _quantityLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_quantityLab];
      
        _salesServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _salesServiceBtn.frame = CGRectMake(ScreenRect.size.width-130, 90, 110, 30);
        _salesServiceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_salesServiceBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_salesServiceBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_salesServiceBtn setTitleColor:[UIColor blackColor]
                               forState:UIControlStateNormal];
        [_salesServiceBtn addTarget:self
                             action:@selector(didRequestSalesService:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_salesServiceBtn];
        
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
    self.textLabel.frame = CGRectMake(84, 10, 230, 34);
}

- (void)didRequestSalesService:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didRequestGuijiupei:)])
    {
        [self.delegate didRequestGuijiupei:self.goodsInfo];
    }
}

#pragma mark setter/getter
- (void)setGoodsInfo:(HYMallOrderItem *)goodsInfo
{
    if (goodsInfo != _goodsInfo)
    {
        _goodsInfo = goodsInfo;
        self.textLabel.text = goodsInfo.productName;
        NSNumber *pPrice = [NSNumber numberWithFloat:goodsInfo.price.floatValue];
        _priceLab.text = [NSString stringWithFormat:@"价格:¥%@+%@现金券", pPrice,goodsInfo.points];
        _quantityLab.text = [NSString stringWithFormat:@"数量：%ld", (long)goodsInfo.quantity];
        _specLab.text = goodsInfo.specification;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:goodsInfo.pictureMiddleUrl]
                      placeholderImage:nil];
        
        switch (_goodsInfo.isCanApplyGuijiupei)
        {
            case 0:
                [_salesServiceBtn setHidden:YES];
                break;
            case 1:
            {
                [_salesServiceBtn setHidden:NO];
                NSString *str = @"申请贵就赔";
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
                [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, str.length)];
                [_salesServiceBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
                break;
            }
            case 2:
            {
                [_salesServiceBtn setHidden:NO];
                NSString *str = @"查看申赔进度";
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
                [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, str.length)];
                [_salesServiceBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
                break;
            }
            default:
                break;
        }
    }
    
    
//    switch (goodsInfo.returnable)
//    {
//        case 0:  //不可申请
//            [_salesServiceBtn setHidden:YES];
//            break;
//        case 1:  //可申请
//            [_salesServiceBtn setHidden:NO];
//            [_salesServiceBtn setTitle:@"申请售后" forState:UIControlStateNormal];
//            break;
//        case 2:  //退换货进行中
//            [_salesServiceBtn setHidden:NO];
//            [_salesServiceBtn setTitle:@"售后处理中" forState:UIControlStateNormal];
//            break;
//        case 3:  //退换货已完成
//            [_salesServiceBtn setHidden:NO];
//            [_salesServiceBtn setTitle:@"售后完成" forState:UIControlStateNormal];
//            break;
//        default:
//            break;
//    }
}

- (void)setIsSears:(NSInteger)isSears
{
    _isSears = isSears;
    if (isSears == 1)
    {
        _abroadBuyTagImg.hidden = NO;
    }
    else
    {
        _abroadBuyTagImg.hidden = YES;
    }
}

@end
