//
//  HYProductFilterViewController.h
//  Teshehui
//
//  Created by HYZB on 15/1/22.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSilderViewController.h"
#import "HYProductFilterDataManeger.h"

/**
 *  筛选界面
 */

@protocol HYProductFilterViewControllerDelegate <NSObject>

@optional
- (void)didFilterSettingFinished:(HYProductFilterDataManeger *)filterData;
- (void)didUpdateFilterCondition:(HYProductFilterDataManeger *)filterData;

- (void)sideDidShow;
- (void)sideDidHide;

@end


@interface HYProductFilterViewController : HYSilderViewController

@property (nonatomic, strong) HYProductFilterDataManeger *filterData;
@property (nonatomic, weak) id<HYProductFilterViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL layoutOffset;
@property (nonatomic, retain, readonly) UITableView* menuTableView;

@end
