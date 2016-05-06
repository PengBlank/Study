//
//  HYVipUpdateViewController.h
//  Teshehui
//
//  Created by Kris on 15/9/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallViewBaseController.h"

@protocol HYVipUpdateViewControllerDelegate;

@interface HYVipUpdateViewController : HYMallViewBaseController

@property (nonatomic, assign) BusinessType curType;
@property (nonatomic, weak) id<HYVipUpdateViewControllerDelegate> delegate;

+ (BOOL)isShowWithBusnessType:(BusinessType)type;

@property (nonatomic , assign) BOOL canContinue;    //是否可继续,可继续下面出现继续按钮,不可继续下面出现取消按钮

@end


@protocol HYVipUpdateViewControllerDelegate <NSObject>

@optional
- (void)didSelectContinue:(HYVipUpdateViewController *)vc;
- (void)didSelectUpgrad;

@end