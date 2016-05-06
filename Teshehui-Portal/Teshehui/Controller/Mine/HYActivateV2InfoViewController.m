//
//  HYActivateV2InfoViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/17.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYActivateV2InfoViewController.h"
#import "HYCardActiveFourRequest.h"
#import "HYCardActiveFourFiveRequest.h"
#import "HYCardType.h"
#import "NSDate+Addition.h"
#import "NSString+Addition.h"
#import "HYCardTypeListViewController.h"
#import "HYCheckInsuranceViewController.h"
#import "METoast.h"
#import "HYSiRedPacketsViewController.h"
#import "HYActivateFillUserInfoView.h"

#import "HYAppDelegate.h"
#import "HYActivateInfo.h"
#import "HYAnalyticsManager.h"

/*
新增两个参数：
 policy_type    保险类型0：平安   1：人寿
 has_policy      是否购买保险  0：需要  1：不需要
 
 */

UIKIT_EXTERN NSString * const LoginStatusChangeNotification;

@interface HYActivateV2InfoViewController ()
<
HYCardTypeListViewControllerDelegate,
HYCheckInsuranceDelegate,
HYActivateFillUserInfoViewDelegate>
{
    BOOL _isLoading;
}

@property (nonatomic, strong) HYActivateFillUserInfoView *fillInfoView;

@property (nonatomic, strong) HYCardActiveFourFiveRequest *fourRequest;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation HYActivateV2InfoViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    [_fourRequest cancel];
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
    //    frame.origin.y = 64;
    
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:.91 alpha:1];

    HYActivateFillUserInfoView *fillInfoView = [[HYActivateFillUserInfoView alloc] initWithFrame:frame];
    fillInfoView.commitBtnTitle = @"同意激活";
    [self.view addSubview:fillInfoView];
    fillInfoView.delegate = self;
    self.fillInfoView = fillInfoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"激活会员卡";
    self.navigationController.navigationBarHidden = NO;
    
    if (self.activeInfo)
    {
        HYPolicyType *policyType = [[HYPolicyType alloc] init];
        policyType.insuranceProvision = self.activeInfo.insuranceProvision;
        policyType.insuranceTypeCode = self.activeInfo.insuranceTypeCode;
        policyType.insuranceTypeName = self.activeInfo.insuranceTypeName;
        self.fillInfoView.policeType = policyType;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private methods


- (void)agreeActivating
{
    [self.view endEditing:YES];
    
    if (!_isLoading)
    {
        _isLoading = YES;
        
        /*
         用户注册激活接口，升级为正式会员接口请求参数增加：isBuyPolicy是否买保险0非，1是，policyType保险类型0平安1人寿。（buyPolicy修改为isBuyPolicy）
         */
        _fourRequest = [[HYCardActiveFourFiveRequest alloc] init];
        _fourRequest.memberCardNumber = _activeInfo.memberCardNumber;
        _fourRequest.realName = _fillInfoView.userName;
        _fourRequest.gender = hyGetJavaSexStringFromSex(_fillInfoView.sex);
        _fourRequest.certificateCode = _fillInfoView.cardInfo.certifacateCode;
        _fourRequest.certificateNumber = _fillInfoView.idNum;
        _fourRequest.password = self.activeInfo.memberCardPassword;
        _fourRequest.isBuyPolicy = @"1";
        _fourRequest.policyType = _activeInfo.policyType;
        _fourRequest.birthday = _fillInfoView.birthday;
        
        [HYLoadHubView show];
        _isLoading = YES;
        __weak typeof(self) b_self = self;
        [_fourRequest sendReuqest:^(HYCardActiveFourFiveResponse* result, NSError *error)
         {
             [HYLoadHubView dismiss];
             [b_self updateBuyCardResult:result error:error];
             b_self.isLoading = NO;
         }];
    }
    
    [HYUmengLoginClick clickMoreActivateNextNextActivate];
}

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
        [METoast toastWithMessage:@"会员卡激活成功"
                         duration:2
                 andCompleteBlock:nil];
        
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
                                                       message:@"会员卡激活"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

#pragma mark - Delegates
#pragma mark -- HYCardTypeListViewControllerDelegate
- (void)didSelectCardtype:(HYCardType *)card
{
    self.fillInfoView.cardInfo = card;
    [self.fillInfoView reloadData];
}

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

@end
