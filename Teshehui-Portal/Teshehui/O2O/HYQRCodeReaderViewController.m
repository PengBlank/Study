//
//  HYQRCodeReaderViewController.m
//  Teshehui
//
//  Created by HYZB on 15/5/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYQRCodeReaderViewController.h"
#import <ZXingObjC.h>
#import "HYQrcodeResultViewController.h"
#import "NSString+Addition.h"
#import "HYMallCartViewController.h"
#import "HYProductDetailViewController.h"
#import "UIImage+Addition.h"
#import "HYUserInfo.h"


#import "MJExtension.h"
#import "METoast.h"
#import "DefineConfig.h"
#import "UIView+Common.h"
#import "PageBaseLoading.h"
#import "BilliardsScanInfoViewController.h"
#import "TicketingViewController.h"
#import "HYBuyDrinksViewController.h"
#import "HYOrderPayViewController.h"
#import "BilliardsTableInfoRequest.h"
#import "BilliardsTableInfo.h"
#import "PrepayViewController.h" // 实体店会员充值

@interface HYQRCodeReaderViewController ()
<
ZXCaptureDelegate,
AVCaptureMetadataOutputObjectsDelegate,
HYQrcodeResultViewControllerDelegate,
UINavigationControllerDelegate,
UIAlertViewDelegate
>
{
    BOOL infoShowing;
    BOOL upToDown;
    int num;
    UIImageView *lineImageView;
    NSTimer *timer;
    
    BOOL _ledOn;
}

@property (nonatomic, strong) ZXCapture                 *capture;
@property (nonatomic, strong) UIImageView               *backImageView;
@property (nonatomic, assign) CGRect                    scanRect;
@property (nonatomic, assign) BOOL                      scanOver;

@property (nonatomic, assign) CGFloat                   cash;
@property (nonatomic, assign) NSInteger                 coupon;

@property (nonatomic,strong ) BilliardsTableInfoRequest *tableInfoRequest;
@property (nonatomic,strong ) BilliardsTableInfo        *tableInfo;
@property (nonatomic,strong) UIView                     *maskView;

/*
 * iOS 7 以上使用系统的扫描
 */
@property (nonatomic, strong) AVCaptureDevice * device;
@property (nonatomic, strong) AVCaptureDeviceInput * input;
@property (nonatomic, strong) AVCaptureMetadataOutput * output;
@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * preview;

@end

@implementation HYQRCodeReaderViewController

- (void)dealloc
{
    [PageBaseLoading hiddeLoad_anyway];
    [HYLoadHubView dismiss];
    [_tableInfoRequest cancel];
    _tableInfoRequest = nil;
    [self.capture.layer removeFromSuperlayer];
    self.navigationController.delegate = nil;
    DebugNSLog(@"HYQRCodeReaderViewController dealloc");
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor blackColor];
    self.view = view;
    
    self.title = @"二维码";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.maskView.backgroundColor = [UIColor whiteColor];
    self.maskView.alpha = 0.0f;
    
    UIImage *bgimg = nil;
    if (currentDeviceType() == iPhone4_4S)
    {
        bgimg = [UIImage imageNamed:@"sm_scan_rect_4s"];
    }
    else
    {
        bgimg = [UIImage imageWithNamedAutoLayout:@"sm_scan_rect"];
    }
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.userInteractionEnabled = YES;
    bg.image = bgimg;
    [self.view addSubview:bg];
    self.backImageView = bg;
    
    self.scanRect = TFRectMake(54, 78, 210, 210);
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.scanRect)+20,
                                                                  CGRectGetWidth(ScreenRect),
                                                                  18)];
    desLabel.textColor = [UIColor whiteColor];
    desLabel.font = [UIFont systemFontOfSize:16];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.text = @"对准二维码到框内，即可自动扫描";
    [self.view addSubview:desLabel];
    
    UIButton *lightBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds)-22,
                                                                    CGRectGetMaxY(desLabel.frame) + 20,
                                                                    44,
                                                                    44)];
    [lightBtn setImage:[UIImage imageNamed:@"sm_light"] forState:UIControlStateNormal];
    [lightBtn addTarget:self action:@selector(turnOnLed:) forControlEvents:UIControlEventTouchUpInside];
    [self.backImageView addSubview:lightBtn];
    
    lineImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan_line"]];
    lineImageView.frame = CGRectMake(self.scanRect.origin.x,
                                     self.scanRect.origin.y,
                                     self.scanRect.size.width, 4);
    [self.view addSubview:lineImageView];
    
    [self setupCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startScan];
    upToDown = YES;
    num = 0;
    lineImageView.frame = CGRectMake(self.scanRect.origin.x,
                                     self.scanRect.origin.y,
                                     self.scanRect.size.width,
                                     4);

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.maskView.isHidden) {
        self.maskView.hidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopScan];
}

