//
//  QRCodeEncoderViewController.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/17.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "QRCodeEncoderViewController.h"
#import "HYAroundMallListViewController.h"
#import "BusinessOrderViewController.h"
#import "PaySuccessViewController.h"
#import "ConfirmOrderViewController.h"
#import "PrepaySuccessViewController.h"
#import "ZXingObjC.h"
#import "HYAppDelegate.h"
#import "HYUserInfo.h"
#import "NSString+Addition.h"
#import "NSTimer+Common.h"
#import "UIView+Frame.h"

#import "GetOrderInfoRequest.h"
#import "MJExtension.h"
#import "OrderInfo.h"
#import "DefineConfig.h"


@interface QRCodeEncoderViewController ()<UIAlertViewDelegate>
{
    UIImageView *_QRImageView;
    
}
@property (nonatomic,strong) GetOrderInfoRequest    *orderInfoRequest;   //轮询请求
@property (nonatomic,strong) OrderInfo              *orderInfo;         //接受轮询请求到的订单模型
@property (nonatomic,strong) NSString               *payNo;
@property (nonatomic,strong) NSTimer                *runTime;

@end


@implementation QRCodeEncoderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"买单";
        self.showBottom = NO;
    }
    return self;
}

- (void)dealloc{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [HYLoadHubView dismiss];
    [self.orderInfoRequest cancel];
    self.orderInfoRequest = nil;
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    _QRImageView = [[UIImageView alloc] initWithFrame:TFRectMake(10,
                                                                 (frame.size.height-300)/2-64,
                                                                 300,
                                                                 300)];
    [self.view addSubview:_QRImageView];
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:TFRectMake(55,
                                                                  (frame.size.height-210)/2+240-64,
                                                                  250,
                                                                  18)];
    [desLabel setCenterX:self.view.centerX];
    desLabel.textColor = [UIColor colorWithRed:101.0/255.0
                                         green:101.0/255.0
                                          blue:99.0/255.0
                                         alpha:1];
    desLabel.font = [UIFont systemFontOfSize:16];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.adjustsFontSizeToFitWidth = YES;
    desLabel.text = @"请将此二维码提供给商户扫描后买单";
    [self.view addSubview:desLabel];
    
//    UILabel *des2Label = [[UILabel alloc] initWithFrame:TFRectMake(52,
//                                                                   desLabel.frame.origin.y+40,
//                                                                   210,
//                                                                   18)];
//    des2Label.textColor = [UIColor colorWithRed:101.0/255.0
//                                          green:101.0/255.0
//                                           blue:99.0/255.0
//                                          alpha:1];
//    des2Label.font = [UIFont systemFontOfSize:14];
//    des2Label.textAlignment = NSTextAlignmentCenter;
//    des2Label.text = @"＊该功能目前在部分城市试运营";
//    [self.view addSubview:des2Label];
    
    if (self.showBottom)
    {
        UIImage *image = [[UIImage imageNamed:@"qr_nav_bg_128"] stretchableImageWithLeftCapWidth:2
                                                                                    topCapHeight:0];
        
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBtn.frame = TFRectMakeFixWidth(0,
                                            frame.size.height-64,
                                            320,
                                            64);
        [checkBtn setBackgroundImage:image
                            forState:UIControlStateNormal];
        [checkBtn setBackgroundImage:image
                            forState:UIControlStateHighlighted];
        [checkBtn setTitle:@"查看合作商户" forState:UIControlStateNormal];
        [checkBtn addTarget:self
                     action:@selector(checkAroundBusinessInfo:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:checkBtn];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view.
    [self updateQRCode];

    BOOL islogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (islogin) {
        //循环获取支付信息

        self.runTime = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(RunLoopPayInfo) userInfo:@"run" repeats:YES];
    }
 
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.runTime invalidate];
     self.runTime = nil;
}

