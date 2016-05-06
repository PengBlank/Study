//
//  HYExpressSelectViewController.h
//  Teshehui
//
//  Created by HYZB on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 *  物流选择
 */
#import "HYMallViewBaseController.h"
#import "HYMallCartShopInfo.h"
#import "HYMallCartShopInfo.h"
#import "HYAddressInfo.h"
#import "HYExpressInfo.h"

@protocol HYExpressSelectViewControllerDelegate <NSObject>

@required
- (void)didSelectExperss:(HYExpressInfo *)express;

@end

@interface HYExpressSelectViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, weak) id<HYExpressSelectViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL showAllExpress;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, strong) HYMallCartShopInfo *storeInfo;
@property (nonatomic, strong) HYAddressInfo *address;

@end
