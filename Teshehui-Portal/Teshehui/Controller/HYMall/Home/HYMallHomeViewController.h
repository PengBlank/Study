//
//  HYMallHomeV2ViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYTabbarViewController.h"
#import "HYMallHomeItem.h"

@interface HYMallHomeViewController : HYMallViewBaseController

//从启动广告页传来的
@property (nonatomic, strong) HYMallHomeItem *item;
//根视图控制器,处于界面底层
@property (nonatomic, weak) HYTabbarViewController *baseViewController;

- (void)reloadAllData;
- (void)checkBannerItem:(id)product
              withBoard:(id)board;
- (void)reloadHomePageWithDataChange:(BOOL)hasChange;


@end
