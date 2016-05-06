//
//  HYCIOrderListViewController.m
//  Teshehui
//
//  Created by HYZB on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIOrderListViewController.h"
#import "HYHYMallOrderListFilterView.h"
#import "HYLoadHubView.h"
#import "HYTableViewFooterView.h"
#import "HYNullView.h"
#import "HYCIOrderListCell.h"
#import "HYCIGetOrderListReq.h"
#import "HYCIOrderDetailViewController.h"
#import "HYCustomerServiceCell.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "HYCIConfirmPaymentViewController.h"

/// 环信
#import "HYChatManager.h"

@interface HYCIOrderListViewController ()
<
HYCustomerServiceCellDelegate,
HYCIOrderListCellDelegate,
UIActionSheetDelegate
>
{
    HYHYMallOrderListFilterView *_filterView;
    HYCustomerServiceCell *_customerView;
}

@property (nonatomic, strong) HYCIGetOrderListReq *orderListRequest;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, assign) NSInteger filterType;
@property (nonatomic, strong) HYNullView *nullView;

@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation HYCIOrderListViewController

- (void)dealloc
{
    [_orderListRequest cancel];
    [HYLoadHubView dismiss];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.pageNumber = 1;
        self.hasMore = YES;
        self.isLoading = NO;
        self.filterType = 0;
    }
    return self;
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
    
    _filterType = 10;
    _filterView = [[HYHYMallOrderListFilterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
    _filterView.conditions = @[@"待付款", @"已付款"];
    _filterView.userInteractionEnabled = YES;
    [_filterView addTarget:self
                    action:@selector(filterOrder:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_filterView];
    
    //tableview
    frame.origin.y += 44;
    frame.size.height -= 44;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    frame.origin = CGPointMake(0, 44);
    _nullView = [[HYNullView alloc] initWithFrame:frame];
    [self.view addSubview:_nullView];
    _nullView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车险订单";
    
    if (!self.orderList)
    {
        [self reloadOrderData];
    }
    
    if (!_customerView)
    {
        _customerView =[[HYCustomerServiceCell alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
        _customerView.hiddenLine = NO;
        _customerView.selectionStyle = UITableViewCellSelectionStyleNone;
        _customerView.delegate = self;
        [self.view addSubview:_customerView];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _customerView.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HYCustomerServiceCellDelegate
- (void)didConnectCustomerServiceWithTpye:(CustomerServiceType)type
{
    if (type == OnlineService)
    {
        [self connectOnlineCustomnerService];
    }
    else
    {
        [self callCustomnerService];
    }
}

#pragma mark - HYCIOrderListCellDelegate
- (void)didPaymentCIOrder:(HYCIOrderDetail *)order
{
    HYCIConfirmPaymentViewController *confirm = [[HYCIConfirmPaymentViewController alloc] init];
    confirm.order = order;
    confirm.sessionid = order.sessionId;
    confirm.pageFrom = 1;
    [self.navigationController pushViewController:confirm animated:YES];
}

#pragma mark private methods
- (void)connectOnlineCustomnerService
{
    //检查登录
    [[HYChatManager sharedManager] chatLogin];
    
    //车险的客服不是针对某一个特定的订单，所以是直接找客服
    ChatViewController *vc = [[ChatViewController alloc] initWithChatter:kCustomerHXId
                                                                    type:eAfterSaleType];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

//- (void)connectMeituan:(id)sender
//{
//    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"如有疑问请拨打美团客服电话"
//                                                        delegate:self
//                                               cancelButtonTitle:NSLocalizedString(@"cancel", nil)
//                                          destructiveButtonTitle:@"拨打电话400-660-5335"
//                                               otherButtonTitles:nil];
//    action.tag = 10;
//    [action showInView:self.view];
//}

- (void)callCustomnerService
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"特奢汇客服竭诚为您服务"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"拨打电话400-806-6528"
                                  otherButtonTitles:nil];
    actionSheet.tag = 11;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        NSString *phone = [NSString stringWithFormat:@"telprompt://4008066528"];
        NSURL *url = [NSURL URLWithString:phone];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - private methods
- (void)filterOrder:(id)sender
{
    if ([sender isKindOfClass:[HYHYMallOrderListFilterView class]])
    {
        HYHYMallOrderListFilterView *fill = (HYHYMallOrderListFilterView*)sender;
        if (fill.currentIndex == 0)
        {
            _filterType = 10;
        }
        else if (fill.currentIndex == 1)
        {
            _filterType = 30;
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
        
        
        _orderListRequest = [[HYCIGetOrderListReq alloc] init];
        _orderListRequest.pageNo = _pageNumber;
        _orderListRequest.orderType = _filterType;
        
        __weak typeof(self) b_self = self;
        [_orderListRequest sendReuqest:^(id result, NSError *error)
         {
             NSArray *orderList = nil;
             if (!error && [result isKindOfClass:[HYCIGetOrderListResp class]])
             {
                 HYCIGetOrderListResp *reposne = (HYCIGetOrderListResp *)result;
                 orderList = reposne.orderList;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.orderList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CIOrderListCellId = @"CIOrderListCellId";
    HYCIOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:CIOrderListCellId];
    if (!cell)
    {
        cell = [[HYCIOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CIOrderListCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    if (self.orderList.count > indexPath.row)
    {
        HYCIOrderDetail *order = [self.orderList objectAtIndex:indexPath.section];
        cell.order = order;
    }
    return cell;
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
    return 172.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.orderList.count > indexPath.row)
    {
        HYCIOrderDetail *order = [self.orderList objectAtIndex:indexPath.row];
        HYCIOrderDetailViewController *vc =[[HYCIOrderDetailViewController alloc] init];
        vc.order = order;
        [self.navigationController pushViewController:vc animated:YES];
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

@end
