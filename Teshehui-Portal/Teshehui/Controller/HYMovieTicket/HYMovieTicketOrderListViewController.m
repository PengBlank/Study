//
//  HYMovieTicketOrderListViewController.m
//  Teshehui
//
//  Created by HYZB on 16/2/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMovieTicketOrderListViewController.h"
#import "HYMovieTicketOrderListCell.h"
#import "HYNullView.h"
// #import "HYMovieTicketOrderDetailViewController.h"
#import "HYMovieTicketOrderListRequest.h"
#import "HYMovieTicketOrderListResponse.h"
#import "HYLoadHubView.h"
#import "HYUserInfo.h"
#import "HYMovieTicketOrderListModel.h"
#import "MJRefresh.h"
#import "METoast.h"
#import "HYMovieTicketOrderListFrame.h"


@interface HYMovieTicketOrderListViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, strong) HYMovieTicketOrderListRequest *movieTicketOrderListReq;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) BOOL hasMore; // 是否为上拉加载数据default is no

@end

@implementation HYMovieTicketOrderListViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_movieTicketOrderListReq cancel];
    _movieTicketOrderListReq = nil;
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    _nullView = [[HYNullView alloc] initWithFrame:frame];
    _nullView.icon = [UIImage imageNamed:@"icon_empty"];
    [self.view addSubview:_nullView];
    _nullView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"电影票订单";
    _pageNo = 1;
    _pageSize = 20;
    _hasMore = NO;
    
    [self loadData];
}

#pragma mark - privateMethod
- (void)loadData
{
    if (!_movieTicketOrderListReq)
    {
        _movieTicketOrderListReq = [[HYMovieTicketOrderListRequest alloc] init];
    }
    
    NSString *userId = [HYUserInfo getUserInfo].userId;
    if (userId)
    {
        _movieTicketOrderListReq.userId = userId;
    }
    _movieTicketOrderListReq.pageNo = _pageNo;
    _movieTicketOrderListReq.pageSize = _pageSize;
    
    [HYLoadHubView show];
    WS(b_self)
    [_movieTicketOrderListReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        HYMovieTicketOrderListResponse *resp = (HYMovieTicketOrderListResponse *)result;
        if (b_self.hasMore)
        {
            [b_self updateWithMoreData:resp.dataList error:error];
        }
        else
        {
            [b_self updateWithData:resp.dataList error:error];
        }
    }];
    
}

/**
 * 下拉加载更多的数据
 */
- (void)updateWithMoreData:(NSMutableArray *)dataList error:(NSError *)error
{
    [_tableView.footer endRefreshing];
    if (error)
    {
        [METoast toastWithMessage:error.domain];
    }
    
    if (dataList.count > 0)
    {
        [self.dataArr addObjectsFromArray:dataList];
        [self.tableView reloadData];
    }
    else
    {
        [_tableView.footer endRefreshingWithNoMoreData];
    }
    
}

/**
 * 第一次加载的数据
 */
- (void)updateWithData:(NSMutableArray *)dataList error:(NSError *)error
{
    if ([dataList count] > 0)
    {
        self.dataArr = dataList;
        [self.tableView reloadData];
    }
    else
    {
        self.tableView.hidden = YES;
        self.nullView.hidden = NO;
        
        if (error)
        {
            _nullView.descInfo = error.domain;
        }
        else
        {
            _nullView.descInfo = @"您暂无卖座网的订单";
        }
    }
    
    if (self.dataArr.count >= 20)
    {
        _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    else
    {
        _tableView.footer = nil;
    }
}

- (void)loadMoreData
{
    _pageNo++;
    _hasMore = YES;
    [self loadData];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMovieTicketOrderListFrame *frame = self.dataArr[indexPath.row];
    return frame.cellHeight+10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMovieTicketOrderListCell *cell = [HYMovieTicketOrderListCell cellWithTableView:tableView];
//    HYMovieTicketOrderListModel *model = self.dataArr[indexPath.row];
//    cell.model = model;
    HYMovieTicketOrderListFrame *frame = self.dataArr[indexPath.row];
    cell.cellFrame = frame;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    HYMovieTicketOrderDetailViewController *vc = [[HYMovieTicketOrderDetailViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}


@end
