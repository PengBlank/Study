//
//  HYOnlineBuyCarSecondStepViewController.m
//  Teshehui
//
//  Created by Kris on 15/9/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYUpdateToOfficialUserViewController.h"

#import "HYCardTypeListViewController.h"
#import "HYCheckInsuranceViewController.h"
#import "METoast.h"
#import "HYSiRedPacketsViewController.h"

#import "HYAppDelegate.h"
#import "HYActivateInfo.h"

#import "HYOnlineBuycardReq.h"
#import "CQBaseRequest.h"
#import "HYAlipayOrder.h"
#import "HYPaymentViewController.h"
#import "HYMyInformationViewController.h"
#import "HYUserUpgradeRequest.h"
#import "HYUserInfo.h"
#import "HYUserService.h"

#import "HYActivateFillUserInfoView.h"
#import "HYPickerToolView.h"

UIKIT_EXTERN NSString * const LoginStatusChangeNotification;

@interface HYUpdateToOfficialUserViewController ()
<HYActivateFillUserInfoViewDelegate,
HYCardTypeListViewControllerDelegate,
HYCheckInsuranceDelegate>
{
    HYPickerToolView *_pickerView;
}

@property (nonatomic, strong) HYActivateFillUserInfoView *fillInfoView;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong)  HYUserInfo *userInfo;
@property (nonatomic, strong) HYUserService *userService;

@end

@implementation HYUpdateToOfficialUserViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:.91 alpha:1];
    
    HYActivateFillUserInfoView *fillInfoView = [[HYActivateFillUserInfoView alloc] initWithFrame:frame];
    fillInfoView.delegate = self;
    [self.view addSubview:fillInfoView];
    self.fillInfoView = fillInfoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"升级";
    self.navigationController.navigationBarHidden = NO;
    
    self.fillInfoView.feeDesc = @"会员服务费￥100/年（促销期间终身制）";
    self.fillInfoView.commitBtnTitle = @"升级";
    
    _userInfo = [HYUserInfo getUserInfo];
    //实名认证的用户 升级的请求的参数在这里初始化
    
    _fillInfoView.userName = _userInfo.realName;
    if (_userInfo.certificateCode)
    {
        HYCardType *cardInfo = [[HYCardType alloc] init];
        cardInfo.certifacateCode = _userInfo.certificateCode;
        cardInfo.certifacateName = _userInfo.certificateName;
        _fillInfoView.cardInfo = cardInfo;
    }
    _fillInfoView.idNum = _userInfo.certificateNumber;
    _fillInfoView.sex = _userInfo.localSex;
    if (_userInfo.localSex != HYSexUnknown
        && _userInfo.idAuthentication.integerValue == 1) {
        _fillInfoView.sexCanEdit = NO;
    }
    else {
        _fillInfoView.sexCanEdit = YES;
    }
    _fillInfoView.isAuthentificated = _userInfo.idAuthentication.integerValue;
    
    /// 如果只有一个controller,可以取消
    if (self.navigationController && self.navigationController.viewControllers.count == 1 &&
        self.navigationController.presentingViewController)
    {
        self.navigationItem.leftBarButtonItem = self.cancelItemBar;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToRootViewController:(id)sender
{
    NSArray *controllers = self.navigationController.viewControllers;
    if (controllers.count > 0 && self == [controllers objectAtIndex:0])
    {
        [self.navigationController dismissViewControllerAnimated:YES
                                                      completion:nil];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)cancelUpgrad:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}


#pragma mark private methods

/// 升级需要保险
- (void)agreeActivating
{
    if (!_isLoading)
    {
        _isLoading = YES;
        WS(weakSelf);
        [HYLoadHubView show];
        [self.userService upgradeWithBuyPolicy:YES
                                    isContinue:NO
                                    policyType:_fillInfoView.policeType.insuranceTypeCode
                                      realName:_fillInfoView.userName
                                         idNum:_fillInfoView.idNum
                                        idCode:_fillInfoView.cardInfo.certifacateCode
                                           sex:_fillInfoView.sex
                                      birthDay:_fillInfoView.birthday
                                        mobile:_userInfo.mobilePhone
                                      callback:^(HYUserUpgradeResponse *repsonse)
         {
             
             [weakSelf updateWithUpgradeResponse:repsonse error:nil];
         }];
    }
}

- (void)updateWithUpgradeResponse:(HYUserUpgradeResponse *)response error:(NSError *)error
{
    [HYLoadHubView dismiss];
    _isLoading = NO;
    if (response.status == 200)
    {
        HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
        payVC.navbarTheme = self.navbarTheme;
        payVC.amountMoney = response.orderAmount;
        payVC.orderID = response.orderId;
        payVC.orderCode = response.orderNumber;
        payVC.type = Pay_Upgrad;
        payVC.productDesc = [NSString stringWithFormat:@"【特奢汇】在线购卡: %@", response.orderNumber]; //商品描述
        
        [self.navigationController pushViewController:payVC animated:YES];
        
        payVC.paymentCallback = ^(HYPaymentViewController *payvc, id data)
        {
            if (payvc.presentingViewController) {
                [payvc.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [payvc.navigationController popToRootViewControllerAnimated:YES];
            }
            [HYSiRedPacketsViewController showWithPoints:@"1000" completeBlock:nil];
        };
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:response.suggestMsg
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - delegates
#pragma mark -- HYCardTypeListViewControllerDelegate
- (void)didSelectCardtype:(HYCardType *)card
{
    self.fillInfoView.cardInfo = card;
    [self.fillInfoView reloadData];
}

#pragma mark -- InsuarceCheckDelegate
- (void)didAgreeInsurance
{
    self.fillInfoView.agreeInsurance = YES;
    [self.fillInfoView reloadData];
}

#pragma mark -- HYFillInfoViewDelegate

- (void)didClickCommit
{
    [self agreeActivating];
}
- (void)didClickInsuranceComments
{
    HYCheckInsuranceViewController *vc = [[HYCheckInsuranceViewController alloc] init];
    vc.delegate = self;
    vc.isAgree = _fillInfoView.agreeInsurance;
    vc.insuranceProvision = _fillInfoView.policeType.insuranceProvision;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didSelectCardType
{
    HYCardTypeListViewController *vc = [[HYCardTypeListViewController alloc] init];
    vc.navbarTheme = self.navbarTheme;
    vc.title = @"选择证件类型";
    vc.delegate = self;
    vc.type = UseForBuyInsourance;
    vc.navbarTheme = self.navbarTheme;
    vc.selectedCard = self.fillInfoView.cardInfo;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)didSelectInsurace
{
    [HYLoadHubView show];
    WS(weakSelf);
    [self.userService getPolicyTypesWithRequestType:2 callback:^(NSString *err, NSArray *types)
     {
         [HYLoadHubView dismiss];
         if (err)
         {
             [METoast toastWithMessage:err];
         }
         else
         {
             [weakSelf showPolicyTypes:types];
         }
     }];
}

- (void)showPolicyTypes:(NSArray *)policyTypes
{
    if (!_pickerView) {
        _pickerView = [[HYPickerToolView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
    }
    NSMutableArray *data = [NSMutableArray array];
    for (HYPolicyType *type in policyTypes) {
        [data addObject:type.insuranceTypeName];
    }
    _pickerView.dataSouce = data;
    [_pickerView showWithAnimation:YES];
    WS(weakSelf);
    _pickerView.didSelectItem = ^(NSInteger idx){
        HYPolicyType *policy = [policyTypes objectAtIndex:idx];
        weakSelf.fillInfoView.policeType = policy;
        [weakSelf.fillInfoView reloadData];
    };
}

- (HYUserService *)userService
{
    if (!_userService) {
        _userService = [[HYUserService alloc] init];
    }
    return _userService;
}


@end
