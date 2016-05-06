//
//  HYCICarBrandListViewController.h
//  Teshehui
//
//  Created by HYZB on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *车型列表
 */

#import "HYMallViewBaseController.h"
#import "HYCICarBrandInfo.h"

@protocol HYCICarBrandListViewControllerDelegate <NSObject>

@optional
- (void)didSelectCarBrandType:(HYCICarBrandInfo *)brandTypeInfo;

@end

@interface HYCICarBrandListViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, weak) id<HYCICarBrandListViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *keyWord;

@end
