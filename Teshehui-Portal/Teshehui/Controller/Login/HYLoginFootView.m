//
//  HYLoginFootView.m
//  Teshehui
//
//  Created by HYZB on 16/2/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYLoginFootView.h"


#define kLabelFont [UIFont systemFontOfSize:14]

@implementation HYLoginFootView

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
    self.backgroundColor = [UIColor clearColor];
    
    //忘记密码
    UIButton *forget = [UIButton buttonWithType:UIButtonTypeCustom];
    forget.frame = CGRectMake(TFScalePoint(300)-75, 5, 75, 20);
    [forget setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forget setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    forget.titleLabel.font = [UIFont systemFontOfSize:14];
    forget.hidden = YES;
    [self addSubview:forget];
    self.forgetBtn = forget;
    
    UILabel *declareLabel = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(20), 5, 198, 20)];
    declareLabel.font = [UIFont systemFontOfSize:11.0f];
    declareLabel.text = @"未注册过的手机将自动创建特奢汇账户";
    declareLabel.hidden = YES;
    declareLabel.textColor = [UIColor grayColor];
    _declareLabel = declareLabel;
    [self addSubview:declareLabel];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:
                          CGRectMake(TFScalePoint(24), TFScalePoint(30), TFScalePoint(272), 44)];
    [loginBtn setBackgroundColor:[UIColor colorWithWhite:0.65 alpha:1.0f]];
    [loginBtn setEnabled:NO];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn = loginBtn;
    [self addSubview:loginBtn];
    
    UIView *containBtnView = [[UIView alloc] init];
    if ([UIScreen mainScreen].bounds.size.height > 480)
    {
        containBtnView.frame = CGRectMake(TFScalePoint(24), CGRectGetMaxY(loginBtn.frame)+20, CGRectGetWidth(loginBtn.frame), 20);
    }
    else
    {
        containBtnView.frame = CGRectMake(TFScalePoint(24), CGRectGetMaxY(loginBtn.frame)+5, CGRectGetWidth(loginBtn.frame), 20);
    }
    [self addSubview:containBtnView];
    
    [self setupRegisterButtonAndBuyCardButtonWithView:containBtnView];
}

- (void)setupRegisterButtonAndBuyCardButtonWithView:(UIView *)view
{
    CGFloat btnWidth = (view.frame.size.width-4)/3;
    
    //快速注册
    UIButton *quicklyRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quicklyRegisterBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    quicklyRegisterBtn.titleLabel.font = kLabelFont;
    [quicklyRegisterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    quicklyRegisterBtn.frame = CGRectMake(TFScalePoint(5), 0, btnWidth-TFScalePoint(10), 20);
    [view addSubview:quicklyRegisterBtn];
    _quicklyRegisterBtn = quicklyRegisterBtn;
    
    UIView *leftSegregateView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(quicklyRegisterBtn.frame), 5, 1.5, 10)];
    leftSegregateView.backgroundColor = [UIColor grayColor];
    [view addSubview:leftSegregateView];
    
    //实体卡激活
    UIButton *activateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [activateBtn setTitle:@"实体卡激活" forState:UIControlStateNormal];
    activateBtn.titleLabel.font = kLabelFont;
    [activateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    activateBtn.frame = CGRectMake(CGRectGetMaxX(quicklyRegisterBtn.frame)+TFScalePoint(5), 0, btnWidth-TFScalePoint(10), 20);
    [view addSubview:activateBtn];
    _activateBtn = activateBtn;
    
    UIView *rightSegregateView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(activateBtn.frame), 5, 1.5, 10)];
    rightSegregateView.backgroundColor = [UIColor grayColor];
    [view addSubview:rightSegregateView];
    
    //在线购卡注册
    UIButton *buyCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyCardBtn setTitle:@"在线购卡注册" forState:UIControlStateNormal];
    buyCardBtn.titleLabel.font = kLabelFont;
    [buyCardBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    buyCardBtn.frame = CGRectMake(CGRectGetMaxX(activateBtn.frame)+TFScalePoint(5), 0, btnWidth, 20);
    buyCardBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:buyCardBtn];
    _buyCardBtn = buyCardBtn;
}

- (void)setupThirdLonginWithFrame:(CGRect)frame footH:(CGFloat)footH
{
    CGFloat lineViewWidth = (CGRectGetWidth(frame)-80-60)/2;
    CGFloat y = footH-125;
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    if ([UIScreen mainScreen].bounds.size.height > 480)
    {
        view.frame = CGRectMake(0, y-30, CGRectGetWidth(frame), 20);
    }
    else
    {
        view.frame = CGRectMake(0, y-10, CGRectGetWidth(frame), 20);
    }
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(20, 9, lineViewWidth, 1)];
    leftLineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:leftLineView];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftLineView.frame)+100, 9, lineViewWidth, 1)];
    rightLineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:rightLineView];
    
    UILabel *thirdLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftLineView.frame)+18, 0, 80, 20)];
    thirdLoginLabel.text = @"第三方登录";
    thirdLoginLabel.font = [UIFont systemFontOfSize:13];
    [thirdLoginLabel setTextColor:[UIColor grayColor]];
    [view addSubview:thirdLoginLabel];
}

- (void)setupthirdLonginButtonWithFootH:(CGFloat)footH info:(NSDictionary *)info x:(CGFloat)x width:(CGFloat)width
{
    CGFloat y = footH-140;
    
    HYImageButton *qqBtn = [[HYImageButton alloc] init];
    qqBtn.frame = CGRectMake(x, y, width, 90);
    [qqBtn setTitle:info[@"title"] forState:UIControlStateNormal];
    [qqBtn setImage:[UIImage imageNamed:info[@"img"]] forState:UIControlStateNormal];
    [qqBtn setTitleColor:[UIColor colorWithWhite:.63 alpha:1] forState:UIControlStateNormal];
    qqBtn.spaceInTestAndImage = 13;
    qqBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:qqBtn];
    _qqBtn = qqBtn;
}

@end
