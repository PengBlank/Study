//
//  HYMasterTableViewController.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-5.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

/*
 * 右边主控制界面
 */

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@class HYSplitViewController;

@interface HYMasterTableViewController : UIViewController
<SKSTableViewDelegate>

@property (nonatomic, strong) UINavigationController *summaryNav;

@property (nonatomic, strong, readonly) SKSTableView *tableView;

@property (nonatomic, weak) HYSplitViewController *splitViewController;

@end
