//
//  HYQuicklyRegisterViewController.m
//  Teshehui
//
//  Created by HYZB on 16/2/22.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYQuicklyRegisterViewController.h"
#import "HYLoginViewCell.h"
#import "HYLoginViewCheckingCodeCell.h"
#import "HYLoginViewInviteCodeCell.h"
#import "METoast.h"
#import "NSString+Addition.h"
#import "HYUserService.h"
#import "HYAppDelegate.h"
#import "HYSiRedPacketsViewController.h"
#import "HYAnalyticsManager.h"

UIKIT_EXTERN NSString * const LoginStatusChangeNotification;


@interface HYQuicklyRegisterViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
UIAlertViewDelegate,
HYLoginViewCellDelegate
>
{
    NSString *_mobilePhone;
    NSString *_validateCode;
    NSString *_inviteCode;
    BOOL _registered;
    
    HYUserService *_userService;
    
    CGFloat _cellHeight;
}

@property (nonatomic,strong) UITableView* tableview;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIButton *completeRegister;


@end

@implementation HYQuicklyRegisterViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"快速注册";
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    _isLoading = NO;
    _userService = [[HYUserService alloc] init];
    _cellHeight = 60;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableview = tableView;
    [self.view addSubview:tableView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    headView.backgroundColor = [UIColor clearColor];
    tableView.tableHeaderView = headView;
    
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    _tableview.tableFooterView = footV;
    
    UIButton *completeRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeRegister = completeRegister;
    [footV addSubview:completeRegister];
    completeRegister.enabled = NO;
    [completeRegister setTitle:@"完成注册" forState:UIControlStateNormal];
//    [completeRegister setBackgroundColor:[UIColor lightGrayColor]];
    UIImage *disable = [[UIImage imageNamed:@"btn_login_new_disable"] stretchableImageWithLeftCapWidth:3 topCapHeight:5];
    UIImage *normal = [UIImage imageNamed:@"btn_login_new"];
    [completeRegister setBackgroundImage:normal forState:UIControlStateNormal];
    [completeRegister setBackgroundImage:disable forState:UIControlStateDisabled];
    completeRegister.frame = CGRectMake(20, 40, self.view.frame.size.width-40, 40);
    [completeRegister addTarget:self action:@selector(completeRegisterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setupRegisterButtonStatus];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        HYLoginViewCell *phoneCell = [HYLoginViewCell cellWithTableView:tableView];
        phoneCell.cellHeight = _cellHeight;
        [phoneCell setDataWithType:kLoginTypeQuicklyLogin phoneNum:_mobilePhone cardNum:nil];
        phoneCell.delegate = self;
        phoneCell.textField.delegate = self;
        phoneCell.textField.tag = 200;
        phoneCell.backgroundColor = [UIColor whiteColor];
        phoneCell.lineView.frame = CGRectMake(TFScalePoint(20), _cellHeight, TFScalePoint(300), 0.5);
        return phoneCell;
    }
    else if (indexPath.row == 1)
    {
        HYLoginViewCheckingCodeCell *checkingCell = [HYLoginViewCheckingCodeCell cellWithTableView:tableView];
        checkingCell.cellHeight = _cellHeight;
        [checkingCell setDataWithType:kLoginTypeQuicklyLogin checkingCode:_validateCode password:nil];
        
        checkingCell.codeTextField.delegate = self;
        checkingCell.codeTextField.tag = 201;
        checkingCell.backgroundColor = [UIColor whiteColor];
        checkingCell.lineView.frame = CGRectMake(TFScalePoint(20), _cellHeight, TFScalePoint(300), 0.5);
        return checkingCell;
    }
    else
    {
        HYLoginViewInviteCodeCell *inviteCell = [HYLoginViewInviteCodeCell cellWithTableView:tableView];
        inviteCell.cellHeight = _cellHeight;
        
        inviteCell.inviteTextField.text = _inviteCode;
        inviteCell.inviteTextField.delegate = self;
        inviteCell.inviteTextField.tag =202;
        inviteCell.backgroundColor = [UIColor whiteColor];
        inviteCell.lineView.frame = CGRectMake(0, _cellHeight, TFScalePoint(320), 0.5);
        return inviteCell;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - HYLoginViewCellDelegate
- (void)validateAction
{
    
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
                 if (registered == YES)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该手机号已被注册" delegate:self cancelButtonTitle:@"换个号码" otherButtonTitles:@"现在登录", nil];
                     [alert show];
                 }
                 else if (registered == NO)
                 {
                     _registered = registered;
                     _isLoading = YES;
                     [b_self getCheckingCode];
                 }
             }
         }];
    }
}

#pragma mark - privateMethod

- (void)getCheckingCode
{
    WS(b_self)
    [_userService getExuserCodeWithPhone:_mobilePhone
                                callback:^(BOOL succ, NSString *err)
     {
         b_self.isLoading = NO;
         if (succ)
         {
             [self startTimming];
         }
         else if (err.length > 0)
         {
             [METoast toastWithMessage:err];
         }
     }];
}

- (void)startTimming
{
    HYLoginViewCell *phoneCell = (HYLoginViewCell*)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (phoneCell)
    {
        [phoneCell startTiming];
    }
}

- (void)setupRegisterButtonStatus
{
    if (_mobilePhone.length > 0 && _validateCode.length > 0 && _inviteCode.length > 0)
    {
        _completeRegister.enabled = YES;
    }
    else
    {
        _completeRegister.enabled = NO;
    }
}

- (void)completeRegisterAction:(UIButton *)btn
{
    NSString *error = nil;
    if (![_mobilePhone checkPhoneNumberValid])
    {
        error = @"请输入正确的手机号码";
    }
    else if (_validateCode.length == 0)
    {
        error = @"请输入验证码";
    }
    else if (_inviteCode.length == 0)
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
             }
             else
             {
                 [METoast toastWithMessage:err];
             }
         }];
    }
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
    
    if (!_registered)
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
        }
        else
        {
            [self.navigationController dismissViewControllerAnimated:YES
                                                          completion:nil];
        }
    }
    
    //统计
    [HYAnalyticsManager sendUserRegisterType:101];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        _mobilePhone = @"";
        [self.tableview reloadData];
    }
    else if (buttonIndex == 1)
    {
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 202)
    {
        _inviteCode = textField.text;
    }
    
    [self setupRegisterButtonStatus];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
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
    
    [self setupRegisterButtonStatus];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "])
    {
        return NO;
    }
    
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
    
    [self setupRegisterButtonStatus];
    return YES;
}


@end
