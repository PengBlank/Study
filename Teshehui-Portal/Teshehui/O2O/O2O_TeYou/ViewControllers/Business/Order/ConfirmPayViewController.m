//
//  ConfirmPayViewController.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "ConfirmPayViewController.h"
#import "HYPaymentViewController.h"
#import "PrepaySuccessViewController.h"
#import "HYExperienceLeakViewController.h"
#import "PaySuccessViewController.h"
#import "HYNormalLeakViewController.h"
#import "HYAlipayOrder.h"
#import "DefineConfig.h"
#import "CreatOrderRequest.h"
#import "BalancePayRequest.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "NSString+Common.h"
#import "Masonry.h"
#import "METoast.h"
#import "HYUserInfo.h"
#import "ConfirmPayView.h"
#import <QuartzCore/QuartzCore.h>

#define myDotNumbers @"0123456789.\n"
#define myNumbers @"0123456789\n"

@interface ConfirmPayViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{

    UIImageView *_bgImageV;
    UIImageView *_bgImageV2;
    ConfirmPayView *_payView;
}
@property (nonatomic,strong) CreatOrderRequest  *creatOrderRequest;
@property (nonatomic,strong) BalancePayRequest  *balancePayRequest;
@property (nonatomic,strong) NSString  *C2B_Order_Number;
@property (nonatomic,strong) NSString  *O2O_Order_Number;
@property (nonatomic,strong) NSString  *C2B_Order_ID;
@property (nonatomic,strong) NSString  *payMoney;
@property (nonatomic,strong) NSString  *payCoupon;

@end

@implementation ConfirmPayViewController

- (void)dealloc{
    [HYLoadHubView dismiss];
    [self.creatOrderRequest cancel];
    self.creatOrderRequest = nil;
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self loadHeadView];
}

- (void)loadHeadView{
    
    WS(weakSelf);
    _payView = [[ConfirmPayView alloc] initWithFrame:self.view.bounds payType:_payType];
    _payView.isChange = self.isChange; // 改变字段
    [_payView setMerName:self.businessdetailInfo.MerchantsName withSender:self];
//    [_payView setConfirmBlock:^(NSString *moneyString, NSString *couponString) {
//        
//        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//        weakSelf.payMoney  = [moneyString stringByTrimmingCharactersInSet:whitespace]; //去掉多余空格
//        weakSelf.payCoupon = [couponString stringByTrimmingCharactersInSet:whitespace]; //去掉多余空格
//        
//        [weakSelf affirmBtnAction];
//    }];

    [self.view addSubview:_payView];
    
    UIButton *affirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [affirmBtn setTitle:_payType == 1 ? @"实体店余额支付" : @"去支付" forState:UIControlStateNormal];
    [[affirmBtn titleLabel] setFont:[UIFont systemFontOfSize:17]];
    [affirmBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"b80000"]] forState:UIControlStateNormal];
    [affirmBtn addTarget:self action:@selector(payBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:affirmBtn];
    
    [affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kScreen_Width);
    }];
}

