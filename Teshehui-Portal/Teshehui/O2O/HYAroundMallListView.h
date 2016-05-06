//
//  HYAroundMallListView.h
//  Teshehui
//
//  Created by RayXiang on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYCityForQRCode;
@class HYNullView;

//由控制器实现，处理界面事件
@protocol HYAroundMallListViewDelegate <NSObject, UITableViewDelegate>

- (void)cityBtnAction:(id)sender;

@end

@interface HYAroundMallListView : UIView

@property (nonatomic, strong) UIButton *cityBtn;
@property (nonatomic, strong) UIView *cityView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HYNullView *nullView;

- (void)reloadTableView;

- (void)setWithCity:(HYCityForQRCode *)city;
- (void)setCity:(NSString *)city;

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)showTable;
- (void)showNullViewWithInfo:(NSString *)info needTouch:(BOOL)touch;
- (void)setLoadMore:(BOOL)loadMore;

@end
