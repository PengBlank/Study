//
//  HYBannerView.m
//  Teshehui
//
//  Created by HYZB on 16/3/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYSignInBannerView.h"


@interface HYSignInBannerView ()

@property (nonatomic, strong) UIImageView *backGroundImageView;
@property (nonatomic, strong) UIView *dayPrefixV;
@property (nonatomic, strong) UIImageView *dayPrefixImageView;
@property (nonatomic, strong) UIImageView *dayImageView;
@property (nonatomic, strong) UIImageView *finallyImageView;
@property (nonatomic, strong) UILabel *dayLab;

@end

@implementation HYSignInBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    _backGroundImageView = [[UIImageView alloc] init];
    _backGroundImageView.image = [UIImage imageNamed:@"pic_signin_banner"];
    [self addSubview:_backGroundImageView];
    
    _dayPrefixV = [[UIView alloc] init];
    _dayPrefixV.backgroundColor = [UIColor clearColor];
    [self addSubview:_dayPrefixV];
    
    _dayPrefixImageView = [[UIImageView alloc] init];
    _dayPrefixImageView.image = [UIImage imageNamed:@"pic_signin_daydesc_new"];
    [_dayPrefixV addSubview:_dayPrefixImageView];
    
    _dayImageView = [[UIImageView alloc] init];
    _dayImageView.image = [UIImage imageNamed:@"pic_signin_day_new"];
    [_dayPrefixV addSubview:_dayImageView];
    
    _dayLab = [[UILabel alloc] init];
//    _dayLab.text = @"29";
    _dayLab.textColor = [UIColor colorWithRed:151/255.0f green:91/255.0f
                                         blue:251/255.0f alpha:1.0f];
    [_dayPrefixV addSubview:_dayLab];
    
    _finallyImageView = [[UIImageView alloc] init];
    _finallyImageView.image = [UIImage imageNamed:@"pic_signin_finallyday_new"];
    [self addSubview:_finallyImageView];
    _finallyImageView.hidden = YES;
}

- (void)layoutSubviews
{
    _backGroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-10);
    
    CGFloat x = TFScalePoint(10);
    CGFloat y = CGRectGetMaxY(_backGroundImageView.frame)-30;
    CGFloat width = TFScalePoint(300);
    CGFloat height = 40;
    _dayPrefixV.frame = CGRectMake(x, y, width, height);
    _dayPrefixImageView.frame = CGRectMake(0, 0, TFScalePoint(220), height);
    _dayImageView.frame = CGRectMake(CGRectGetMaxX(_dayPrefixImageView.frame), 0,
                                     TFScalePoint(80), height);
     _dayLab.frame = CGRectMake(CGRectGetMaxX(_dayPrefixImageView.frame)+TFScalePoint(3), 11, TFScalePoint(30), 20);
    
    _finallyImageView.frame = CGRectMake(x, y, TFScalePoint(300), height);
}

- (void)setCurrentSignNum:(NSString *)currentSignNum
{
    _currentSignNum = currentSignNum;
    
    if (currentSignNum.integerValue == 30)
    {
        _dayPrefixImageView.hidden = YES;
        _dayImageView.hidden = YES;
        _dayLab.hidden = YES;
        _finallyImageView.hidden = NO;
    }
    else if (currentSignNum.integerValue == 0)
    {
        _dayPrefixImageView.hidden = NO;
        _dayImageView.hidden = NO;
        _dayLab.hidden = NO;
        _dayLab.text = @"30";
        _finallyImageView.hidden = YES;
    }
    else
    {
        _dayPrefixImageView.hidden = NO;
        _dayImageView.hidden = NO;
        _dayLab.hidden = NO;
        _dayLab.text = [NSString stringWithFormat:@"%ld", 30 - currentSignNum.integerValue];
        _finallyImageView.hidden = YES;
    }
}

@end
