//
//  SceneBookDetailViewController.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "SceneBookDetailViewController.h"

#import "SceneBookDetailTableController.h"
#import "SceneBookDetailTabController.h"
#import "PayResultOfSceneCtrl.h"    // 支付成功
#import "Masonry.h"

#import "HYUserInfo.h"          // 用户信息头文件
#import "SceneBookDetailRequest.h"
#import "SceneBookInfo.h"
#import "MJExtension.h"

#import "DefineConfig.h"
#import "METoast.h"
#import "UIUtils.h"

#import "HYAlipayOrder.h"
#import "HYPaymentViewController.h"
#import "TYAnalyticsManager.h"
#import "HYExperienceLeakViewController.h"
#import "HYNormalLeakViewController.h"

@interface SceneBookDetailViewController ()<SceneBookDetailTabControllerControllerDelegae>{
    SceneBookDetailTableController *tableController;
    SceneBookDetailTabController *_tabController;
}

@end

@implementation SceneBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购买详情";

    CGRect rctView            = self.view.frame;
    CGFloat fFooterViewHeight = 50.0f;
    UIStoryboard *sb          = [UIStoryboard storyboardWithName:@"SceneBookDetail" bundle:nil];
    // 添加tableview
    tableController = [sb instantiateInitialViewController];
    tableController.detailInfo = _detailInfo;
    tableController.view.frame          = CGRectMake(0, 0, CGRectGetWidth(rctView), CGRectGetMaxY(rctView) - fFooterViewHeight);
    tableController.view.translatesAutoresizingMaskIntoConstraints = NO; //要实现自动布局，必须把该属性设置为NO
    [self addChildViewController:tableController];
    [self.view addSubview:tableController.view];
    [tableController didMoveToParentViewController:self];
    
    // 添加底部的bar
    _tabController = [sb instantiateViewControllerWithIdentifier:@"SceneBookDetailTabController"];
    _tabController.buttonDelegate = self;
    _tabController.detailInfo = _detailInfo;
    _tabController.view.frame       = CGRectMake(0, CGRectGetMaxY(rctView) - fFooterViewHeight-self.navigationController.navigationBar.frame.size.height - 20, CGRectGetWidth(rctView), fFooterViewHeight);
    _tabController.view.translatesAutoresizingMaskIntoConstraints = NO; //要实现自动布局，必须把该属性设置为NO
    [self addChildViewController:_tabController];
    [self.view addSubview:_tabController.view];
    [_tabController didMoveToParentViewController:self];
    
    // 添加约束
    WS(weakSelf);
    [_tabController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(0);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(0);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(fFooterViewHeight);
    }];
    
    [tableController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(0);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(0);
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(fFooterViewHeight);
    }];
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
// 子视图delegate
- (void) SceneBookDetailTabControllerPayButtonClick {
    

    
    NSLog(@"SceneBookDetailTabControllerPayButtonClick");
    if (tableController.txtContacts.text.length > 0) {
        
        //统计
        [[TYAnalyticsManager sharedManager] sendAnalyseForSceneBtnClick:ScenePayBtn];
        
        [self networkCreateSceneOrder];
    }else{
        [self setButtonPayEnabled];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"联系人不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void) setButtonPayEnabled {
    _tabController.btnPay.enabled = YES;
}
// 生成订单网络请求
- (void) networkCreateSceneOrder {
    
    [HYLoadHubView show];
    SceneBookDetailRequest *bookRequest              = [[SceneBookDetailRequest alloc] init];
    bookRequest.interfaceURL = [NSString stringWithFormat:@"%@/v4/Scene/CreateSceneOrder",BASEURL];
    bookRequest.httpMethod   = @"POST";
    bookRequest.postType     = JSON;
    bookRequest.interfaceType = DotNET2;
    
    HYUserInfo *userInfo      = [HYUserInfo getUserInfo];
    bookRequest.merId         = _detailInfo.merId;
    bookRequest.merchantName  = _detailInfo.merchantName;
    bookRequest.cardNo        = userInfo.number;
    bookRequest.mobile        = tableController.txtPhone.text;
    bookRequest.userName      = tableController.txtContacts.text;
    bookRequest.amount        = _detailInfo.thsPrice;
    bookRequest.coupon        = _detailInfo.coupon;
    bookRequest.productName   = @"Scene";
    bookRequest.packId        = _detailInfo.packId;
    bookRequest.packageName   = _detailInfo.packageName;
    bookRequest.packagePerson = _detailInfo.person ?: @"";
    bookRequest.packageCount  = @"1";//　写死一份
    bookRequest.cityName      = _cityName;//                                  城市名
    bookRequest.useDate       = tableController.dateSelected ? tableController.strDate : @"";
    
    WS(weakSelf);
    [bookRequest sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         [weakSelf setButtonPayEnabled];
         
         if(result){
             
             NSDictionary *objDic = [result jsonDic];
             
             int code = [objDic[@"code"] intValue];
             
             if (code == 0) {  //这种接口将成功定义为 0
                 
                 NSDictionary *dic = objDic[@"data"];

                 if(weakSelf.detailInfo.thsPrice.floatValue == 0 && weakSelf.detailInfo.coupon != 0){ //纯现金券支付  直接跳转原来的支付流程
                     [weakSelf pushPaySuccessWithType:ScenePay BookInfo:[SceneBookInfo objectWithKeyValues:dic]];
                 }else{
                     [weakSelf gotoPay:[SceneBookInfo objectWithKeyValues:dic]];
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
                     [METoast toastWithMessage:msg ?: @"生成订单失败"];
                 }
             }
             
         }else{
             [METoast toastWithMessage:@"网络出错，请稍后重试"];
         }
     }];
}

