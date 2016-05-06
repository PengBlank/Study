//
//  HYLoginViewController.m
//  Teshehui
//
//  Created by HYZB on 16/2/18.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYLoginViewController.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WXApi.h"
#import "HYLoginViewBaseCell.h"
#import "HYLoginViewCell.h"
#import "HYLoginViewCheckingCodeCell.h"
#import "NSString+Addition.h"
#import "METoast.h"
#import "HYUserService.h"
#import "HYAppDelegate.h"
#import "HYSiRedPacketsViewController.h"
#import "HYLoginViewInviteCodeCell.h"
#import "HYThirdPartyLoginController.h"
#import "HYThirdpartyRegisterViewController.h"
#import "HYUmengLoginClick.h"
#import "HYForgetViewController.h"
#import "HYLoginHeadView.h"
#import "HYLoginFootView.h"
#import "HYActivateV2ViewController.h"
#import "HYOnlineBuyCardFirstStepViewController.h"
#import "HYLoginRequest.h"
#import "HYLoginResponse.h"
#import "HYQuicklyRegisterViewController.h"
#import "HYAnalyticsManager.h"

UIKIT_EXTERN NSString * const LoginStatusChangeNotification;

@interface HYLoginViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
HYThirdPartyLoginControllerDelegate,
UIAlertViewDelegate>
{
    //第三登陆逻辑控制器
    HYThirdPartyLoginController *_loginController;
    //账号登录请求
    HYLoginRequest *_loginRequset;
    
    NSString *_mobilePhone;
    NSString *_validateCode;
    NSString *_inviteCode;
    NSString *_cardNumber;
    NSString *_key;
    CGFloat _cellHeight;
    NSInteger _numberOfRows;
    
    HYLoginHeadView *_headView;
    HYLoginFootView *_footView;
    BOOL _isLoading;    //加载标志位
    BOOL _didSendCode;
    HYUserService *_userService;
}

@property (nonatomic, strong) UITableView *loginTbaleView;
@property (nonatomic, assign) NSInteger registered; //-1 未知，0未注,1已注册
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) LoginType type;

@end

@implementation HYLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _loginController = [[HYThirdPartyLoginController alloc] init];
        _loginController.delegate = self;
        
        _isLoading = NO;
        _didSendCode = NO;
        _userService = [[HYUserService alloc] init];
        _registered = -1;
        _type = kLoginTypeQuicklyLogin;
        
        _cellHeight = 70;
        _numberOfRows = 2;
    }
    return self;
}

