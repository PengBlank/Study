//
//  HYMallVIewViewBaseController.m
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

@interface HYMallViewBaseController ()

@end

@implementation HYMallViewBaseController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navbarTheme = HYNavigationBarThemeRed;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)backItemBar
{
    if (!_backItemBar)
    {
        UIImage *back_n = [UIImage imageNamed:@"nav_back_itembar"];
//        UIImage *back_s = [UIImage imageNamed:@"nav_back_itembar"];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 48, 30);
        [backButton setImage:back_n forState:UIControlStateNormal];
//        [backButton setImage:back_s forState:UIControlStateHighlighted];
        [backButton setAdjustsImageWhenHighlighted:NO];
        if (!CheckIOS7)
        {
            [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 24, 0, 0)];
        }
        [backButton addTarget:self
                       action:@selector(backToRootViewController:)
             forControlEvents:UIControlEventTouchUpInside];
        _backItemBar = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    
    return _backItemBar;
}

@end
