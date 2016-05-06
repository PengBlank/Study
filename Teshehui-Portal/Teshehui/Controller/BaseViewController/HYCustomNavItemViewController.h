//
//  PTCustomBackItemViewController.h
//  Putao
//
//  Created by ChengQian on 12-11-15.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCustomTitleViewController.h"

typedef enum
{
    NoneItemBar,
    BackItemBar,
    CloseItemBar,
    CustomItemBar
}ItemBarType;

typedef NS_ENUM(NSUInteger, HYNavigationBarTheme)
{
    HYNavigationBarThemeDefault,
    HYNavigationBarThemeRed,
    HYNavigationBarThemeBlue,
    HYNavigationBarThemeFlowerRed,
    HYNavigationBarThemeClean
};

@interface HYCustomNavItemViewController : HYCustomTitleViewController
{
    UIBarButtonItem *_backItemBar;
}

//@property (nonatomic, assign) BOOL redThemeNavbar;
@property (nonatomic, assign) ItemBarType leftItemType;   //default is BackItemBar
@property (nonatomic, strong) UIBarButtonItem *backItemBar;
@property (nonatomic, strong) UIBarButtonItem *homeItemBar;
@property (nonatomic, strong) UIBarButtonItem *cancelItemBar;

/**
 *  该参数必须在viewDidLoad被调用之前赋值,否则返回按钮和title颜色无法被改变
 */
@property (nonatomic, assign) HYNavigationBarTheme navbarTheme;

@property (nonatomic, strong) UIColor *navBarTitleColor;
@property (nonatomic, assign) NSInteger navBarTitleWidth;

- (IBAction)backToRootViewController:(id)sender;
- (IBAction)backToHomeViewController:(id)sender;

//指定是否可以滑动返回 Default yes
@property (nonatomic, assign) BOOL canDragBack;

- (void)willSwipToBack;

@end
