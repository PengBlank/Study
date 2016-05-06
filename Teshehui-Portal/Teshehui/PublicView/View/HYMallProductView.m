//
//  HYMallProductView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallProductView.h"
#import "UIImageView+WebCache.h"
#import "HYShengView.h"


@interface HYMallProductView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *stockView;
@property (nonatomic, strong) UIImageView *cameraView;
// 需求变更，原来省图标换成现金券抵用文字
//@property (nonatomic, strong) HYShengView *sheng;
@property (nonatomic, strong) UILabel *stockLabel;
@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *pointLabel;


@end

@implementation HYMallProductView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:TFRectMake(10, 0, 135, 170)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        //        _brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 180, 152, 30)];
        //        _brandLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        //        _brandLabel.backgroundColor = [UIColor clearColor];
        //        [_brandLabel setFont:[UIFont systemFontOfSize:14]];
        //        _brandLabel.lineBreakMode = NSLineBreakByCharWrapping;
        //        _brandLabel.numberOfLines = 0;
        //        _brandLabel.textAlignment = NSTextAlignmentCenter;
        //        [self addSubview:_brandLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:
                       CGRectMake(4, TFScalePoint(170), TFScalePoint(152), 36)];
        _titleLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:
                       CGRectMake(4, TFScalePoint(213), TFScalePoint(152), TFScalePoint(20))];
        _priceLabel.backgroundColor = [UIColor clearColor];
//        _priceLabel.backgroundColor = [UIColor orangeColor];
        [_priceLabel setFont:[UIFont systemFontOfSize:16]];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_priceLabel];
        
        _pointLabel = [[UILabel alloc] initWithFrame:
                       CGRectMake(10, TFScalePoint(213), TFScalePoint(152), TFScalePoint(17))];
//        _pointLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_pointLabel];
        
        _cameraView = [[UIImageView alloc]initWithFrame:
                       CGRectMake(TFScalePoint(130), TFScalePoint(140), 20, 20)];
        _cameraView.image = [UIImage imageNamed:@"home_video"];
        _cameraView.hidden = YES;
        [self addSubview:_cameraView];
        
//        需求变更，原来省图标换成现金券抵用文字
//        _sheng = [[HYShengView alloc] initWithDirection:HYShengLeft height:TFScalePoint(20)];
//        _pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(28), TFScalePoint(0), TFScalePoint(152), TFScalePoint(17))];
//        _pointLabel.textColor = [UIColor colorWithRed:0.18 green:0.45 blue:0.89 alpha:1.0f];
//        _pointLabel.backgroundColor = [UIColor clearColor];
//        [_pointLabel setFont:[UIFont systemFontOfSize:15]];
//        _pointLabel.textAlignment = NSTextAlignmentLeft;
//        [_sheng addSubview:_pointLabel];
//        [self addSubview:_sheng];
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

#pragma mark setter/getter
- (UIImageView *)stockView
{
    if (!_stockView)
    {
        _stockView = [[UIImageView alloc] initWithFrame:TFRectMake(120, 10, 30, 30)];
        
        _stockLabel = [[UILabel alloc] initWithFrame:TFRectMake(4, 4, 20, 24)];
        _stockLabel.backgroundColor = [UIColor clearColor];
        [_stockLabel setFont:[UIFont systemFontOfSize:10]];
        _stockLabel.textAlignment = NSTextAlignmentCenter;
        _stockLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _stockLabel.numberOfLines = 2;
        [_stockView addSubview:_stockLabel];
        
        [self addSubview:_stockView];
    }
    
    return _stockView;
}

- (void)setWithProductListSummaryData:(HYProductListSummary *)data
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:data.productPicUrl]
                  placeholderImage:[UIImage imageNamed:@"logo_loading"]];
    _titleLabel.text = data.productName;
    
    if (data.stock < 10)
    {
        [self.stockView setHidden:NO];
        
        if (data.stock > 0)
        {
            self.stockView.image = [UIImage imageNamed:@"stock_icon"];
            _stockLabel.textColor = [UIColor whiteColor];
            _stockLabel.text = [NSString stringWithFormat:@"剩余%ld件", (long)data.stock];
        }
        else
        {
            self.stockView.image = [UIImage imageNamed:@"stock_icon_gray"];
            _stockLabel.textColor = [UIColor blackColor];
            _stockLabel.text = @"卖光了";//@"售罄";
        }
    }
    else
    {
        [_stockView setHidden:YES];
    }
    NSString *priceText = [NSString stringWithFormat:@"￥%@", data.marketPrice];
    _priceLabel.textColor = [UIColor redColor];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    CGSize priceSize = [priceText sizeWithFont:[UIFont systemFontOfSize:14]];
    _priceLabel.frame = CGRectMake(4, TFScalePoint(213), priceSize.width, priceSize.height);
    _priceLabel.text = priceText;
    
    NSString *pointText = [NSString stringWithFormat:@"现金券可抵%ld元", (long)data.points];
    _pointLabel.textColor = [UIColor colorWithRed:80/255.0 green:140/255.0 blue:230/255.0 alpha:1.0f];
    _pointLabel.font = [UIFont systemFontOfSize:11];
    CGSize pointSize = [pointText sizeWithFont:[UIFont systemFontOfSize:11]];
