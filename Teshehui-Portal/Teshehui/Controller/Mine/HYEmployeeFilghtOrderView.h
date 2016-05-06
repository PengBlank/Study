//
//  HYEmployeeFilghtOrderView.h
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 企业员工的机票订单列表
 */

#import <UIKit/UIKit.h>
#import "HYEmployee.h"

@interface HYEmployeeFilghtOrderView : UIView
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) HYEmployee *employee;

- (void)relaodData;

@end