#pragma mark private methods
- (void)setupCamera
{
    if (SupportSystemVersion(7))
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请在“设置-隐私-照片”选项中允许特奢汇访问你的相机。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ( [_device lockForConfiguration:NULL] == YES )
        {
            
            CGPoint point = CGPointMake(0.5,0.5);
            [_device setFocusPointOfInterest:point];
            [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [_device unlockForConfiguration];
        }
        
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([_session canAddInput:self.input])
        {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output])
        {
            [_session addOutput:self.output];
        }
        
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        
        _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = self.scanRect;//self.view.bounds;
        [self.view.layer insertSublayer:self.preview below:self.backImageView.layer];
    }
    else
    {
        self.capture = [[ZXCapture alloc] init];
        self.capture.camera = self.capture.back;
        self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        self.capture.rotation = 90.0f;
        
        self.capture.layer.frame = self.view.bounds;
        [self.view.layer insertSublayer:self.capture.layer
                                  below:self.backImageView.layer];
    }
}

- (void)startScan
{
    _scanOver = NO;
    
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                             target:self
                                           selector:@selector(lineAnimation)
                                           userInfo:nil
                                            repeats:YES];
    
    if (SupportSystemVersion(7))
    {
        [_session startRunning];
    }
    else
    {
        self.capture.delegate = self;
        self.capture.layer.frame = self.view.bounds;
        self.capture.hints.assumeGS1 = YES;
        
        CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
        self.capture.scanRect = CGRectApplyAffineTransform(self.scanRect, captureSizeTransform);
    }
}

- (void)stopScan
{
    if (SupportSystemVersion(7))
    {
        [_session stopRunning];
        [timer invalidate];
    }
    else
    {
        [self.capture stop];
    }
}

-(void)turnOnLed:(id)sender
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        
        _ledOn = !_ledOn;
        
        if (_ledOn)
        {
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
        }
        else
        {
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
        }

        [device unlockForConfiguration];
    }   
}

- (NSDictionary *)decodeStr:(NSString *)result
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *qrscanStr = [result base64DecodedString];
    
    if (!qrscanStr)
    {
        qrscanStr = result;
    }
    
    NSArray *array = [qrscanStr componentsSeparatedByString:@"&"];
    
    //过滤无效的二维码
    if ([array containsObject:@"teshehui"])
    {
        for (NSString *param in array)
        {
            NSArray *p = [param componentsSeparatedByString:@"="];
            
            if ([p count] >= 2)
            {
                NSString *key = [p objectAtIndex:0];
                NSString *value = [p objectAtIndex:1];
                
                [params setObject:value
                           forKey:key];
            }
        }
    }else if ([array containsObject:@"billiards"]){
        
        for (NSString *param in array)
        {
            NSArray *p = [param componentsSeparatedByString:@"="];
            
            if ([p count] >= 2)
            {
                NSString *key = [p objectAtIndex:0];
                NSString *value = [p objectAtIndex:1];
                
                [params setObject:value
                           forKey:key];
            }
        }
        
    }else if ([array containsObject:@"snack"]){
        
        for (NSString *param in array)
        {
            NSArray *p = [param componentsSeparatedByString:@"="];
            
            if ([p count] >= 2)
            {
                NSString *key = [p objectAtIndex:0];
                NSString *value = [p objectAtIndex:1];
                
                [params setObject:value
                           forKey:key];
            }
        }
    }
    else{
        
    }
    
    return [params copy];
}

