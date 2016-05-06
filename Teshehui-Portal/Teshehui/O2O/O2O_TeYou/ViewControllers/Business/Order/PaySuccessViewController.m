//
//  PaySuccessViewController.m
//  Teshehui
//
//  Created by xkun on 15/10/2.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "PostCommentViewController.h"
#import "BilliardOrderViewController.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "PayResultLoadingView.h"
#import "PayResultSuccessView.h"
#import "CheckPayStatusRequest.h"


@interface PaySuccessViewController ()
{
    CheckPayStatusRequest *_checkOrderStatusRq;
    NSString *_timeStr;
    
}
@property (nonatomic, strong) NSTimer   *O2ORunTimer;
@property (nonatomic, strong) PayResultSuccessView  *payResultSuccessView;
@property (nonatomic, strong) PayResultLoadingView  *payResultLoadingView;
@property (nonatomic, assign) BOOL    isPushSuccess;
@end

@implementation PaySuccessViewController


- (PayResultLoadingView *)payResultLoadingView{
    
    if (!_payResultLoadingView) {
        _payResultLoadingView = [[PayResultLoadingView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 145) payType:self.payType];
    }
    
    return _payResultLoadingView;
}

- (PayResultSuccessView *)payResultSuccessView{
    
    if (!_payResultSuccessView) {
        _payResultSuccessView = [[PayResultSuccessView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavBarHeight) payType:self.payType];
    }
    
    return _payResultSuccessView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = UIColorFromRGB(245, 245, 245);
    self.title = @"付款结果";
     [self.view addSubview:self.payResultLoadingView];
    if (self.money.floatValue == 0 || _memberPay) { //当使用的时会员卡支付或者纯现金券支付的时候不用轮询订单
        WS(weakSelf);
        if(kDevice_Is_iPhone5 || kDevice_Is_iPhone4 || IOS7_OR_LATER){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf btnClick];
            });
        }else{
            [weakSelf btnClick];
        }
        
       //  [self loadSuccessView];
    }else{
        [self runLoopOrderStatus];
    }
}

- (void)loadSuccessView{
    
    [self.payResultLoadingView removeFromSuperview];
    self.payResultLoadingView = nil;
    [self.view addSubview:self.payResultSuccessView];
//    WS(weakSelf);
//    self.payResultSuccessView.checkBtnBlock= ^(UIButton *btn){
//        [weakSelf btnClick];
//    };
    [self.payResultSuccessView bindData:self.storeName money:self.money coupon:self.coupon
                               packName:nil payCode:nil];
    
//    [self btnClick];
}

#pragma mark 检查O2O商家付款状态
- (void)runLoopOrderStatus{
    
    
    //    //循环检查订单状态
    [HYLoadHubView show];
    self.O2ORunTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self
                                                      selector:@selector(checkO2OOrderStatus)
                                                      userInfo:nil repeats:YES];
    [self.O2ORunTimer fire];
}

- (void)checkO2OOrderStatus{

//    [_checkOrderStatusRq cancel];
//    _checkOrderStatusRq = nil;
    
    _checkOrderStatusRq = [[CheckPayStatusRequest alloc] init];
    _checkOrderStatusRq.interfaceURL     = [NSString stringWithFormat:@"%@/OrderCommon/GetOrderStatus",ORDER_API_URL];
    _checkOrderStatusRq.interfaceType    = DotNET;
    _checkOrderStatusRq.httpMethod       = @"POST";

    _checkOrderStatusRq.OrderNo           = self.O2O_OrderNo;
    _checkOrderStatusRq.Type              = @"1";

    WS(weakSelf);
    [_checkOrderStatusRq sendReuqest:^(id result, NSError *error)
     {
         if(result){
             NSDictionary *objDic = [result jsonDic];

             int code = [objDic[@"Result"] intValue];

             if (code == 1) { //状态值为1 代表已付款成功

                 [HYLoadHubView dismiss];
                 [weakSelf.O2ORunTimer invalidate];
                  weakSelf.O2ORunTimer = nil;
                 
                 
                 
                 
                 if (!weakSelf.isPushSuccess) {
                     weakSelf.isPushSuccess = YES;
                     
                     if(kDevice_Is_iPhone5 || kDevice_Is_iPhone4 || IOS7_OR_LATER){
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [weakSelf btnClick];
                         });
                     }else{
                          [weakSelf btnClick];
                     }
                    
                 }
                 
             }else{
             }
         }
         
         [HYLoadHubView dismiss];
     }];
}



- (void)backToRootViewController:(id)sender{
    
    if (self.payType == BusinessPay) {
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
    }else{
        
        if (self.payType == BilliardsPay) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)btnClick{
    
    PostCommentViewController *tmpCtrl = [[PostCommentViewController alloc] init];
    tmpCtrl.MerId = self.merId;
    tmpCtrl.MerName = self.storeName;
    tmpCtrl.money = self.money;
    tmpCtrl.coupon = self.coupon;
    tmpCtrl.orderDate = _timeStr;
    tmpCtrl.orderId = self.O2O_OrderNo;
    tmpCtrl.orderType = self.orderType.integerValue;
    tmpCtrl.payPush = YES;
    tmpCtrl.backType = (self.payType == BusinessPay ? BusinessDetail : RootCtrl);
    
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.O2ORunTimer invalidate];
    self.O2ORunTimer = nil;
    [_checkOrderStatusRq cancel];
    _checkOrderStatusRq = nil;
}

- (void)dealloc{
    [HYLoadHubView dismiss];
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
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
