//
//  HYCodeCheckViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/26.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYCodeCheckViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Addition.h"

@interface HYCodeCheckView : UIView
@property (nonatomic, assign) CGRect scanRect;
@end

@implementation HYCodeCheckView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddRect(ctx, self.scanRect);
    CGContextClip(ctx);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:.63 alpha:.5].CGColor);
    CGContextFillPath(ctx);
}

@end

@interface HYCodeCheckViewController ()
<
AVCaptureMetadataOutputObjectsDelegate,
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

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, assign) BOOL scanOver;

@property (nonatomic, strong) AVCaptureDevice * device;
@property (nonatomic, strong) AVCaptureDeviceInput * input;
@property (nonatomic, strong) AVCaptureMetadataOutput * output;
@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * preview;

@end

@implementation HYCodeCheckViewController

- (void)dealloc
{
    self.navigationController.delegate = nil;
    
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    HYCodeCheckView *view = [[HYCodeCheckView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor blackColor];
    self.view = view;
    
    self.title = @"扫码";
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
    
//    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    bg.userInteractionEnabled = YES;
//    bg.image = bgimg;
//    [self.view addSubview:bg];
//    self.backImageView = bg;
    
    self.scanRect = TFRectMake(34, 68, 250, 130);
    //[(HYCodeCheckView *)self.view setScanRect:self.scanRect];
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.scanRect)+20,
                                                                  CGRectGetWidth(ScreenRect),
                                                                  18)];
    desLabel.textColor = [UIColor whiteColor];
    desLabel.font = [UIFont systemFontOfSize:16];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.text = @"对准二维码/条形码到框内，即可自动扫描";
    [self.view addSubview:desLabel];
    
    UIButton *lightBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds)-22,
                                                                    CGRectGetMaxY(desLabel.frame) + 20,
                                                                    44,
                                                                    44)];
    [lightBtn setImage:[UIImage imageNamed:@"sm_light"] forState:UIControlStateNormal];
    [lightBtn addTarget:self action:@selector(turnOnLed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightBtn];
    
    lineImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan_line"]];
    lineImageView.frame = CGRectMake(self.scanRect.origin.x,
                                     self.scanRect.origin.y,
                                     self.scanRect.size.width, 4);
    [self.view addSubview:lineImageView];
    
    [self setupCamera];
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
        
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = self.scanRect;
        [self.view.layer insertSublayer:self.preview below:self.backImageView.layer];
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
}

- (void)stopScan
{
    if (SupportSystemVersion(7))
    {
        [_session stopRunning];
        [timer invalidate];
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


- (void)stopTimer
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
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
    
    if (stringValue.length > 0 && self.didGetCode)
    {
        [self stopScan];
        self.didGetCode(stringValue);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
