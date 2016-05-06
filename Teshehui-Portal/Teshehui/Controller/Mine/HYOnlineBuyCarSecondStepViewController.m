//
//  HYOnlineBuyCarSecondStepViewController.m
//  Teshehui
//
//  Created by Kris on 15/9/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYOnlineBuyCarSecondStepViewController.h"
#import "HYPickerToolView.h"

#import "HYActivateV2InfoViewController.h"
#import "HYCardActiveFourRequest.h"
#import "HYCardActiveFourFiveRequest.h"
#import "HYCardType.h"
#import "HYCardTypeListViewController.h"
#import "HYCheckInsuranceViewController.h"
#import "METoast.h"
#import "UIAlertView+BlocksKit.h"

#import "HYAppDelegate.h"
#import "HYActivateInfo.h"

#import "HYOnlineBuycardReq.h"
#import "CQBaseRequest.h"
#import "HYAlipayOrder.h"
#import "HYPaymentViewController.h"
#import "HYMyInformationViewController.h"
#import "HYGetPolicyListRequest.h"
#import "HYGetPolicyListResponse.h"
#import "HYSiRedPacketsViewController.h"

#import "HYActivateFillUserInfoView.h"
#import "HYUmengLoginClick.h"
#import "HYAnalyticsManager.h"

UIKIT_EXTERN NSString * const LoginStatusChangeNotification;

/*
 在线购卡新增两个参数：
 policy_type    保险类型1：平安   2：人寿
 has_policy      是否购买保险  1：需要  0：不需要
 
*/


@interface HYOnlineBuyCarSecondStepViewController ()
<
HYCardTypeListViewControllerDelegate,
HYCheckInsuranceDelegate
>
{
    HYOnlineBuycardReq *_buyCardReq;
    HYGetPolicyListRequest *_getPolicyTypeRequest;
    
    HYPickerToolView *_pickerView;
}

@property (nonatomic, strong) HYActivateFillUserInfoView *fillInfoView;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) HYCardActiveFourFiveRequest *fourRequest;

@end

@implementation HYOnlineBuyCarSecondStepViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_pickerView dismissWithAnimation:YES];
    
    [_buyCardReq cancel];
    _buyCardReq = nil;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
//        _sex = HYSexMale;
//        _agreeInsurance = NO;
//        _cardInfo = [[HYCardType alloc] init];
//        _markType = _cardInfo;
//        _cardInfo.certifacateCode = @"01";
//        _cardInfo.certifacateName = @"身份证";
////        _birthday = @"1980-01-01";
//        _insuranceTypeName = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    self.navigationController.navigationBarHidden = NO;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    //    frame.origin.y = 64;
    
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:.91 alpha:1];
    
    HYActivateFillUserInfoView *fillInfoView = [[HYActivateFillUserInfoView alloc] initWithFrame:frame];
    fillInfoView.sexCanEdit = YES;
    [self.view addSubview:fillInfoView];
    self.fillInfoView = fillInfoView;
    
    WS(weakSelf);
    fillInfoView.didClickCommit = ^{
        [weakSelf agreeActivating];
    };
    fillInfoView.didClickInsuranceComments = ^{
        [weakSelf checkProtocol];
    };
    fillInfoView.didSelectInsurace = ^{
        [weakSelf loadPolicyList];
    };
    fillInfoView.didSelectCardType = ^{
        [weakSelf checkCardTypeList];
    };
}

#pragma mark private methods

