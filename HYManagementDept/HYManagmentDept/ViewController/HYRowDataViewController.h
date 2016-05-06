//
//  HYRowDataViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-12.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseDetailViewController.h"
#import "HYRefreshHeaderView.h"
#import "HYRefreshFooterView.h"
#import "HYBaseResponse.h"
#import "HYBaseRequestParam.h"
#import "HYSortHeadView.h"
#import "HYRowDataRequest.h"
#import "HYRowDataResponse.h"
#import "HYGridCell.h"
#import "UIAlertView+Utils.h"

#define TableHeaderBackgroundColor \
        [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1]

@interface HYRowDataViewController : HYBaseDetailViewController
<
CCRefreshBaseViewDelegate,
HYSortHeadViewDelegate,
UITableViewDataSource,
UITableViewDelegate
>
{
    UITableView *_tableView;
    HYSortHeadView *_headView;
    HYRefreshHeaderView *_refreshHeader;
    HYRefreshFooterView *_refreshFooter;
    UIScrollView *_tableWrapper;
    NSUInteger _page;
    
    HYRowDataRequest *_rowDatarequest;
    
    BOOL _shouldReplaceHeader;
    
    BOOL _isPad;
    
    BOOL _isLoading;
}

@property (nonatomic, strong) HYSortHeadView        *headView;
@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) HYRefreshHeaderView   *refreshHeader;
@property (nonatomic, strong) HYRefreshFooterView   *refreshFooter;
@property (nonatomic, strong) NSMutableArray        *dataSource;
@property (nonatomic, assign) NSUInteger             page;
@property (nonatomic, strong) UIScrollView          *tableWrapper;;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, assign) BOOL                  isLoading;

- (void)addTouchPreventer;

- (void)adjustRefresher;

- (NSArray *)getTableColumnWidth;

- (void)setTotalNumber:(NSInteger)total;

- (void)createTableWithOffset:(CGFloat)yoffset;

/**
 *  显示，总共total个项目, 当前已加载page页
 *
 *  @param total
 *  @param page
 *  @param perpage
 */
- (void)setTotal:(NSInteger)total currentPage:(NSInteger)page perPage:(NSInteger)per;

- (void)sendRequest;

- (void)reloadDatas;

@property (nonatomic, strong) HYRowDataRequest *rowDatarequest;


//Child implements!!!
- (void)configureCell:(HYGridCell *)cell withModel:(id)model;
- (NSArray *)tableHeaderTexts;

@end
