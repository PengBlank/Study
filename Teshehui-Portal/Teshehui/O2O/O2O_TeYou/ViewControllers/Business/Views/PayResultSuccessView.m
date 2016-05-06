//
//  PayResultSuccessView.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "PayResultSuccessView.h"
#import "UILabel+Common.h"
#import "UIColor+expanded.h"
#import "Masonry.h"
#import "UIImage+Common.h"

@interface PayResultSuccessView ()
{
    O2OPayType _type;
}
@end

@implementation PayResultSuccessView
- (instancetype)initWithFrame:(CGRect)frame payType:(O2OPayType)type
{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = UIColorFromRGB(245, 245, 245);
        _type = type;
        [self setup];
    }
    return self;
}

- (void)setup{
    
    UIView *topBgView = [[UIView alloc] init];
    [topBgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:topBgView];
    
    _storeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:17] textColor:[UIColor colorWithHexString:@"0x343434"]];
    [_storeLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_storeLabel];
    
    _priceLabel = [UILabel labelWithFont:g_fitSystemFontSize(@[@19,@20,@21]) textColor:[UIColor colorWithHexString:@"0xb80000"]];
    [_priceLabel setTextAlignment:NSTextAlignmentCenter];
    [topBgView addSubview:_priceLabel];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    _timeStr = [formatter stringFromDate:[NSDate date]];
    
    _timeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHexString:@"0x343434"]];
    [_timeLabel setTextAlignment:NSTextAlignmentCenter];

    [topBgView addSubview:_timeLabel];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:_type == ScenePay ? @"查看订单详情" : @"确定" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xb80000"]] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(kScreen_Width);
        make.height.mas_equalTo(50);
    }];
    
    
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@145);
    }];

    [_storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(topBgView.mas_top).offset(25);
        make.right.equalTo(self);
    }];

    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(_storeLabel.mas_bottom).offset(20);
        make.right.equalTo(self);
    }];

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(_priceLabel.mas_bottom).offset(20);
        make.right.equalTo(self);
    }];
    
    
    if (_type != ScenePay) {
        return;
    }
    
    UIView *bottomBgView = [[UIView alloc] init];
    [bottomBgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bottomBgView];
    
    _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"0x343434"]];
    [bottomBgView addSubview:_titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UIColor colorWithHexString:@"0xc7c7c7"]];
    [self addSubview:lineView];
    
    _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"0x343434"]];
    [bottomBgView addSubview:_desLabel];
    
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(topBgView.mas_bottom).offset(8);
        make.width.mas_equalTo(kScreen_Width);
        make.height.equalTo(@100);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(bottomBgView.mas_top).offset(18);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(bottomBgView.mas_top).offset(50);
        make.height.equalTo(@0.5);
    }];
    
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(bottomBgView.mas_bottom).offset(-18);
    }];
    
    
    UILabel  *tipLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"0x343434"]];
    [tipLabel setText:@"温馨提示："];
    [self addSubview:tipLabel];
    
    UILabel  *guideLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"0x343434"]];
    [guideLabel setAdjustsFontSizeToFitWidth:YES];
    [guideLabel setText:@"亲~您可以前往“我>我的订单>场景消费订单”查看！"];
    [self addSubview:guideLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_desLabel);
        make.top.equalTo(bottomBgView.mas_bottom).offset(15);
    }];
    
    [guideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_desLabel);
        make.right.equalTo(self);
        make.top.equalTo(tipLabel.mas_bottom).offset(10);
    }];
    
}

- (void)bindData:(NSString *)title
           money:(NSString *)money
          coupon:(NSString *)coupon
        packName:(NSString *)packName
         payCode:(NSString *)paycode
{
    
    [_storeLabel setText:[NSString stringWithFormat:@"您在%@共支付了",title]];
    [_priceLabel setText:[self analyzingMoney:money coupon:coupon]];
    [_timeLabel setText:_timeStr];
    
    
    if (_type != ScenePay) {
        return;
    }
    [_titleLabel setText:packName];
   

    NSMutableAttributedString *desString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"消费码：%@",paycode]];
    [desString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x02b293"] range:NSMakeRange(4, paycode.length)];
    [_desLabel setAttributedText:desString];
    
}

- (NSString *)analyzingMoney:(NSString *)money coupon:(NSString *)coupon{
    
    
    CGFloat rtCoupon = [coupon floatValue];
    CGFloat rtMoney = [money floatValue];
    
    NSString *tmpString = @"0";
    
    if(rtCoupon == 0 && rtMoney != 0){
        
        tmpString  = [NSString stringWithFormat:@"￥%@",money];
        
    }else if (rtCoupon != 0 && rtMoney == 0){
        
        tmpString  = [NSString stringWithFormat:@"%@现金券",coupon];
        
    }else if (rtCoupon != 0 && rtMoney != 0){
        tmpString  = [NSString stringWithFormat:@"￥%@ + %@现金券",money,coupon];
    }
    
    return tmpString;
}

- (void)btnAction:(UIButton *)btn{
    
    if (_checkBtnBlock) {
        _checkBtnBlock(btn);
    }
}

@end
