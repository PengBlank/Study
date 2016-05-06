//
//  HYAccoutSecurityViewController.h
//  Teshehui
//
//  Created by Kris on 15/5/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYMineInfoViewController.h"

/**
 *  @brief 帐户安全
 */
@interface HYAccoutSecurityViewController : HYMallViewBaseController
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic,weak) HYMineInfoViewController *mineVC;

@end
