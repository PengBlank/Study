//
//  HYLoginView.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-4.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYLoginView.h"
#import "UIDevice+Resolutions.h"
#import "UIView+Style.h"
#import "HYLoginInfoCache.h"
#import "SFHFKeychainUtils.h"


struct HYLoginViewMetrics {
    CGRect loginFrameFrame;
    CGRect loginTextframe;
    CGFloat fieldOffsetX;
    CGFloat fieldOffsetY;
    CGFloat rememberLineOffsetX;
    CGFloat rememberLineOffsetY;
    CGSize btnSize;
    CGFloat btnLblSpace;
    CGFloat lblWidth;
    CGFloat loginBtnOffsetX;
    CGFloat loginBtnOffsetY;
    CGSize loginBtnSize;
    CGSize logoSize;
    CGFloat spaceOfLogoAndFrame;
    CGFloat fontSize;
    CGFloat titleFontSize;
};
typedef struct HYLoginViewMetrics HYLoginViewMetrics;

@interface HYLoginView ()
@property (nonatomic, assign) HYLoginViewMetrics metrics;
@end

@implementation HYLoginView

- (void)fillMetrics
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
    {
        _metrics.loginFrameFrame = CGRectMake(0, 0, 480, 306);
        _metrics.loginTextframe = CGRectMake(28,40,422,102);
        _metrics.fieldOffsetX = 20;
        _metrics.fieldOffsetY = 5;
        _metrics.rememberLineOffsetX = 30;
        _metrics.rememberLineOffsetY = 20;
        _metrics.btnSize = CGSizeMake(45, 44);
        _metrics.btnLblSpace = 5;
        _metrics.lblWidth = 83;
        _metrics.loginBtnOffsetX = 48;
        _metrics.loginBtnOffsetY = 22;
        _metrics.loginBtnSize = CGSizeMake(373, 52);
        _metrics.logoSize = CGSizeMake(277, 92);
        _metrics.spaceOfLogoAndFrame = 22.0;
        _metrics.fontSize = 18;
        _metrics.titleFontSize = 20;
    }
    else
    {
        _metrics.loginFrameFrame = CGRectMake(0, 0, 280, 190);
        _metrics.loginTextframe = CGRectMake(15,20,280 - 30,80);
        _metrics.fieldOffsetY = 2.5;
        _metrics.fieldOffsetX = 10;
        _metrics.rememberLineOffsetX = 15;
        _metrics.rememberLineOffsetY = 11;
        _metrics.btnSize = CGSizeMake(45, 44);
        _metrics.btnSize.width /= 2;
        _metrics.btnSize.height /= 2;
        _metrics.btnLblSpace = 2.5;
        _metrics.lblWidth = 80;
        _metrics.loginBtnOffsetX = 24;
        _metrics.loginBtnOffsetY = 11;
        _metrics.loginBtnSize = CGSizeMake(373*.6, 52*.6);
        _metrics.logoSize = CGSizeMake(277*0.6, 92*0.6);
        _metrics.spaceOfLogoAndFrame = 11.0;
        _metrics.fontSize = 15;
        _metrics.titleFontSize = 15;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:94 green:114 blue:114 alpha:1.0];
        
        UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newLogo"]];
        self.logo = logo;
        [self addSubview:logo];
        