- (void)payBtnAction:(UIButton *)btn{
    
    UITextField *mText = [_payView viewWithTag:100];
    UITextField *cText = [_payView viewWithTag:101];
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    self.payMoney  = [mText.text stringByTrimmingCharactersInSet:whitespace]; //去掉多余空格
    self.payCoupon = [cText.text stringByTrimmingCharactersInSet:whitespace]; //去掉多余空格

    NSString *title = btn.titleLabel.text;
    if ([title isEqualToString:@"去支付"]) {
        [self affirmBtnAction];
    }else{
        //实体店余额支付
        [self storeBalancePay];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    _bgImageV = [_payView viewWithTag:102];
    _bgImageV2 = [_payView viewWithTag:103];
    
    if (textField.tag == 100) {
    
        [_bgImageV.layer setBorderColor:[UIColor colorWithHexString:@"0xb80000"].CGColor];
        [_bgImageV2.layer setBorderColor:[UIColor colorWithHexString:@"0xbfbfbf"].CGColor];
    }else{
        [_bgImageV.layer setBorderColor:[UIColor colorWithHexString:@"0xbfbfbf"].CGColor];
        [_bgImageV2.layer setBorderColor:[UIColor colorWithHexString:@"0xb80000"].CGColor];
    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
  
    if (textField.text.length > 8 && range.length != 1) {
        return NO;
    }
    
    if(textField.tag == 101){
        
        if (![string isPureInt] && range.length != 1) {
            return NO;
        }
    }else{
        
            NSCharacterSet *cs;
            NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
        
        
            if (NSNotFound == nDotLoc && 0 != range.location) {
                cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers]invertedSet];
                if ([string isEqualToString:@"."]) {
                    return YES;
                }
                if (textField.text.length >= 13) {
                    return NO;
                }
            }
            else {
                cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers]invertedSet];
                if (textField.text.length >= 13) {
                    return  NO;
                }
            }
        
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [string isEqualToString:filtered];
            if (!basicTest) {
                return NO;
            }
            if (NSNotFound != nDotLoc && range.location > nDotLoc + 2) { // 小数点后面两位
                return NO;
            }
            if (NSNotFound != nDotLoc && range.location > nDotLoc) {
                if ([string isEqualToString:@"."]) {
                    return NO;
                }
            }
    }
    return YES;
}

- (void)storeBalancePay{
    
    
    [self.view endEditing:YES];
    
    if (self.payMoney.floatValue == 0) {
        [METoast toastWithMessage:@"请输入有效金额"];
        return;
    }
    
    [HYLoadHubView show];
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    self.view.userInteractionEnabled = NO;
    self.balancePayRequest = [[BalancePayRequest alloc] init];
    self.balancePayRequest.interfaceURL     = [NSString stringWithFormat:@"%@/v4/Charge/Cost",ORANGE_API_URL];
    self.balancePayRequest.interfaceType    = DotNET2;
    self.balancePayRequest.postType         = JSON;
    self.balancePayRequest.httpMethod       = @"POST";
    
    self.balancePayRequest.amount           = self.payMoney.doubleValue;
    self.balancePayRequest.userId           = userInfo.userId;
    self.balancePayRequest.username         = userInfo.realName.length == 0 ? userInfo.mobilePhone : userInfo.realName;
    self.balancePayRequest.mobile           = userInfo.mobilePhone;
    self.balancePayRequest.cardno           = userInfo.number;
    self.balancePayRequest.istsh            = @"1"; //1 主动付款
    self.balancePayRequest.hard_Ware        = @"";
    self.balancePayRequest.merid            = self.businessdetailInfo.MerId;
    self.balancePayRequest.payee            = self.businessdetailInfo.MerId;
    self.balancePayRequest.payeename        = self.businessdetailInfo.MerchantsName;

    WS(weakSelf);
    [self.balancePayRequest sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         [weakSelf.view endEditing:YES];
         if(result){
             NSDictionary *objDic = [result jsonDic];
             NSDictionary *dic = objDic[@"data"];
             int code = [objDic[@"code"] intValue];
             if (code == 0) {
                 
//                 tmpCtrl.MerId = self.orderInfo.MerchantId ? : self.merId;
//                 tmpCtrl.MerName = self.orderInfo.MerchantsName ? : self.merName;
//                 tmpCtrl.money = self.orderInfo.Amount ? : self.money;
//                 tmpCtrl.coupon = @"0";
//                 tmpCtrl.orderDate = self.orderInfo.CreateOn ? : timeStr;
//                 tmpCtrl.orderId = self.orderInfo.O2O_Order_Number ? : self.o2o_trade_no;
//                 tmpCtrl.orderType = self.orderInfo.OrderType.integerValue ? : 1;

                 
                 PrepaySuccessViewController *vc = [[PrepaySuccessViewController alloc] init];
                 vc.money = weakSelf.payMoney;
                 vc.successType = 0; //付款类型
                 vc.o2o_trade_no = dic[@"o2o_trade_no"];
                 vc.merId = weakSelf.businessdetailInfo.MerId;
                 vc.merName = weakSelf.businessdetailInfo.MerchantsName;
                 [weakSelf.navigationController pushViewController:vc animated:YES];
                 
             }else{
                 
                
                 PrepaySuccessViewController *vc = [[PrepaySuccessViewController alloc] init];
                 vc.remindMoney = dic[@"balance"];
                 vc.successType = 3; //付款类型
                 vc.comeType = 1;
                 vc.merId = weakSelf.businessdetailInfo.MerId;
                 [weakSelf.navigationController pushViewController:vc animated:YES];
             }
         }else{
             [METoast toastWithMessage:@"服务器请求异常"];
         }
         
           self.view.userInteractionEnabled = YES;
     }];

}


