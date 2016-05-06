//
//  BusinessMapViewController.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYTabbarViewController.h"
@interface BusinessMapViewController : HYMallViewBaseController
@property (nonatomic, weak) HYTabbarViewController *baseViewController;

@property (nonatomic, strong) UITableView       *baseTableView;

@property (nonatomic,assign) BOOL       isNormalLeakViewController;
@end
