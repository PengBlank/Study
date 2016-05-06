//
//  HYLoginHeadView.m
//  Teshehui
//
//  Created by HYZB on 16/2/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYLoginHeadView.h"


#define kLabelFont [UIFont systemFontOfSize:16]

@interface HYLoginHeadView ()
{
    CGFloat btnWidth;
}


@end

@implementation HYLoginHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupWithFrame:frame];
    }
    return self;
}

- (void)setupWithFrame:(CGRect)frame
{
    self.frame = CGRectMake(0, 0, CGRectGetWidth(frame), TFScalePoint(160));
    self.backgroundColor = [UIColor colorWithRed:223/255.0f green:58/255.0f blue:60/255.0f alpha:1.0f];
    
    btnWidth = CGRectGetWidth(frame)/5;
    
    [self setupImageView];
    
    [self setupButton];
}

- (void)setupImageView
{
    UIImageView *logoBackground = [[UIImageView alloc] initWithFrame:self.frame];
    logoBackground.image = [UIImage imageNamed:@"login_logo_background"];
    [self addSubview:logoBackground];
    
    // 特奢汇LOGO
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo_new"]];
    logo.frame = TFRectMake(0, 80, 102, 36);
    logo.center = CGPointMake(self.frame.size.width/2, 80);
    [self addSubview:logo];
    
    //arrow icon
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_arrow"]];
    arrowImageView.frame = CGRectMake(btnWidth+25, CGRectGetHeight(self.frame)-7, arrowImageView.frame.size.width, 8);
    _arrowImageView = arrowImageView;
    [self addSubview:arrowImageView];
}

- (void)setupButton
{
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 55, 55)];
    [closeBtn setImage:[UIImage imageNamed:@"login_icon_cancel"] forState:UIControlStateNormal];
    _closeBtn = closeBtn;
    [self addSubview:closeBtn];
    
    CGFloat y = CGRectGetHeight(self.frame)-32;
    
    //快速登录
    UIButton *quicklyLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quicklyLoginBtn setTitle:@"快速登录" forState:UIControlStateNormal];
    quicklyLoginBtn.titleLabel.font = kLabelFont;
    quicklyLoginBtn.frame = CGRectMake(btnWidth, y, btnWidth, 20);
    _quicklyLoginBtn = quicklyLoginBtn;
    [self addSubview:quicklyLoginBtn];
    
    //密码登录
    UIButton *keyLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [keyLoginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
    keyLoginBtn.titleLabel.font = kLabelFont;
    keyLoginBtn.frame = CGRectMake(btnWidth*3, y, btnWidth, 20);
    _keyLoginBtn = keyLoginBtn;
    [self addSubview:keyLoginBtn];
}

@end
