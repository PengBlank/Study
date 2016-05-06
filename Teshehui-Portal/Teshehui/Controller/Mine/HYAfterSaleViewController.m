//
//  HYMallOrderListViewController.m
//  Teshehui
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAfterSaleViewController.h"
#import "HYHYMallOrderListFilterView.h"
#import "HYMallOrderDetailViewController.h"

#import "HYLoadHubView.h"
#import "HYTableViewFooterView.h"
#import "HYNullView.h"

//#import "HYMallOrderHandleCell.h"
//#import "HYMallOrderListStatusCell.h"
//#import "HYMallOrderListGoodsCell.h"
//Cells
#import "HYAfterSaleBriefCell.h"
#import "HYAfterSaleInfoCell.h"

#import "HYMallOrderListRequest.h"
#import "HYMallOrderListResponse.h"

#import "HYMallCancelOrderRequest.h"
#import "HYConfirmRequest.h"
#import "HYMallDelOrderRequest.h"
#import "HYMallOrderReturnListRequest.h"

#import "HYCommentAddViewController.h"

#import "HYPaymentViewController.h"
#import "HYMallLogisticsTrackViewController.h"
#import "HYGoodsReturnViewViewController.h"
#import "HYGoodsRetStatViewController.h"
#import "HYIndemnityProgressViewController.h"
#import "HYAfterSaleDetailViewController.h"

#import "HYOrderReturnDetailRequest.h"
#import "HYMallRemindDeliverRequest.h"

#import "METoast.h"

#import "HYExpensiveAlertViewController.h"

#import "HYMallOrderGoodsInfo.h"
#import "UIColor+hexColor.h"

#import "MJRefresh.h"
#import "MJRefreshNormalHeader.h"

#define CancelAlertViewTag  10
#define DeleteAlertViewTag  11

NSString *const kAfterSaleListDidChange = @"AfterSaleListDidChange";

@interface HYAfterSaleViewController ()
<
UIAlertViewDelegate
>
{
    HYMallOrderReturnListRequest *_returnReq;
    HYMallCancelOrderRequest *_cancelReq;
    HYConfirmRequest *_confirmReq;
    HYMallDelOrderRequest *_deleteReq;
    HYOrderReturnDetailRequest *_retDetailReq;
    HYMallRemindDeliverRequest *_remindReq;
    BOOL _isShowReturnOrder;
    NSInteger _pageNumber;
    NSInteger _pageSize;
    HYHYMallOrderListFilterView *_filterView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, copy) NSString *filterType;
@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, strong) HYMallOrderSummary *handleOrder;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger returnType;

@end

@implementation HYAfterSaleViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_returnReq cancel];
    _returnReq = nil;
    
    [_cancelReq cancel];
    _cancelReq = nil;
    
    [_confirmReq cancel];
    _confirmReq = nil;
    
    [_deleteReq cancel];
    _deleteReq = nil;
    
    [_remindReq cancel];
    _remindReq = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAfterSaleListDidChange object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _pageNumber = 1;
        _pageSize = 10;
        _isLoading = NO;
        _hasMore = YES;
        self.title = @"售后服务";
    }
    return self;
}


- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithHexColor:@"f5f5f5" alpha:1];
    self.view = view;
    
    _filterView = [[HYHYMallOrderListFilterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
    _filterView.conditions = @[@"闪电退", @"退货", @"换货"];
    _filterView.userInteractionEnabled = YES;
    [_filterView addTarget:self
                    action:@selector(filterOrder:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_filterView];
    _returnType = 2;
    
    //tableview
    frame.origin.y += 44;
    frame.size.height -= 44;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    __weak typeof (self) weakSelf = self;
    tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    tableview.backgroundView = nil;
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (!self.orderList)
    {
        [self reloadOrderData];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listDidChanged:) name:kAfterSaleListDidChange object:nil];
}

#pragma mark 下拉刷新
- (void)loadNewData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadOrderData];
        [self.tableView.header endRefreshing];
    });
}

