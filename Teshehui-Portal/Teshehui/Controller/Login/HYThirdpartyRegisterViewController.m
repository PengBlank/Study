//
//  HYLoginV2ValidateViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYThirdpartyRegisterViewController.h"
#import "HYSiRedPacketsViewController.h"
#import "HYLoginV2TextCell.h"
#import "HYLoginV2CodeCell.h"
#import "NSString+Addition.h"
#import "HYAppDelegate.h"
#import "HYUserService.h"
#import "HYLoginViewCell.h"
#import "HYLoginViewCheckingCodeCell.h"
#import "HYLoginViewInviteCodeCell.h"
#import "METoast.h"

UIKIT_EXTERN NSString * const LoginStatusChangeNotification;

@interface HYThirdpartyRegisterViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate
>
{
    HYUserService *_userService;
}
@property (nonatomic, strong) UITableView *tableView;

//数据
@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *validateCode;
@property (nonatomic, strong) NSString *inviteCode;

//控制变量
@property (nonatomic, assign) BOOL didSendCode;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, assign) NSInteger registered; //-1 未知，0未注,1已注册

@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation HYThirdpartyRegisterViewController

- (void)dealloc
{
    [_userService cancel];
    [_userService cancel];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _didSendCode = NO;
        _isLoading = NO;
        _userService = [[HYUserService alloc] init];
        _registered = -1;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0f];
    
    self.tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //head
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 10)];
    self.tableView.tableHeaderView = head;
    
    //foot
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 65)];
//    UIImage *disable = [[UIImage imageNamed:@"btn_login_new_disable"] stretchableImageWithLeftCapWidth:3 topCapHeight:5];
//    UIImage *normal = [UIImage imageNamed:@"btn_login_new"];
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:
                          CGRectMake(24, 25, CGRectGetWidth(frame)-48, 44)];
//    [loginBtn setBackgroundImage:normal
//                        forState:UIControlStateNormal];
//    [loginBtn setBackgroundImage:disable
//                        forState:UIControlStateDisabled];
    loginBtn.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    [loginBtn setTitle:@"确定登录"
              forState:UIControlStateNormal];
    [loginBtn addTarget:self
                 action:@selector(nextAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:loginBtn];
    _loginBtn = loginBtn;
    loginBtn.enabled = NO;
    self.tableView.tableFooterView = foot;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"绑定手机号码";
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - private
- (void)setupLoginButtonStatus
{
    switch (_registered)
    {
        case YES:
            if (_mobilePhone.length > 0 && _validateCode.length)
            {
                _loginBtn.backgroundColor = [UIColor colorWithRed:223/255.0f green:58/255.0f blue:60/255.0f alpha:1.0f];
                _loginBtn.enabled = YES;
            }
            else
            {
                _loginBtn.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
                _loginBtn.enabled = NO;
            }
            break;
        case NO:
            if (_mobilePhone.length > 0 && _validateCode.length > 0 && _inviteCode.length > 0)
            {
                _loginBtn.backgroundColor = [UIColor colorWithRed:223/255.0f green:58/255.0f blue:60/255.0f alpha:1.0f];
                _loginBtn.enabled = YES;
            }
            else
            {
                _loginBtn.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
                _loginBtn.enabled = NO;
            }
            break;
        default:
            break;
    }
}

- (void)listenToInviteCode:(UITextField *)sender
{
    _inviteCode = sender.text;
}

- (void)nextAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (!_isLoading)
    {
        NSString *err = nil;
        if (!_didSendCode)
        {
            err = @"请先发送验证码";
        }
        else if (_validateCode.length == 0)
        {
            err = @"请输入验证码";
        }
        else if (_inviteCode.length == 0 && !_registered)
        {
            err = @"请输入邀请码";
        }
        if (err)
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:err
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
            [METoast toastWithMessage:err];
        }
        else
        {
            __weak typeof(self) b_self = self;
            _isLoading = YES;
            [HYLoadHubView show];
            
            [_userService thirdPartyRegisterWithPhone:_mobilePhone
                                            checkCode:_validateCode
                                           inviteCode:_inviteCode
                                                token:_thirdpartyToken
                                               openid:_thirdpartyOpenid
                                                 type:_thirdpartyType
                                             callback:^(HYUserInfo *user, NSString *err)
             {
                 [HYLoadHubView dismiss];
                 b_self.isLoading = NO;
                 if (user)
                 {
                     //如果切换了账号则需要清除内存
                     NSString *lastNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumber];
                     BOOL needClearCache = !([lastNumber isEqualToString:user.mobilePhone]);
                     
                     [[NSUserDefaults standardUserDefaults] setBool:YES
                                                             forKey:kIsLogin];
                     [user saveData];
                     [[NSNotificationCenter defaultCenter] postNotificationName:LoginStatusChangeNotification
                                                                         object:nil];
                     
                     if (!self.registered)
                     {
                         HYSiRedPacketsViewController *vc = [[HYSiRedPacketsViewController alloc]initWithNibName:@"HYSiRedPacketsViewController" bundle:nil];
                         vc.cashCard = user.points;
                         [self presentViewController:vc animated:YES completion:nil];
                         WS(weakSelf);
                         vc.completeBlock = ^{
                             [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                         };
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
                             [b_self.navigationController dismissViewControllerAnimated:YES
                                                                             completion:nil];
                         }
                     }
                 }
                 else
                 {
//                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                     message:err
//                                                                    delegate:nil
//                                                           cancelButtonTitle:@"确定"
//                                                           otherButtonTitles:nil];
//                     [alert show];
                     [METoast toastWithMessage:err];
                 }
             }];
        }
    }
}