- (void)agreeActivating
{
    if (!_isLoading)
    {
        _isLoading = YES;
        if (!_buyCardReq)
        {
            _buyCardReq = [[HYOnlineBuycardReq alloc] init];
        }
        [_buyCardReq cancel];
        _buyCardReq.name = _fillInfoView.userName;
        _buyCardReq.phone = _cellphoneNum;
        _buyCardReq.invitationCode = _inviteCode;
        _buyCardReq.idCardType = _fillInfoView.cardInfo.certifacateCode;
        _buyCardReq.idCardNum = _fillInfoView.idNum;
        _buyCardReq.policyType = _fillInfoView.policeType.insuranceTypeCode;
        _buyCardReq.hasPolicy = @"1";
        _buyCardReq.cardPrice = @"100";
        _buyCardReq.productSkuCode = @"CARD0000001";
        _buyCardReq.birthday = _fillInfoView.birthday;
        _buyCardReq.sex = hyGetJavaSexStringFromSex(_fillInfoView.sex);
        [HYLoadHubView show];
        __weak typeof(self) b_self = self;
        [_buyCardReq sendReuqest:^(id result, NSError *error) {
            [b_self updateBuyCardResult:result error:error];
            
            [HYUmengLoginClick clickMoreBuycardNextInsuaresBuyClose];
        }];
    }
    
    [HYUmengLoginClick clickMoreBuycardNextInsuaresBuy];
}

- (void)updateBuyCardResult:(id)result error:(NSError *)error
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:error.domain
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
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
        payVC.productDesc = [NSString stringWithFormat:@"【特奢汇】在线购卡: %@", reponse.order_no]; //商品描述;
        
        [self.navigationController pushViewController:payVC animated:YES];
        
        /// 支付成功后显示撕红包，然后退回登录
        WS(weakSelf);
        payVC.paymentCallback = ^(HYPaymentViewController *payvc, id data)
        {
            //统计  APP-在线购卡注册
            [HYAnalyticsManager sendUserRegisterType:103];
            
            HYSiRedPacketsViewController *vc = [[HYSiRedPacketsViewController alloc]initWithNibName:@"HYSiRedPacketsViewController" bundle:nil];
            vc.cashCard = @"2000";;
            vc.completeBlock = ^{
                [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"购卡成功，请重新登录!" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }];
            };
            [weakSelf presentViewController:vc animated:YES completion:nil];
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

//- (void)agreeAction:(UIButton *)btn
//{
//    btn.selected = !btn.selected;
//    _agreeInsurance = btn.selected;
//    if (_agreeInsurance)
//    {
//        HYCheckInsuranceViewController *vc = [[HYCheckInsuranceViewController alloc] init];
//        vc.insuranceProvision = _insuranceProvision;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}

-(void)checkProtocol
{
    HYCheckInsuranceViewController *vc = [[HYCheckInsuranceViewController alloc] init];
    vc.delegate = self;
    vc.isAgree = _fillInfoView.agreeInsurance;
    vc.insuranceProvision = _fillInfoView.policeType.insuranceProvision;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadPolicyList
{
    [HYLoadHubView show];
    
    if (!_getPolicyTypeRequest)
    {
        _getPolicyTypeRequest = [[HYGetPolicyListRequest alloc] init];
    }
    [_getPolicyTypeRequest cancel];
    
    _getPolicyTypeRequest.type = @"3";
    
    __weak typeof(self) b_self = self;
    [_getPolicyTypeRequest sendReuqest:^(HYGetPolicyListResponse *result, NSError *error)
     {
         if (b_self)
         {
             [b_self updateWithPolicyList:result error:error];
         }
     }];
}

- (void)updateWithPolicyList:(HYGetPolicyListResponse *)result error:(NSError *)error
{
    [HYLoadHubView dismiss];
    if (result.status == 200)
    {
        if (!_pickerView) {
            _pickerView = [[HYPickerToolView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
        }
        NSMutableArray *data = [NSMutableArray array];
        for (HYPolicyType *type in result.dataList) {
            [data addObject:type.insuranceTypeName];
        }
        _pickerView.dataSouce = data;
        [_pickerView showWithAnimation:YES];
        WS(weakSelf);
        _pickerView.didSelectItem = ^(NSInteger idx){
            HYPolicyType *policy = [result.dataList objectAtIndex:idx];
            weakSelf.fillInfoView.policeType = policy;
            [weakSelf.fillInfoView reloadData];
        };
    }
    else
    {
        [METoast toastWithMessage:error.domain];
    }
}

- (void)checkCardTypeList
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

#pragma mark - Delegates
#pragma mark - HYCardTypeListViewControllerDelegate
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

@end


