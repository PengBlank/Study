//
//  ConfirmOrderViewController.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "HYPaymentViewController.h"
#import "PaySuccessViewController.h"
#import "OrderStatusRequest.h"
#import "HYAlipayOrder.h"
#import "HYUserInfo.h"

#import "UIColor+expanded.h"
#import "UIView+Frame.h"
#import "UIImage+Addition.h"
#import "UIImage+Common.h"

#import "DefineConfig.h"
#import "Masonry.h"
#import "METoast.h"

@interface ConfirmOrderViewController ()

@property (nonatomic,strong) OrderStatusRequest         *orderStatusRequest;
@property (nonatomic,assign) NSInteger                  success_pay;

@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认付款信息";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    UIView *bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = [NSString stringWithFormat:@"消费商家:%@",self.orderInfo.MerchantsName];
    nameLabel.textColor = [UIColor colorWithHexString:@"373737"];
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    [bgView addSubview:nameLabel];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UIColor colorWithHexString:@"dfdfdf"]];
    [bgView addSubview:lineView];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"消费金额：";
    moneyLabel.textColor = [UIColor colorWithHexString:@"272727"];
    moneyLabel.font = [UIFont systemFontOfSize:17];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:moneyLabel];
    
    UILabel *moneyDetail = [[UILabel alloc] init];
    moneyDetail.text = self.orderInfo ? [NSString stringWithFormat:@"￥%@",self.orderInfo.Amount] : @"";
    moneyDetail.textColor = [UIColor colorWithHexString:@"b80000"];
    moneyDetail.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:moneyDetail];
    
    UILabel *couponLabel = [[UILabel alloc] init];
    couponLabel.text = @"现金券：";
    couponLabel.textColor = [UIColor colorWithHexString:@"272727"];
    couponLabel.font = [UIFont systemFontOfSize:17];
    couponLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:couponLabel];
    
    UILabel *couponDetail = [[UILabel alloc] init];
    couponDetail.text = self.orderInfo.Coupon;
    couponDetail.textColor = [UIColor colorWithHexString:@"b80000"];
    couponDetail.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:couponDetail];
    
    UIButton *affirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    affirmBtn.tag = 10086;
    [affirmBtn setTitle:@"确 认" forState:UIControlStateNormal];
    [[affirmBtn titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [affirmBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"b80000"]] forState:UIControlStateNormal];
    [[affirmBtn layer] setCornerRadius:5];
    [affirmBtn setClipsToBounds:YES];
    [affirmBtn addTarget:self action:@selector(affirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:affirmBtn];

    WS(weakSelf);
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.width.mas_equalTo(kScreen_Width);
        make.height.mas_equalTo(178);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(36);
        make.top.mas_equalTo(bgView.mas_top).offset(21.5);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(20);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(21.5);
        make.width.mas_equalTo(kScreen_Width - 40);
        make.height.mas_equalTo(.5);
    }];
    
    [moneyLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.top.mas_equalTo(lineView.mas_bottom).offset(22.5);
    }];
    
    [moneyDetail  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(moneyLabel.mas_right).offset(10);
        make.top.mas_equalTo(moneyLabel.mas_top);
    }];
    
    [couponLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.top.mas_equalTo(moneyLabel.mas_bottom).offset(22.5);
        make.width.mas_equalTo(moneyLabel.mas_width);
    }];
    
    [couponDetail  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(moneyDetail.mas_left);
        make.top.mas_equalTo(couponLabel.mas_top);
    }];
    
    [affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).offset(15);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(37);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-37);
        make.height.mas_equalTo(42.5);
        make.width.mas_equalTo(kScreen_Width - 37 * 2);
        
    }];

}