- (void)validateCodeAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (!_isLoading)
    {
        if (_mobilePhone.length == 0)
        {
            [METoast toastWithMessage:@"请输入您的手机号码"];
        }
        else
        {
            if (![_mobilePhone checkPhoneNumberValid])
            {
                //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                //                                                            message:@"请填写有效的手机号码"
                //                                                           delegate:nil
                //                                                  cancelButtonTitle:@"确定"
                //                                                  otherButtonTitles:nil];
                //            [alert show];
                [METoast toastWithMessage:@"请填写有效的手机号码"];
            }
            else
            {
                __weak typeof(self) b_self = self;
                _isLoading = YES;
                [HYLoadHubView show];
                [_userService getThirdpartyCheckCodeWithPhone:_mobilePhone
                                                     callback:^(BOOL succ, NSString *err)
                 {
                     [HYLoadHubView dismiss];
                     b_self.isLoading = NO;
                     if (succ)
                     {
                         b_self.didSendCode = YES;
                         [b_self startTimming];
                     }
                     else
                     {
                         //                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                         //                                                                     message:@"发送手机号码失败"
                         //                                                                    delegate:nil
                         //                                                           cancelButtonTitle:@"确定"
                         //                                                           otherButtonTitles:nil];
                         //                     [alert show];
                         [METoast toastWithMessage:@"发送手机号码失败"];
                     }
                 }];
                
                [_userService checkUserIsRegisterd:_mobilePhone
                                          callback:^(BOOL registered, NSString *err)
                 {
                     b_self.registered = registered;
                     [b_self.tableView reloadData];
                 }];
            }
        }
    }
}


