//
//  HYOnlineBuyCardFirstStepViewController.m
//  Teshehui
//
//  Created by Kris on 15/9/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYOnlineBuyCardFirstStepViewController.h"
#import "HYOnlineBuyCarSecondStepViewController.h"
#import "HYSiRedPacketsViewController.h"
#import "HYAppDelegate.h"
#import "UIAlertView+BlocksKit.h"
#import "HYAnalyticsManager.h"
//
//  HYLoginV2ViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLoginViewController.h"
#import "HYThirdPartyLoginController.h"
#import "HYBaseLineCell.h"
#import "HYLoginV2TextCell.h"
#import "HYLoginV2CodeCell.h"
#import "HYImageButton.h"
#import "HYAccountLoginViewController.h"
#import "HYAppDelegate.h"
#import "HYThirdPartyLoginRequest.h"
#import "HYThirdpartyRegisterViewController.h"
#import "HYExuserCheckRequest.h"
#import "HYExuserGetCodeRequest.h"
#import "HYExuserLoginRequest.h"
#import "NSString+Addition.h"
#import "HYActivateV2ViewController.h"
#import "HYUserService.h"
#import "HYActivateV2InfoViewController.h"
#import "HYRPCompleteAnimationView.h"
#import "HYSendCheckRequest.h"
#import "HYSendCheckResponse.h"
#import "METoast.h"
#import "HYMyInformationViewController.h"
#import "HYUpdateToOfficialUserViewController.h"
#import "HYBuyCardFirstRequest.h"
#import "HYBuyCardFirstStepResponse.h"
#import "UIAlertView+BlocksKit.h"
#import "HYOnlineBuycardReq.h"
#import "HYPaymentViewController.h"
#import "HYInfoInputCell.h"
#import "HYInfoValidateCell.h"
#import "HYInfoInputButtonCell.h"

/// 随机验证码
#import "HYGetWebLinkRequest.h"
#import "HYGetWebLinkResponse.h"
#import "HYGetRandomInviteCodeRequest.h"
#import "HYGetRandomInviteCodeResponse.h"

#import "HYUmengLoginClick.h"

UIKIT_EXTERN NSString * const LoginStatusChangeNotification;

@interface HYOnlineBuyCardFirstStepViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
HYThirdPartyLoginControllerDelegate,
UITextFieldDelegate>
{
    HYSendCheckRequest* _sendCheckRequest;
    HYBuyCardFirstRequest *_buyCardFirstStepReq;
    
    //table
    UITableView *_tableView;
    
    BOOL _didSendCode;
    
    NSString *_mobilePhone;
    NSString *_validateCode;
    NSString *_inviteCode;
    
    BOOL _isLoading;    //加载标志位
    
    HYUserService *_userService;
    HYOnlineBuycardReq* _buyCardReq;
    
    /// 随机邀请码
    HYGetWebLinkRequest* _linkRequest;
    HYGetRandomInviteCodeRequest *_getRandomCodeRequest;
}

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *validateCode;
@property (nonatomic, strong) NSString *inviteCode;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, assign) NSInteger registered; //-1 未知，0未注,1已注册

@end

@implementation HYOnlineBuyCardFirstStepViewController

- (void)dealloc
{
    [_sendCheckRequest cancel];
    _sendCheckRequest = nil;
    
    [HYLoadHubView dismiss];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _didSendCode = NO;
        
        _registered = -1;
        
        _isLoading = NO;
        
        _userService = [[HYUserService alloc] init];
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:.94 alpha:1];
    
    //table
    UITableView *table = [[UITableView alloc] initWithFrame:frame
                                                      style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 50;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 10)];
    [self.view addSubview:table];
    self.tableView = table;
    
    //foot
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)-290)];
    footview.backgroundColor = [UIColor clearColor];
    table.tableFooterView = footview;
    
    UIImage *disable = [[UIImage imageNamed:@"btn_login_new_disable"] stretchableImageWithLeftCapWidth:3 topCapHeight:5];
    UIImage *normal = [UIImage imageNamed:@"btn_login_new"];
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:
                          CGRectMake(24, 30, CGRectGetWidth(frame)-48, 44)];
    [loginBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:disable forState:UIControlStateDisabled];
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn addTarget:self
                 action:@selector(startAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:loginBtn];
    self.nextBtn = loginBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"验证手机号码";
    [self checkNextBtn];
}

#pragma mark - functions
#pragma mark -- private

- (void)checkNextBtn
{
    if (self.mobilePhone.length > 0 &&
        self.validateCode.length > 0 &&
        self.inviteCode.length > 0)
    {
        self.nextBtn.enabled = YES;
    }
    else
    {
        self.nextBtn.enabled = NO;
    }
}

- (void)showInviteCodeInfo
{
    if (!_linkRequest)
    {
        _linkRequest = [[HYGetWebLinkRequest alloc] init];
    }
    [_linkRequest cancel];
    _linkRequest.type = InviteCodeInfo;
    
    [HYLoadHubView show];
    [_linkRequest sendReuqest:^(id result, NSError *error) {
        
        if (result && [result isKindOfClass:[HYGetWebLinkResponse class]])
        {
            [HYLoadHubView dismiss];
            HYGetWebLinkResponse *response = (HYGetWebLinkResponse *)result;
            if (response.status == 200)
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"邀请码是加入特奢汇的凭证"
                                      message:response.infoStr
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"获取随机邀请码",nil];
                
                [alert show];
            }
        }
    }];
}

