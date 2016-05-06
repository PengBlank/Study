//
//  HYMallHomeBrandView.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeBrandView.h"
#import "Masonry.h"
#import "UIColor+hexColor.h"
#import "UIImageView+WebCache.h"

CGSize CGSizeAspectFit(CGSize aspectRatio, CGSize boundingSize)
{
    float mW = boundingSize.width / aspectRatio.width;
    float mH = boundingSize.height / aspectRatio.height;
    if( mH < mW )
        boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width;
    else if( mW < mH )
        boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height;
    return boundingSize;
}

@interface HYMallHomeBrandView ()

@property (nonatomic, strong) UIImageView *productImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *priceLab;

@end

@implementation HYMallHomeBrandView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectZero];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(8);
            make.right.mas_equalTo(8);
            make.bottom.mas_equalTo(-42.5);
        }];
        self.productImg = img;
        self.productImg.image = [UIImage imageNamed:@"loading"];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectZero];
        name.font = [UIFont systemFontOfSize:13.0];
        name.textColor = [UIColor  colorWithHexColor:@"555555" alpha:1];
        name.backgroundColor = [UIColor clearColor];
        name.textAlignment = NSTextAlignmentCenter;
        [self addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(img.mas_left);
            make.right.equalTo(img.mas_right);
            make.top.equalTo(img.mas_bottom).offset(8);
        }];
        self.nameLab = name;
        self.nameLab.text = @"NIKE夏季...";
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectZero];
        price.font = [UIFont systemFontOfSize:12.0];
        price.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        price.backgroundColor = [UIColor clearColor];
        price.textAlignment = NSTextAlignmentCenter;
        [self addSubview:price];
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(name.mas_left);
            make.right.equalTo(name.mas_right);
            make.top.equalTo(name.mas_bottom).offset(2);
        }];
        self.priceLab = price;
    }
    return self;
}


- (void)setItem:(HYMallHomeItem *)item
{
    if (item != _item)
    {
        _item = item;
        self.nameLab.text = item.name;
        
        if (item.points.length > 0 && item.price.length > 0)
        {
            NSString *price = [NSString stringWithFormat:@"¥%0.2f", item.marketPrice.floatValue];
            NSString *point = [NSString stringWithFormat:@"-%ld现金券", (long)item.points.integerValue];
            NSString *total = [NSString stringWithFormat:@"%@%@", price, point];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:total];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexColor:@"d91512" alpha:1] range:NSMakeRange(0, price.length)];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexColor:@"888888" alpha:1] range:NSMakeRange(price.length, point.length)];
            self.priceLab.attributedText = attr;
            
        }
        if (item.pictureUrl != nil)
        {
            
            NSURL *url = [NSURL URLWithString:item.pictureUrl];
            __weak typeof(_productImg) imageview = _productImg;
            [_productImg sd_setImageWithURL:url
                           placeholderImage:[UIImage imageNamed:@"loading"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      if (image)
                                      {
                                          UIView *mask = [[UIView alloc] initWithFrame:imageview.bounds];
                                          mask.backgroundColor = [UIColor blackColor];
                                          mask.alpha = 0.3;
                                          [imageview addSubview:mask];
                                          
                                          UIImage *icon = [UIImage imageNamed:@"home_mask"];
                                          UIImageView *iconv = [[UIImageView alloc] initWithImage:icon];
                                          iconv.center = mask.center;
                                          [imageview addSubview:iconv];
                                      }
                           }];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