- (void)gotoPay:(SceneBookInfo *)_bookInfo{
    
    HYAlipayOrder *alOrder = [[HYAlipayOrder alloc] init];
    alOrder.partner            = PartnerID;
    alOrder.seller             = SellerID;
    alOrder.tradeNO            = _bookInfo.c2b_trade_no;// self.C2B_Order_Number; //订单号 (显示订单号)
    alOrder.productName        = [NSString stringWithFormat:@"【特奢汇】O2O商家订单: %@",_bookInfo.c2b_trade_no];//商品标题 (显示订单号)
    alOrder.productDescription = [NSString stringWithFormat:@"【特奢汇】O2O商家订单: %@", _bookInfo.c2b_trade_no];//商品描述
    alOrder.amount             = [NSString stringWithFormat:@"%0.2f",_detailInfo.thsPrice.floatValue];//商品价格
    
    HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
    payVC.navbarTheme = self.navbarTheme;
    payVC.alipayOrder = alOrder;
    payVC.amountMoney = _detailInfo.thsPrice;//付款总额
    payVC.point       = _detailInfo.coupon.floatValue;//  现金券
    payVC.orderID     = _bookInfo.c2b_order_id;//用户获取银联支付流水号
    payVC.orderCode   = _bookInfo.c2b_trade_no;//订单号
    payVC.type        = Pay_O2O_QRScan;
    payVC.O2OpayType  = ScenePay;
    
    __weak typeof(self) weakSelf = self;
    [payVC setBusinessPaymentSuccess:^(O2OPayType type) {
        
        [weakSelf pushPaySuccessWithType:type BookInfo:_bookInfo];
        
    }];
    
    [self.navigationController pushViewController:payVC animated:YES];
}
//　回调支付成功
- (void)pushPaySuccessWithType:(O2OPayType)type BookInfo:(SceneBookInfo *)_bookInfo{
    
    PayResultOfSceneCtrl *vc = [[PayResultOfSceneCtrl alloc] init];
    
    vc.O2O_OrderNo  = _bookInfo.o2o_trade_no;
    vc.orderId      = _bookInfo.o2o_trade_no;
    
    vc.storeName    = _detailInfo.merchantName;
    vc.money        = _detailInfo.thsPrice;
    vc.coupon       = _detailInfo.coupon;
    vc.packName     = _detailInfo.packageName;
    vc.payCode      = _bookInfo.validCode;
    vc.comeType     = BusinessDetail;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)dealloc{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
