//
//  HYMeiWeiQiQiOrderListViewController.m
//  Teshehui
//
//  Created by HYZB on 15/12/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMeiWeiQiQiOrderListViewController.h"
#import "HYNullView.h"
#import "HYMeiWeiQiQiOrderListPriceCell.h"
#import "HYMeiWeiQiQiOrderListStatusCell.h"
#import "HYMeiWeiQiQiOrderListPointCell.h"
#import "HYMeiWeiQiQiOrderListRequest.h"
#import "HYMeiWeiQiQiOrderListResponse.h"
#import "MJRefresh.h"
#import "HYNullView.h"
#import "HYMeiWeiQiQiOrderListModel.h"

@interface HYMeiWeiQiQiOrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    HYMeiWeiQiQiOrderListRequest *_orderListReq;
    
}

@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, copy) NSString *pageSize;

@property (nonatomic, strong) HYNullView *nullView;

@end

@implementation HYMeiWeiQiQiOrderListViewController

- (void)dealloc
{
    [_orderListReq cancel];
    _orderListReq = nil;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
                                           alpha:1.0];
    self.view = view;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"美味七七订单";
    
    _pageNo = 1;
    _pageSize = @"20";
    _isLoading = NO;
    
    [self loadData];
}

#pragma mark - GetNetworkData
- (void)loadData
{

    if (!_isLoading)
    {
        _isLoading = YES;
        [HYLoadHubView show];
        
        if (!_orderListReq)
        {
            _orderListReq = [[HYMeiWeiQiQiOrderListRequest alloc] init];
        }
        _orderListReq.type = @"0"; // 类别 0：全部订单；1：未完成；2：已完成；3:已取消"
        _orderListReq.pageNo = [NSString stringWithFormat:@"%ld", self.pageNo];
        _orderListReq.pageSize = self.pageSize;
        
        WS(weakSelf)
        [_orderListReq sendReuqest:^(id result, NSError *error) {
            
            [HYLoadHubView dismiss];
            weakSelf.isLoading = NO;
            HYMeiWeiQiQiOrderListResponse *response = (HYMeiWeiQiQiOrderListResponse *)result;
            [weakSelf updateViewWithData:response.orders error:error];
            
        }];
    }
}

- (void)updateViewWithData:(NSArray *)array error:(NSError *)error
{
    if (array.count > 0)
    {
        
        [self.tableView setHidden:NO];
        [self.nullView setHidden:YES];
        
        [self.orderList addObjectsFromArray:array];
        
        if (self.orderList.count > 20)
        {
            self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }
        else
        {
            self.tableView.footer.hidden = YES;
        }
        [self.tableView reloadData];
    }
    else
    {
        [self.tableView setHidden:YES];
        [self.nullView setHidden:NO];
        
        if ([error.domain isEqualToString:@"网络请求出现异常"])
        {
            [self.nullView setNeedTouch:YES];
            self.nullView.descInfo = @"由于网络原因加载失败，请点击重新加载";
        }
        else
        {
            [self.nullView setNeedTouch:NO];
            NSString *str = error.domain;
            if ([str length] <= 0)
            {
                str = @"您暂无美味七七的订单";
            }
            self.nullView.descInfo = str;
            self.nullView.icon = [UIImage imageNamed:@"icon_empty"];
        }
    }
}

- (void)loadMoreData
{
    if (!_isLoading) {
        
        _isLoading = YES;
        self.pageNo++;
        [HYLoadHubView show];
        
        if (!_orderListReq)
        {
            _orderListReq = [[HYMeiWeiQiQiOrderListRequest alloc] init];
        }
        
        _orderListReq.type = @"0"; // 类别 0：全部订单；1：未完成；2：已完成；3:已取消"
        _orderListReq.pageNo = [NSString stringWithFormat:@"%ld", self.pageNo];
        _orderListReq.pageSize = self.pageSize;
        
        WS(weakSelf)
        [_orderListReq sendReuqest:^(id result, NSError *error) {
            
            [HYLoadHubView dismiss];
            weakSelf.isLoading = NO;
            [weakSelf.tableView.footer endRefreshing];
            HYMeiWeiQiQiOrderListResponse *response = (HYMeiWeiQiQiOrderListResponse *)result;
            
            if (response.orders.count > 0)
            {
                if (response.orders.count <= 20) {
                    self.tableView.footer.hidden = YES;
                } else {
                    self.tableView.footer.hidden = NO;
                }
                [weakSelf.orderList addObjectsFromArray:response.orders];
                [weakSelf.tableView reloadData];
            }
            else
            {
                weakSelf.tableView.footer.hidden = YES;
            }
        }];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMeiWeiQiQiOrderListModel *model = self.orderList[indexPath.section];
    if (indexPath.row == 0)  //main order title
    {
        HYMeiWeiQiQiOrderListStatusCell *cell = [HYMeiWeiQiQiOrderListStatusCell setCellWithTableView:tableView];
        [cell setMainOrderTitle:model.orderCode];
        [cell setStatusDesc:model.orderShowStatus];
        return cell;
    } //订单数据
    else if (indexPath.row == 1)
    {
        HYMeiWeiQiQiOrderListPriceCell *cell = [HYMeiWeiQiQiOrderListPriceCell setCellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    else
    {
        HYMeiWeiQiQiOrderListPointCell *cell = [HYMeiWeiQiQiOrderListPointCell setCellWithTableView:tableView];
        [cell setPointNumber:model.points];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row == 0)  //main order title
    {
        height = 38;
    }
    else if (indexPath.row == 1) //main order info
    {
        height = 70;
    }
    else
    {
        height = 40;
    }
    return height;
}

#pragma mark setter/getter
- (HYNullView *)nullView
{
    if (!_nullView)
    {
        CGRect frame = self.view.frame;
        frame.origin = CGPointZero;
        
        _nullView = [[HYNullView alloc] initWithFrame:frame];
        _nullView.needTouch = YES;
        [_nullView addTarget:self
                      action:@selector(didClickUpdateEvent)
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nullView];
    }
    
    return _nullView;
}


- (NSMutableArray *)orderList
{
    if (!_orderList) {
        _orderList = [NSMutableArray array];
    }
    return _orderList;
}

#pragma mark - privateMethod
- (void)didClickUpdateEvent
{
    [self.nullView setHidden:YES];
    
    [self loadData];
}


@end
