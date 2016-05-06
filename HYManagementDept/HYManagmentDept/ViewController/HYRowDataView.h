//
//  HYRowDataView.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYRowDataView;
@class HYGridCell;
@protocol HYRowDataViewDelegate <UITableViewDelegate>
@optional
- (void)rowDataViewWillBeginRefreshHeader:(HYRowDataView *)dataView;
- (void)rowDataViewWillBeginRefreshFooter:(HYRowDataView *)dataView;

- (NSArray *)getTableColumnWidth;

@required
- (void)configureCell:(HYGridCell *)cell withModel:(id)model;
- (NSArray *)tableHeaderTexts;
@end

struct HYRowDataViewMetrics {
    CGFloat footHeight;
    CGFloat footSize;
    CGFloat tableMargin;
    CGFloat additionInfoHeight;
};
typedef struct HYRowDataViewMetrics HYRowDataViewMetrics;

@interface HYRowDataView : UIView
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL _shouldReload;
}
@property (nonatomic, assign) HYRowDataViewMetrics metrics;

@property (nonatomic, weak) id<HYRowDataViewDelegate> delegate;
@property (nonatomic, weak) id<UITableViewDataSource> dataSource;

@property (nonatomic, strong) NSArray *tableColumnWidth;

- (void)endRefresh;
@property (nonatomic, assign) BOOL canRefresh;
@property (nonatomic, assign) BOOL canLoadMore;
- (void)reloadData;
@property (nonatomic, assign) BOOL isLoading;

//移到显示区域到左上角
- (void)resetVisibleScope;

/**
 *  下角信息
 *  @param total    项目总数
 *  @param page     当前页
 *  @param per      每页数，传0默认20
 */
- (void)setTotal:(NSInteger)total
     currentPage:(NSInteger)page
         perPage:(NSInteger)per;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger number_per_page;
- (void)setTotal:(NSInteger)total
      currentNum:(NSInteger)num;

/**
 * 底部显示额外信息
 */
@property (nonatomic, strong) NSString *additionInfo;
@property (nonatomic, strong, readonly) UILabel *additionLabel;

/**
 * 数据部分
 */
//store the objects.
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign, readonly) NSInteger count;
- (id)dataAtIndex:(NSInteger)idx;
- (void)add:(NSArray *)array;
- (void)clear;

@end
