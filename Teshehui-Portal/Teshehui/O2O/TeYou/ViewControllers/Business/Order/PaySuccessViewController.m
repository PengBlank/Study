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

#import "CheckPayStatusRequest.h"


@interface PaySuccessViewController ()
{
    CheckPayStatusRequest *_checkOrderStatusRq;
    NSString *_timeStr;
    
}
@property (nonatomic, strong) NSTimer   *O2ORunTimer;
@property (nonatomic, strong) UILabel   *titleLabel;
@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"付款结果";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    UIView *bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setText:@"订单处理中..."];
    [_titleLabel setFont:g_fitSystemFontSize(@[@18,@20,@22])];
    [_titleLabel setNumberOfLines:2];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor colorWithHexString:@"259F00"]];
    [bgView addSubview:_titleLabel];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    _timeStr = [formatter stringFromDate:[NSDate date]];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [timeLabel setText:_timeStr];
    [timeLabel setTextColor:[UIColor colorWithHexString:@"434343"]];
    [timeLabel setFont:g_fitSystemFontSize(@[@14,@15,@16])];
    [bgView addSubview:timeLabel];
    
    
    UIView  *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
    [bgView addSubview:lineView];
    
    UILabel *topDes = [[UILabel alloc] init];
    if(self.storeName.length != 0){
        [topDes setText:[NSString stringWithFormat:@"您在%@共消费了",self.storeName]];
    }
    [topDes setFont:g_fitSystemFontSize(@[@16,@18,@20])];
    [topDes setTextColor:[UIColor colorWithHexString:@"434343"]];
    [topDes setTextAlignment:NSTextAlignmentCenter];
    [topDes setNumberOfLines:2];
    [bgView addSubview:topDes];
    
   
    UILabel *bottomDes = [[UILabel alloc] init];
   
    [bottomDes setFont:g_fitSystemFontSize(@[@16,@18,@20])];
    [bottomDes setTextColor:[UIColor colorWithHexString:@"434343"]];
    [bottomDes setTextAlignment:NSTextAlignmentCenter];
    [bgView addSubview:bottomDes];
    
    
    NSString *tmpString = nil;
    NSMutableAttributedString *desString = nil;
    if (self.money.floatValue > 0 && self.coupon.floatValue == 0) {
        
        tmpString = [NSString stringWithFormat:@"%@元现金",self.money];
        desString = [[NSMutableAttributedString alloc] initWithString:tmpString];
        [desString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b80000"] range:NSMakeRange(0, self.money.length)];
        
    }else if (self.money.floatValue > 0 && self.coupon.floatValue > 0){
        
        tmpString = [NSString stringWithFormat:@"%@元现金 + %@现金券",self.money,self.coupon];
       desString = [[NSMutableAttributedString alloc] initWithString:tmpString];
        [desString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b80000"] range:NSMakeRange(0, self.money.length)];
        
        [desString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b80000"] range:NSMakeRange(tmpString.length - self.coupon.length - 3, self.coupon.length)];
        
    }else if (self.money.floatValue == 0 && self.coupon.length > 0){
        
        tmpString = [NSString stringWithFormat:@"%@现金券",self.coupon];
        desString = [[NSMutableAttributedString alloc] initWithString:tmpString];
        [desString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b80000"] range:NSMakeRange(0, self.coupon.length)];
    }else{}
    
    [bottomDes setAttributedText:desString];
    
    UIButton *affirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [affirmBtn setTitle:@"确 认" forState:UIControlStateNormal];
    [[affirmBtn titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [affirmBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"b80000"]] forState:UIControlStateNormal];
    [[affirmBtn layer] setCornerRadius:5];
    [affirmBtn setClipsToBounds:YES];
    [affirmBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:affirmBtn];
    
    WS(weakSelf);
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreen_Width);
        make.height.mas_equalTo(178);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(24);
     //   make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(10);
     //   make.right.mas_equalTo(weakSelf.view.mas_right).offset(-10);
        make.width.mas_equalTo(kScreen_Width - 20);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(8);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(20);
        make.width.mas_equalTo(kScreen_Width - 20 * 2);
        make.height.mas_equalTo(0.5);
    }];
    
    [topDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(17);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(10);
        make.width.mas_equalTo(kScreen_Width - 20);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
    [bottomDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topDes.mas_bottom).offset(10);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
    [affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).offset(15);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(37);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-37);
        make.height.mas_equalTo(42.5);
        make.width.mas_equalTo(kScreen_Width - 37 * 2);
        
    }];
    
    
    if (self.money.floatValue == 0 || _memberPay) { //当使用的时会员卡支付或者纯现金券支付的时候不用轮询订单
        [_titleLabel setText:@"付款成功"];
    }else{
        [self runLoopOrderStatus];
    }
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
             NSString   *msg = objDic[@"Remark"];

             if (code == 1) { //状态值为1 代表已付款成功

                 [HYLoadHubView dismiss];
                 [weakSelf.O2ORunTimer invalidate];
                 weakSelf.O2ORunTimer = nil;
                 
                 weakSelf.titleLabel.text = msg ? : @"付款成功";

             }else{
                  weakSelf.titleLabel.text = msg ? : @"处理失败";
             }
         }
         
         [HYLoadHubView dismiss];
     }];
}



- (void)backToRootViewController:(id)sender{
    
//    if (self.payType == BilliardsPay) {
//        
//        NSArray * ctrlArray = self.navigationController.viewControllers;
//        
//        for (UIViewController *ctrl in ctrlArray) {
//            
//            if ([ctrl isKindOfClass:[BilliardOrderViewController class]]) {
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithBilliardsOrderListChanged object:nil];
//                WS(weakSelf);
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [weakSelf.navigationController popToViewController:ctrl animated:YES];
//                });
//                return;
//            }
//            
//        }
//        
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        return;
//    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
}

- (void)dealloc{
    [HYLoadHubView dismiss];

    
    [_checkOrderStatusRq cancel];
    _checkOrderStatusRq = nil;
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
