//
//  HYCategoryViewController.h
//  Teshehui
//
//  Created by RayXiang on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "SKSTableView.h"

@class HYTabbarViewController;

/**
 *  分类主界面
 */
@interface HYCategoryViewController : HYMallViewBaseController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) HYTabbarViewController *baseViewController;

@end
