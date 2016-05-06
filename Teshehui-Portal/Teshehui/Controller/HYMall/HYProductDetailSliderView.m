//
//  HYProductDetailSliderView.m
//  Teshehui
//
//  Created by Kris on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYProductDetailSliderView.h"
#import "Masonry.h"

@interface HYProductDetailSliderView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HYProductDetailSliderView

-(instancetype)init
{
    if (self = [super init])
    {
        // 0.添加侧拉提示
        WS(weakSelf);
        UILabel *label = [[UILabel alloc]init];
        label.text = @"继续滑动查看图文详情";
        label.textColor = [UIColor darkGrayColor];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 250));
            make.right.equalTo(weakSelf.mas_right).with.offset(0);
            make.centerY.equalTo(weakSelf);
        }];
        self.titleLabel = label;
        
        UIImageView *arrow = [[UIImageView alloc]init];
        NSString *resourcePath = [[NSBundle mainBundle]resourcePath];
        arrow.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/productDetail_slider.png",resourcePath]];
        [self addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left).with.offset(-5);
            make.size.mas_equalTo(CGSizeMake(30, 30));
//            make.top.equalTo(weakSelf.mas_top).with.offset(100);
            make.centerY.equalTo(weakSelf);
        }];
        self.imgView = arrow;
    }
    return self;
}

- (void)changeArrow
{
    [UIView animateWithDuration:.3 animations:^{
        self.titleLabel.text = @"释放滑动查看图文详情";
        CGAffineTransform at = CGAffineTransformMakeRotation(M_PI);
        self.imgView.transform = at;
    }];
}

- (void)restoreArrow
{
    [UIView animateWithDuration:.3 animations:^{
        self.titleLabel.text = @"继续滑动查看图文详情";
        self.imgView.transform = CGAffineTransformIdentity;
    }];
}



@end
