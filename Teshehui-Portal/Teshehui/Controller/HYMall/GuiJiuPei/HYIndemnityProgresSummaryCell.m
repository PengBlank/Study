//
//  HYIndemnityProgresSummaryCell.m
//  Teshehui
//
//  Created by Fei Wang on 15-3-31.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYIndemnityProgresSummaryCell.h"
#import "HYMallOrderItem.h"
#import "UIImageView+WebCache.h"

@interface HYIndemnityProgresSummaryCell ()
{
    UIImageView *_imageView;
    UILabel *_priceLab;
    UILabel *_quantityLab;
    UILabel *_specLab;  //规格
    
    UIButton *_checkDetailBtn;  //查看详情
}

@end

@implementation HYIndemnityProgresSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 46, TFScalePoint(216), 16)];
        _priceLab.font = [UIFont systemFontOfSize:14];
        _priceLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_priceLab];
        
        _quantityLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 66, 90, 16)];
        _quantityLab.font = [UIFont systemFontOfSize:14];
        _quantityLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _quantityLab.backgroundColor = [UIColor clearColor];
        _quantityLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_quantityLab];
        
        _specLab = [[UILabel alloc] initWithFrame:CGRectMake(84, 86, 140, 16)];
        _specLab.font = [UIFont systemFontOfSize:14];
        _specLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _specLab.backgroundColor = [UIColor clearColor];
        _specLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_specLab];
        
        _checkDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkDetailBtn.frame = CGRectMake(84, 100, 120, 36);
        [_checkDetailBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_checkDetailBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_checkDetailBtn setTitle:@"查看上传详情" forState:UIControlStateNormal];
        [_checkDetailBtn setTitleColor:[UIColor colorWithRed:218.0/255.0
                                                        green:0
                                                         blue:0
                                                        alpha:1.0]
                               forState:UIControlStateNormal];
        [_checkDetailBtn addTarget:self
                             action:@selector(checkIndemnityDetail:)
                   forControlEvents:UIControlEventTouchUpInside];
        [_checkDetailBtn setBackgroundImage:[[UIImage imageNamed:@"g_btn_checkinfo"] stretchableImageWithLeftCapWidth:4
                                                                                                         topCapHeight:6]
                                   forState:UIControlStateNormal];
        [self.contentView addSubview:_checkDetailBtn];
        
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:10.];
        self.textLabel.font = [UIFont systemFontOfSize:14];
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
    self.textLabel.frame = CGRectMake(84, 10, TFScalePoint(216), 34);
    
    if (!_specLab.text.length)
    {
        _checkDetailBtn.frame = CGRectMake(84, 96, 120, 36);
    }
    else
    {
        _checkDetailBtn.frame = CGRectMake(84, 106, 120, 36);
    }
}

#pragma mark - private methods
- (void)checkIndemnityDetail:(id)sneder
{
    if ([self.delegate respondsToSelector:@selector(checkIndemnityDetail)])
    {
        [self.delegate checkIndemnityDetail];
    }
}

#pragma mark - setter/getter
- (void)setGoodsInfo:(HYMallOrderItem *)goodsInfo
{
    if (goodsInfo != _goodsInfo)
    {
        _goodsInfo = goodsInfo;
        
        self.textLabel.text = goodsInfo.productName;
        _priceLab.text = [NSString stringWithFormat:@"会员价: ¥%@+%ld现金券", @(goodsInfo.price.floatValue), goodsInfo.points.integerValue];
        _quantityLab.text = [NSString stringWithFormat:@"购买数量: %ld", goodsInfo.quantity];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:goodsInfo.pictureBigUrl]
                      placeholderImage:nil];
        _specLab.text = goodsInfo.specification;
    }
}


@end
