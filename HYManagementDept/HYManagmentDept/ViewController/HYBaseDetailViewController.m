//
//  HYBaseDetailViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-15.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseDetailViewController.h"

#import "HYSplitViewController.h"
#import "UINavigationItem+Margin.h"


@interface HYBaseDetailViewController ()
{
    UITapGestureRecognizer *_editingTap;
    BOOL _keyboardIsShow;
}

@end

@implementation HYBaseDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = YES;
        }
        _keyboardIsShow = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL onPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    float titleFontSize = onPad ? 22.0 : 16.0;
    
    UIImage *navB;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        navB = [UIImage imageNamed:@"nav_128"];
    }
    else
    {
        navB = [UIImage imageNamed:@"nav_88"];
    }
    [self.navigationController.navigationBar setBackgroundImage:navB forBarMetrics:UIBarMetricsDefault];
    
//    UIImage *navB;
//    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
//        navB = [UIImage imageNamed:@"detail_nav2.png"];
//    else
//        navB = [UIImage imageNamed:@"detail_nav.png"];
//    
//    [[UINavigationBar appearance] setBackgroundImage:navB forBarMetrics:UIBarMetricsDefault];
    
//    UIImage *navB;
//    if (!onPad && [UIDevice currentDevice].systemVersion.floatValue >= 7.0)
//        navB = [UIImage imageNamed:@"detail_nav2.png"];
//    else
//        navB = [UIImage imageNamed:@"detail_nav.png"];
//    
//    [self.navigationController.navigationBar setBackgroundImage:navB forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeFont: [UIFont boldSystemFontOfSize:titleFontSize], UITextAttributeTextColor:[UIColor whiteColor]}];
    
    
    //self.wantsFullScreenLayout = YES;
    //self.extendedLayoutIncludesOpaqueBars = YES;
    
    //菜单
    UIImage *menu = [UIImage imageNamed:@"icon_menu.png"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    //[btn setBackgroundImage:menu forState:UIControlStateNormal];
    [btn setImage:menu forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(menuItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = menuItem;
    [self.navigationItem setLeftBarButtonItemWithMargin:menuItem];
    self.menuItem = menuItem;
    
    //self.navigationController.navigationBar.
    
    _editingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editingTapAction:)];
    _editingTap.delegate = self;
    [self.view addGestureRecognizer:_editingTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)n
{
    _keyboardIsShow = YES;
}

- (void)keyboardHide:(NSNotification *)n
{
    _keyboardIsShow = NO;
}

- (void)editingTapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)menuItemClicked:(UIBarButtonItem *)menuItem
{
    HYSplitViewController *split = (HYSplitViewController *)self.navigationController.parentViewController;
    [split changeSlideState];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _editingTap)
    {
        return _keyboardIsShow;
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
//        self.navigationController.navigationBar.frame =
//            CGRectMake(0, 0, CGRectGetWidth(self.view.frame), naviHeight);
        
        //在pad情况下，竖屏需显示菜单按钮，横屏不需要
        BOOL isFirstViewController;
        isFirstViewController = [self.navigationController.viewControllers objectAtIndex:0] == self;
        if (isFirstViewController)
        {
            if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
            {
                self.navigationItem.leftBarButtonItem = nil;
            } else {
                [self.navigationItem setLeftBarButtonItemWithMargin:self.menuItem];
//                self.navigationItem.leftBarButtonItem = self.menuItem;
            }
        }
    }
}

- (void)becomeState:(SlideState)slideState
{
    self.slideState = slideState;
    [self.view endEditing:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self nextResponder] touchesMoved:touches withEvent:event];
}



//- (void)sendArrayRequest:(HYRowDataRequest*)request


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
