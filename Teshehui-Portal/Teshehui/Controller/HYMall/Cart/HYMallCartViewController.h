//
//  HYMallCartViewController.h
//  Teshehui
//
//  Created by RayXiang on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYTabbarViewController.h"

/**
 *  商城购物车界面
 */
@interface HYMallCartViewController : HYMallViewBaseController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) HYTabbarViewController *baseViewController;

@end
