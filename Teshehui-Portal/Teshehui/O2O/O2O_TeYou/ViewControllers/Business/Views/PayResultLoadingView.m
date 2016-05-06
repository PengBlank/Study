//
//  PayResultLoadingView.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "PayResultLoadingView.h"
#import "UILabel+Common.h"
#import "UIColor+expanded.h"
#import "Masonry.h"

@interface PayResultLoadingView ()
{
    O2OPayType _type;
}
@end

@implementation PayResultLoadingView
- (instancetype)initWithFrame:(CGRect)frame payType:(O2OPayType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _type = type;
        [self setup];
    }
    return self;
}

- (void)setup{
   
    _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithHexString:@"0x259f00"]];
    [_titleLabel setText: _type == ScenePay ? @"正努力为你生成套餐消费码..." : @"正在付款中..."];
    [_titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:_titleLabel];
    
    _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"0x343434"]];
    [_desLabel setText:@"请稍等片刻"];
    [_desLabel setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:_desLabel];
    WS(weakSelf);
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(50);
    }];
    
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(15);
    }];

    
}
@end