#pragma mark setter/getter
- (HYNullView *)nullView
{
    if (!_nullView)
    {
        CGRect frame = self.view.frame;
        frame.origin = CGPointMake(0, CGRectGetHeight(_filterView.frame));
        
        _nullView = [[HYNullView alloc] initWithFrame:frame];
        [self.view addSubview:_nullView];
    }
    
    return _nullView;
}

#pragma mark - private methods
- (void)filterOrder:(id)sender
{
    if ([sender isKindOfClass:[HYHYMallOrderListFilterView class]])
    {
        HYHYMallOrderListFilterView *filter = (HYHYMallOrderListFilterView *)sender;
        if (filter.currentIndex == 0)
        {
            _returnType = 2;
        }
        else if (filter.currentIndex == 1)
        {
            _returnType = 1;
        }
        else if (filter.currentIndex == 2)
        {
            _returnType = 3;
        }
        [self reloadOrderData];
    }
}

- (void)reloadOrderData
{
    _pageNumber = 1;
    _hasMore = YES;
    [_orderList removeAllObjects];
    
    [self loadOrderData];
}

- (void)loadOrderData
{
    if (!_isLoading)
    {
        _isLoading = YES;
        
        [HYLoadHubView show];
        
        _returnReq = [[HYMallOrderReturnListRequest alloc] init];
        _returnReq.page = _pageNumber;
        _returnReq.num_per_page = _pageSize;
        _returnReq.refund_type = _returnType;
        
        __weak typeof(self) b_self = self;
        [_returnReq sendReuqest:^(id result, NSError *error)
        {
            NSArray *orderList = nil;
            if (!error && [result isKindOfClass:[HYMallOrderReturnListResponse class]])
            {
                HYMallOrderReturnListResponse *reposne = (HYMallOrderReturnListResponse *)result;
                orderList = reposne.returnList;
            }
            [b_self updateViewWithData:orderList error:error];
        }];
    }
}

- (void)updateViewWithData:(NSArray *)array error:(NSError *)error
{
    [HYLoadHubView dismiss];
    _isLoading = NO;
    _hasMore = ([array count] > 0);
    
    if (_hasMore)
    {
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        if (!_orderList)
        {
            _orderList = [[NSMutableArray alloc] init];
        }
        
        [_orderList addObjectsFromArray:array];
        [self.tableView reloadData];
    }
    else if ([self.orderList count] <= 0)
    {
        _hasMore = YES;
        _pageNumber = 1;
        
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
                str = @"暂无该类订单数据";
            }
            self.nullView.descInfo = str;
        }
    }
    else
    {
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    }
}

- (void)reloadMoreData
{
    if (!_isLoading && _hasMore)
    {
        _pageNumber++;
        [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
        [self loadOrderData];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;   //每行两个
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMallAfterSaleInfo *order = nil;
    if (indexPath.section < [self.orderList count])
    {
        order = [self.orderList objectAtIndex:indexPath.section];
    }
    
    if (indexPath.row == 0)  //store title
    {
        static NSString *orderStatusCellId = @"brief";
        HYAfterSaleBriefCell *cell = [tableView dequeueReusableCellWithIdentifier:orderStatusCellId];
        if (!cell)
        {
            cell = [[HYAfterSaleBriefCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:orderStatusCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*0.11);
        }
        
        cell.item = order;
        return cell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *amountCellId = @"info";
        HYAfterSaleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:amountCellId];
        if (!cell)
        {
            cell = [[HYAfterSaleInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:amountCellId];
        }
        cell.order = order;
        
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row == 0)
    {
        height = self.view.frame.size.width * 0.11;
    }
    else if (indexPath.row == 1)
    {
        height = self.view.frame.size.width * 0.35;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < self.orderList.count)
    {
        HYMallAfterSaleInfo *order = [self.orderList objectAtIndex:indexPath.section];
        HYAfterSaleDetailViewController *detail = [[HYAfterSaleDetailViewController alloc] init];
        detail.saleInfo = order;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //加载更多
    if (scrollView.contentSize.height >= scrollView.frame.size.height)
    {
        float scrollOffset = scrollView.contentOffset.y;
        float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (scrollOffset >= maximumOffset)
        {
            [self reloadMoreData];
        }
    }
}

- (void)listDidChanged:(NSNotification *)n
{
    [self reloadOrderData];
}

@end