//        UIImageView *title = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"title"]];
//        self.title = title;
//        [self addSubview:title];
        CGFloat titleFont = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 40 : 26;
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.font = [UIFont boldSystemFontOfSize:titleFont];
        self.title.textColor = [UIColor colorWithRed:7/255.0 green:177/255.0 blue:243/255.0 alpha:1];
        self.title.text = @"补贴蓝";
        [self addSubview:_title];
        
        UIImage *userFrameImg = [UIImage imageNamed:@"input_on"];
        userFrameImg = [userFrameImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        UIImageView *userFrame = [[UIImageView alloc] initWithImage:userFrameImg];
//        userFrame.backgroundColor = [UIColor blackColor];
        userFrame.userInteractionEnabled = YES;
        [self addSubview:userFrame];
        
        UIButton *user = [UIButton buttonWithType:UIButtonTypeCustom];
        [user setImage:[UIImage imageNamed:@"icon1"] forState:UIControlStateNormal];
        user.userInteractionEnabled = NO;
        user.frame = CGRectMake(5, 5, 30, 30);
        self.user = user;
        [userFrame addSubview:user];
        
        UITextField *userText = [[UITextField alloc]init];
        [userFrame addSubview:userText];
        userText.placeholder = @"请输入用户名";
        [userText setFont:[UIFont systemFontOfSize:13]];
        
        userText.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.nameField = userText;
        
        self.userFrame = userFrame;
        [self addSubview:userFrame];
        
        UIImage *passwordFrameImg = [UIImage imageNamed:@"input"];
        passwordFrameImg = [passwordFrameImg stretchableImageWithLeftCapWidth:2 topCapHeight:10];
        UIImageView *passwordFrame= [[UIImageView alloc]initWithImage:passwordFrameImg];
        passwordFrame.userInteractionEnabled = YES;
        
        UIButton *password = [UIButton buttonWithType:UIButtonTypeCustom];
        [password setImage:[UIImage imageNamed:@"icon2"] forState:UIControlStateNormal];
        password.userInteractionEnabled = NO;
        password.frame = CGRectMake(5, 5, 30, 30);
        
        self.password = password;
        [passwordFrame addSubview:password];
        
        UITextField *passwordText = [[UITextField alloc]init];
        passwordText.placeholder = @"请输入密码";
        passwordText.secureTextEntry = YES;
        [passwordText setFont:[UIFont systemFontOfSize:13]];
        
        passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
//        passwordText.frame = CGRectMake(passwordTextX, 5, 180, 30);
        
        self.passField = passwordText;
        [passwordFrame addSubview:passwordText];
        
        self.passwordFrame = passwordFrame;
        [self addSubview:passwordFrame];
        
        UIButton *rememberPassword = [UIButton buttonWithType:UIButtonTypeCustom];
        [rememberPassword setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [rememberPassword setImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
        
        self.rememberPassBtn = rememberPassword;
        [self addSubview:rememberPassword];
        
        UILabel *rememberCode = [[UILabel alloc]init];
        [rememberCode setText:@"记住密码"];
        [rememberCode setFont:[UIFont systemFontOfSize:13]];
        self.rememberCode = rememberCode;
        [self addSubview:rememberCode];
        
        UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
        [login setBackgroundImage:[[UIImage imageNamed:@"btn_login"]stretchableImageWithLeftCapWidth:5 topCapHeight:10] forState:UIControlStateNormal];
        [login setTitle:@"登录" forState:UIControlStateNormal];
        
        self.loginBtn = login;
        [self addSubview:login];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            CGFloat logoX = self.frame.size.width * 0.15;
            CGFloat logoY = self.frame.size.width * 0.3;
            logo.frame = CGRectMake(logoX, logoY, 100, 35);
            
            CGFloat titleW = 180;
            CGFloat titleX = (CGRectGetWidth(self.frame) - titleW) * 0.5;
            CGFloat titleY = CGRectGetMaxY(logo.frame) + 20;
            CGFloat titleH = 30;
            self.title.frame = CGRectMake(titleX, titleY, titleW, titleH);
            
            CGFloat userFrameW = 220;
            CGFloat userFrameX = (CGRectGetWidth(self.frame) - userFrameW) * 0.5;
            CGFloat userFrameY = CGRectGetMaxY(_title.frame) + 20;
            CGFloat userFrameH = 45;
            userFrame.frame = CGRectMake(userFrameX, userFrameY, userFrameW, userFrameH);
            
            CGFloat userTextX = CGRectGetMaxX(_user.frame) + 10;
            CGFloat userTextW = CGRectGetWidth(_userFrame.frame) - 40;
            _nameField.frame = CGRectMake(userTextX, 5, userTextW, 30);
            
            CGFloat passwordFrameW = 220;
            CGFloat passwordFrameX = (CGRectGetWidth(self.frame) - userFrameW) * 0.5;
            CGFloat passwordFrameY = CGRectGetMaxY(userFrame.frame) + 20;
            CGFloat passwordFrameH = 45;
            passwordFrame.frame = CGRectMake(passwordFrameX, passwordFrameY, passwordFrameW, passwordFrameH);
            
            CGFloat passwordTextX = CGRectGetMaxX(password.frame) + 10;
            CGFloat passwordTextW = CGRectGetWidth(passwordFrame.frame) - 40;
            _passField.frame = CGRectMake(passwordTextX, 5, passwordTextW, 30);
            
            CGFloat rememberPasswordY = CGRectGetMaxY(passwordFrame.frame) + 20;
            rememberPassword.frame = CGRectMake(passwordFrameX, rememberPasswordY, 20, 20);
            CGFloat rememberCodeX = CGRectGetMaxX(rememberPassword.frame) + 5;
            rememberCode.frame = CGRectMake(rememberCodeX, rememberPasswordY, 60, 20);
            
            CGFloat loginW = 210;
            CGFloat loginX = (CGRectGetWidth(self.frame) - loginW) * 0.5;
            CGFloat loginY = CGRectGetMaxY(rememberPassword.frame) + 20;
            CGFloat loginH = 40;
            login.frame = CGRectMake(loginX, loginY, loginW, loginH);
            
            [self getCacheLoginInfo];

        }else if ([[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationPortrait)
        {
            [self setupiPadPortrait];
            [self getCacheLoginInfo];
        }else
        {
            [self setupiPadLanscape];
            [self getCacheLoginInfo];
        }
    }
    return self;
}



- (void)setupiPadLanscape
{
    CGFloat logoX = self.frame.size.width * 0.15;
    CGFloat logoY = self.frame.size.width * 0.2;
    _logo.frame = CGRectMake(logoX, logoY, 300, 100);

    CGFloat titleW = 400;
    CGFloat titleX = (CGRectGetWidth(self.frame) - titleW) * 0.5;
    CGFloat titleY = CGRectGetMaxY(_logo.frame) + 30;
    CGFloat titleH = 75;
    _title.frame = CGRectMake(titleX, titleY, titleW, titleH);

    CGFloat userFrameW = 400;
    CGFloat userFrameX = (CGRectGetWidth(self.frame) - userFrameW) * 0.5;
    CGFloat userFrameY = CGRectGetMaxY(_title.frame) + 20;
    CGFloat userFrameH = 50;
    _userFrame.frame = CGRectMake(userFrameX, userFrameY, userFrameW, userFrameH);
    
    CGFloat userTextX = CGRectGetMaxX(_user.frame) + 10;
    CGFloat userTextW = CGRectGetWidth(_userFrame.frame) - 40;
    _nameField.frame = CGRectMake(userTextX, 5, userTextW, 30);
    
    CGFloat passwordFrameW = 400;
    CGFloat passwordFrameX = (CGRectGetWidth(self.frame) - userFrameW) * 0.5;
    CGFloat passwordFrameY = CGRectGetMaxY(_userFrame.frame) + 20;
    CGFloat passwordFrameH = 50;
    _passwordFrame.frame = CGRectMake(passwordFrameX, passwordFrameY, passwordFrameW, passwordFrameH);
    
    CGFloat passwordTextX = CGRectGetMaxX(_password.frame) + 10;
    CGFloat passwordTextW = CGRectGetWidth(_passwordFrame.frame) - 40;
    _passField.frame = CGRectMake(passwordTextX, 5, passwordTextW, 30);
    
    CGFloat rememberPasswordY = CGRectGetMaxY(_passwordFrame.frame) + 20;
     _rememberPassBtn.frame = CGRectMake(passwordFrameX, rememberPasswordY, 20, 20);
    CGFloat rememberCodeX = CGRectGetMaxX(_rememberPassBtn.frame) + 5;
    _rememberCode.frame = CGRectMake(rememberCodeX, rememberPasswordY, 60, 20);

    CGFloat loginW = 400;
    CGFloat loginX = (CGRectGetWidth(self.frame) - loginW) * 0.5;
    CGFloat loginY = CGRectGetMaxY(_rememberPassBtn.frame) + 20;
    CGFloat loginH = 60;
    _loginBtn.frame = CGRectMake(loginX, loginY, loginW, loginH);
}

- (void)setupiPadPortrait
{
    CGFloat logoX = self.frame.size.width * 0.15;
    CGFloat logoY = self.frame.size.width * 0.3;
    _logo.frame = CGRectMake(logoX, logoY, 150, 50);
    
    CGFloat titleW = 300;
    CGFloat titleX = (CGRectGetWidth(self.frame) - titleW) * 0.5;
    CGFloat titleY = CGRectGetMaxY(_logo.frame) + 30;
    CGFloat titleH = 50;
    _title.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat userFrameW = 300;
    CGFloat userFrameX = (CGRectGetWidth(self.frame) - userFrameW) * 0.5;
    CGFloat userFrameY = CGRectGetMaxY(_title.frame) + 20;
    CGFloat userFrameH = 45;
    _userFrame.frame = CGRectMake(userFrameX, userFrameY, userFrameW, userFrameH);
    
    CGFloat userTextX = CGRectGetMaxX(_user.frame) + 10;
    CGFloat userTextW = CGRectGetWidth(_userFrame.frame) - 40;
    _nameField.frame = CGRectMake(userTextX, 5, userTextW, 30);
    
    CGFloat passwordFrameW = 300;
    CGFloat passwordFrameX = (CGRectGetWidth(self.frame) - userFrameW) * 0.5;
    CGFloat passwordFrameY = CGRectGetMaxY(_userFrame.frame) + 20;
    CGFloat passwordFrameH = 45;
    _passwordFrame.frame = CGRectMake(passwordFrameX, passwordFrameY, passwordFrameW, passwordFrameH);
    
    CGFloat passwordTextX = CGRectGetMaxX(_password.frame) + 10;
    CGFloat passwordTextW = CGRectGetWidth(_passwordFrame.frame) - 40;
    _passField.frame = CGRectMake(passwordTextX, 5, passwordTextW, 30);
    
    CGFloat rememberPasswordY = CGRectGetMaxY(_passwordFrame.frame) + 20;
    _rememberPassBtn.frame = CGRectMake(passwordFrameX, rememberPasswordY, 20, 20);
    CGFloat rememberCodeX = CGRectGetMaxX(_rememberPassBtn.frame) + 5;
    _rememberCode.frame = CGRectMake(rememberCodeX, rememberPasswordY, 60, 20);
    
    CGFloat loginW = 300;
    CGFloat loginX = (CGRectGetWidth(self.frame) - loginW) * 0.5;
    CGFloat loginY = CGRectGetMaxY(_rememberPassBtn.frame) + 20;
    CGFloat loginH = 40;
    _loginBtn.frame = CGRectMake(loginX, loginY, loginW, loginH);
}

- (void)getCacheLoginInfo
{
    HYLoginInfoCache *cache = [HYLoginInfoCache cachedLoginInfo];
    
    BOOL shouldRememberName = [[NSUserDefaults standardUserDefaults] boolForKey:kShouldRememberUserNameKey];
    if (shouldRememberName) {
        _rememberPassBtn.selected = YES;
        if (cache) {
            _nameField.text = cache.userName;
        }
    }
    BOOL shouldRememberPass = [[NSUserDefaults standardUserDefaults] boolForKey:kShouldRememberUserPassKey];
    if (shouldRememberPass) {
        if (cache) {
            _passField.text = cache.passWord;
        }
        _rememberPassBtn.selected = YES;
    }
}
//        [self fillMetrics];
//        //背景
//
//        UIImage *bgImg = [UIImage imageNamed:@"main_bg.png"];
//        UIImageView *bgV = [[UIImageView alloc] initWithImage:bgImg];
//        bgV.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
//        bgV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [self addSubview:bgV];
//
//        UIImage *check_n = [UIImage imageNamed:@"check_btn_n.png"];
//        UIImage *check_s = [UIImage imageNamed:@"check_btn_s.png"];
//
//        UIView *loginFrameView;
//        loginFrameView = [[UIView alloc] initWithFrame:_metrics.loginFrameFrame];
//        CGPoint center = CGPointMake(CGRectGetWidth(frame)/2,
//                                     CGRectGetHeight(frame)/2);
//        loginFrameView.center = center;
//        loginFrameView.autoresizingMask = UIViewAutoresizingFlexibleAllMargin;
//        loginFrameView.backgroundColor = [UIColor whiteColor];
//        [loginFrameView addCorner:14.0];
//        _loginFrameView = loginFrameView;
//        
//        //输入框边框
//        
//        HYLoginTextFrameView *frameV = [[HYLoginTextFrameView alloc] initWithFrame:_metrics.loginTextframe];
//        frameV.autoresizingMask = UIViewAutoresizingFlexibleAllMargin;
//        [_loginFrameView addSubview:frameV];
//        
//        //输入框
//        _nameField = [[UITextField alloc] initWithFrame:
//                      CGRectMake(CGRectGetMinX(_metrics.loginTextframe)+_metrics.fieldOffsetX,
//                                 CGRectGetMinY(frameV.frame)+_metrics.fieldOffsetY,
//                                 CGRectGetWidth(frameV.frame) - 2 * _metrics.fieldOffsetX,
//                                 CGRectGetHeight(frameV.frame)/2 - 2 * _metrics.fieldOffsetY)];
//        _nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        _nameField.autocorrectionType = UITextAutocorrectionTypeNo;
//        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _nameField.placeholder = @"账户";
//        //_nameField.delegate = self;
//        _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        _nameField.font = [UIFont systemFontOfSize:_metrics.fontSize];
//        [_loginFrameView addSubview:_nameField];
//        
//        _passField = [[UITextField alloc] initWithFrame:
//                      CGRectMake(CGRectGetMinX(_nameField.frame),
//                                 CGRectGetMaxY(_nameField.frame) + 2* _metrics.fieldOffsetY,
//                                 CGRectGetWidth(_nameField.frame),
//                                 CGRectGetHeight(_nameField.frame))];
//        _passField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        _passField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _passField.secureTextEntry = YES;
//        _passField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        _passField.placeholder = @"密码";
//        _passField.font = [UIFont systemFontOfSize:_metrics.fontSize];
//        //_passField.delegate = self;
//        [_loginFrameView addSubview:_passField];
//        
//        //记住
//        
//        _rememberNameBtn = [[UIButton alloc] initWithFrame:
//                            CGRectMake(CGRectGetMinX(frameV.frame) + _metrics.rememberLineOffsetX,
//                                       CGRectGetMaxY(frameV.frame) + _metrics.rememberLineOffsetY,
//                                       _metrics.btnSize.width,
//                                       _metrics.btnSize.height)];
//        [_rememberNameBtn setImage:check_n forState:UIControlStateNormal];
//        [_rememberNameBtn setImage:check_s forState:UIControlStateSelected];
//        [_loginFrameView addSubview:_rememberNameBtn];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:
//                          CGRectMake(CGRectGetMaxX(_rememberNameBtn.frame) + _metrics.btnLblSpace,
//                                     CGRectGetMinY(_rememberNameBtn.frame),
//                                     _metrics.lblWidth,
//                                     CGRectGetHeight(_rememberNameBtn.frame))];
//        label.text = @"记住帐号";
//        label.font = [UIFont systemFontOfSize:_metrics.fontSize];
//        label.textColor = [UIColor grayColor];
//        [_loginFrameView addSubview:label];
//        
//        _rememberPassBtn = [[UIButton alloc] initWithFrame:
//                            CGRectMake(CGRectGetMidX(frameV.frame) + _metrics.rememberLineOffsetX,
//                                       CGRectGetMaxY(frameV.frame) + _metrics.rememberLineOffsetY,
//                                       _metrics.btnSize.width,
//                                       _metrics.btnSize.height)];
//        [_rememberPassBtn setImage:check_n forState:UIControlStateNormal];
//        [_rememberPassBtn setImage:check_s forState:UIControlStateSelected];
//        [_loginFrameView addSubview:_rememberPassBtn];
//        
//        label = [[UILabel alloc] initWithFrame:
//                 CGRectMake(CGRectGetMaxX(_rememberPassBtn.frame) + _metrics.btnLblSpace,
//                            CGRectGetMinY(_rememberPassBtn.frame),
//                            _metrics.lblWidth,
//                            CGRectGetHeight(_rememberPassBtn.frame))];
//        label.text = @"记住密码";
//        label.font = [UIFont systemFontOfSize:_metrics.fontSize];
//        label.textColor = [UIColor grayColor];
//        [_loginFrameView addSubview:label];
//        
//        //登陆按钮
//        UIImage *login = [UIImage imageNamed:@"btn_login.png"];
//        _loginBtn = [[UIButton alloc] initWithFrame:
//                     CGRectMake(CGRectGetWidth(_metrics.loginFrameFrame)/2 - _metrics.loginBtnSize.width /2 ,
//                                CGRectGetMaxY(_rememberPassBtn.frame) + _metrics.loginBtnOffsetY,
//                                _metrics.loginBtnSize.width,
//                                _metrics.loginBtnSize.height)];
//        [_loginBtn setBackgroundImage:login forState:UIControlStateNormal];
//        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
//        [_loginFrameView addSubview:_loginBtn];
//        
//        UIImage *logo = [UIImage imageNamed:@"logo.png"];
//        UIImageView *logoV = [[UIImageView alloc] initWithImage:logo];
//        logoV.frame = CGRectMake(CGRectGetMidX(_loginFrameView.frame)-_metrics.logoSize.width/2,
//                                 CGRectGetMinY(_loginFrameView.frame) - _metrics.spaceOfLogoAndFrame - _metrics.logoSize.height,
//                                 _metrics.logoSize.width,
//                                 _metrics.logoSize.height);
//        logoV.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
//        //[self.view addSubview:logoV];
//        
//        UIView *wrapper = [[UIView alloc]
//                           initWithFrame:CGRectMake(CGRectGetMinX(_loginFrameView.frame),
//                                                    CGRectGetMinY(logoV.frame),
//                                                    CGRectGetWidth(_loginFrameView.frame),
//                                                    CGRectGetMaxY(_loginFrameView.frame)-CGRectGetMinY(logoV.frame))];
//        wrapper.autoresizingMask = UIViewAutoresizingFlexibleAllMargin;
//        CGRect frame = _loginFrameView.frame;
//        frame.origin.x = 0;
//        frame.origin.y = CGRectGetHeight(logoV.frame) + _metrics.spaceOfLogoAndFrame;
//        _loginFrameView.frame = frame;
//        frame = logoV.frame;
//        frame.origin.x = CGRectGetMinX(logoV.frame) - CGRectGetMinX(wrapper.frame);
//        frame.origin.y = 0;
//        logoV.frame = frame;
//        [wrapper addSubview:logoV];
//        [wrapper addSubview:_loginFrameView];
//        [self addSubview:wrapper];
//




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
