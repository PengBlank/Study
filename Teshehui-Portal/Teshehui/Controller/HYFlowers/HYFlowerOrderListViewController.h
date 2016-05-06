//
//  HYFolwerOrderListViewController.h
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCustomNavItemViewController.h"

@class HYFlowerOrderListCell;
@interface HYFlowerOrderListViewController : HYCustomNavItemViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *recommendList;

-(void)reloadOrderList;

- (void)deleteOrderAndCell:(HYFlowerOrderListCell *)cell;

@end