- (void)RunLoopPayInfo{
    
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    self.orderInfoRequest = [[GetOrderInfoRequest alloc] init];
    self.orderInfoRequest.interfaceURL = [NSString stringWithFormat:@"%@/v4/tshorder/GetLatestOrder",ORDER_API_URL];
    self.orderInfoRequest.interfaceType = DotNET2;
    self.orderInfoRequest.httpMethod    = @"POST";
    self.orderInfoRequest.postType      = JSON;
    
    self.orderInfoRequest.UId           = userInfo.userId;                               //  用户id

    WS(weakSelf);
    [self.orderInfoRequest sendReuqest:^(id result, NSError *error)
     {
         if(result){
             NSDictionary *objDic = [result jsonDic];
             
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为1 代表请求成功  其他为失败
                 NSDictionary *objKeyValue = objDic[@"data"];
                 weakSelf.orderInfo = [OrderInfo objectWithKeyValues:objKeyValue];
                 
                 if(weakSelf.orderInfo.isRechargeCost == 1){ //充值消费
                     
                     PrepaySuccessViewController *vc = [[PrepaySuccessViewController alloc] init];
                     vc.orderInfo = weakSelf.orderInfo;
                     vc.successType = 0; //付款类型
                     [weakSelf.navigationController pushViewController:vc animated:YES];
                     
                 } else {
                 
                     if ([weakSelf.orderInfo.Is_Coupon integerValue] == 1) { //1代表是纯现金券支付，由c2b直接扣除，不生成对应流水订单
                         
                         //跳转到支付成功的页面
                         PaySuccessViewController *tmpCtrl = [[PaySuccessViewController alloc] init];
                         tmpCtrl.merId      = weakSelf.orderInfo.MerchantId;
                         tmpCtrl.storeName  =  weakSelf.orderInfo.MerchantsName;
                         tmpCtrl.coupon     =  weakSelf.orderInfo.Coupon;
                         tmpCtrl.O2O_OrderNo = self.orderInfo.O2O_Order_Number;
                         tmpCtrl.payType = BusinessPay;
                         tmpCtrl.orderType = @"1";
                         [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
                         
                     }else{
                         [self confirmOrderPage];
                     }
                 }

             }else{

             }
         }
     }];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1000) {
        
//        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
//        if ([title isEqualToString:@"确定"]) {
//            
//            [self.runTime invalidate];
//            self.runTime = nil;
////            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
////            [appDelegate loadPayView:self.orderInfo];
//            [self confirmOrderPage];
//
//        }else{
//            [self.runTime resumeTimerAfterTimeInterval:5.0f];
//        }
        
    }else{
        
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
        
    }
}

- (void)confirmOrderPage{
    
    ConfirmOrderViewController *vc = [[ConfirmOrderViewController alloc] init];
    vc.orderInfo = self.orderInfo;
    vc.pageType = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark private methods
- (void)updateQRCode
{
#if TARGET_OS_IPHONE
    NSString *dataStr = [self createQRCodeString];
    
    if (dataStr)
    {
        ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
        ZXBitMatrix *result = [writer encode:dataStr
                                      format:kBarcodeFormatQRCode
                                       width:_QRImageView.frame.size.width
                                      height:_QRImageView.frame.size.width
                                       error:nil];
        
        if (result)
        {
            ZXImage *image = [ZXImage imageWithMatrix:result];
            
            UIImage *logo = [UIImage imageNamed:@"QR_icon"];
            UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(_QRImageView.frame.size.width/2-27,
                                                                                  _QRImageView.frame.size.height/2-27,
                                                                                  56,
                                                                                  56)];
            logoView.image = logo;
            
            _QRImageView.backgroundColor = [UIColor blackColor];
            [_QRImageView addSubview:logoView];
            
            _QRImageView.image = [UIImage imageWithCGImage:image.cgimage];
        } else {
            _QRImageView.image = nil;
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                        message:@"用户登录信息不完整，请重新登录"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"重新登录", nil];
        [alert show];
    }
#endif
}

- (NSString *)createQRCodeString
{
    NSMutableString *QRStr = [NSMutableString stringWithString:@"teshehui"];
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    
    if ([user.number length]<=0 || [user.mobilePhone length]<=0)
    {
        return nil;
    }
    
    if ([user.realName length] > 0){ //体验会员没有真实姓名，所以当用户是体验会员的时候 将电话作为真实姓名
        [QRStr appendFormat:@"&name=%@", user.realName];
    }else{
        [QRStr appendFormat:@"&name=%@", user.mobilePhone];
    }
    
    [QRStr appendFormat:@"&us_id=%@", user.userId];
    [QRStr appendFormat:@"&card_no=%@", user.number];
    [QRStr appendFormat:@"&phone_no=%@", user.mobilePhone];
    
    return [QRStr base64EncodedString];
}



- (void)didReceiveMemoryWarning
{
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