- (void)affirmBtnAction{
    
    [self.view endEditing:YES];

    if (self.payMoney.floatValue == 0 && self.payCoupon.floatValue == 0) { //两个都没有，不让生成订单
        DebugNSLog(@"%f and  %f",self.payMoney.floatValue,self.payCoupon.floatValue);
        [METoast toastWithMessage:@"请输入有效金额或现金券"];
        return;
    }
   
    self.view.userInteractionEnabled = NO;
    [HYLoadHubView show];
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];

    self.creatOrderRequest = [[CreatOrderRequest alloc] init];
    self.creatOrderRequest.interfaceURL     = [NSString stringWithFormat:@"%@/TSHOrder/Create",ORDER_API_URL_V3];
    self.creatOrderRequest.interfaceType = DotNET2;
    self.creatOrderRequest.postType      = JSON;
    self.creatOrderRequest.httpMethod    = @"POST";

    self.creatOrderRequest.Coupon           = self.payCoupon.integerValue;
    self.creatOrderRequest.Amount           = self.payMoney.doubleValue;
    self.creatOrderRequest.userId           = userInfo.userId;
    self.creatOrderRequest.UserName         = userInfo.realName.length == 0 ? userInfo.mobilePhone : userInfo.realName;
    self.creatOrderRequest.Mobile           = userInfo.mobilePhone ? : @"";
    self.creatOrderRequest.CardNo           = userInfo.number? : @"";
    self.creatOrderRequest.MerId            = self.self.businessdetailInfo.MerId ? :@"";
    self.creatOrderRequest.MerchantName     = self.self.businessdetailInfo.MerchantsName? : @"";
    self.creatOrderRequest.MerchantLogo     = self.self.businessdetailInfo.Logo ? :@"";
    self.creatOrderRequest.productName      = @"TSHAPP";
    
    self.creatOrderRequest.first_area_id    = self.businessdetailInfo.first_area_id;
    self.creatOrderRequest.second_area_id   = self.businessdetailInfo.second_area_id;
    self.creatOrderRequest.third_area_id    = self.businessdetailInfo.third_area_id;
    self.creatOrderRequest.fourth_area_id   = self.businessdetailInfo.fourth_area_id;
   
    WS(weakSelf);
    [self.creatOrderRequest sendReuqest:^(id result, NSError *error)
     {
        [HYLoadHubView dismiss];
        [weakSelf.view endEditing:YES];
         if(result){
             NSDictionary *objDic = [result jsonDic];
             
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功  其他为失败
                 NSDictionary *objKeyValue = objDic[@"data"];
                
                 weakSelf.C2B_Order_Number = objKeyValue[@"c2b_trade_no"];
                 weakSelf.O2O_Order_Number = objKeyValue[@"o2o_trade_no"];
                 weakSelf.C2B_Order_ID     = objKeyValue[@"c2b_order_id"];
                 
                 if(weakSelf.payMoney.floatValue == 0 && weakSelf.payCoupon.floatValue != 0){  //此时说明用户只用现金券支付 服务器会直接扣除 不需要跳转支付页面
                     
                     PaySuccessViewController *tmpCtrl = [[PaySuccessViewController alloc] init];
                     tmpCtrl.merId = weakSelf.businessdetailInfo.MerId;
                     tmpCtrl.storeName = weakSelf.businessdetailInfo.MerchantsName;
                     tmpCtrl.coupon = weakSelf.payCoupon;
                     tmpCtrl.O2O_OrderNo = weakSelf.O2O_Order_Number;
                     tmpCtrl.orderType = @"1";
                     tmpCtrl.payType = BusinessPay;
                     [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
                     
                 }else{
                     [weakSelf gotoPay];
                 }
                 
             }else{
                 NSString *msg = objDic[@"msg"];
                 
                 if([msg isEqualToString:@"现金券不足"]){
                    /*** 这里进行现金券不足页面跳转 页面由总部那边提供***/
                     
                     if ([HYUserInfo getUserInfo].userLevel == 0) { //体验用户跳转到体验用户的页面
                         HYExperienceLeakViewController *vc = [[HYExperienceLeakViewController alloc] init];
                         [weakSelf.navigationController pushViewController:vc animated:YES];
                     }
                     else {//正式会员用户跳转到正式会员的页面
                         HYNormalLeakViewController *vc = [[HYNormalLeakViewController alloc] init];
                         vc.pushType = @"O2O";
                         [weakSelf.navigationController pushViewController:vc animated:YES];
                     }

                 }else{
                   [METoast toastWithMessage:msg];
                 }
             }
         }else{
             [METoast toastWithMessage:@"服务器请求异常"];
         }
         
           self.view.userInteractionEnabled = YES;
     }];
}

