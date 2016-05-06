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
#import "HYPayWaysViewController.h"
#import "HYMallCartViewController.h"
#import "HYProductDetailViewController.h"
#import "UIImage+Addition.h"

@interface HYQRCodeReaderViewController ()
<
ZXCaptureDelegate,
AVCaptureMetadataOutputObjectsDelegate,
HYQrcodeResultViewControllerDelegate,
UINavigationControllerDelegate
>
{
    BOOL infoShowing;
    BOOL upToDown;
    int num;
    UIImageView *lineImageView;
    NSTimer *timer;
    
    BOOL _ledOn;
}

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, assign) BOOL scanOver;

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
    [self.capture.layer removeFromSuperlayer];
    self.navigationController.delegate = nil;
    
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
    if ([result length] > 0)
    {
        NSDictionary *dic = [self decodeStr:result];
        HYQRCodeType type = [[dic objectForKey:@"type"] intValue];
        
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

@end
