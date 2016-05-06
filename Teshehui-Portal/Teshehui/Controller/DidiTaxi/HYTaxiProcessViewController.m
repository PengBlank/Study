//
//  HYTaxiProcessViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiProcessViewController.h"
#import "CircleProgressView.h"
#import "UIAlertView+BlocksKit.h"
#import "METoast.h"
#import "HYTaxiResponseInfoView.h"
#import "HYTaxiPriceView.h"
#import "HYUserInfo.h"
#import "HYTabbarViewController.h"
#import "HYTaxiOrderListViewController.h"
#import "HYPaymentViewController.h"
#import "HYTaxiPaySuccViewController.h"
#import "HYCallTaxiViewController.h"
#import "HYTabbarViewController.h"

@interface HYTaxiProcessViewController ()
{
    UILabel *_infoLab;
    UILabel *_detailLab;
    
    CircleProgressView *_progressView;
    
    HYTaxiResponseInfoView *_responseInfoView;
    
    HYTaxiPriceView *_priceView;
    
    HYTaxiOrder *_taxiOrder;
}


@property (nonatomic, strong) HYTaxiOrderView *orderView;
@property (nonatomic, strong) CircleProgressView *progressView;

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, assign) BOOL isCancelling;

@end

@implementation HYTaxiProcessViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];
    self.view = view;
    
    _infoLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, frame.size.width-40, 30)];
    _infoLab.backgroundColor = [UIColor clearColor];
    _infoLab.font = [UIFont systemFontOfSize:24];
    _infoLab.textColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:84/255.0 alpha:1];
    _infoLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_infoLab];
    
    _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_infoLab.frame)+10, frame.size.width-40, 30)];
    _detailLab.backgroundColor = [UIColor clearColor];
    _detailLab.font = [UIFont systemFontOfSize:15.0];
    _detailLab.textColor = [UIColor colorWithWhite:.7 alpha:1];
    _detailLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_detailLab];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打车";
    self.canDragBack = NO;
    if (self.taxiOrder)
    {
//        _isCancelling = YES;
        [self refreshOrder];
    }
    else if (self.orderParam)
    {
        [self createOrder];
    }
    else
    {
        //测试数据
        self.orderParam = [HYTaxiAddOrderParam testData];
        self.orderParam.userId = [HYUserInfo getUserInfo].userId;
        [self createOrder];
        
//        HYTaxiOrderView *orderView = [[HYTaxiOrderView alloc] init];
//        NSMutableArray *orderfees = [NSMutableArray array];
//        for (int i = 0; i < 5; i++)
//        {
//            HYTaxiOrderFee *orderfee = [[HYTaxiOrderFee alloc] init];
//            orderfee.feeName = @"费用名称";
//            orderfee.fee = @"100";
//            [orderfees addObject:orderfee];
//        }
//        orderView.orderFee = orderfees;
//        self.orderView = orderView;
//        [self showPriceSummary];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn)
    {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(self.view.frame)-64, CGRectGetWidth(self.view.frame)-40, 44)];
        [_cancelBtn setBackgroundColor:[UIColor clearColor]];
        _cancelBtn.layer.borderColor = [UIColor colorWithWhite:.8 alpha:1].CGColor;
        _cancelBtn.layer.borderWidth = 1.0;
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.cornerRadius = 4.0;
        [_cancelBtn setTitle:@"取消叫车" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.view addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

- (void)backToRootViewController:(id)sender
{
//    HYTabbarViewController *tab = (HYTabbarViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    UINavigationController *mine = [tab.viewControllers objectAtIndex:3];
//    HYTaxiOrderListViewController *list = [[HYTaxiOrderListViewController alloc] init];
//    [mine pushViewController:list animated:NO];
//    NSMutableArray *vcs = [self.navigationController.viewControllers mutableCopy];
//    [vcs removeObject:self];
//    self.navigationController.viewControllers = vcs;
//    
//    [mine pushViewController:self animated:NO];
//    [self.navigationController popViewControllerAnimated:YES];
//    [tab setCurrentSelectIndex:3];
//    [tab setTabbarShow:NO];
//    return;
    [self pauseRefresh];
    if (_taxiOrder)
    {
        //等待中的订单直接取消
        if (_taxiOrder.didiOrderStatus.integerValue >= 300 && _taxiOrder.didiOrderStatus.integerValue < 400)
        {
            [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"确定要取消此次叫车" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex)
             {
                 if (buttonIndex == 1)
                 {
                     //如果未有接单
                     __weak typeof(self) weakSelf = self;
                     [HYLoadHubView show];
                     [self.taxiService cancelOrder:_taxiOrder.orderCode
                                           isForce:NO
                                      withCallback:^(NSString *err, HYTaxiCancelResult *result)
                      {
                          [HYLoadHubView dismiss];
                          if (err)
                          {
                              [METoast toastWithMessage:err];
                              [weakSelf.navigationController popViewControllerAnimated:YES];
                          }
                          else if (result.cancelResult.integerValue == 1)
                          {
                              [METoast toastWithMessage:@"取消成功"];
                              [weakSelf.navigationController popViewControllerAnimated:YES];
                          }
                          else
                          {
                              [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                                             message:result.cancelFeeDescription
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@[@"确定"]
                                                             handler:^(UIAlertView *alertView, NSInteger buttonIndex)
                              {
                                  if (buttonIndex == 1)
                                  {
                                      [HYLoadHubView show];
                                      [weakSelf.taxiService cancelOrder:weakSelf.taxiOrder.orderCode
                                                                isForce:YES
                                                           withCallback:^(NSString *err, HYTaxiCancelResult *cancelResult)
                                      {
                                          [HYLoadHubView dismiss];
                                          if (err)
                                          {
                                              [METoast toastWithMessage:err];
                                          }
                                          [weakSelf.navigationController popViewControllerAnimated:YES];
                                      }];
                                  }
                                  else
                                  {
                                      [weakSelf resumeRefresh];   //此时返回, 重新开始刷新
                                  }
                                  
                              }];
                          }
                      }];
                 }
                 else
                 {
                     [self resumeRefresh];    //直接点击取消时, 也重新开始刷新
                 }
             }];
            
        }
        else if (_taxiOrder.didiOrderStatus.integerValue == 400 ||
                 _taxiOrder.didiOrderStatus.integerValue == 410)
        {
            [UIAlertView bk_showAlertViewWithTitle:@"确定取消行程吗?" message:@"司机正赶来接您了" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex)
             {
                 if (buttonIndex == 1)
                 {
                     //如果未有接单
                     __weak typeof(self) weakSelf = self;
                     [HYLoadHubView show];
                     [self.taxiService cancelOrder:_taxiOrder.orderCode
                                           isForce:NO
                                      withCallback:^(NSString *err, HYTaxiCancelResult *result)
                      {
                          [HYLoadHubView dismiss];
                          if (err)
                          {
                              [METoast toastWithMessage:err];
                              [weakSelf.navigationController popViewControllerAnimated:YES];
                          }
                          else if (result.cancelResult.integerValue == 1)
                          {
                              [METoast toastWithMessage:@"取消成功"];
                              [weakSelf.navigationController popViewControllerAnimated:YES];
                          }
                          else
                          {
                              [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                                             message:result.cancelFeeDescription
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@[@"确定"]
                                                             handler:^(UIAlertView *alertView, NSInteger buttonIndex)
                               {
                                   if (buttonIndex == 1)
                                   {
                                       [HYLoadHubView show];
                                       [weakSelf.taxiService cancelOrder:weakSelf.taxiOrder.orderCode
                                                                 isForce:YES
                                                            withCallback:^(NSString *err, HYTaxiCancelResult *cancelResult)
                                        {
                                            [HYLoadHubView dismiss];
                                            if (err)
                                            {
                                                [METoast toastWithMessage:err];
                                            }
                                            [weakSelf.navigationController popViewControllerAnimated:YES];
                                        }];
                                   }
                                   else
                                   {
                                       [self resumeRefresh];
                                   }
                               }];
                          }
                      }];
                 }
                 else
                 {
                     [self resumeRefresh];
                 }
             }];
        }
        //已开始订单, 返回订单列表
        else if (_taxiOrder.didiOrderStatus.integerValue >= 500)
        {
            //强行将自己塞到订单列表的下一个界面
            HYTabbarViewController *tab = (HYTabbarViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *mine = [tab.viewControllers objectAtIndex:3];
            NSMutableArray *vcs = [mine.viewControllers mutableCopy];
            [vcs removeObjectsInRange:NSMakeRange(1, vcs.count-1)];
            mine.viewControllers = vcs;
            
            ///移除赚现金券里面的其他界面, 退回到初始界面
            UINavigationController *earn = [tab.viewControllers objectAtIndex:2];
            NSMutableArray *earnvcs = [earn.viewControllers mutableCopy];
            [earnvcs removeObjectsInRange:NSMakeRange(1, earnvcs.count-1)];
            earn.viewControllers = earnvcs;
            
            ///在我的这一分支, 压入订单列给, 及当前界面
            HYTaxiOrderListViewController *list = [[HYTaxiOrderListViewController alloc] init];
            [mine pushViewController:list animated:NO];
            [mine pushViewController:self animated:NO];
            [self.navigationController popViewControllerAnimated:YES];
            [tab setCurrentSelectIndex:3];
            [tab setTabbarShow:NO];
        }
    }
    else if (_orderParam)
    {
        [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"确定要取消此次叫车" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex)
         {
             if (buttonIndex == 1)
             {
                 //如果未有接单
                 [METoast toastWithMessage:@"取消成功"];
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - process
/**
 *  创建订单
 *  只会在有下单参数, 进入此界面时发生
 *  重建订单使用重新下单的service方法
 */
- (void)createOrder
{
    _infoLab.text = @"正在为您创建订单";
    _detailLab.text = @"请稍后...";
    [self.view addSubview:_infoLab];
    [self.view addSubview:_detailLab];
//    self.orderParam = [HYTaxiAddOrderParam testData];
    _orderParam.userId = [HYUserInfo getUserInfo].userId;
    _orderParam.passengerPhone = [HYUserInfo getUserInfo].mobilePhone;
    [HYLoadHubView show];
    __weak typeof(self) weakSelf = self;
    [self.taxiService addOrder:self.orderParam
                  withCallback:^(NSString *err, HYTaxiOrder *order)
    {
        [HYLoadHubView dismiss];
        if (order)
        {
            weakSelf.taxiOrder = order;
            [weakSelf callTaxies];
        }
        else
        {
            [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                           message:err
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil
                                           handler:^(UIAlertView *alertView, NSInteger buttonIndex)
            {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

/**
 *  正在叫车
 *  实时单5分钟超时, 预约单10分钟超时
 *  有可能从重建订单入口进入, 检测界面是否正确显示
 */
- (void)callTaxies
{
    if (!_infoLab.superview) {
        [self.view addSubview:_infoLab];
    }
    if (!_detailLab.superview) {
        [self.view addSubview:_detailLab];
    }
    _infoLab.frame = CGRectMake(20, 20, self.view.frame.size.width-40, 30);
    _detailLab.frame = CGRectMake(20, CGRectGetMaxY(_infoLab.frame)+10, self.view.frame.size.width-40, 30);
    
    _infoLab.text = @"收到,正在为您叫车";
    if (_taxiType == 1)
    {
        _detailLab.text = @"附近的快车会优先通知";
    }
    else if (_taxiType == 2)
    {
        _detailLab.text = @"附近的专车会优先通知";
    }
    else
    {
        _detailLab.text = @"附近的快(专)车会优先通知";
    }
    
    if (!_progressView)
    {
        _progressView = [[CircleProgressView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds)-100, CGRectGetMaxY(_detailLab.frame) + 20, 200, 200)];
        [self.view addSubview:_progressView];
    }
    _progressView.timeLimit = 60 * 5;
    _progressView.elapsedTime = 0;
    [_progressView start];
    
    [self refreshOrder];
    
    //取消事件
    [self.cancelBtn addTarget:self
                       action:@selector(cancelCallTaxi)
             forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelCallTaxi
{
    [self backToRootViewController:nil];
}

- (void)refreshOrder
{
    _isCancelling = NO;
    [self refreshOrderAfterDelay:0];
}

- (void)pauseRefresh
{
    _isCancelling = YES;
    [self.progressView pause];
}

- (void)resumeRefresh
{
    _isCancelling = NO;
    [self.progressView resume];
    [self refreshOrder];
}

/// 
- (void)refreshOrderAfterDelay:(NSInteger)delay
{
    __weak typeof(self) weakSelf = self;
    if (_isCancelling)
    {
        //被打断
        [weakSelf.progressView pause];
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       
        {
            if (weakSelf && !weakSelf.isCancelling)
            {
                [HYLoadHubView show];
                [weakSelf.taxiService getOrderInfoRealTime:weakSelf.taxiOrder.didiOrderId
                                          withCallback:^(NSString *err, HYTaxiOrderView *orderView)
                 {
                     [HYLoadHubView dismiss];
                     if (orderView)
                     {
                         [weakSelf updateWithRefreshResponse:orderView];
                     }
                     else
                     {
                         [[UIAlertView bk_alertViewWithTitle:@"提示" message:err] show];
                     }
                 }];
            }
        });
    }
}

- (void)updateWithRefreshResponse:(HYTaxiOrderView *)orderView
{
    //如果订单状态发生变更
    if (![self.orderView.didiOrderStatus isEqualToString:orderView.didiOrderStatus] || self.orderView == nil)
    {
        self.taxiOrder.didiOrderStatus = orderView.didiOrderStatus;
        self.orderView = orderView;
        if (orderView.didiOrderStatus.integerValue == 400)  //应答,等接
        {
            [self taxiResponse];
            [self refreshOrderAfterDelay:5];
        }
        else if (orderView.didiOrderStatus.integerValue == 410) //到达, 等上车
        {
            [self taxiResponse];
            [self showTaxiArrived];
            [self refreshOrderAfterDelay:5];
        }
        else if (orderView.didiOrderStatus.integerValue == 500) //开始行程
        {
            [self taxiStarted];
            [self refreshOrderAfterDelay:10];
        }
        else if (orderView.didiOrderStatus.integerValue == 600) //行程结束
        {
            [self showPriceSummary];
        }
        else if (orderView.didiOrderStatus.integerValue == 610)
        {
            [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                           message:@"行程异常结束"
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil
                                           handler:^(UIAlertView *alertView, NSInteger buttonIndex)
             {
                 [self.navigationController popViewControllerAnimated:YES];
             }];
        }
        else if (orderView.didiOrderStatus.integerValue == 700) //支付完成
        {
            [self showPriceSummary];
        }
        else if (orderView.didiOrderStatus.integerValue == 311)
        {
            [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                           message:@"该订单已超时，请重新下单"
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil
                                           handler:^(UIAlertView *alertView, NSInteger buttonIndex)
             {
                 [self.navigationController popViewControllerAnimated:YES];
             }];
        }
        else if (orderView.didiOrderStatus.integerValue == 300) //等接单,
            ///这里是从外部进入等接单状态, 需要创建界面
        {
            [self callTaxies];
        }
        else if (orderView.didiOrderStatus.integerValue == 700)
        {
            [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"当前订单已支付" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex)
             {
                 [self.navigationController popViewControllerAnimated:YES];
             }];
        }
        else
        {
            [self refreshOrderAfterDelay:10];
        }
    }
    else if (orderView.didiOrderStatus.integerValue == 300) //等接单
    {
        //显示有多少车辆
        _progressView.status = [self carNumShowWithNum:orderView.driverCount.integerValue];
        if (_progressView.percent == 1)
        {
            [self noTaxiResponse];
        }
        else
        {
            [self refreshOrderAfterDelay:3];
        }
    }
    else
    {
        [self refreshOrderAfterDelay:10];
    }
}

// 已通知carNum车快车
- (NSAttributedString *)carNumShowWithNum:(NSInteger)carNum
{
    NSString *s1 = @"已通知\n";
    NSString *s2 = [NSString stringWithFormat:@"%ld\n", (long)carNum];
    NSString *s3;
    if (_taxiType == 1)
    {
        s3 = @"辆快车";
    }
    else if (_taxiType == 2)
    {
        s3 = @"辆专车";
    }
    else
    {
        s3 = @"辆快(专)车";
    }
    NSString *s = [NSString stringWithFormat:@"%@%@%@", s1, s2, s3];
    NSMutableAttributedString *ret = [[NSMutableAttributedString alloc] initWithString:s];
    [ret setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:.7 alpha:1]} range:NSMakeRange(0, s1.length)];
    [ret setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:59/255.0 blue:85/255.0 alpha:1]} range:NSMakeRange(s1.length, s2.length)];
    [ret setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:.7 alpha:1]} range:NSMakeRange(s1.length+s2.length, s3.length)];
    return ret;
}

/**
 *  无司机应答
 *  叫车时无司机应答逻辑处理
 */
- (void)noTaxiResponse
{
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"暂无司机应答,是否重新叫车" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex)
    {
        if (buttonIndex == 1)
        {
            //重新aocheain:
            __weak typeof(self) weakSelf = self;
            [self.taxiService callCarAgain:self.taxiOrder.didiOrderId
                              withCallback:^(NSString *err) {
                                  [weakSelf callTaxies];
                              }];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

/**
 *  司机应答
 *  小于200米时弹出到达附近提示
 *  需不断轮询当前订单状态, 开始上车时显示下一个界面
 */
- (void)taxiResponse
{
    _infoLab.text = @"稍后, 司机正赶来接您";
    _detailLab.text = @"请您保持手机通畅";
    [self.cancelBtn setTitle:@"取消行程" forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self
                       action:@selector(cancelCallTaxi)
             forControlEvents:UIControlEventTouchUpInside];
    
    [_progressView removeFromSuperview];
    _progressView = nil;
    
    if (!_responseInfoView) {
        _responseInfoView = [HYTaxiResponseInfoView instanciate];
        _responseInfoView.frame = CGRectMake(20,
                                             CGRectGetMaxY(_detailLab.frame)+10,
                                             CGRectGetWidth(self.view.frame)-40,
                                             CGRectGetHeight(_responseInfoView.frame));
        [self.view addSubview:_responseInfoView];
    }
    _responseInfoView.orderView = _orderView;
}

- (void)showTaxiArrived
{
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"司机已到达您附近, 准备上车吧" cancelButtonTitle:@"好, 知道了" otherButtonTitles:nil handler:nil];
}

#pragma mark - 行程已开始
/**
 *  行程已开始显示界面
 */
- (void)taxiStarted
{
    [_responseInfoView removeFromSuperview];
    _responseInfoView = nil;
    [_progressView removeFromSuperview];
    _progressView = nil;
    [_cancelBtn removeFromSuperview];
    _cancelBtn = nil;
    
    UIImage *started = [UIImage imageNamed:@"taxi_didstarted"];
    UIImageView *startedv = [[UIImageView alloc] initWithImage:started];
    startedv.frame = CGRectMake(CGRectGetMidX(self.view.bounds)-started.size.width/2,
                                20,
                                started.size.width,
                                started.size.height);
    [self.view addSubview:startedv];
    
    CGRect frame = _infoLab.frame;
    frame.origin.y = CGRectGetMaxY(startedv.frame) + 10;
    _infoLab.frame = frame;
    _infoLab.text = @"行程开始了";
    
    frame = _detailLab.frame;
    frame.origin.y = CGRectGetMaxY(_infoLab.frame) + 10;
    _detailLab.frame = frame;
    _detailLab.text = @"祝您一路好心情";
}

#pragma mark - 价格
- (void)showPriceSummary
{
    self.title = @"打车";
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _infoLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, 30)];
    _infoLab.backgroundColor = [UIColor clearColor];
    _infoLab.font = [UIFont systemFontOfSize:24];
    _infoLab.textColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:84/255.0 alpha:1];
    _infoLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_infoLab];
    _infoLab.text = @"请您确认并支付车费";
    
    HYTaxiPriceView *price = [HYTaxiPriceView instanciate];
    price.frame = CGRectMake(20,
                             CGRectGetMaxY(_infoLab.frame) + 20,
                             self.view.frame.size.width-40,
                             price.frame.size.height);
    _priceView = price;
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(self.view.frame)-64, CGRectGetWidth(self.view.frame)-40, 44)];
    [payBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:59/255.0 blue:84/255.0 alpha:1]];
    payBtn.layer.borderColor = [UIColor colorWithWhite:.8 alpha:1].CGColor;
    payBtn.layer.borderWidth = 1.0;
    payBtn.layer.masksToBounds = YES;
    payBtn.layer.cornerRadius = 4.0;
    [payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [payBtn addTarget:self action:@selector(payOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payBtn];
    
    ///如果显示不下, 即: 高度+20+button高度 > 界面高度, 创建scrollview
    ///scrollview 由infoLab起, 包含价格界面和按钮
    if (CGRectGetMaxY(price.frame) + 20 + 44 > self.view.frame.size.height)
    {
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:
                                CGRectMake(0,
                                           CGRectGetMaxY(_infoLab.frame) + 20,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height - CGRectGetMaxY(_infoLab.frame) - 20)];
        scroll.contentSize = CGSizeMake(self.view.frame.size.width,
                                        CGRectGetHeight(price.frame) + 20 + 44);
        [self.view addSubview:scroll];
        
        price.frame = CGRectMake(CGRectGetMinX(price.frame),
                                 0,
                                 price.frame.size.width,
                                 price.frame.size.height);
        [scroll addSubview:price];
        price.orderView = _orderView;
        
        payBtn.frame = CGRectMake(CGRectGetMinX(payBtn.frame),
                                  CGRectGetMaxY(price.frame)+10,
                                  payBtn.frame.size.width,
                                  payBtn.frame.size.height);
        [scroll addSubview:payBtn];
        
    }
    else
    {
        [self.view addSubview:price];
        price.orderView = _orderView;
        [self.view addSubview:payBtn];
    }
}

