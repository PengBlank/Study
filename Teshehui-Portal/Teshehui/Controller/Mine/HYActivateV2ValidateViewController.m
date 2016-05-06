//
//  HYActivateV2ValidateViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/17.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYActivateV2ValidateViewController.h"
#import "HYLoginV2TextCell.h"
#import "HYLoginV2CodeCell.h"
#import "HYActivateV2InfoViewController.h"
#import "HYCardActiveTwoRequest.h"
#import "HYCardActiveThreeRequest.h"
#import "UIAlertView+BlocksKit.h"
#import "HYCardActiveFourFiveRequest.h"
#import "HYSiRedPacketsViewController.h"
#import "HYAppDelegate.h"
#import "HYInfoValidateCell.h"
#import "HYInfoInputCell.h"
#import "HYUmengLoginClick.h"
#import "METoast.h"
#import "NSString+Addition.h"
#import "HYAnalyticsManager.h"

UIKIT_EXTERN NSString *const LoginStatusChangeNotification;

@interface HYActivateV2ValidateViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate>
{
    NSString *_mobilePhone;
    NSString *_validateCode;
    
    NSString *_gettedCode;  //由接口返回的code
    
    BOOL _isLoading;
    
    HYCardActiveFourFiveRequest *_fourRequest;  //不需保险直接升级
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) HYCardActiveTwoRequest *twoRequest;
@property (nonatomic, strong) HYCardActiveThreeRequest *threeRequest;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *validateCode;

@end

@implementation HYActivateV2ValidateViewController

-(void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_twoRequest cancel];
    [_threeRequest cancel];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:.91 alpha:1];
    
    self.tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 10)];
    [self.view addSubview:self.tableView];
    
    //head
//    UIView *headview = [[UIView alloc] initWithFrame:
//                        CGRectMake(0, 0, CGRectGetWidth(frame), TFScalePoint(80))];
//    headview.backgroundColor = [UIColor clearColor];
//    _tableView.tableHeaderView = headview;
//    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
//    logo.frame = TFRectMake(0, 0, 102, 36);
//    logo.center = CGPointMake(CGRectGetWidth(frame)/2, TFScalePoint(30));
//    [headview addSubview:logo];
    
    //foot
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 65)];
    UIImage *disable = [[UIImage imageNamed:@"btn_login_new_disable"] stretchableImageWithLeftCapWidth:3 topCapHeight:5];
    UIImage *normal = [UIImage imageNamed:@"btn_login_new"];
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:
                          CGRectMake(24, 15, CGRectGetWidth(frame)- 48, 44)];
    [loginBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:disable forState:UIControlStateDisabled];
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:loginBtn];
    self.tableView.tableFooterView = foot;
    self.nextBtn = loginBtn;
    _isLoading = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"验证手机号码";
    self.navigationController.navigationBarHidden = NO;
    [self checkNextBtn];
}

#pragma mark - event


#pragma mark - functions
#pragma mark -- private

- (void)checkNextBtn
{
    if (_mobilePhone.length > 0 && _validateCode.length > 0)
    {
        self.nextBtn.enabled = YES;
    }
    else
    {
        self.nextBtn.enabled = NO;
    }
}

- (void)nextAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (!_isLoading)
    {
        if (_validateCode.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"请输入验证码"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            _threeRequest = [[HYCardActiveThreeRequest alloc] init];
            _threeRequest.memberCardNumber = self.activateInfo.memberCardNumber;
            _threeRequest.checkCode = _validateCode;
            [HYLoadHubView show];
            _isLoading = YES;
            __weak typeof(self) weakSelf = self;
            [_threeRequest sendReuqest:^(HYCardActiveThreeResponse* result, NSError *error)
             {
                 [weakSelf updateWithActivateResponse:result error:error];
             }];
        }
    }
}