- (void)gotoPay
{
    HYAlipayOrder *alOrder = [[HYAlipayOrder alloc] init];
    alOrder.partner = PartnerID;
    alOrder.seller = SellerID;
    alOrder.tradeNO = self.C2B_Order_Number; //订单号 (显示订单号)
    alOrder.productName = [NSString stringWithFormat:@"【特奢汇】O2O商家订单: %@", self.C2B_Order_Number]; //商品标题 (显示订单号)
    alOrder.productDescription = [NSString stringWithFormat:@"【特奢汇】O2O商家订单: %@", self.C2B_Order_Number]; //商品描述
    alOrder.amount = [NSString stringWithFormat:@"%0.2f",self.payMoney.floatValue]; //商品价格
    
    HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
    payVC.navbarTheme = self.navbarTheme;
    payVC.alipayOrder = alOrder;
    payVC.amountMoney = self.payMoney;   //付款总额
    payVC.point = self.payCoupon.floatValue;     //  现金券
    payVC.orderID = self.C2B_Order_ID;          //用户获取银联支付流水号
    payVC.orderCode = self.C2B_Order_Number;        //订单号
    payVC.type = Pay_O2O_QRScan;
    payVC.O2OpayType = BusinessPay;
    
    __weak typeof(self) weakSelf = self;
    [payVC setBusinessPaymentSuccess:^(O2OPayType type) {
     
        [weakSelf pushPaySuccessWithType:type];
  
    }];
    
    [self.navigationController pushViewController:payVC animated:YES];

}

//　回调支付成功
- (void)pushPaySuccessWithType:(O2OPayType)type{
    
    PaySuccessViewController *tmpCtrl = [[PaySuccessViewController alloc] init];
    tmpCtrl.merId = self.businessdetailInfo.MerId;
    tmpCtrl.storeName = self.businessdetailInfo.MerchantsName;
    tmpCtrl.money = self.payMoney;//[NSString stringWithFormat:@"%.2f",self.payMoney.floatValue];
    tmpCtrl.O2O_OrderNo = self.O2O_Order_Number;
    tmpCtrl.payType = type;
    tmpCtrl.orderType = @"1"; //1 代表商家订单
    if (self.payCoupon.floatValue != 0) {
        tmpCtrl.coupon = self.payCoupon;
    }
    [self.navigationController pushViewController:tmpCtrl animated:YES];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
