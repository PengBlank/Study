//
//  HYFlowerFullBuyerViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-4-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFolwerViewBaseController.h"

@protocol HYFlowerFullBuyerDelegate <NSObject>

@optional
- (void)didSelectedBuyerName:(NSString *)name mobile:(NSString *)mobile;

@end

@interface HYFlowerFullBuyerViewController : HYFolwerViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, weak) id<HYFlowerFullBuyerDelegate>delegate;
@property (nonatomic, readonly, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *mobile;

@end
