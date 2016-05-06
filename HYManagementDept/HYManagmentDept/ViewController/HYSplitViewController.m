//
//  HYSplitViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-14.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSplitViewController.h"
#import "UIView+Style.h"
#import "UIDevice+Resolutions.h"
//#import "HYDirectionPanGestureRecognizer.h"
#import "HYSplitViewController+UmengShake.h"
#import "HYUserInfo.h"

#define kMenuWidth 200

@interface HYSplitViewController ()
<
UIGestureRecognizerDelegate
>
{
    BOOL _shouldPan;
    CGPoint _initPosition;
    CGRect _initDetailFrame;
    
    UIImageView *_detailShadowView;
}

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) SlideState slideState;

@end

@implementation HYSplitViewController

- (void)dealloc
{
    DebugNSLog(@"main content view is released.");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
            
            _shouldPan = NO;
            
            _slideState = Open;
        }
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    _slideState = Open;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIImage *bg = [UIImage imageNamed:@"main_bg.png"];
//    UIImageView *bgV = [[UIImageView alloc] initWithImage:bg];
//    bgV.frame = self.view.bounds;
//    bgV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:bgV];
    self.view.backgroundColor = [UIColor colorWithRed:56/255.0 green:58/255.0 blue:76/255.0 alpha:1];
    UIView *banner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
    banner.backgroundColor = [UIColor colorWithRed:0/255.0 green:172/255.0 blue:238/255.0 alpha:1];
    banner.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:banner];
    
    self.detailWrapperView = [[UIView alloc] initWithFrame:CGRectZero];
    //_detailWrapperView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_detailWrapperView];
    
    self.masterViewController = [[HYMasterTableViewController alloc] init];
    self.masterViewController.splitViewController = self;
    [self addChildViewController:self.masterViewController];
    [self.view addSubview:self.masterViewController.view];
    [self.masterViewController willMoveToParentViewController:self];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    _panGesture.delegate = self;
    //self.panGesture.direction = HYDirectionPanGestureRecognizerHorizontal;
    [_detailWrapperView addGestureRecognizer:_panGesture];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    _tapGesture.delegate = self;
    [_detailWrapperView addGestureRecognizer:_tapGesture];
    
    _detailShadowView = [[UIImageView alloc] init];
    _detailShadowView.frame = _detailWrapperView.bounds;
    _detailShadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //加阴影
    [_detailShadowView addShadow:CGSizeMake(-5, 0)];
    [_detailWrapperView insertSubview:_detailShadowView atIndex:0];
    
    
    //这里手动加载第一个界面，而不是调用showDetail方法来加载，因为初次显示的时候，因为使用动画，会造成很奇怪的现象
    UIViewController *detail = self.masterViewController.summaryNav;
    self.detailViewController = detail;
    [self addChildViewController:detail];
    [_detailWrapperView addSubview:self.detailViewController.view];
//    if ([UIDevice isRunningOnPad])
//    {
//        [_detailViewController.view addCorner:16.0];
//    }
    [self.view setNeedsLayout];
    [_detailViewController.view setNeedsLayout];
    
#if !TARGET_IPHONE_SIMULATOR
    [self umengShake];
#endif
}

