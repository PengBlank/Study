//
//  HYFlightOrderListViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-3.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightOrderListViewController.h"
#import "HYFlightOrderListRequest.h"
#import "HYUserInfo.h"
#import "HYFlightOrderListCell.h"
#import "HYFlightOrderDetailViewController.h"
#import "HYLoadHubView.h"
#import "HYNullView.h"
#import "HYTableViewFooterView.h"
#import "HYFlightSummaryView.h"

@interface HYFlightOrderListViewController ()
{
    HYFlightOrderListRequest *_requset;
    BOOL _isLoading;
    BOOL _loadFinish;
    NSInteger _pageNumber;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, strong) HYUserInfo *userInfo;

- (void)updateTableViewWithOrders:(NSArray *)orders
                            error:(NSError *)error;

@end

@implementation HYFlightOrderListViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_requset cancel];
    _requset = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _pageNumber = 1;
        _loadFinish = NO;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionFooterHeight = 10;
    tableview.sectionHeaderHeight = 0;
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"机票订单";

    //获取机票订单
    [self relaodData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (!self.view.window)
    {
        self.view = nil;
    }
}

#pragma mark setter/getter
- (HYUserInfo *)userInfo
{
    if (!_userInfo)
    {
        _userInfo = [HYUserInfo getUserInfo];
    }
    
    return _userInfo;
}

#pragma mark - Overloaded
- (IBAction)backToHomeViewController:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - pulice methods

//删除订单，以orderid确定是否是同一个order
- (void)deleteOrder:(HYFlightOrder *)order
{
    for (HYFlightOrder *o in self.orderList)
    {
        if ([o.orderId isEqualToString:order.orderId])
        {
            [self.orderList removeObject:o];
            break;
        }
    }
    
    [self.tableView reloadData];
}

//取消订单
- (void)cancelOrder:(HYFlightOrder *)order
{
    for (HYFlightOrder *o in self.orderList)
    {
        if ([o.orderId isEqualToString:order.orderId])
        {
            o.status = order.status;
            o.orderShowStatus = [order statusDesc];
            break;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark private methods
- (void)relaodData
{
    _pageNumber = 1;
    [self.orderList removeAllObjects];
    [self.tableView reloadData];
    
    [self loadOrderList];
}

- (void)loadOrderList
{
    if (!_isLoading)
    {
        _isLoading = YES;
        [HYLoadHubView show];
        
        _requset = [[HYFlightOrderListRequest alloc] init];
        _requset.user_id = [self.userInfo userId];
        _requset.page = _pageNumber;
        
        //如果为企业用户
        if (self.userInfo.userType == Enterprise_User)
        {
            _requset.is_enterprise = 1;
        }
        
        __weak typeof(self) b_self = self;
        [_requset sendReuqest:^(id result, NSError *error) {
            NSArray *array = nil;
            if (!error && [result isKindOfClass:[HYFlightOrderListResponse class]])
            {
                HYFlightOrderListResponse *respnse = (HYFlightOrderListResponse *)result;
                array = respnse.orderList;
            }
            [b_self updateTableViewWithOrders:array error:error];
        }];
    }
}

- (void)updateTableViewWithOrders:(NSArray *)orders error:(NSError *)error
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    
    if (!error)
    {
        if (!self.orderList)
        {
            self.orderList = [[NSMutableArray alloc] init];
        }
        if ([orders count] > 0)
        {
            [self.orderList addObjectsFromArray:orders];
            [self.tableView reloadData];
        }
        else
        {
            _loadFinish = YES;
            [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
        }
    }
    
    if ([self.orderList count] <= 0)
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
        
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        HYNullView *v = [[HYNullView alloc] initWithFrame:rect];
        
        if (error)
        {
            v.descInfo = @"机票订单查询失败，请稍后再试";
        }
        else
        {
            v.descInfo = @"您暂无机票订单";
        }
        
        [self.view addSubview:v];
    }
}

- (void)reloadMoreData
{
    if (!_isLoading && !_loadFinish)
    {
        [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
        
        if ([self.orderList count])
        {
            _pageNumber++;
            [self loadOrderList];
        }
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.userInfo.userType == Enterprise_User)
    {
        return 102;
    }
    else
    {
        return 88;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *passengerCellId = @"passengerCellId";
    HYFlightOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:passengerCellId];
    if (cell == nil)
    {
        cell = [[HYFlightOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:passengerCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row < [self.orderList count])
    {
        HYFlightOrder *order = [self.orderList objectAtIndex:indexPath.row];
        [cell setFlightOrder:order];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [self.orderList count])
    {
        HYFlightOrder *order = [self.orderList objectAtIndex:indexPath.row];
        HYFlightOrderDetailViewController *vc = [[HYFlightOrderDetailViewController alloc] init];
        vc.flightOrder = order;
        vc.orderListVC = self;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float scrollOffset = scrollView.contentOffset.y;
    float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (scrollOffset >= maximumOffset)
    {
        [self reloadMoreData];
    }
}
@end
