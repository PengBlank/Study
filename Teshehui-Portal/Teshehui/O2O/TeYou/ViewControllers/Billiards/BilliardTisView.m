//
//  BilliardTisView.m
//  Teshehui
//
//  Created by apple_administrator on 15/11/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "BilliardTisView.h"
#import "UIColor+expanded.h"
#import "Masonry.h"
#import "DefineConfig.h"
#import "UIImage+Common.h"
#import "UIUtils.h"
@interface BilliardTisView ()
@property (nonatomic ,strong) UIView    *bgView;
@property (nonatomic ,strong) UILabel   *titleLabel;
@property (nonatomic ,strong) UILabel   *subTitleLabel;
@property (nonatomic ,strong) UILabel   *desLabel;
@property (nonatomic ,strong) UIButton   *iKnowBtn;


@end

@implementation BilliardTisView

- (id)initWithFrame:(CGRect)frame billiardsTableInfo:(BilliardsTableInfo *)info
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        
        self.bgView = [[UIView alloc] init];
        [ self.bgView setBackgroundColor:[UIColor colorWithHexString:@"ffffff" andAlpha:1]];
        [self addSubview: self.bgView];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setText:@"成功开台"];
        [self.titleLabel setFont:[UIFont systemFontOfSize:30]];
        [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setTextColor:[UIColor colorWithHexString:@"0xb80000"]];
        [self.bgView addSubview:self.titleLabel];
        
        self.subTitleLabel = [[UILabel alloc] init];
        [self.subTitleLabel setText:info.TableName];
        [self.subTitleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.subTitleLabel setTextColor:[UIColor colorWithHexString:@"0x343434"]];
        [self.bgView addSubview:self.subTitleLabel];
        
        
        self.desLabel = [[UILabel alloc] init];
        [self.desLabel setText:@"再扫一扫二维码即可购买酒水或者收台"];
        [self.desLabel setFont:[UIFont systemFontOfSize:14]];
        [self.desLabel setTextColor:[UIColor colorWithHexString:@"0x343434"]];
        [self.bgView addSubview:self.desLabel];
        
        self.iKnowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.iKnowBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [self.iKnowBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.iKnowBtn setTitleColor:[UIColor colorWithHexString:@"606060"] forState:UIControlStateNormal];
        [self.iKnowBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.iKnowBtn addTarget:self action:@selector(iKnowBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.iKnowBtn];
        

        
        WS(weakSelf);
//        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(weakSelf.mas_centerX);
//            make.centerY.mas_equalTo(weakSelf.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(WIDTH(300), HEIGHT(150)));
//        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.bgView.mas_top).offset(ScaleHEIGHT(18));
            make.centerX.mas_equalTo(weakSelf.bgView.mas_centerX);
            make.width.mas_equalTo(ScaleWIDTH(280));
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(ScaleHEIGHT(13));
            make.centerX.mas_equalTo(weakSelf.bgView.mas_centerX);
        }];
        
        
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.subTitleLabel.mas_bottom).offset(ScaleHEIGHT(ScaleHEIGHT(5)));
            make.centerX.mas_equalTo(weakSelf.bgView.mas_centerX);
        }];
        
        [self.iKnowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(weakSelf.bgView.mas_right);
            make.bottom.mas_equalTo(weakSelf.bgView.mas_bottom);
            make.height.mas_equalTo(45);
        }];
        
        [UIUtils addLineInView:self.iKnowBtn top:YES leftMargin:0 rightMargin:0];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}

- (void)iKnowBtnAction{
    if (_BilliardsViewBlock) {
        _BilliardsViewBlock();
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (_BilliardsViewBlock) {
        _BilliardsViewBlock();
    }
}

- (void)show{
    
    if (!self.superview)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = [UIScreen mainScreen].bounds;
        [window addSubview:self];
    }
    
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:.3 animations:^{
        b_self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        b_self.bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0f];
        WS(weakSelf);
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(ScaleWIDTH(280), ScaleHEIGHT(165)));
        }];
    }];
    
    
}

- (void)dismiss{
    
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:.3 animations:^
     {
         b_self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
         b_self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
         [b_self removeFromSuperview];
     } completion:^(BOOL finished)
     {
         
     }];
}

@end