- (void)payOrder
{
    [HYLoadHubView show];
    __weak typeof(self) weakSelf = self;
    [self.taxiService getOrderInfoWithOrderId:_taxiOrder.orderId
                                    orderCode:_taxiOrder.orderCode
                                       userId:[HYUserInfo getUserInfo].userId
                                   enterprise:NO
                                     callback:^(NSString *err, HYTaxiOrder *order)
    {
        [HYLoadHubView dismiss];
        if (err)
        {
            [METoast toastWithMessage:err];
        }
        else
        {
            [weakSelf payWithOrder:order];
        }
    }];
    
    
}

- (void)payWithOrder:(HYTaxiOrder *)order
{
    HYAlipayOrder *alPay = [[HYAlipayOrder alloc] init];
    alPay.partner = PartnerID;
    alPay.seller = SellerID;
    
    NSMutableString* nameStr = [[NSMutableString alloc]initWithCapacity:0];
    [nameStr appendString:@"【滴滴打车】订单编号:"];
    
    CGFloat price = order.orderTotalAmount.floatValue;
    alPay.tradeNO = order.orderCode; //订单号（由商家自行制定）
    alPay.productName = nameStr;
    alPay.productDescription = [NSString stringWithFormat:@"%@机票订单", order.passengerPhone]; //商品描述
    alPay.amount = [NSString stringWithFormat:@"%0.2f",price]; //商品价格
    
    
    
    
    HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
    payVC.navbarTheme = self.navbarTheme;
    payVC.alipayOrder = alPay;
    payVC.amountMoney = [[NSNumber numberWithFloat:price] stringValue];
    payVC.payMoney = [[NSNumber numberWithFloat:price] stringValue];
    payVC.orderID = order.orderId;
    payVC.orderCode = order.orderCode;
    payVC.type = Pay_DidiTaxi;
    
    //强行将自己塞到订单列表的下一个界面
    HYTabbarViewController *tab = (HYTabbarViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *mine = [tab.viewControllers objectAtIndex:3];
    NSMutableArray *vcs = [mine.viewControllers mutableCopy];
    [vcs removeObjectsInRange:NSMakeRange(1, vcs.count-1)];
    mine.viewControllers = vcs;
    HYTaxiOrderListViewController *list = [[HYTaxiOrderListViewController alloc] init];
    [mine pushViewController:list animated:NO];
    [mine pushViewController:payVC animated:NO];
    [tab setCurrentSelectIndex:3];
    [tab setTabbarShow:NO];
    
    UINavigationController *earnNav = [tab.viewControllers objectAtIndex:2];
    vcs = [earnNav.viewControllers mutableCopy];
    [vcs removeObjectsInRange:NSMakeRange(1, vcs.count-1)];
    earnNav.viewControllers = vcs;
    
    //支付成功, 成功界面
    payVC.paymentCallback = ^(HYPaymentViewController *vc,id order)
    {
        HYTaxiPaySuccViewController *succVc = [[HYTaxiPaySuccViewController alloc] init];
        [vc.navigationController pushViewController:succVc animated:YES];
        NSMutableArray *vcs = [vc.navigationController.viewControllers mutableCopy];
        [vcs removeObject:vc];
        vc.navigationController.viewControllers = vcs;
    };
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
