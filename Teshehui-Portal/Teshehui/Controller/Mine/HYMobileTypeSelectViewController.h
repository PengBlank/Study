//
//  HYMobileTypeSelectViewController.h
//  Teshehui
//
//  Created by HYZB on 14-10-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYTelNumberInfo.h"

@protocol HYMobileTypeSelectViewControllerDelegate <NSObject>

@optional
- (void)didSelectMobileType;

@end

@interface HYMobileTypeSelectViewController : HYMallViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, weak) id<HYMobileTypeSelectViewControllerDelegate> delegate;
@property (nonatomic, strong) HYTelNumberInfo *telNumber;
@property (nonatomic, readonly, strong) UITableView *tableView;

@end