- (void)dealloc
{
    [_loginRequset cancel];
    _loginRequset = nil;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //table
    UITableView *table = [[UITableView alloc] initWithFrame:frame
                                                      style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 40;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    self.loginTbaleView = table;
    
    //header
    HYLoginHeadView *headView = [[HYLoginHeadView alloc] initWithFrame:frame];
    table.tableHeaderView = headView;
    _headView = headView;
    
    [_headView.closeBtn addTarget:self action:@selector(dismissView:)
       forControlEvents:UIControlEventTouchUpInside];
    [_headView.quicklyLoginBtn addTarget:self action:@selector(quicklyLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headView.keyLoginBtn addTarget:self action:@selector(keyLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //foot
    CGFloat footH = self.view.frame.size.height+60 - 2*_cellHeight - headView.frame.size.height;
    HYLoginFootView *footView = [[HYLoginFootView alloc] initWithFrame:frame];
    footView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), footH);
    table.tableFooterView = footView;
    _footView = footView;
    
    [footView.loginBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView.activateBtn addTarget:self action:@selector(activateAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView.buyCardBtn addTarget:self action:@selector(onlineBuyCardAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView.quicklyRegisterBtn addTarget:self action:@selector(quicklyRegisterAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView.forgetBtn addTarget:self action:@selector(forgetPass:) forControlEvents:UIControlEventTouchUpInside];
    
    //第三方登陆
    NSArray *footBtnTitles = [NSArray array];
    if ([TencentApiInterface isTencentAppInstall:kIphoneQQ])
    {
        footBtnTitles = [footBtnTitles arrayByAddingObject:@{@"title": @"QQ登录",
                                                             @"img": @"login_qq_icon",
                                                             @"action": @"qqLoginAction:"}];
    }
    if ([WXApi isWXAppInstalled])
    {
        footBtnTitles = [footBtnTitles arrayByAddingObject:@{@"title": @"微信登录",
                                                             @"img": @"login_weixin_icon",
                                                             @"action": @"wxLoginAction:"}];
    }
    
    if (footBtnTitles.count)
    {
        [_footView  setupThirdLonginWithFrame:frame footH:footH];
    }
    
    CGFloat width = 68;
    CGFloat x = (CGRectGetWidth(frame)-width*footBtnTitles.count) / 2;
    
    for (NSDictionary *info in footBtnTitles)
    {
        [_footView setupthirdLonginButtonWithFootH:footH info:info x:x width:width];
        [_footView.qqBtn addTarget:self
                  action:NSSelectorFromString(info[@"action"])
        forControlEvents:UIControlEventTouchUpInside];
        x += width;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - privateMethod
- (void)dismissView:(id)sender
{
    [self.view endEditing:YES];
    /// 取消后会产生状态栏变为白色的情况，但是如果是在首页调出登录界面，会有问题
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
                             }];
}

- (void)keyLoginBtnClicked:(UIButton *)btn
{
    [UIView animateWithDuration:0.25 animations:^{

        _headView.arrowImageView.frame = CGRectMake(btn.frame.size.width*3+25, CGRectGetHeight(_headView.frame)-7, _headView.arrowImageView.frame.size.width, 8);
    }];
    _type = kLoginTypeKeyLogin;
    _footView.declareLabel.hidden = YES;
    _footView.forgetBtn.hidden = NO;
    _numberOfRows = 2;
    [self.loginTbaleView reloadData];
    
    [self setupLoginButtonStatus];
}

- (void)quicklyLoginBtnClicked:(UIButton *)btn
{
    [UIView animateWithDuration:0.25 animations:^{

        _headView.arrowImageView.frame = CGRectMake(btn.frame.size.width+25, CGRectGetHeight(_headView.frame)-7, _headView.arrowImageView.frame.size.width, 8);
        
    }];
    _type = kLoginTypeQuicklyLogin;
    _footView.forgetBtn.hidden = YES;
    
    if (_registered == 0)
    {
        _numberOfRows = 3;
    }
    else
    {
        _numberOfRows = 2;
    }
    
    [self.loginTbaleView reloadData];
    
    [self setupLoginButtonStatus];
}

- (void)validateAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    if (_isLoading)
    {
        return;
    }
    
    if (!_mobilePhone.length)
    {
        [METoast toastWithMessage:@"请输入您的手机号码"];
    }
    else if (![_mobilePhone checkPhoneNumberValid])
    {
        [METoast toastWithMessage:@"请填写有效的手机号码"];
    }
    else
    {
        WS(b_self)
        [_userService checkUserIsRegisterd:_mobilePhone
                                  callback:^(BOOL registered, NSString *err)
         {
             if (err)
             {
                 [METoast toastWithMessage:err];
             }
             else
             {
                 b_self.registered = registered;
                 if (_registered == 0)
                 {
                     _numberOfRows = 3;
                 }
                 else
                 {
                     _numberOfRows = 2;
                 }
                 [b_self.loginTbaleView reloadData];
             }
         }];
        
        _didSendCode = YES;
        _isLoading = YES;
        [_userService getExuserCodeWithPhone:_mobilePhone
                                    callback:^(BOOL succ, NSString *err)
         {
             b_self.isLoading = NO;
             if (succ)
             {
                 [b_self startTimming];
             }
             else if (err.length > 0)
             {
                 [METoast toastWithMessage:err];
             }
         }];
    }
}

- (void)startTimming
{
    HYLoginViewCell *phoneCell = (HYLoginViewCell*)[self.loginTbaleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (phoneCell)
    {
        [phoneCell startTiming];
    }
}

- (void)startAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    if (_isLoading)
    {
        return;
    }
    
    switch (self.type)
    {
        case kLoginTypeKeyLogin:
            [self keyLogin];
            break;
        case kLoginTypeQuicklyLogin:
            [self quicklyLogin];
            break;
        default:
            break;
    }
}

- (void)keyLogin
{
    [HYLoadHubView show];
    
    if (!_loginRequset)
    {
        _loginRequset = [[HYLoginRequest alloc] init];
    }
    _loginRequset.loginName = _cardNumber;
    _loginRequset.password = _key;
    WS(b_self)
    self.isLoading = YES;
    [_loginRequset sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         b_self.isLoading = NO;
         HYLoginResponse *response = (HYLoginResponse *)result;
         if (response.status == 200)
         {
             [[NSUserDefaults standardUserDefaults] setBool:YES
                                                     forKey:kIsLogin];
             
             //如果切换了账号则需要清除内存
             NSString *lastNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumber];
             BOOL needClearCache = !([lastNumber isEqualToString:response.userInfo.mobilePhone]);
             
             [response.userInfo saveData];
             [[NSNotificationCenter defaultCenter] postNotificationName:LoginStatusChangeNotification object:nil];
             
             if (needClearCache)
             {
                 HYAppDelegate* appDelegate = (HYAppDelegate*)[[UIApplication sharedApplication] delegate];
                 [appDelegate loadContentView:YES];
             }
             else
             {
                 [self.navigationController dismissViewControllerAnimated:YES
                                                               completion:nil];
             }
             
             //统计
             [HYAnalyticsManager sendUserLoginType:102];
         }
         else if (response.status == -90010)  //未激活的卡
         {
             UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                            message:@"该卡暂未激活,您可以立刻激活"
                                                           delegate:b_self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"激活", nil];
             [alert show];
         }
         else
         {
             [METoast toastWithMessage:response.suggestMsg];
         }
     }];
}

- (void)quicklyLogin
{
    NSString *error = nil;
    if (![_mobilePhone checkPhoneNumberValid])
    {
        error = @"请输入正确的手机号码";
    }
    else if (!_didSendCode)
    {
        error = @"请先发送验证码";
    }
    else if (_validateCode.length == 0)
    {
        error = @"请输入验证码";
    }
    else if (!_registered && _inviteCode.length == 0)
    {
        error = @"请输入邀请码";
    }
    
    if (error)
    {
        [METoast toastWithMessage:error];
    }
    else
    {
        [HYLoadHubView show];
        _isLoading = YES;
        
        WS(b_self)
        [_userService exuserLoginWithPhone:_mobilePhone
                                 checkCode:_validateCode
                            invitationCode:_inviteCode
                                 loginFlag:_registered
                                  callback:^(HYUserInfo *user, NSString *err)
         {
             
             [HYLoadHubView dismiss];
             b_self.isLoading = NO;
             if (user)
             {
                 [b_self updateLoginWithUserInfo:user];
                 
                 //统计
                 [HYAnalyticsManager sendUserLoginType:101];
             }
             else
             {
                 [METoast toastWithMessage:err];
             }
         }];
    }
}

- (void)activateAction:(id)sender
{
    HYActivateV2ViewController *activate = [[HYActivateV2ViewController alloc] init];
    [self.navigationController pushViewController:activate animated:YES];
    
    [HYUmengLoginClick clickMoreActivate];
}

- (void)onlineBuyCardAction:(UIButton *)btn
{
    HYOnlineBuyCardFirstStepViewController *vc = [[HYOnlineBuyCardFirstStepViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    [HYUmengLoginClick clickMoreBuycard];
}

- (void)updateLoginWithUserInfo:(HYUserInfo *)userinfo
{
    /*
     [_userService updateLoginStatusWithUserInfo:userinfo];
     */
    
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:kIsLogin];
    
    //如果切换了账号则需要清除内存
    NSString *lastNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumber];
    BOOL needClearCache = !([lastNumber isEqualToString:userinfo.mobilePhone]);
    
    //保存用户
    [userinfo saveData];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginStatusChangeNotification object:nil];
    
    if (!self.registered)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [HYSiRedPacketsViewController showWithPoints:userinfo.points completeBlock:nil];
        }];
    }
    else
    {
        if (needClearCache)
        {
            HYAppDelegate* appDelegate = (HYAppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate loadContentView:YES];
//            [appDelegate showStarAnimation];
        }
        else
        {
            [self.navigationController dismissViewControllerAnimated:YES
                                                          completion:nil];
        }
    }
}

