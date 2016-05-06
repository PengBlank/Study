//
//  HYLuckyPrizeView.m
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyPrizeView.h"
#import "UIImage+Addition.h"
#import "UIImageView+WebCache.h"

@implementation HYLuckyPrizeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _levelView = [[UIImageView alloc] initWithFrame:TFRectMake(46, 0, 42, 14)];
        [self addSubview:_levelView];
        
        _prizeView = [[UIImageView alloc] initWithFrame:TFRectMake(10,
                                                                   18,
                                                                   115,
                                                                   75)];
        _prizeView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_prizeView];
        
        _nameLab = [[UILabel alloc] initWithFrame:TFRectMake(10, 92, 115, 30)];
        _nameLab.textColor = [UIColor whiteColor];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.font = [UIFont systemFontOfSize:TFScalePoint(12)];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.lineBreakMode = NSLineBreakByCharWrapping;
        _nameLab.numberOfLines = 2;
        [self addSubview:_nameLab];
        
        UIImageView *bottomView = [[UIImageView alloc] initWithFrame:TFRectMake(0,
                                                                                122,
                                                                                135,
                                                                                14)];
        bottomView.image = [[UIImage imageNamed:@"kj_img_info"] stretchableImageWithLeftCapWidth:10
                                                                                    topCapHeight:6];
        [self addSubview:bottomView];
        _priceLab = [[UILabel alloc] initWithFrame:TFRectMake(10, 0, 115, 12)];
        _priceLab.textColor = [UIColor blackColor];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.font = [UIFont systemFontOfSize:TFScalePoint(12)];
        _priceLab.textAlignment = NSTextAlignmentCenter;
        [bottomView addSubview:_priceLab];
    }
    
    return self;
}

#pragma mark setter/getter
- (void)setPrize:(HYLuckyPrize *)prize
{
    if (prize != _prize)
    {
        _prize = prize;
        
        switch (prize.prizeGrade.intValue)
        {
            case 1:
                [_levelView setImage:[UIImage imageWithNamedAutoLayout:@"kj_title7"]];
                break;
            case 2:
                [_levelView setImage:[UIImage imageWithNamedAutoLayout:@"kj_title8"]];
                break;
            case 3:
                [_levelView setImage:[UIImage imageWithNamedAutoLayout:@"kj_title9"]];
                break;
            case 4:
                [_levelView setImage:[UIImage imageWithNamedAutoLayout:@"kj_title10"]];
                break;
            case 5:
                [_levelView setImage:[UIImage imageWithNamedAutoLayout:@"kj_title11"]];
                break;
            case 6:
                [_levelView setImage:[UIImage imageWithNamedAutoLayout:@"kj_title12"]];
                break;
            default:
                break;
        }
        
        _nameLab.text = prize.prizeName;
        _priceLab.text = [NSString stringWithFormat:@"价格:%@现金券", prize.prizePrice];
        [_prizeView sd_setImageWithURL:[NSURL URLWithString:prize.prizeImage]
                     placeholderImage:[UIImage imageNamed:@"url_image_loading"]];
    }
}
@end