- (void)startTimming
{
    HYLoginV2CodeCell *codeCell = (HYLoginV2CodeCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (codeCell)
    {
        [codeCell startTiming];
    }
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _registered ? 2 : 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
//        HYLoginV2CodeCell *codeCell = [tableView dequeueReusableCellWithIdentifier:@"codeCell"];
//        if (!codeCell)
//        {
//            codeCell = [[HYLoginV2CodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"codeCell"];
//            [codeCell.codeBtn addTarget:self
//                                 action:@selector(validateCodeAction:)
//                       forControlEvents:UIControlEventTouchUpInside];
//            codeCell.textField.placeholder = @"请输入手机号码";
//            codeCell.textField.delegate = self;
//            [codeCell.codeBtn setTitle:@"验证"
//                              forState:UIControlStateNormal];
//            codeCell.textField.keyboardType = UIKeyboardTypeNumberPad;
//        }
//        codeCell.textField.tag = 200;
//        codeCell.textField.text = _mobilePhone;
        HYLoginViewCell *phoneCell = [HYLoginViewCell cellWithTableView:tableView];
        [phoneCell setDataWithType:kLoginTypeQuicklyLogin phoneNum:_mobilePhone cardNum:nil];
        phoneCell.lineView.frame = CGRectMake(TFScalePoint(20), 60, TFScalePoint(300), 0.5);
        phoneCell.textField.frame = CGRectMake(TFScalePoint(20), 30, TFScalePoint(280)-90, 20);
        phoneCell.codeBtn.frame = CGRectMake(CGRectGetMaxX(phoneCell.textField.frame), 20, 90, 35);
        
        [phoneCell.codeBtn addTarget:self action:@selector(validateCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        phoneCell.textField.delegate = self;
        phoneCell.textField.tag = 200;
        phoneCell.backgroundColor = [UIColor whiteColor];
        
        return phoneCell;
    }
    else if (indexPath.row == 1)
    {
//        HYLoginV2TextCell *phoneCell = [tableView dequeueReusableCellWithIdentifier:@"phoneCell"];
//        if (!phoneCell)
//        {
//            phoneCell = [[HYLoginV2TextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"phoneCell"];
//            phoneCell.textField.placeholder = @"请输入验证码";
//            phoneCell.textField.delegate = self;
//        }
//        phoneCell.textField.text = _validateCode;
//        phoneCell.textField.tag = 201;
        HYLoginViewCheckingCodeCell *checkingCell = [HYLoginViewCheckingCodeCell cellWithTableView:tableView];
        [checkingCell setDataWithType:kLoginTypeQuicklyLogin checkingCode:_validateCode password:nil];
        checkingCell.codeTextField.frame = CGRectMake(TFScalePoint(20), 30, TFScalePoint(280), 20);
        checkingCell.lineView.frame = CGRectMake(TFScalePoint(20), 60, TFScalePoint(300), 0.5);
        checkingCell.codeTextField.delegate = self;
        checkingCell.codeTextField.tag = 201;
        checkingCell.backgroundColor = [UIColor whiteColor];
        
        return checkingCell;
    }
    else if (indexPath.row == 2)
    {
        HYLoginViewInviteCodeCell *inviteCell = [HYLoginViewInviteCodeCell cellWithTableView:tableView];
//        inviteCell.askBtn.frame = CGRectMake(TFScalePoint(275), 0, 20, 20);
        inviteCell.lineView.frame = CGRectMake(TFScalePoint(20), 60, TFScalePoint(300), 0.5);
//        inviteCell.inviteTextField.frame = CGRectMake(TFScalePoint(20), 0, TFScalePoint(280)-25, 20);
        inviteCell.inviteTextField.text = _inviteCode;
        inviteCell.inviteTextField.delegate = self;
        inviteCell.inviteTextField.tag =202;
        inviteCell.backgroundColor = [UIColor whiteColor];
        return inviteCell;
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

#pragma mark - text field
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    UITextFieldEx *textFieldEx = (UITextFieldEx *)textField;
//    textFieldEx.isActive = NO;
//    
//    switch (textField.tag) {
//        case 200:
//            _mobilePhone = textField.text;
//            break;
//        case 201:
//            _validateCode = textField.text;
//            break;
//        case 202:
//            _inviteCode = textField.text;
//            break;
//        default:
//            break;
//    }
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    UITextFieldEx *textFieldEx = (UITextFieldEx *)textField;
//    textFieldEx.isActive = YES;
//}
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
    
    [self setupLoginButtonStatus];
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
    
    [self setupLoginButtonStatus];
    return YES;
}

@end
