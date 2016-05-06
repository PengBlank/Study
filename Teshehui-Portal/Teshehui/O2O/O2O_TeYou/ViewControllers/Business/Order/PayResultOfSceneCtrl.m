//
//  PayResultOfSceneCtrl.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "PayResultOfSceneCtrl.h"
#import "CheckPayStatusRequest.h"
#import "PayResultLoadingView.h"
#import "PayResultSuccessView.h"
#import "DefineConfig.h"
#import "SceneOrderDetailViewController.h"
#import "TYAnalyticsManager.h"
@interface PayResultOfSceneCtrl()
{
    CheckPayStatusRequest *_checkOrderStatusRq;
}

@property (nonatomic, strong) NSTimer   *O2ORunTimer;

@property (nonatomic, strong) PayResultSuccessView  *payResultSuccessView;
@property (nonatomic, strong) PayResultLoadingView  *payResultLoadingView;

@end

@implementation PayResultOfSceneCtrl



- (PayResultLoadingView *)payResultLoadingView{
    
    if (!_payResultLoadingView) {
        _payResultLoadingView = [[PayResultLoadingView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 145) payType:ScenePay];
    }
    
    return _payResultLoadingView;
}

- (PayResultSuccessView *)payResultSuccessView{

    if (!_payResultSuccessView) {
        _payResultSuccessView = [[PayResultSuccessView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavBarHeight) payType:ScenePay];
    }
    
    return _payResultSuccessView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(245, 245, 245);
    self.title = @"付款结果";
    
    //统计
    [[TYAnalyticsManager sharedManager] sendAnalyseForSceneDetailPage:EntertainmentPackageDetailPage packId:nil
                                                       pageIdentifier:_comeType == BusinessDetail ? @"BusinessMainViewController" : @"SceneOrderViewController" toPageIdentifier:NSStringFromClass([self class])];
    
    if (self.money.floatValue == 0) { //当使用纯现金券支付的时候不用轮询订单
        [self loadSuccessView];
    }else{
        [self.view addSubview:self.payResultLoadingView];
        [self runLoopOrderStatus];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.O2ORunTimer invalidate];
    self.O2ORunTimer = nil;
}

- (void)dealloc{
    [HYLoadHubView dismiss];
    
    
    [_checkOrderStatusRq cancel];
    _checkOrderStatusRq = nil;
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
#pragma mark 检查O2O商家付款状态
- (void)runLoopOrderStatus{
    
    
    //    //循环检查订单状态
    [HYLoadHubView show];
    self.O2ORunTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self
                                                      selector:@selector(checkO2OOrderStatus)
                                                      userInfo:nil repeats:YES];
    [self.O2ORunTimer fire];
}

- (void)checkO2OOrderStatus{
    
    
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
//             NSString   *msg = objDic[@"Remark"];
             
             if (code == 1) { //状态值为1 代表已付款成功
                 
                 [HYLoadHubView dismiss];
                 [weakSelf.O2ORunTimer invalidate];
                 weakSelf.O2ORunTimer = nil;
                 [weakSelf loadSuccessView];
                 
             }else{
//                 weakSelf.payResultLoadingView.titleLabel.text = msg ? : @"订单处理失败";
//                 weakSelf.payResultLoadingView.desLabel.text = @"";
             }
         }
         
         [HYLoadHubView dismiss];
     }];
}

- (void)loadSuccessView{
    
    [self.payResultLoadingView removeFromSuperview];
    self.payResultLoadingView = nil;
    [self.view addSubview:self.payResultSuccessView];
    WS(weakSelf);
    self.payResultSuccessView.checkBtnBlock= ^(UIButton *btn){
        SceneOrderDetailViewController *tmpCtrl = [[SceneOrderDetailViewController alloc] init];
        tmpCtrl.orderNum = weakSelf.orderId;
        tmpCtrl.comeType = 1;
        [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
    };
    [self.payResultSuccessView bindData:self.storeName money:self.money coupon:self.coupon
                                   packName:self.packName payCode:self.payCode];
    


}

- (void)backToRootViewController:(id)sender{
    
    NSArray *array = [self.navigationController viewControllers];
    
    if(self.comeType == BusinessDetail)
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
