//
//  HYSelectContactsViewController.h
//  Teshehui
//
//  Created by HYZB on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 * 选择联系人
 */
#import "HYMallViewBaseController.h"

@protocol HYSelectContactsViewControllerDelegate <NSObject>

@optional
- (void)didSelectContacts:(NSArray *)contacts;

@end

@interface HYSelectContactsViewController : HYMallViewBaseController
<
UISearchDisplayDelegate,
UISearchBarDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, weak) id<HYSelectContactsViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) UITableView *tableView;

@end
