//
//  CQBaseNavViewController.m
//  Teshehui
//
//  Created by ChengQian on 13-10-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYNavigationController.h"
#import "HYProductDetailContentView.h"
#import "HYCustomNavItemViewController.h"

#import "HYMallViewBaseController.h"

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]

// 背景视图起始frame.x
#define startX -200

@interface HYNavigationController ()<UIGestureRecognizerDelegate>
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
    BOOL _isEnable;
    ;
}

@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) NSMutableArray *screenShotsList;
@property (nonatomic,assign) BOOL isMoving;

@end

@implementation HYNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = YES;
    }
    return self;
}

- (void)dealloc
{
    self.screenShotsList = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (CheckIOS7)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
    shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
    [self.view addSubview:shadowImageView];
    
    //默认添加
    [self addPanGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deletePanGestureRecognizer
{
    _isEnable = NO;
    [self.view removeGestureRecognizer:_recognizer];
}

- (void)addPanGestureRecognizer
{
    _isEnable = YES;
    
    _recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                         action:@selector(paningGestureReceive:)];
    _recognizer.delegate = self;
    [_recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:_recognizer];
}

- (void)setEnableSwip:(BOOL)enable
{
    if (enable != _isEnable)
    {
        if (enable)
        {
            [self addPanGestureRecognizer];
        }
        else
        {
            [self deletePanGestureRecognizer];
        }
    }
}

// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIImage *viewCapture = [self.captrueDelegate captureScreen];
    if (!viewCapture)
    {
        viewCapture = [self capture];
    }
    
    [self.screenShotsList addObject:viewCapture];
    
    //处理商城里面wap跳转到app的字段stg_id需要在任意不断传递的问题
    if ([self.topViewController isKindOfClass:[HYMallViewBaseController class]] &&
        [viewController isKindOfClass:[HYMallViewBaseController class]])
    {
        HYMallViewBaseController *lastVC = (HYMallViewBaseController *)self.topViewController;
        if (lastVC.stgId)
        {
            [(HYMallViewBaseController *)viewController setStgId:lastVC.stgId];
        }
    }
    
    [super pushViewController:viewController animated:animated];
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];
    [self.backgroundView setHidden:YES];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods -
// get the current view screen shot
- (UIImage *)capture
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [[UIScreen mainScreen] scale]); //Retina support
    else
        UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x
{
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x/6400)+0.95;
    float alpha = 0.6 - (x/800);
    DebugNSLog(@"alpha = %f", alpha);

    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    blackMask.alpha = alpha;
}

#pragma mark
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([[otherGestureRecognizer view] isKindOfClass:[HYProductDetailContentView class]])
    {
        UIScrollView *scrollView = (UIScrollView *)[otherGestureRecognizer view];
        if (scrollView.contentOffset.x <= 0)
        {
            return YES;
        }
        
        return NO;
    }
    
    /// 解决滑动返回与cell滑动删除的冲突，
    if ([[otherGestureRecognizer view] isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isKindOfClass:[UITableViewCell class]]) {
        return YES;
    }
    if (gestureRecognizer == _recognizer)
    {
        UIViewController *content = [self.viewControllers lastObject];
        if ([content isKindOfClass:[HYCustomNavItemViewController class]])
        {
            HYCustomNavItemViewController *navContent = (HYCustomNavItemViewController *)content;
            if (navContent.canDragBack) {
                return YES;
            }
            return NO;
        }
        return YES;
    }
    return YES;
}

#pragma mark - Gesture Recognizer -
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication]keyWindow]];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView.superview)  //在tabbar的切换过程中，会存在将该届满
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];

        //End paning, always check that if it should move right or move left automatically
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {
                UIViewController *poped = [self.viewControllers lastObject];
                if ([poped isKindOfClass:[HYCustomNavItemViewController class]]) {
                    [(HYCustomNavItemViewController*)poped willSwipToBack];
                }
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            [lastScreenShotView removeFromSuperview];
            lastScreenShotView = nil;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    // it keeps move with touch
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

@end
