//
//  LocationErrorView.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "LocationErrorView.h"
#import "DefineConfig.h"
#import "UILabel+Common.h"
#import "UIColor+expanded.h"
#import "UIView+Frame.h"
#import "Masonry.h"
@implementation LocationErrorView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV setImage:IMAGE(@"noconnect")];
    [self addSubview:imageV];
    
    UILabel *titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor]];
    [titleLabel setText:@"无法搜索到您的位置"];
    [self addSubview:titleLabel];
    
    UILabel *desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"606060"]];
    [desLabel setText:@"请检查是否开启定位服务"];
    [self addSubview:desLabel];
    
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cityBtn setTitleColor:[UIColor colorWithHexString:@"606060"] forState:UIControlStateNormal];
    [cityBtn setTitle:@"选择所在城市" forState:UIControlStateNormal];
    [cityBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [cityBtn addTarget:self action:@selector(cityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cityBtn.layer setBorderWidth:0.5f];
    [cityBtn.layer setBorderColor:[UIColor colorWithHexString:@"606060"].CGColor];
    [self addSubview:cityBtn];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(100);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(imageV.mas_bottom).offset(20);
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
    }];
    
    [cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(desLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
}

- (void)cityBtnClick:(UIButton *)btn{
    
    if (_selectCityBlock) {
        _selectCityBlock(btn);
    }
}

@end
