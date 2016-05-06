//
//  HYMallHomeShoppingPlaceCell.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallHomeShoppingPlaceCell.h"
#import "UIImageView+WebCache.h"

@implementation HYMallHomeShoppingPlaceCell
{
    @private
    UIImageView *_bannerView;
    UIView *_titleMask;
    UILabel *_titleLab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *bannerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, TFScalePoint(130))];
        [self.contentView addSubview:bannerView];
        _bannerView = bannerView;
        
        UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bannerView.frame)-25, frame.size.width, 25)];
        mask.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        [self.contentView addSubview:mask];
        _titleMask = mask;
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, frame.size.width-25, CGRectGetHeight(mask.frame))];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.font = [UIFont systemFontOfSize:13.0];
        [mask addSubview:titleLab];
        _titleLab = titleLab;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mask.frame), frame.size.width, 0.5)];
        line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setItem:(HYMallHomeItem *)item
{
    if (_item != item) {
        _item = item;
        [_bannerView sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                       placeholderImage:[UIImage imageNamed:@"loading"]];
        _titleLab.text = item.name;
    }
}

@end
