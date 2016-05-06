//
//  HYFolwerDetailViewController.h
//  Teshehui
//
//  Created by ichina on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYFolwerViewBaseController.h"
#import "HYFlowerTypeInfo.h"
#import "HYActivityGoodsRequest.h"

@interface HYFlowerSubListViewController : HYFolwerViewBaseController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, copy) NSString *categoryName;
@property(nonatomic, copy) NSString *categoryID;

@property (nonatomic, strong) HYActivityGoodsRequest *getActiveDataReq;

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
