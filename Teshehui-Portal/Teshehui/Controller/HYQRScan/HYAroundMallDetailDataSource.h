//
//  HYAroundMallDetailDataSource.h
//  Teshehui
//
//  Created by RayXiang on 14-7-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HYQRCodeShop;
@interface HYAroundMallDetailDataSource : NSObject
<UITableViewDataSource>

@property (nonatomic, strong) HYQRCodeShop *shopDetail;
@property (nonatomic, strong) NSMutableArray *photos;

- (CGFloat)rowHeightForIndexPath:(NSIndexPath *)idxPath;

//- (void)willDisplayCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

@property (nonatomic, copy) void (^telBtnCallback)(id sender);
@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, weak) UITableView *tableView;

@end
