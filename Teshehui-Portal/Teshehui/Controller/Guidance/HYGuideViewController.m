//
//  HYGuideViewController.m
//  Teshehui
//
//  Created by Kris on 15/7/20.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYGuideViewController.h"
#import "HYTabbarViewController.h"
#import "HYGetCartGoodsAmountRequest.h"
#import "HYGetRedpacketCountReq.h"
//#import "EPGLTransitionView.h"
//#import "DemoTransition.h"
#import "HYStartAdsViewController.h"
#import "UIImage+Addition.h"
#import "SDWebImageManager.h"
#import "HYAppDelegate.h"

@interface HYGuideViewController () <UIScrollViewDelegate>
{
    
}
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) HYStartAdsViewController *baseContentView;
@property (strong, nonatomic) HYNavigationController *baseLoginView;
@end

@implementation HYGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.添加UISrollView
    [self setupScrollView];
    
    // 2.添加pageControl
    [self setupPageControl];
}

/**
 *  添加pageControl
 */
#pragma mark private methods
- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 4;
    CGFloat centerX = self.view.frame.size.width * 0.5;
    CGFloat centerY = self.view.frame.size.height - 60;
    if (iPhone4_4S == currentDeviceType()) {
        centerY = self.view.frame.size.height - 35;
    }
    
    pageControl.center = CGPointMake(centerX, centerY);
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:253/255.0 green:98/255.0 blue:42/255.0 alpha:1.0];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0];
    
    self.pageControl.hidden = YES;
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    NSString *guidepre = nil;
    CGRect window = [[UIScreen mainScreen] bounds];
    if (window.size.height > 480)
    {
        guidepre = @"guidance";
    }
    else
    {
        guidepre = @"guidance_4s";
    }
    
    // 2.添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    for (int index = 0; index < 5; index++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 设置图片
        NSString *name = [NSString stringWithFormat:@"%@_%d", guidepre, index + 1];
        
        imageView.image = [UIImage imageNamed:name];
        
        CGFloat W = imageView.image.size.width;
        CGFloat H = imageView.image.size.height;
        CGFloat ratio = H/W;
        
        imageH = imageW * ratio;
        
        // 设置frame
        CGFloat imageX = index * imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        
        [scrollView addSubview:imageView];
        
        if (index == 4) {
//              在最后一个图片上面添加按钮
            [self setupLastImageView:imageView];
            
        }
    }
    
    // 3.设置滚动的内容尺寸
    scrollView.contentSize = CGSizeMake(imageW * 5, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
}

/**
 *  添加内容到最后一个图片
 */

- (void)setupLastImageView:(UIImageView *)imageView
{
    //让imageView能跟用户交互
    imageView.userInteractionEnabled = YES;
    
    UIButton *checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
//    checkbox.backgroundColor = [UIColor blueColor];
    checkbox.selected = YES;
    checkbox.contentMode = UIViewContentModeScaleAspectFit;

//    UIImage *checkBoxImg = [UIImage imageNamed:@"guidanceNew_btn"];
//    
//    [checkbox setBackgroundImage:checkBoxImg  forState:UIControlStateNormal];
    
    checkbox.bounds = TFRectMake(0, 0, 140, 40);
    CGFloat checkboxCenterX = self.view.frame.size.width * 0.5;
    CGFloat y = 0.82;

//    if ([UIScreen mainScreen].bounds.size.height == 480)
//    {
//        y = 0.65;
//    }
    CGFloat checkboxCenterY = imageView.frame.size.height * y;
    checkbox.center = CGPointMake(checkboxCenterX, checkboxCenterY);
    [checkbox setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    checkbox.titleLabel.font = [UIFont systemFontOfSize:20];
    [checkbox addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    //    checkbox.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    checkbox.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    //    checkbox.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [imageView addSubview:checkbox];
}

/**
 *  只要UIScrollView滚动了,就会调用
 *
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 2.求出页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;

//    if (pageInt == 4) {
//        self.pageControl.hidden = YES;
//    } else {
//        self.pageControl.hidden = NO;
//    }
    self.pageControl.hidden = YES;
}

- (void)start
{

    [[HYAppDelegate sharedDelegate] chooseRootController];

//    // 显示状态栏
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    // 切换窗口的根控制器,加载广告页
////    [self showStarAnimation];
//    if (self.isFrom3DTouch)
//    {
//        
//    }
//    else
//    {
//        //有缓存则加载广告页面，否则直接进商城
//        UIImage *cache = [[SDImageCache sharedImageCache]
//                          imageFromDiskCacheForKey:kAdsImage];
//        if (cache)
//        {
//            [self loadAdsView];
//        }
//        else
//        {
//            [self loadContentView];
//        }
//    }

}

//- (void)loadContentView
//{
//    self.view.window.rootViewController = [[HYTabbarViewController alloc] init];
//}
//
//- (void)loadAdsView
//{
//    self.view.window.rootViewController = [[HYStartAdsViewController alloc]init];
//}
//
//>>>>>>> .r9225
@end
