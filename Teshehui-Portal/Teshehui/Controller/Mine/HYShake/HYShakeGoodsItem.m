//
//  HYShakeGoodsItem.m
//  Teshehui
//
//  Created by HYZB on 16/3/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYShakeGoodsItem.h"
#import "HYShakeViewModel.h"
#import "UIImageView+WebCache.h"
#import "HYShakeProductPOModel.h"

@interface HYShakeGoodsItem ()

@property (nonatomic, strong) UIImageView *goodsImg;
@property (nonatomic, strong) UILabel *desc;
@property (nonatomic, strong) UILabel *price;


@end

@implementation HYShakeGoodsItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        self.hidden = YES;
        [self setupContentView];
    }
    return self;
}

- (void)setupContentView
{
    UIImageView *goodsImg = [[UIImageView alloc] init];
    [self addSubview:goodsImg];
    _goodsImg = goodsImg;
    
    UILabel *desc = [[UILabel alloc] init];
    desc.numberOfLines = 0;
    _desc = desc;
    desc.font = [UIFont systemFontOfSize:13];
    [self addSubview:desc];
    
    UILabel *price = [[UILabel alloc] init];
    _price = price;
    [self addSubview:price];
    
    CGFloat btnY = CGRectGetMaxY(price.frame)+10;
    // 246 61 82
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake(self.center.x-50, btnY, 100, 40);
    [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    detailBtn.layer.cornerRadius = 6;
    detailBtn.backgroundColor = [UIColor colorWithRed:246/255.0f green:61/255.0f blue:82/255.0f alpha:1.0f];
    [self addSubview:detailBtn];
    _detailBtn = detailBtn;
}

- (void)layoutSubviews
{
    CGFloat x = (CGRectGetWidth(self.frame)-180)/2;
    CGFloat y = 10;
    CGFloat width = 180;
    CGFloat height = 150;
    _goodsImg.frame = CGRectMake(x, y, width, height);
    
    CGFloat labelX = CGRectGetMinX(_goodsImg.frame);
    _desc.frame = CGRectMake(labelX, CGRectGetMaxY(_goodsImg.frame), CGRectGetWidth(_goodsImg.frame), 60);
    
    _price.frame = CGRectMake(labelX, CGRectGetMaxY(_desc.frame)+10, CGRectGetWidth(_goodsImg.frame), 20);
    
    CGFloat btnY = CGRectGetMaxY(_price.frame)+10;
    _detailBtn.frame = CGRectMake(self.center.x-50, btnY, 100, 40);
}

- (void)setShakeModel:(HYShakeViewModel *)shakeModel
{
    
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:shakeModel.imagePath] placeholderImage:[UIImage imageNamed:@"loading"]];
//    _goodsImg.backgroundColor = [UIColor redColor];
    
    _desc.text = shakeModel.shakeName;
//    _desc.backgroundColor = [UIColor grayColor];
//    _desc.text = @"MICHAEL KORS 新款单肩手提斜挎女包斜挎女包";
}

- (void)setProductModel:(HYShakeProductPOModel *)productModel
{
    _productModel = productModel;
    NSString *str = [NSMutableString stringWithFormat:@"￥%@  现金券可抵%@元", _productModel.marketPrice, _productModel.tb];
    NSString *prefixStr = [NSString stringWithFormat:@"￥%@", _productModel.marketPrice];
    NSString *subStr = [NSString stringWithFormat:@"  现金券可抵%@元", _productModel.tb];
    
    NSRange redRange = NSMakeRange(0, prefixStr.length);
    NSRange blueRange = NSMakeRange(prefixStr.length, subStr.length);
    
    NSMutableAttributedString *strA = [[NSMutableAttributedString alloc] initWithString:str];
//        NSMutableAttributedString *strA = [[NSMutableAttributedString alloc] initWithString:@"￥258  现金券可抵158元"];
    // 211 67 61
    [strA addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:211/255.0f green:67/255.0f blue:61/255.0f alpha:1.0f] range:redRange];
    // 60 148 242
    [strA addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:60/255.0f green:148/255.0f blue:242/255.0f alpha:1.0f] range:blueRange];
    _price.font = [UIFont systemFontOfSize:15];
    _price.attributedText = strA;
}

@end
