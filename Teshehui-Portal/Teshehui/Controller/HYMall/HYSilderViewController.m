//
//  HYSilderViewController.m
//  Teshehui
//
//  Created by HYZB on 15/1/22.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSilderViewController.h"
#import <Accelerate/Accelerate.h>

#define duration 0.3
#define kSidebarWidth 280.0

@interface HYSilderViewController () <UIGestureRecognizerDelegate>
{
    CGPoint startTouchPotin; // 手指按下时的坐标
    CGFloat startContentOriginX; // 移动前的窗口位置
    BOOL _isMoving;
    
    float red;
    float green;
    float blue;
}

@property (nonatomic, retain) UIImageView* snapImageView;
@property (nonatomic, retain) UIView* blurView;
@end

@implementation HYSilderViewController

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
    self.snapImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.snapImageView.userInteractionEnabled = YES;
    //    [self.view addSubview:self.snapImageView]; // 暂时不用它,以后可以用作固定背景
    
    self.blurView = [[UIView alloc] initWithFrame:self.view.frame];
    self.blurView.userInteractionEnabled = NO;
    self.blurView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.blurView];
    self.blurView.alpha = 0; // 一开始不显示
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapDetected:)];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.view addGestureRecognizer:pan];
    
    // 列表
    CGRect rect = CGRectMake(ScreenRect.size.width, 0, TFScalePoint(kSidebarWidth), self.view.frame.size.height);
    self.contentView = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:self.contentView];
    
    self.view.hidden = YES;
}


- (BOOL)isShow
{
    return self.contentView.frame.origin.x < ScreenRect.size.width ? YES : NO;
}

- (void)showHideSidebar
{
    if (self.contentView.frame.origin.x == ScreenRect.size.width)
    {
        [self beginShowSidebar];
    }
    
    [self autoShowHideSidebar];
}

#pragma mark 子类中可用的
- (void)slideToRightOccured
{
    
}

- (void)sidebarDidShown
{
    
}

- (void)didHide
{
    
}

- (void)autoShowHideSidebar
{
    if (!self.isShow)
    {
        self.view.hidden = NO;
        
        [UIView animateWithDuration:duration animations:^{
            [self setSidebarOriginX:ScreenRect.size.width-TFScalePoint(kSidebarWidth)];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            [self sidebarDidShown];
        }];
    }
    else
    {
        [UIView animateWithDuration:duration animations:^{
            [self setSidebarOriginX:ScreenRect.size.width];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.view.hidden = YES;
            [self didHide];
        }];
    }
}

- (void)beginShowSidebar
{
    // 记录按下时的x位置
    startContentOriginX = self.contentView.frame.origin.x;
    
    if (self.contentView.frame.origin.x >= ScreenRect.size.width)
    {
        // 截图
        self.snapImageView.image = [self imageFromView:self.view.superview];
        __block typeof(self) bself = self;
        dispatch_queue_t queue = dispatch_queue_create("cn.lugede.LLBlurSidebar", NULL);
        dispatch_async(queue, ^ {
            
            UIImage *blurImage = [self blurryImage:bself.snapImageView.image
                                     withBlurLevel:0.2];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                bself.blurView.layer.contents = (id)blurImage.CGImage;
            });
        });
        
#if !OS_OBJECT_USE_OBJC
        dispatch_release(queue);
#endif
    }
}

#pragma mark - 手势响应
- (void)tapDetected:(UITapGestureRecognizer*)recognizer
{
    [self autoShowHideSidebar];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.view];
    if (point.x < self.contentView.frame.origin.x)
    {
        return YES;
    }
    return  NO;
}

- (void)panDetected:(UIPanGestureRecognizer *)recoginzer
{
    CGPoint touchPoint = [recoginzer locationInView:self.view];
    CGFloat offsetX = touchPoint.x - startTouchPotin.x;
    
    if (recoginzer.state == UIGestureRecognizerStateBegan)
    {
        _isMoving = YES;
        startTouchPotin = touchPoint;
        
        self.view.hidden = NO;
        [self beginShowSidebar];
    }
    else if (recoginzer.state == UIGestureRecognizerStateEnded)
    {
        if (offsetX > 40 || ((int)startContentOriginX==0 && offsetX<0 && offsetX>-20)) // 右滑大于40，或展开时左滑一丁点
        {
            [UIView animateWithDuration:duration animations:^{
                [self setSidebarOriginX:ScreenRect.size.width];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.view.hidden = YES;
            }];
        }
        else
        {
            [self slideToRightOccured]; // 即将显示到底
            
            self.view.hidden = NO;
            [UIView animateWithDuration:duration animations:^{
                [self setSidebarOriginX:ScreenRect.size.width-TFScalePoint(kSidebarWidth)];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                [self sidebarDidShown];
            }];
        }
        return;
        
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled)
    {
        [UIView animateWithDuration:duration animations:^{
            [self setSidebarOriginX:ScreenRect.size.width];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.view.hidden = YES;
        }];
        return;
    }
    
    if (_isMoving)
    {
        [self setSidebarOffset:offsetX];
    }
    
}

#pragma mark - 侧栏出来
/*
 * 设置侧栏位置
 * 完全不显示时为x=-kSidebarWidth，显示到最右时x=0
 */
- (void)setSidebarOriginX:(CGFloat)x
{
    CGRect rect = self.contentView.frame;
    rect.origin.x = x;
    [self.contentView setFrame:rect];
    
    [self setBlurViewAlpha];
}

/*
 * 设置侧栏相对于开始点击时的偏移
 */
- (void)setSidebarOffset:(CGFloat)offset
{
    CGRect rect = self.contentView.frame;
    
    DebugNSLog(@"point = %f", offset);
    
    if (offset >=0)
    {
        if (rect.origin.x < ScreenRect.size.width)
        {
            rect.origin.x = startContentOriginX + offset;
        }
        else
        {
            rect.origin.x = ScreenRect.size.width;
        }
    }
    else
    {
        if (rect.origin.x > ScreenRect.size.width-kSidebarWidth)
        {
            rect.origin.x = startContentOriginX + offset;
        }
        else
        {
            rect.origin.x = ScreenRect.size.width-kSidebarWidth;
        }
    }
    [self.contentView setFrame:rect];
    [self setBlurViewAlpha];
}

// 之所以分开是为了动画时渐变
- (void)setBlurViewAlpha
{
    CGRect rect = self.contentView.frame;
    float percent = (ScreenRect.size.width-rect.origin.x) / kSidebarWidth;
    self.blurView.alpha = percent = 0.2 + (1-0.2)*(percent); // 不从0开始，效果更明显
    percent = 0.7 + (0.8-0.7)*(percent);
    self.contentView.backgroundColor = [UIColor colorWithRed:red
                                                       green:green
                                                        blue:blue
                                                       alpha:percent];
}

- (void)setBgColor:(UIColor *)bgColor
{
    red = 0;//bgColor.CIColor.red;
    green = 0;//bgColor.CIColor.green;
    blue = 0;//bgColor.CIColor.blue;
}

#pragma mark - Blur
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
