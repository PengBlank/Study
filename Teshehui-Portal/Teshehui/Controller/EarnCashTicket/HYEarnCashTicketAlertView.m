//
//  HYEarnCashTicketAlertView.m
//  Teshehui
//
//  Created by HYZB on 16/4/16.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYEarnCashTicketAlertView.h"


@interface HYEarnCashTicketAlertView ()

@property (nonatomic, strong) UIView *alertV;
@property (nonatomic, strong) UIImageView *lightImgV;
@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UIImageView *topImgV;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *breakpointImageView;



@end

@implementation HYEarnCashTicketAlertView

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
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    
    UIView *alertV = [[UIView alloc] init];
    _alertV = alertV;
    alertV.layer.cornerRadius = 10;
    alertV.backgroundColor = [UIColor whiteColor];
    [self addSubview:alertV];
    
    UIImageView *lightImgV = [[UIImageView alloc] init];
    _lightImgV = lightImgV;
    lightImgV.image = [UIImage imageNamed:@"iocn_light_earncashticket"];
    [self addSubview:lightImgV];
    
    UIView *topV = [[UIView alloc] init];
    _topV = topV;
    topV.backgroundColor = [UIColor whiteColor];
    [self addSubview:topV];
    UIImageView *topImgV = [[UIImageView alloc] init];
    topImgV.image = [UIImage imageNamed:@"iocn_alert_earncashticket"];
    _topImgV = topImgV;
    [topV addSubview:topImgV];
    
    UILabel *titleLab = [[UILabel alloc] init];
    _titleLab = titleLab;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:21];
    titleLab.text = @"配送注意事项";
    titleLab.textColor = [UIColor colorWithRed:246/255.0f
                                         green:93/255.0f
                                          blue:93/255.0f alpha:1.0f];
    [alertV addSubview:titleLab];
    
    _breakpointImageView = [[UIImageView alloc] init];
    _breakpointImageView.image = [UIImage imageNamed:@"icon_breakpoint_flower"];
    [alertV addSubview:_breakpointImageView];
    
    UIWebView *contentWebV = [[UIWebView alloc] init];
    contentWebV.backgroundColor = [UIColor clearColor];
    
    _contentWebV = contentWebV;
    _contentWebV.paginationMode = UIWebPaginationModeTopToBottom;
    [alertV addSubview:contentWebV];
    
    UIButton *agreedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreedBtn = agreedBtn;
    // 246 93 93
    agreedBtn.backgroundColor = [UIColor colorWithRed:246/255.0f
                                                green:93/255.0f blue:93/255.0f alpha:1.0f];
    [agreedBtn setTitle:@"同意" forState:UIControlStateNormal];
    [alertV addSubview:agreedBtn];
}

- (void)layoutSubviews
{
//    _lightImgV.frame = CGRectMake(self.center.x - 30, 100, 60, 20);
//    
//    _topV.frame = CGRectMake(self.center.x - 50, CGRectGetMaxY(_lightImgV.frame), 100, 100);
//    _topV.layer.cornerRadius = 50;
//    
//    _topImgV.frame = CGRectMake(25, 20, 50, 60);
    
//    CGFloat alertVX = TFScalePoint(40);
//    CGFloat alertVY = CGRectGetMaxY(_topV.frame) - _topV.frame.size.height/2;
    CGFloat alertVWidth = TFScalePoint(240);
    CGFloat alertVHeight = TFScalePoint(330);
    _alertV.frame = CGRectMake(0, 0, alertVWidth, alertVHeight);
    CGPoint center = self.center;
    CGFloat centerY = center.y;
    center.y = centerY + 40;
    _alertV.center = center;
//    _alertV.frame = CGRectMake( alertVX, alertVY, alertVWidth, alertVHeight);
    
    CGFloat topVY = CGRectGetMinY(_alertV.frame)-50;
    _topV.frame = CGRectMake(self.center.x - 50, topVY, 100, 100);
    _topV.layer.cornerRadius = 50;
    
    _topImgV.frame = CGRectMake(25, 20, 50, 60);
    
    _lightImgV.frame = CGRectMake(self.center.x - 30, CGRectGetMinY(_topV.frame)-30, 60, 20);
    
    CGFloat titleWidth = TFScalePoint(200);
    CGFloat titleHeight = 35;
    CGFloat titleX = (_alertV.frame.size.width - titleWidth)/2;
    CGFloat titleY = _topV.frame.size.height/2-3;
    _titleLab.frame = CGRectMake(titleX, titleY, titleWidth, titleHeight);
    
    CGFloat lineVWidth = alertVWidth - 40;
    CGFloat lineVHeight = 1;
    CGFloat lineVX = 20;
    CGFloat lineVY = CGRectGetMaxY(_titleLab.frame);
    _breakpointImageView.frame = CGRectMake(lineVX, lineVY, lineVWidth, lineVHeight);
    
    CGFloat contentWebVWidth = lineVWidth;
    CGFloat contentWebVHeight = TFScalePoint(180);
    CGFloat contentWebVX = lineVX;
    CGFloat contentWebVY = CGRectGetMaxY(_breakpointImageView.frame)+10;
    _contentWebV.frame = CGRectMake(contentWebVX, contentWebVY, contentWebVWidth, contentWebVHeight);
    
    CGFloat agreedBtnWidth = lineVWidth;
    CGFloat agreedBtnHeight = 40;
    CGFloat agreedBtnX = lineVX;
    CGFloat agreedBtnY = CGRectGetMaxY(_contentWebV.frame)+10;
    _agreedBtn.frame = CGRectMake(agreedBtnX, agreedBtnY, agreedBtnWidth, agreedBtnHeight);
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

@end