- (void)showDetailViewController:(UIViewController *)detail
{
    if (_detailViewController) {
        [_detailViewController willMoveToParentViewController:nil];
        [self.detailViewController removeFromParentViewController];
        [self.detailViewController.view removeFromSuperview];
    }
    self.detailViewController = detail;
    [detail willMoveToParentViewController:self];
    [self addChildViewController:detail];
    [_detailWrapperView addSubview:self.detailViewController.view];
    //_detailViewController.view.backgroundColor = [UIColor greenColor];
//    if ([UIDevice isRunningOnPad])
//    {
//        [_detailViewController.view addCorner:16.0];
//    }
    
    
    [self.view setNeedsLayout];
    
    //点击菜单后直接显示内容
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation) &&
        [UIDevice isRunningOniPhone])
    {
        _slideState = Normal;
        [self setFrameWithStateAnimated:YES];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    float versionoffset = 0;
    if (version >= 7.0) {
        versionoffset = 20;
    }
    
    BOOL isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    
    if (!isPad)
    {
        versionoffset = 0;
    }
    
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
    {
        [self setFrameWithStateAnimated:NO];
        _detailViewController.view.frame = _detailWrapperView.bounds;
    }
    else
    {
        if (version >= 8.0) {   //8.0时横竖屏
            self.masterViewController.view.frame = CGRectMake(0, versionoffset, kMenuWidth, CGRectGetHeight(self.view.frame)-versionoffset);
            _detailWrapperView.frame = CGRectMake(kMenuWidth,
                                                  0,
                                                  CGRectGetWidth(self.view.frame)-kMenuWidth,
                                                  CGRectGetHeight(self.view.frame));
        } else {
            self.masterViewController.view.frame = CGRectMake(0, versionoffset, kMenuWidth, CGRectGetWidth(self.view.frame)-versionoffset);
            _detailWrapperView.frame = CGRectMake(kMenuWidth,
                                                  0,
                                                  CGRectGetHeight(self.view.frame)-kMenuWidth,
                                                  CGRectGetWidth(self.view.frame));
        }
        
        _detailViewController.view.frame = _detailWrapperView.bounds;
        
        //[_detailWrapperView removeShadow];
    }
    
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
    {
        _shouldPan = YES;
        _detailShadowView.hidden = NO;
    }
    else
    {
        _shouldPan = NO;
        _detailShadowView.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return YES;
}

#pragma mark - PanGesture

- (void)panGestureAction:(UIPanGestureRecognizer *)pan
{
    switch (pan.state)
    {
        case UIGestureRecognizerStateBegan:
            _initPosition = [pan locationInView:self.view];
            _initDetailFrame = _detailWrapperView.frame;
            //_prePosition = [pan locationInView:self.view]
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint newPosition = [pan locationInView:self.view];
            CGFloat offset = newPosition.x - _initPosition.x;
            
            [self moveOffset:offset];
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self setFrameWithStateAnimated:YES];
        }
        default:
            break;
    }
}

- (void)moveOffset:(CGFloat)offset
{
    float x = _initDetailFrame.origin.x + offset;
    
    x = x < 0 ? 0 : x;
    x = x > kMenuWidth ? kMenuWidth : x;
    
    CGRect frame = _initDetailFrame;
    frame.origin.x = x;
    _detailWrapperView.frame = frame;
    
    frame = _masterViewController.view.frame;
    frame.origin.x = CGRectGetMinX(_detailWrapperView.frame) - CGRectGetWidth(frame) - 20;
    _masterViewController.view.frame = frame;
    
    UINavigationController *detailNav = (UINavigationController *)_detailViewController;
    HYBaseDetailViewController *detailC = (HYBaseDetailViewController *)[[detailNav viewControllers] lastObject];
    
    if (x > 100) {
        if (_slideState == Normal)
        {
            [detailC becomeState:Open];
        }
        _slideState = Open;
    } else {
        if (_slideState == Open)
        {
            [detailC becomeState:Normal];
        }
        _slideState = Normal;
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture
{
    _slideState = Normal;
    [self setFrameWithStateAnimated:YES];
}

- (void)changeSlideState
{
    if (_slideState == Normal)
    {
        _slideState = Open;
    }
    else
    {
        _slideState = Normal;
    }
    
    [self setFrameWithStateAnimated:YES];
    
    UINavigationController *detailNav = (UINavigationController *)_detailViewController;
    HYBaseDetailViewController *detailC = (HYBaseDetailViewController *)[[detailNav viewControllers] lastObject];
    [detailC becomeState:_slideState];
}

- (void)setFrameWithStateAnimated:(BOOL)animate
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    float yoffset = 0;
    if (version >= 7.0) {
        yoffset = 20;
    }
    
    switch (_slideState)
    {
        case Normal:
        {
            if (animate)
                [UIView beginAnimations:@"animate" context:nil];
            self.masterViewController.view.frame = CGRectMake(-kMenuWidth, yoffset, kMenuWidth, CGRectGetHeight(self.view.frame) - yoffset);
            _detailWrapperView.frame = self.view.bounds;
            if (animate)
                [UIView commitAnimations];
            
            break;
        }
        case Open:
        {
            if (animate)
                [UIView beginAnimations:@"animate" context:nil];
            self.masterViewController.view.frame = CGRectMake(0, yoffset, kMenuWidth, CGRectGetHeight(self.view.frame) - yoffset);
            _detailWrapperView.frame = CGRectMake(kMenuWidth, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            if (animate)
                [UIView commitAnimations];
            break;
        }
        default:
            break;
    }
    _initDetailFrame = _detailWrapperView.frame;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _panGesture) {
        return _shouldPan;
    }
    if (gestureRecognizer == _tapGesture) {
        return _shouldPan && _slideState == Open;
    }
    return NO;
}

#pragma mark - 

- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
