//
//  HYChannelMoreProductView.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChannelMoreProductView.h"
#import "HYMallChannelGoods.h"
#import "UIColor+hexColor.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface HYChannelMoreProductView ()
@property (nonatomic, strong) UIImageView *productImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *priceLab;
@end

@implementation HYChannelMoreProductView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.borderColor = [UIColor colorWithWhite:.83 alpha:1].CGColor;
        self.layer.borderWidth = 0.5;
        self.backgroundColor = [UIColor whiteColor];
        
        self.productImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.productImg.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.productImg];
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nameLab.font = [UIFont systemFontOfSize:14.0];
        self.nameLab.backgroundColor = [UIColor clearColor];
        self.nameLab.textColor = [UIColor colorWithHexColor:@"555555" alpha:1];
        self.nameLab.numberOfLines = 2;
        [self addSubview:self.nameLab];
        
        self.priceLab = [[UILabel alloc] initWithFrame:CGRectZero];
        self.priceLab.font = [UIFont systemFontOfSize:13.0];
        self.priceLab.backgroundColor = [UIColor clearColor];
        [self addSubview:self.priceLab];
        
        //layout
        [self.productImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.equalTo(_productImg.mas_width).multipliedBy(1.24);
        }];
        
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.productImg.mas_bottom).offset(8);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
        
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLab.mas_bottom).offset(3);
            make.left.equalTo(self.nameLab);
            make.right.equalTo(self.nameLab);
        }];
    }
    return self;
}

- (void)setItem:(HYMallChannelGoods *)item
{
    if (item != _item)
    {
        _item = item;
        self.nameLab.text = item.productName;
        
        if (item.tshPrice.length > 0 && item.points.length > 0)
        {
            NSString *price = [NSString stringWithFormat:@"¥%0.2f", item.marketPrice.floatValue];
            NSString *point = [NSString stringWithFormat:@"现金券可抵%ld元", (long)item.points.integerValue];
            NSString *total = [NSString stringWithFormat:@"%@  %@", price, point];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:total];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexColor:@"d91512" alpha:1] range:NSMakeRange(0, price.length)];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, price.length)];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:74/255.0 green:140/255.0 blue:230/255.0 alpha:1.0f] range:NSMakeRange(price.length+2, point.length)];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(price.length+2, point.length)];
            self.priceLab.attributedText = attr;
            
        }
        else {
            self.priceLab.text = nil;
        }
        if (item.pictureUrl != nil)
        {
            NSURL *url = [NSURL URLWithString:item.pictureUrl];
            [_productImg sd_setImageWithURL:url
                           placeholderImage:[UIImage imageNamed:@"loading"]];
        }
        else {
            _productImg.image = nil;
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