//    _pointLabel.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame)+5, TFScalePoint(215), pointSize.width, pointSize.height);
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-22)/2 - CGRectGetMaxX(_priceLabel.frame)+5;
    _pointLabel.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame)+5, TFScalePoint(215), width, pointSize.height);
    _pointLabel.text = pointText;
//    CGSize priceSize = [_priceLabel sizeThatFits:CGSizeZero];
//    [_sheng setPoint:CGPointMake(CGRectGetMaxX(_imageView.frame), TFScalePoint(211)) maxWidth:self.frame.size.width-(CGRectGetMinX(_priceLabel.frame)+priceSize.width+20)];
//    _sheng.sheng = [NSString stringWithFormat:@"%ld", (long)data.points];
    
    if ([data.productVideoUrl length] > 0)
    {
        _cameraView.hidden = NO;
    }else _cameraView.hidden = YES;
}

- (void)setWithHomeItem:(HYMallHomeItem *)data
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:data.pictureUrl]
                  placeholderImage:[UIImage imageNamed:@"logo_loading"]];
    _titleLabel.text = data.name;
    
    _stockView.hidden = YES;
    //    if (data.stock < 10)
    //    {
    //        [self.stockView setHidden:NO];
    //
    //        if (data.stock > 0)
    //        {
    //            self.stockView.image = [UIImage imageNamed:@"stock_icon"];
    //            _stockLabel.textColor = [UIColor whiteColor];
    //            _stockLabel.text = [NSString stringWithFormat:@"剩余%d件", data.stock];
    //        }
    //        else
    //        {
    //            self.stockView.image = [UIImage imageNamed:@"stock_icon_gray"];
    //            _stockLabel.textColor = [UIColor blackColor];
    //            _stockLabel.text = @"卖光了";//@"售罄";
    //        }
    //    }
    //    else
    //    {
    //        [_stockView setHidden:YES];
    //    }
    
    NSString *priceText = [NSString stringWithFormat:@"￥%0.2f", data.marketPrice.floatValue];
    _priceLabel.textColor = [UIColor redColor];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    CGSize priceSize = [priceText sizeWithFont:[UIFont systemFontOfSize:14]];
    _priceLabel.frame = CGRectMake(4, TFScalePoint(213), priceSize.width, priceSize.height);
    _priceLabel.text = priceText;
    
    NSString *pointText = [NSString stringWithFormat:@"现金券可抵%ld元", (long)data.points.integerValue];
    _pointLabel.textColor = [UIColor colorWithRed:80/255.0 green:140/255.0 blue:230/255.0 alpha:1.0f];
    _pointLabel.font = [UIFont systemFontOfSize:11];
    CGSize pointSize = [pointText sizeWithFont:[UIFont systemFontOfSize:11]
                             constrainedToSize:CGSizeMake(self.frame.size.width-CGRectGetMaxX(_priceLabel.frame)-5, _pointLabel.font.lineHeight)];
    _pointLabel.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame)+5, TFScalePoint(215), pointSize.width, pointSize.height);
    _pointLabel.text = pointText;
//    CGSize priceSize = [_priceLabel sizeThatFits:CGSizeZero];
//    [_sheng setPoint:CGPointMake(CGRectGetMaxX(_imageView.frame), TFScalePoint(211)) maxWidth:self.frame.size.width-(CGRectGetMinX(_priceLabel.frame)+priceSize.width+20)];
//    _sheng.sheng = [NSString stringWithFormat:@"%ld", (long)data.points.integerValue];
}

- (void)setData:(id)data
{
    if (data != _data)
    {
        _data = data;
        if ([data isKindOfClass:[HYProductListSummary class]])
        {
            HYProductListSummary *summaryData = (HYProductListSummary *)data;
            [self setWithProductListSummaryData:summaryData];
        }
        else if ([data isKindOfClass:[HYMallHomeItem class]])
        {
            HYMallHomeItem *itemData = (HYMallHomeItem *)data;
            [self setWithHomeItem:itemData];
        }
    }
}

//- (void)setItem:(HYProductListSummary *)item
//{
//    if (_item != item)
//    {
//        _item = item;
//        [_imageView sd_setImageWithURL:[NSURL URLWithString:item.thumbnailURL]
//                      placeholderImage:[UIImage imageNamed:@"logo_loading"]];
//        _titleLabel.text = item.goods_name;
//
//        [_stockView setHidden:YES];
//
//        _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", item.price];
//        _pointLabel.text = [NSString stringWithFormat:@"消费%.0f现金券", item.points];
//    }
//}

@end