- (void)getRandomInviteCode
{
    if (!_getRandomCodeRequest)
    {
        _getRandomCodeRequest = [[HYGetRandomInviteCodeRequest alloc]init];
    }
    [_getRandomCodeRequest cancel];
    [HYLoadHubView show];
    
    __weak typeof(self) weakSelf = self;
    [_getRandomCodeRequest sendReuqest:^(HYGetRandomInviteCodeResponse *result, NSError *error) {
        [HYLoadHubView dismiss];
        if (result)
        {
            weakSelf.inviteCode = result.invteCode;
            [weakSelf.tableView reloadData];
            [weakSelf checkNextBtn];
        }
    }];
}

- (void)startAction:(UIButton *)btn
{
    [HYUmengLoginClick clickMoreBuycardNext];
    
    [self.view endEditing:YES];
    
    if (!_isLoading)
    {
        NSString *error = nil;
        if (![_mobilePhone checkPhoneNumberValid])
        {
            error = @"请填写有效的手机号码";
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
            __weak typeof(self) b_self = self;
            if (!_buyCardFirstStepReq)
            {
                _buyCardFirstStepReq = [[HYBuyCardFirstRequest alloc]init];
            }
            _buyCardFirstStepReq.phone = _mobilePhone;
            _buyCardFirstStepReq.phone_code = _validateCode;
            _buyCardFirstStepReq.invitationCode = _inviteCode;
            _isLoading = YES;
            [_buyCardFirstStepReq sendReuqest:^(HYBuyCardFirstStepResponse *result, NSError *error)
             {
                 [b_self updateWithFirstStepRepsonse:result error:error];
             }];
        }
    }
}

- (void)updateWithFirstStepRepsonse:(HYBuyCardFirstStepResponse *)response error:(NSError *)err
{
    self.isLoading = NO;
    if (200 == response.status)
    {
        [UIAlertView bk_showAlertViewWithTitle:@""
                                       message:@"在线购卡将赠送您一年的保险，最高价值210万。您是否需要？" cancelButtonTitle:@"直接购买"
                             otherButtonTitles:@[@"需要保险"]
                                       handler:^(UIAlertView *alertView, NSInteger buttonIndex)
        {
            if (buttonIndex == 0)
            {
                [self buyCard];
            }
            else
            {
                HYOnlineBuyCarSecondStepViewController *vc = [[HYOnlineBuyCarSecondStepViewController alloc]init];
                vc.cellphoneNum = _mobilePhone;
                vc.authCode = _validateCode;
                vc.inviteCode = _inviteCode;
                [self.navigationController pushViewController:vc animated:YES];
                
                [HYUmengLoginClick clickMoreBuycardNextInsuares];
            }
        }];
    }
    else
    {
        [self alertMessage:err.domain];
    }
}

/// 直接购卡
- (void)buyCard
{
    if (!_isLoading)
    {
        _isLoading = YES;
        _buyCardReq = [[HYOnlineBuycardReq alloc] init];
        _buyCardReq.name = nil;
        _buyCardReq.phone = _mobilePhone;
        _buyCardReq.invitationCode = _inviteCode;
        _buyCardReq.idCardType = nil;
        _buyCardReq.idCardNum = nil;
        _buyCardReq.hasPolicy = @"0";
        _buyCardReq.cardPrice = @"100";
        _buyCardReq.productSkuCode = @"CARD0000001";
        _buyCardReq.policyType = @"0";
        
        [HYLoadHubView show];
        __weak typeof(self) b_self = self;
        [_buyCardReq sendReuqest:^(HYOnlineBuyCardResp *result, NSError *error) {
            [b_self updateBuyCardResult:result error:error];
            [HYUmengLoginClick clickMoreBuycardNextInsuaresBuyClose];
        }];
        
    }
    
    [HYUmengLoginClick clickMoreBuycardNextBuy];
}