- (void)dealloc{
    [HYLoadHubView dismiss];
    [self.orderStatusRequest cancel];
    self.orderStatusRequest = nil;
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)backToRootViewController:(id)sender{
    
    if (self.pageType) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)affirmBtnAction{
    
    [HYLoadHubView show];
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    self.orderStatusRequest = [[OrderStatusRequest alloc] init];
    self.orderStatusRequest.interfaceURL = [NSString stringWithFormat:@"%@/tshorder/CheckOrder",ORDER_API_URL];
    self.orderStatusRequest.interfaceType = DotNET;
    self.orderStatusRequest.httpMethod    = @"POST";
    self.orderStatusRequest.UserId           = userInfo.userId;                               //  用户id
    self.orderStatusRequest.Coupon           = self.orderInfo.Coupon;
    self.orderStatusRequest.O2O_Order_Number = self.orderInfo.O2O_Order_Number;
    self.orderStatusRequest.C2B_Order_Number = self.orderInfo.C2B_Order_Number;
    self.orderStatusRequest.CardNo           = userInfo.number;
    
    WS(weakSelf);
    [self.orderStatusRequest sendReuqest:^(id result, NSError *error)
     {
        [HYLoadHubView dismiss];
         if(result){
             NSDictionary *objDic = [result jsonDic];
             
             int code = [objDic[@"Result"] intValue];
             if (code == 1) { //状态值为1 代表请求成功  其他为失败
                 NSDictionary *objKeyValue = objDic[@"Data"];
                 weakSelf.success_pay = [objKeyValue[@"IsSucc"] integerValue];
                 
                 if (weakSelf.success_pay != 1) {
                     [METoast toastWithMessage:@"订单异常，请稍后再试"];
                     return;
                 }else{

                     if(self.orderInfo.Amount.floatValue != 0){
                         [weakSelf gotoPay];
                     }else{
                         [weakSelf pushPaySuccessWithType:BusinessPay];
                     }
            
                 }
                 
             }else{
                 NSString *msg = objDic[@"Remark"];
                 [METoast toastWithMessage:msg];
                 return;
             }
         }else{
             [METoast toastWithMessage:@"无法连接服务器，请稍后再试"];
         }
     }];
}

- (void)gotoPay{
    
    HYAlipayOrder *alOrder = [[HYAlipayOrder alloc] init];
    alOrder.partner = PartnerID;
    alOrder.seller = SellerID;
    alOrder.tradeNO = self.orderInfo.C2B_Order_Number; //订单号 (显示订单号)
    alOrder.productName = [NSString stringWithFormat:@"【特奢汇】O2O商家订单: %@", self.orderInfo.C2B_Order_Number]; //商品标题 (显示订单号)
    alOrder.productDescription = [NSString stringWithFormat:@"【特奢汇】O2O商家订单: %@", self.orderInfo.C2B_Order_Number]; //商品描述
    alOrder.amount = [NSString stringWithFormat:@"%0.2f",self.orderInfo.Amount.floatValue]; //商品价格
    
    HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
    payVC.navbarTheme = self.navbarTheme;
    payVC.alipayOrder = alOrder;
    payVC.amountMoney = self.orderInfo.Amount;   //付款总额
    payVC.point = self.orderInfo.Coupon.floatValue;     //  现金券
    payVC.orderID = self.orderInfo.C2B_Order_ID;            //订单ID
    payVC.orderCode = self.orderInfo.C2B_Order_Number;        //订单号
//    payVC.O2O_OrderNo = self.orderInfo.O2O_Order_Number;
//    payVC.O2O_storeName = self.orderInfo.MerchantsName;
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
    tmpCtrl.merId = self.orderInfo.MerchantId;
    tmpCtrl.storeName = self.orderInfo.MerchantsName;
    tmpCtrl.money = self.orderInfo.Amount;
    tmpCtrl.O2O_OrderNo = self.orderInfo.O2O_Order_Number;
    tmpCtrl.payType = type;
    tmpCtrl.orderType = @"1";
    if (self.orderInfo.Coupon.floatValue != 0) {
        tmpCtrl.coupon =self.orderInfo.Coupon;
    }
    [self.navigationController pushViewController:tmpCtrl animated:YES];
    
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
