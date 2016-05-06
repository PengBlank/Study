//
//  RKBasePageViewController.h
//  Kuke
//
//  Created by 成才 向 on 15/10/28.
//  Copyright © 2015年 RK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallViewBaseController.h"
#import "RKPageContentViewController.h"

@interface RKBasePageViewController : HYMallViewBaseController
<UIPageViewControllerDataSource,
UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, assign) CGRect pageContent;
@property (nonatomic, strong) NSArray *contentControllers;
@property (nonatomic, assign) NSInteger currentIdx;

//overload
- (void)contentControllerAtIndexDidLoad:(NSInteger)idx;
- (void)contentControllerAtIndexWillAppear:(NSInteger)idx;  //trigger by viewcontroller's view will apear
- (void)didShowControllerAtIndex:(NSInteger)idx;   //triggier by pagecontroller's data source
- (void)contentControllerAtIndexWillDisappear:(NSInteger)idx;

@end
