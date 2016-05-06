//
//  HYSummaryDetailViewController.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-5.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

/*
 * 运营公司概览界面
 */

#import <UIKit/UIKit.h>
#import "HYBaseDetailViewController.h"
#import "HYHomeSummaryRepsonse.h"

@interface HYSummaryDetailViewController : HYBaseDetailViewController
<UITableViewDataSource,
UITableViewDelegate>
{
    
}

/// SubstitutableDetailViewController

@property (nonatomic, strong, readonly) UITableView *tableView;

/*
 * 开放接口用于测试
 */
- (void)sendRequest;

@end