- (void)updateBuyCardResult:(id)result error:(NSError *)error
{
    [HYLoadHubView dismiss];
    _isLoading = NO;
    if (error)
    {
        [METoast toastWithMessage:error.domain];
    }
    else if ([result isKindOfClass:[HYOnlineBuyCardResp class]])
    {
        HYOnlineBuyCardResp *reponse = (HYOnlineBuyCardResp *)result;
        
        HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
        payVC.navbarTheme = self.navbarTheme;
        payVC.amountMoney = reponse.pay_total;
        payVC.orderID = reponse.order_id;
        payVC.orderCode = reponse.order_no;
        payVC.type = Pay_BuyCard;
        payVC.productDesc = [NSString stringWithFormat:@"【特奢汇】在线购卡: %@", reponse.order_no]; //商品描述
        
        [self.navigationController pushViewController:payVC animated:YES];
        self.navigationController.navigationBarHidden = NO;
        
        /// 支付成功后显示撕红包，然后显示首页
        payVC.paymentCallback = ^(HYPaymentViewController *payvc, id data)
        {
            //统计  APP-在线购卡注册
            [HYAnalyticsManager sendUserRegisterType:103];
            
            HYSiRedPacketsViewController *vc = [[HYSiRedPacketsViewController alloc]initWithNibName:@"HYSiRedPacketsViewController" bundle:nil];
            vc.cashCard = @"2000";
            [self presentViewController:vc animated:YES completion:nil];
            vc.completeBlock = ^{
                HYAppDelegate *app = (HYAppDelegate*)[UIApplication sharedApplication].delegate;
                [app loadContentView:YES];
            };
        };
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"在线购卡失败"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

- (void)sendValidate:(NSString *)phone callback:(void (^)(BOOL success))callback
{
    if (phone.length == 0)
    {
        [METoast toastWithMessage:@"请输入您的手机号码！"];
        callback(NO);
    }
    else if (![phone checkPhoneNumberValid])
    {
        [METoast toastWithMessage:@"请填写有效的手机号码！"];
        callback(NO);
    }
    else
    {
        _sendCheckRequest = [[HYSendCheckRequest alloc] init];
        _sendCheckRequest.phone_mob = _mobilePhone;
        WS(weakSelf);
        [HYLoadHubView show];
        [ _sendCheckRequest sendReuqest:^(id result, NSError *error) {
            [HYLoadHubView dismiss];
            if ([result isKindOfClass:[HYSendCheckResponse class]])
            {
                HYSendCheckResponse *response = (HYSendCheckResponse *)result;
                if (response.status == 200)
                {
                    callback(YES);
                }
                else if (500 == response.status && response.code == 29901039)
                {
                    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"该手机号已被注册" cancelButtonTitle:@"换个号码" otherButtonTitles:@[@"现在登录"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 0)
                        {
                            weakSelf.mobilePhone = nil;
                            HYInfoValidateCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                            if (cell) {
                                cell.mob = nil;
                            }
                        }
                        else
                        {
                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                        }
                    }];
                }
                else
                {
                    [METoast toastWithMessage:response.rspDesc];
                    callback(NO);
                }
            }
            else
            {
                [METoast toastWithMessage:@"网络出现问题,请稍后再试"];
                callback(NO);
            }
        }];
    }
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[HYBaseLineCell class]])
    {
        NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
        if(indexPath.row == totalRow -1)
        {
            HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
            lineCell.separatorLeftInset = 0.0f;
        }
        else
        {
            HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
            lineCell.separatorLeftInset = 15;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *reuse = @"validate";
        HYInfoValidateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell)
        {
            cell = [[HYInfoValidateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        WS(weakSelf);
        __weak HYInfoValidateCell *weakCell = cell;
        cell.startValidate = ^(NSString *mob) {
            [weakSelf sendValidate:mob callback:^(BOOL success) {
                if (weakCell && success) {
                    [weakCell startCounting];
                }
            }];
        };
        cell.mob = self.mobilePhone;
        cell.showName = NO;
        cell.didGetValue = ^(NSString *value){
            weakSelf.mobilePhone = value;
            [weakSelf checkNextBtn];
        };
        return cell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *reuse = @"info";
        HYInfoInputCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell)
        {
            cell = [[HYInfoInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
            
        }
        WS(weakSelf);
        cell.name = @"验证码";
        cell.value = self.validateCode;
        cell.valueField.placeholder = @"请输入短信验证码";
        cell.didGetValue = ^(NSString *value) {
            weakSelf.validateCode = value;
            [weakSelf checkNextBtn];
        };
        cell.valueField.keyboardType = UIKeyboardTypeNumberPad;
        return cell;
    }
    else
    {
        HYInfoInputButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"invite"];
        if (!cell)
        {
            cell = [[HYInfoInputButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"invite"];
        }
        WS(weakSelf);
        cell.name = @"邀请码";
        cell.valueField.placeholder = @"请输入邀请码";
        cell.value = _inviteCode;
        cell.didGetValue = ^(NSString *value) {
            weakSelf.inviteCode = value;
            [weakSelf checkNextBtn];
        };
        cell.didClickButton = ^{
            [weakSelf showInviteCodeInfo];
        };
        UIImage *img = [UIImage imageNamed:@"online_buycard_ask"];
        [cell.additionBtn setImage:img
                          forState:UIControlStateNormal];
        [cell.additionBtn setImage:img
                          forState:UIControlStateHighlighted];
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
}


#pragma mark - actionSheet delegate

- (void)updateLoginWithUserInfo:(HYUserInfo *)userinfo
{
    /*
     [_userService updateLoginStatusWithUserInfo:userinfo];
     */
    
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:kIsLogin];
    [userinfo saveData];
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginStatusChangeNotification
                                                        object:nil];
    
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

#pragma mark alert
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        [self getRandomInviteCode];
    }
}

#pragma mark - util
- (void)alertMessage:(NSString *)message
{
    [METoast toastWithMessage:message];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                    message:message
//                                                   delegate:nil
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil];
//    [alert show];
}

@end