- (void)qqLoginAction:(id)sender
{
    [_loginController loginWithTencent];
}

- (void)wxLoginAction:(id)sender
{
    [_loginController loginWithWeixin];
}

+ (void)wxCancel
{
    [METoast toastWithMessage:@"授权取消"];
}

- (void)forgetPass:(UIButton *)btn
{
    HYForgetViewController *vc = [[HYForgetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    [HYUmengLoginClick clickMoreAccountForget];
}

- (void)quicklyRegisterAction:(UIButton *)btn
{
    HYQuicklyRegisterViewController *vc = [[HYQuicklyRegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupLoginButtonStatus
{
    switch (_type)
    {
        case kLoginTypeQuicklyLogin:
            
            if (_registered == YES)
            {
                if (_mobilePhone.length > 0 && _validateCode.length > 0)
                {
                    _footView.loginBtn.backgroundColor = [UIColor colorWithRed:223/255.0f green:58/255.0f blue:60/255.0f alpha:1.0f];
                    _footView.loginBtn.enabled = YES;
                }
                else
                {
                    _footView.loginBtn.backgroundColor = [UIColor colorWithWhite:0.65 alpha:1.0f];
                    _footView.loginBtn.enabled = NO;
                }
            }
            else
            {
                if (_mobilePhone.length > 0 && _validateCode.length > 0 && _inviteCode.length > 0)
                {
                    _footView.loginBtn.backgroundColor = [UIColor colorWithRed:223/255.0f green:58/255.0f blue:60/255.0f alpha:1.0f];
                    _footView.loginBtn.enabled = YES;
                }
                else
                {
                    _footView.loginBtn.backgroundColor = [UIColor colorWithWhite:0.65 alpha:1.0f];
                    _footView.loginBtn.enabled = NO;
                }
            }
            break;
        case kLoginTypeKeyLogin:
            
            if (_cardNumber.length > 0 && _key.length > 0)
            {
                _footView.loginBtn.backgroundColor = [UIColor colorWithRed:223/255.0f green:58/255.0f blue:60/255.0f alpha:1.0f];
                _footView.loginBtn.enabled = YES;
            }
            else
            {
                _footView.loginBtn.backgroundColor = [UIColor colorWithWhite:0.65 alpha:1.0f];
                _footView.loginBtn.enabled = NO;
            }
            break;
        default:
            break;
    }
    
}

#pragma mark - HYThirdPartyLoginControllerDelegate
- (void)didGetThirdLoginToken:(NSString *)token
                       openId:(NSString *)openId
                    loginType:(HYThirdPartyLoginType)type
{
    WS(b_self)
    [HYLoadHubView show];
    [_userService thirdpartyLogin:token
                           openid:openId
                             type:type
                         callback:^(NSInteger result, HYUserInfo *user, NSString *err)
     {
         [HYLoadHubView dismiss];
         if (result == 0)
         {
             [b_self updateLoginWithUserInfo:user];
             
             
             //统计
             if ([type isEqualToString:HYThirdPartyQQ])
             {
                 [HYAnalyticsManager sendUserLoginType:112];
             }
             else
             {
                 [HYAnalyticsManager sendUserLoginType:111];
             }
         }
         else if (result == -1)
         {
             HYThirdpartyRegisterViewController *validate = [[HYThirdpartyRegisterViewController alloc] init];
             validate.thirdpartyType = type;
             validate.thirdpartyOpenid = openId;
             validate.thirdpartyToken = token;
             [b_self.navigationController pushViewController:validate animated:YES];
         }
         else
         {
             [METoast toastWithMessage:err];
         }
     }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        HYLoginViewCell *phoneCell = [HYLoginViewCell cellWithTableView:tableView];
        phoneCell.cellHeight = _cellHeight;
        [phoneCell setDataWithType:self.type phoneNum:_mobilePhone cardNum:_cardNumber];
        
        [phoneCell.codeBtn addTarget:self
                         action:@selector(validateAction:)
               forControlEvents:UIControlEventTouchUpInside];
        phoneCell.textField.delegate = self;
        
        return phoneCell;
    }
    else if (indexPath.row == 1)
    {
        HYLoginViewCheckingCodeCell *checkingCodeCell = [HYLoginViewCheckingCodeCell cellWithTableView:tableView];
        checkingCodeCell.cellHeight = _cellHeight;
        [checkingCodeCell setDataWithType:self.type checkingCode:_validateCode password:_key];
        
//        [checkingCodeCell.forgetBtn addTarget:self action:@selector(forgetPass:) forControlEvents:UIControlEventTouchUpInside];
        checkingCodeCell.codeTextField.delegate = self;
        
        return checkingCodeCell;
    }
    else
    {
        HYLoginViewInviteCodeCell *inviteCodeCell = [HYLoginViewInviteCodeCell cellWithTableView:tableView];
        inviteCodeCell.cellHeight = _cellHeight;
        
        _footView.declareLabel.hidden = NO;
        inviteCodeCell.inviteTextField.text = _inviteCode;
        inviteCodeCell.inviteTextField.delegate = self;
        
        return inviteCodeCell;
    }
    DebugNSLog(@"cell缺失");
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self activateAction:nil];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 202)
    {
        _inviteCode = textField.text;
    }
    [self setupLoginButtonStatus];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.type == kLoginTypeKeyLogin)
    {
        switch (textField.tag)
        {
            case 200:
                _cardNumber = @"";
                break;
            case 201:
                _key = @"";
                break;
            default:
                break;
        }
    }
    else if (self.type == kLoginTypeQuicklyLogin)
    {
        switch (textField.tag)
        {
            case 200:
                _mobilePhone = @"";
                break;
            case 201:
                _validateCode = @"";
                break;
            case 202:
                _inviteCode = @"";
                break;
            default:
                break;
        }
    }
    
    [self setupLoginButtonStatus];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "])
    {
        return NO;
    }
    
    if (self.type == kLoginTypeQuicklyLogin)
    {
        switch (textField.tag)
        {
            case 200:
                _mobilePhone = [textField.text stringByReplacingCharactersInRange:range withString:string];
                break;
            case 201:
                _validateCode = [textField.text stringByReplacingCharactersInRange:range withString:string];
                break;
            case 202:
                _inviteCode = [textField.text stringByReplacingCharactersInRange:range withString:string];
                break;
            default:
                break;
        }
    }
    else if (self.type == kLoginTypeKeyLogin)
    {
        switch (textField.tag)
        {
            case 200:
                _cardNumber = [textField.text stringByReplacingCharactersInRange:range withString:string];
                break;
            case 201:
                _key = [textField.text stringByReplacingCharactersInRange:range withString:string];
                break;
            default:
                break;
        }
    }
    
    [self setupLoginButtonStatus];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 200:
            
            break;
        case 201:
            if (currentDeviceType() < iPhone6)
            {
                [self.loginTbaleView setContentOffset:CGPointMake(0, 100) animated:YES];
            }
            break;
        case 202:
            if (currentDeviceType() < iPhone6)
            {
                [self.loginTbaleView setContentOffset:CGPointMake(0, 130) animated:YES];
            }
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 201)
    {
        [self.view endEditing:YES];
    }
    return YES;
}


@end