- (void)updateWithActivateResponse:(HYCardActiveThreeResponse *)response error:(NSError *)error
{
    [HYLoadHubView dismiss];
    if ([response isKindOfClass:[HYCardActiveThreeResponse class]] && response.status == 200)
    {
        [UIAlertView bk_showAlertViewWithTitle:@"" message:@"激活会员将赠送您一年的保险，最高价值210万。您是否需要？" cancelButtonTitle:@"直接激活" otherButtonTitles:@[@"需要保险"] handler:^(UIAlertView *alertView, NSInteger buttonIndex)
        {
            if (buttonIndex == 0)
            {
                [self noNeedInsurace];
            }
            else
            {
                HYActivateV2InfoViewController *info = [[HYActivateV2InfoViewController alloc] init];
                info.activeInfo = self.activateInfo;
                [self.navigationController pushViewController:info animated:YES];
            }
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:error.domain
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    self.isLoading = NO;
}

/// 不需保险直接激活
- (void)noNeedInsurace
{
    if (!_isLoading)
    {
        _fourRequest = [[HYCardActiveFourFiveRequest alloc] init];
        _fourRequest.memberCardNumber = self.activateInfo.memberCardNumber;
        _fourRequest.password = self.activateInfo.memberCardPassword;
        [HYLoadHubView show];
        _isLoading = YES;
        __weak typeof(self) b_self = self;
        [_fourRequest sendReuqest:^(HYCardActiveFourFiveResponse* result, NSError *error)
         {
             b_self.isLoading = NO;
             [HYLoadHubView dismiss];
             [b_self updateBuyCardResult:result error:error];
         }];
    }
    
    [HYUmengLoginClick clickMoreActivateNextNextInsuare];
}

/// 直接激活结果
- (void)updateBuyCardResult:(id)result error:(NSError *)error
{
    _isLoading = NO;
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:error.domain
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else if ([result isKindOfClass:[HYCardActiveFourFiveResponse class]])
    {
        HYCardActiveFourFiveResponse *response = (HYCardActiveFourFiveResponse *)result;
        
        [response.userinfo saveData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginStatusChangeNotification object:nil];
        
        HYSiRedPacketsViewController *vc = [[HYSiRedPacketsViewController alloc]initWithNibName:@"HYSiRedPacketsViewController" bundle:nil];
        vc.cashCard = @"2000";
        [self presentViewController:vc animated:YES completion:nil];
        vc.completeBlock = ^{
            HYAppDelegate* appDelegate = (HYAppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate loadContentView:YES];
        };
        
        //统计 102：APP-实体卡激活
        [HYAnalyticsManager sendUserRegisterType:102];
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

/// 发送验证码
- (void)sendValidate:(NSString *)phone callback:(void (^)(BOOL success))callback
{
    if (!_isLoading)
    {
        if (phone.length == 0)
        {
            [METoast toastWithMessage:@"请输入您的手机号码"];
            callback(NO);
        }
        else if (![phone checkPhoneNumberValid])
        {
            [METoast toastWithMessage:@"请填写有效的手机号码"];
            callback(NO);
        }
        else
        {
            _twoRequest = [[HYCardActiveTwoRequest alloc] init];
            _twoRequest.mobilePhone = phone;
            _twoRequest.memberCardNumber = self.activateInfo.memberCardNumber;
            
            [HYLoadHubView show];
            _isLoading = YES;
            __weak typeof (self) b_self = self;
            [_twoRequest sendReuqest:^(id result, NSError *error)
             {
                 [HYLoadHubView dismiss];
                 
                 NSString *err = nil;
                 if ([result isKindOfClass:[HYCardActiveTwoResponse class]])
                 {
                     HYCardActiveTwoResponse *response = (HYCardActiveTwoResponse *)result;
                     if (response.status == 200)
                     {
                         callback(YES);
                     }
                     else
                     {
                         err = response.suggestMsg;
                     }
                 }
                 else
                 {
                     err = @"网络出现问题,请稍后再试";
                 }
                 if (err)
                 {
                     [METoast toastWithMessage:err];
                     callback(NO);
                 }
                 b_self.isLoading = NO;
             }];
        }
    }
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

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
        cell.mob = _mobilePhone;
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
        cell.placeholder = @"请输入验证码";
        cell.value = self.validateCode;
        cell.valueField.returnKeyType = UIReturnKeyNext;
        cell.valueField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.didGetValue = ^(NSString *value) {
            weakSelf.validateCode = value;
            [weakSelf checkNextBtn];
        };
        cell.didReturn = ^{
            
        };
        return cell;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
}

@end