- (void)stopTimer
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)handleScannerResult:(NSString *)result
{
    /**
     *  景点扫码  http://travel-api.o2o.teshehui.com/ticket/buy?sid=0027BCDC-4166-4C77-8DDB-8EDF7D5392C1&type=0
     */
    if ([result rangeOfString:TRAVEL_API_URL].location != NSNotFound) {
        NSArray *array = [result componentsSeparatedByString:@"?"];
        
        if (array.count >= 2) {
            
            NSString *tmpString = [array objectAtIndex:1];
            NSArray *array = [tmpString componentsSeparatedByString:@"&"];
            
            //过滤无效的二维码
             NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                for (NSString *param in array)
                {
                    NSArray *p = [param componentsSeparatedByString:@"="];
                    
                    if ([p count] >= 2)
                    {
                        NSString *key = [p objectAtIndex:0];
                        NSString *value = [p objectAtIndex:1];
                        
                        [params setObject:value
                                   forKey:key];
                    }
                }
            
            NSString *sid = [params objectForKey:@"sid"];
            
            if (sid.length != 0) {
                
                [self stopScan];
                if (!_scanOver)
                {
                    _scanOver = YES;
                }
                
                NSString *type = [params objectForKey:@"type"];
                TicketingViewController *ticketController = [[TicketingViewController alloc]initWithNibName:@"TicketingViewController" bundle:nil];
                ticketController.strScenicId = sid;
                ticketController.strTicketType = type;
                [self.navigationController pushViewController:ticketController animated:YES];
            }

        }
        
        return;
        
    }else if ([result length] > 0)
    {
        NSDictionary *dic = [self decodeStr:result];
        HYQRCodeType type = [[dic objectForKey:@"type"] intValue];
        NSString *btid = [dic objectForKey:@"btid"];
        NSString *sid = dic[@"sid"];
        /**
         *  桌球扫码
         */
        if (btid.length > 0) {
            [self stopScan];
            
            if (!_scanOver){
                _scanOver = YES;
            }
            
            [self getBilliardsTableInfoWithMerId:[dic objectForKey:@"mid"] btId:btid];
            
            return;
        }
        
        /**
         *  商家扫码充值
         */
        if (sid.length >0){
            [self stopScan];
            if (!_scanOver){
                _scanOver = YES;
            }
            
            NSString *businessType = dic[@"t"]; //这里判断是普通商家还是桌球商家 0标示普通商家 1标示桌球商家
            
            PrepayViewController *vc = [[PrepayViewController alloc] init];
            vc.merId = sid;  // 商家id
            vc.comeType = 0; // 进入路径
            vc.merchantType = [businessType integerValue]; // 商家类型
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        /**
         *  购买商品扫码
         */
        if (type > 0)
        {
            [self stopScan];
        }
        
        if (!_scanOver)
        {
            _scanOver = YES;
            
            switch (type)  //
            {
                case QR_ProductInfo:
                {
                    NSString *goodsId = [dic objectForKey:@"product_id"];
                    
                    HYQrcodeResultViewController *result = [[HYQrcodeResultViewController alloc] init];
                    result.goodsId = goodsId;
                    result.delegate = self;
                    [result showInView];
                }
                    break;
                    /*
                case QR_Payment:
                {
                    NSString *paycode = [dic objectForKey:@"voucher_code"];
                    HYPayWaysViewController *vc = [[HYPayWaysViewController alloc] init];
                    vc.payCode = paycode;
                    vc.QRcodeStr = result;
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                }
                    break;
                     */
                default:
                    break;
            }
        }
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    DebugNSLog(@"结果是= %@",stringValue);
    
    [self handleScannerResult:stringValue];
}

#pragma mark - ZXCaptureDelegate Methods
- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result
{
    if (!result)
    {
        return;
    }
    
    DebugNSLog(@"ZXCaptureDelegate 结果是= %@",result.text);
    
    [self handleScannerResult:result.text];
}

#pragma mark private methods
- (void)lineAnimation
{
    if (!([self isViewLoaded] && [self.view superview]))
    {
        return;
    }
    
    if (upToDown)
    {
        num++;
        float temp = 0.0;
        if (4*num > self.scanRect.size.height-4)
        {
            temp = self.scanRect.size.height+self.scanRect.origin.y;
            upToDown = NO;
        }
        else
        {
            temp = self.scanRect.origin.y + 4*num;
        }
        lineImageView.frame = CGRectMake(self.scanRect.origin.x,
                                         temp,
                                         self.scanRect.size.width,
                                         4);
    }
    else
    {
        num--;
        float temp = 0.0;
        if (num <= 0)
        {
            temp = self.scanRect.origin.y;
            upToDown = YES;
        }
        else
        {
            temp = self.scanRect.origin.y + 4*num;
        }
        lineImageView.frame = CGRectMake(self.scanRect.origin.x,
                                         temp,
                                         self.scanRect.size.width,
                                         4);
    }
}

#pragma mark - 检测到旅游二维码结果处理
- (void)resultViewControllerOfTravleDetail:(NSString *)sid{
    
    if (sid.length != 0) {
        
        [self stopScan];
        if (!_scanOver)
        {
            _scanOver = YES;
        }
        
        TicketingViewController *ticketController = [[TicketingViewController alloc]initWithNibName:@"TicketingViewController" bundle:nil];
        ticketController.strScenicId = sid;
        [self.navigationController pushViewController:ticketController animated:YES];
    }
}

#pragma mark - result delegate
- (void)resultViewControllerDidDismiss
{
    [self startScan];
}

- (void)resultViewControllerDidCheckDetail:(NSString *)goodsid
{
    HYProductDetailViewController *detail = [[HYProductDetailViewController alloc] init];
    detail.goodsId = goodsid;
    detail.title = @"商品详情";
//    if (self.baseViewController)
//    {
//        [self.baseViewController setTabbarShow:NO];
//    }
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)resultViewControllerDidAddCart
{
    //购物车加入成功，返回首页
    [self.navigationController popToRootViewControllerAnimated:YES];
    /*
    HYMallCartViewController *vc = [[HYMallCartViewController alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:YES];
     */
}

/**
 *  获取球桌信息
 */
- (void)getBilliardsTableInfoWithMerId:(NSString *)merID btId:(NSString *)btId{
    
    WS(weakSelf);
    [UIView animateWithDuration:0.15f animations:^{
        weakSelf.maskView.alpha = 1.0f;
        [weakSelf.view addSubview:weakSelf.maskView];

    }];
    
        if (self.maskView.isHidden) {
         self.maskView.hidden = NO;
    }
    
   // [HYLoadHubView show];
     [PageBaseLoading showLoading];
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    self.tableInfoRequest               = [[BilliardsTableInfoRequest alloc] init];
    self.tableInfoRequest.interfaceURL  = [NSString stringWithFormat:@"%@/Share/GetBilliardInfo",BILLIARDS_API_URL];
    self.tableInfoRequest.interfaceType = DotNET2;
    self.tableInfoRequest.postType      = JSON;
    self.tableInfoRequest.httpMethod    = @"POST";
    
    self.tableInfoRequest.UId           = userInfo.userId;//  用户id
    self.tableInfoRequest.merId         = merID;
    self.tableInfoRequest.btId          = btId;
    
    [self.tableInfoRequest sendReuqest:^(id result, NSError *error)
     {
         
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功  其他为失败
                 
                 [BilliardsTableInfo setupObjectClassInArray:^NSDictionary *{
                     return @{@"DiscountList" : @"DiscountInfo"};
                 }];

                 NSDictionary *dataDic = objDic[@"data"];
                 
               //  weakSelf.maskView.hidden = YES;
                 if(!dataDic){
                     
                     BilliardsScanInfoViewController *tmpCtrl = [[BilliardsScanInfoViewController alloc] init];
                     tmpCtrl.type = 4;
                     [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
                    // [HYLoadHubView dismiss];
                     [PageBaseLoading hide_Load];
                     
                     return ;
                 }
                 
                 weakSelf.tableInfo = [BilliardsTableInfo objectWithKeyValues:dataDic];
                 [weakSelf pushPageWithType:merID btId:btId];
  
             }else{
                
                 NSString *msg = objDic[@"msg"];
                 [METoast toastWithMessage:msg ? : @"获取球桌信息失败"];
             }
         }else{
            
             [weakSelf getTableInfoFailedWithMsg:@"服务器请求异常，确定重新连接吗？"];
         }
         
        //  [HYLoadHubView dismiss];
          [PageBaseLoading hide_Load];


     }];
}


- (void)pushPageWithType:(NSString *)merID btId:(NSString *)btId{
    WS(weakSelf);
    
    NSInteger tableStatus =  weakSelf.tableInfo.TableStatus.integerValue;
    NSString  *orderStatus =  weakSelf.tableInfo.TableStatus;
    NSString  *orderId =  weakSelf.tableInfo.OrderId;
    NSString  *endTime  = weakSelf.tableInfo.EndTime;
    switch (tableStatus) {
            
        case 1:
        {
            if (orderId.length == 0) {
                /**
                 *  开台
                 */
                
                BilliardsScanInfoViewController *tmpCtrl = [[BilliardsScanInfoViewController alloc] init];
                tmpCtrl.merId = merID;
                tmpCtrl.btId = btId;
                tmpCtrl.type = 1;
                tmpCtrl.billiardsTableInfo = weakSelf.tableInfo;
                [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
               // [HYLoadHubView dismiss];
                
                return ;
            } else if (orderId.length != 0 &&
                       (orderStatus.integerValue == 1 ||
                        orderStatus.integerValue == 3 ||
                        orderStatus.integerValue == 4)) {
                           
                           /**
                            *  开台
                            */
                           
                           BilliardsScanInfoViewController *tmpCtrl = [[BilliardsScanInfoViewController alloc] init];
                           tmpCtrl.merId = merID;
                           tmpCtrl.btId = btId;
                           tmpCtrl.type = 1;
                           tmpCtrl.billiardsTableInfo = weakSelf.tableInfo;
                           [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
                          // [HYLoadHubView dismiss];
                           
                           return ;
                           
                       }
            
        }
            break;
        case 2:
        {
            if (orderId.length != 0 && endTime.length == 0) {
                /**
                 *  购买酒水确认页
                 */
               // [HYLoadHubView dismiss];
                HYBuyDrinksViewController *buyDrinks = [[HYBuyDrinksViewController alloc] init];
                buyDrinks.billiardsTableInfo = weakSelf.tableInfo;
                [weakSelf.navigationController pushViewController:buyDrinks animated:YES];
                return;
                
            } else if (orderId.length == 0){
                
                /**
                 *  扫的是别人的台子
                 */
               // [HYLoadHubView dismiss];
                BilliardsScanInfoViewController *tmpCtrl = [[BilliardsScanInfoViewController alloc] init];
                tmpCtrl.type = 2;
                [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
                return;
                
            } else if (orderId.length != 0 &&  orderStatus.integerValue != 0){
                
                /**
                 *  扫的是别人的台子
                 */
               // [HYLoadHubView dismiss];
                BilliardsScanInfoViewController *tmpCtrl = [[BilliardsScanInfoViewController alloc] init];
                tmpCtrl.type = 2;
                [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
                return;
                
            }
            
        }
            break;
        case 3:
        {
            /**
             *  禁用的台子
             */
           // [HYLoadHubView dismiss];
            BilliardsScanInfoViewController *tmpCtrl = [[BilliardsScanInfoViewController alloc] init];
            tmpCtrl.type = 3;
            [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
            return;
            
        }
            break;
        case 4:  //临时开灯状态，暂时不需要做处理
        {
            
        }
            break;
        case 5: //暂停收费
        {
            if (orderId.length != 0 && endTime.length == 0) {
                /**
                 *  购买酒水确认页
                 */
             //   [HYLoadHubView dismiss];
                HYBuyDrinksViewController *buyDrinks = [[HYBuyDrinksViewController alloc] init];
                buyDrinks.billiardsTableInfo = weakSelf.tableInfo;
                [weakSelf.navigationController pushViewController:buyDrinks animated:YES];
                return;
                
            }
        }
            break;
        case 6:
        {
            if (orderId.length != 0 || orderId.length == 0) {
                
                /**
                 *  扫的是别人的台子
                 */
               // [HYLoadHubView dismiss];
                BilliardsScanInfoViewController *tmpCtrl = [[BilliardsScanInfoViewController alloc] init];
                tmpCtrl.type = 2;
                [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
                return;
            }
        }
            break;
        case 7:
        {
            if (orderId != 0 || orderId.length == 0) {
                
                /**
                 *  扫的是别人的台子
                 */
              //  [HYLoadHubView dismiss];
                BilliardsScanInfoViewController *tmpCtrl = [[BilliardsScanInfoViewController alloc] init];
                tmpCtrl.type = 2;
                [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
                return;
            }
        }
            break;
            
        default:
            break;
    }
    
    
    if(orderId.length != 0 && endTime.length != 0 && orderStatus.integerValue == 0){
        /**
         *  扫收台待结  显示订单结算页
         */
        
       // [HYLoadHubView dismiss];
        HYOrderPayViewController *orderPay = [[HYOrderPayViewController alloc] init];
        orderPay.billiardsTableInfo  = weakSelf.tableInfo;
        orderPay.isPayStatus = orderStatus;
        [weakSelf.navigationController pushViewController:orderPay animated:YES];
        return;
    }
    
    
    if(orderStatus.integerValue == 4){ //订单状态 == 4  为已评论了 所以可以继续开台
        /**
         *  开台
         */
        
        BilliardsScanInfoViewController *tmpCtrl = [[BilliardsScanInfoViewController alloc] init];
        tmpCtrl.merId = merID;
        tmpCtrl.btId = btId;
        tmpCtrl.type = 1;
        tmpCtrl.billiardsTableInfo = weakSelf.tableInfo;
        [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
       // [HYLoadHubView dismiss];
        
        return;
    }
    
    [weakSelf getTableInfoFailedWithMsg:@"未获取到该球桌的状态，确定重新获取吗？"];

}




- (void)getTableInfoFailedWithMsg:(NSString *)msg{

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定",nil];
    [av show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        self.maskView.hidden = YES;
        [self startScan];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
