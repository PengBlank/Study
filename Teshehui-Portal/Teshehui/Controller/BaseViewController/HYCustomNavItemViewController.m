//
//  PTCustomBackItemViewController.m
//  Putao
//
//  Created by ChengQian on 12-11-15.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

#import "HYCustomNavItemViewController.h"
#import <objc/runtime.h>
#import "UIColor+hexColor.h"

static char *naviThemePropertyKey;

@interface HYCustomNavItemViewController ()

@end

@implementation HYCustomNavItemViewController

@synthesize backItemBar = _backItemBar;
@synthesize leftItemType = _leftItemType;

//兼容旧版
//- (void)setRedThemeNavbar:(BOOL)redThemeNavbar
//{
//    _redThemeNavbar = redThemeNavbar;
//    if (redThemeNavbar)
//    {
//        _navbarTheme = HYNavigationBarThemeRed;
//    }
//}

- (id)init
{
    self = [super init];
    
    if (self) {
        _leftItemType = BackItemBar;
        _canDragBack = YES;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        _leftItemType = BackItemBar;
        _navbarTheme = HYNavigationBarThemeDefault;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    HYNavigationBarTheme naviTheme = [self getNavigationControllerTheme];
    if (naviTheme != _navbarTheme)
    {
        [self reloadNavbarTheme];
        [self setNavigationControllerTheme:_navbarTheme];
    }
    
    switch (self.leftItemType)
    {
        case BackItemBar:
        {
            if ([[self.navigationController viewControllers] count] > 1)
            {
                self.navigationItem.leftBarButtonItem = self.backItemBar;
            }
        }
            break;
        case CloseItemBar:
        {
            UIImage *back_bg_n = [UIImage imageNamed:@"bg_topbar_btn.png"];
            UIImage *back_n = [UIImage imageNamed:@"icon_top_cancer.png"];
            
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            backButton.frame = CGRectMake(0, 0, 48, 30);
            [backButton setBackgroundImage:back_bg_n forState:UIControlStateNormal];
            
            [backButton setAdjustsImageWhenHighlighted:NO];
            //    [backButton setBackgroundImage:back_bg_s forState:UIControlStateHighlighted];
            [backButton setImage:back_n forState:UIControlStateNormal];
            //    [backButton setImage:back_s forState:UIControlStateHighlighted];
            [backButton addTarget:self
                           action:@selector(backToRootViewController:)
                 forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
            self.navigationItem.leftBarButtonItem = leftBarItem;
        }
            break;
        default:
            break;
    }
    
    UIColor *titleColor = nil;
    switch (_navbarTheme)
    {
        case HYNavigationBarThemeRed:
            titleColor = [UIColor colorWithHexColor:@"555555" alpha:1];
            break;
        case HYNavigationBarThemeBlue:
            titleColor = [UIColor blackColor];
            break;
        default:
            break;
    }
    if (titleColor)
    {
        CGFloat width = 160;
        if (_navBarTitleWidth)
        {
            width = _navBarTitleWidth;
        }
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
        t.textColor = titleColor;
        t.font = [UIFont systemFontOfSize:19];
        t.backgroundColor = [UIColor clearColor];
        t.textAlignment = NSTextAlignmentCenter;
        t.text = self.title;
        self.navigationItem.titleView = t;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    HYNavigationBarTheme naviTheme = [self getNavigationControllerTheme];
    if (naviTheme != _navbarTheme)
    {
        [self reloadNavbarTheme];
        [self setNavigationControllerTheme:_navbarTheme];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /// 友盟用户行为收集
    [self beginUmengPageLog];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endUmengPageLog];
}

- (void)beginUmengPageLog
{
    [MobClick beginLogPageView:[self getUmengPageLog]];
}

- (NSString *)getUmengPageLog
{
    NSString *className = NSStringFromClass(self.class);
    NSString *pageLog = [NSString stringWithFormat:@"Page%@", className];
    return pageLog;
}

- (void)endUmengPageLog
{
    [MobClick endLogPageView:[self getUmengPageLog]];
}

- (void)reloadNavbarTheme
{
    switch (_navbarTheme)
    {
        case HYNavigationBarThemeRed:
        case HYNavigationBarThemeDefault:
        {
            NSString *imageName = CheckIOS7 ? @"navbar_bg_128" : @"navbar_bg_88";
            UIImage *bgImage = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
            [self.navigationController.navigationBar setBackgroundImage:bgImage
                                                          forBarMetrics:UIBarMetricsDefault];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            break;
        }
        case HYNavigationBarThemeBlue:
        {
            NSString *imageName = CheckIOS7 ? @"navbar_bg_128_blue" : @"navbar_bg_88_blue";
            UIImage *bgImage = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
            [self.navigationController.navigationBar setBackgroundImage:bgImage
                                                          forBarMetrics:UIBarMetricsDefault];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            break;
        }
        case HYNavigationBarThemeFlowerRed:
        {
            NSString *imageName = CheckIOS7 ? @"flower_bg_title_bar_128" : @"flower_bg_title_bar_88";
            UIImage *image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:1
                                                                                 topCapHeight:0];
            [self.navigationController.navigationBar setBackgroundImage:image
                                                          forBarMetrics:UIBarMetricsDefault];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [(UILabel *)self.navigationItem.titleView setText:title];
}

#pragma mark setter/getter
- (UIBarButtonItem *)homeItemBar
{
    if (!_homeItemBar)
    {
        UIImage *back_s = [UIImage imageNamed:@"home_itembar_press"];
        UIImage *back_n = [UIImage imageNamed:@"home_itembar_normal"];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 48, 30);
        
        [backButton setAdjustsImageWhenHighlighted:NO];
        [backButton setImage:back_n forState:UIControlStateNormal];
        [backButton setImage:back_s forState:UIControlStateHighlighted];
        [backButton addTarget:self
                       action:@selector(backToHomeViewController:)
             forControlEvents:UIControlEventTouchUpInside];
        _homeItemBar = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    
    return _homeItemBar;
}

- (UIBarButtonItem *)backItemBar
{
    if (!_backItemBar)
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 48, 30);
        
        if (self.navbarTheme == HYNavigationBarThemeBlue)
        {
            UIImage *back_n = [UIImage imageNamed:@"btn_back_arrow_blue"];
            
            [backButton setImage:back_n forState:UIControlStateNormal];
            [backButton setAdjustsImageWhenHighlighted:NO];
            if (!CheckIOS7)
            {
                [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 24, 0, 0)];
            }
        }
        else if (self.navbarTheme == HYNavigationBarThemeRed)
        {
            UIImage *back_n = [UIImage imageNamed:@"nav_back_itembar"];
            
            [backButton setImage:back_n forState:UIControlStateNormal];
            [backButton setAdjustsImageWhenHighlighted:NO];
            if (!CheckIOS7)
            {
                [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 24, 0, 0)];
            }
        }
        else
        {
            UIImage *back_n = [UIImage imageNamed:@"btn_back_arrow"];
            UIImage *back_s = [UIImage imageNamed:@"btn_back_arrow_focus"];
            
            backButton.frame = CGRectMake(0, 0, 48, 30);
            [backButton setImage:back_n forState:UIControlStateNormal];
            [backButton setImage:back_s forState:UIControlStateHighlighted];
        }
        
        [backButton addTarget:self
                       action:@selector(backToRootViewController:)
             forControlEvents:UIControlEventTouchUpInside];
        
        _backItemBar = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _backItemBar;
}

- (UIColor *)navBarTitleColor
{
    switch (_navbarTheme)
    {
        case HYNavigationBarThemeRed:
            return [UIColor blackColor];
            break;
        case HYNavigationBarThemeBlue:
            return [UIColor colorWithWhite:.4 alpha:1];
            break;
        case HYNavigationBarThemeDefault:
            return [UIColor blackColor];
            break;
        case HYNavigationBarThemeFlowerRed:
            return [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    return nil;
}

//- (void)setNavbarTheme:(HYNavigationBarTheme)navbarTheme
//{
//    if (navbarTheme != _navbarTheme)
//    {
//        _navbarTheme = navbarTheme;
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToRootViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backToHomeViewController:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (HYNavigationBarTheme)getNavigationControllerTheme
{
    HYNavigationBarTheme theme = [objc_getAssociatedObject(self.navigationController, &naviThemePropertyKey) unsignedIntegerValue];
    return theme;
}

- (void)setNavigationControllerTheme:(HYNavigationBarTheme)theme
{
    if (self.navigationController)
    {
        objc_setAssociatedObject(self.navigationController, &naviThemePropertyKey, @(theme), OBJC_ASSOCIATION_RETAIN);
    }
}

- (void)willSwipToBack
{
    
}

/// 取消按钮
- (UIBarButtonItem *)cancelItemBar
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btn addTarget:self action:@selector(cancelItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

- (void)cancelItemAction:(UIButton *)btn
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
