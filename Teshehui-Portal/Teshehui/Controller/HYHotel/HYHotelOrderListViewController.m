//
//  CQHotelOrderViewController.m
//  Teshehui
//
//  Created by ChengQian on 13-11-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYHotelOrderListViewController.h"
#import "HYHotelOrderCell.h"
#import "HYHotelOrderListRequest.h"
#import "HYUserInfo.h"
#import "HYHotelOrderDetailViewController.h"
#import "HYLoadHubView.h"
#import "HYNullView.h"
#import "HYTableViewFooterView.h"
#import "HYHotelOrderDetail.h"

@interface HYHotelOrderListViewController ()
{
    HYHotelOrderListRequest *_orderRequest;
    
    BOOL _isLoading;
    BOOL _loadFinish;
    NSInteger _pageNumber;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, strong) HYUserInfo *userInfo;

- (void)updateTableviewWithHotelOrders:(NSArray *)orderList error:(NSError *)error;
@end

@implementation HYHotelOrderListViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    [_orderRequest cancel];
    _orderRequest = nil;
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
    view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                           green:237.0f/255.0f
                                            blue:237.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    //line
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
    tableview.tableHeaderView = lineView;
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"酒店订单";
    
    //加载数据
    [self relaodData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Overloaded
- (IBAction)backToHomeViewController:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
#pragma mark private methods
- (void)relaodData
{
    _pageNumber = 1;
    [self.orderArray removeAllObjects];
    [self.tableView reloadData];
    
    [self loadHotelOrder];
}

- (void)loadHotelOrder
{
    if (!_isLoading)
    {
        _isLoading = YES;
        
        [HYLoadHubView show];
        
        _orderRequest = [[HYHotelOrderListRequest alloc] init];
        HYUserInfo *user = [HYUserInfo getUserInfo];
        _orderRequest.userId = user.userId;
        _orderRequest.pageNo = [NSString stringWithFormat:@"%ld",_pageNumber];
        
        //如果为企业用户
        if (self.userInfo.userType == Enterprise_User)
        {
            _orderRequest.isEnterprise = @"1";
        }
        
        __weak typeof(self) b_self = self;
        [_orderRequest sendReuqest:^(id result, NSError *error) {
            NSArray *array = nil;
            if (!error && [result isKindOfClass:[HYHotelOrderListResponse class]])
            {
                HYHotelOrderListResponse *response = (HYHotelOrderListResponse *)result;
                array = response.orderList;
            }
            
            [b_self updateTableviewWithHotelOrders:array error:error];
        }];
    }
}

- (void)updateTableviewWithHotelOrders:(NSArray *)orderList error:(NSError *)error
{
    _isLoading = NO;
    _loadFinish = ([orderList count] <= 0);
    [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    
    [HYLoadHubView dismiss];
    
    if ([orderList count] > 0)
    {
        if (!_orderArray)
        {
            _orderArray = [[NSMutableArray alloc] init];
        }
        
        [_orderArray addObjectsFromArray:orderList];
        
        [self.tableView reloadData];
    }
    else if ([self.orderArray count] <= 0)
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
        
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        HYNullView *v = [[HYNullView alloc] initWithFrame:rect];
        
        if (error)
        {
            v.descInfo = @"酒店订单查询失败，请稍后再试";
        }
        else
        {
            v.descInfo = @"您暂无酒店订单";
        }
        
        [self.view addSubview:v];
    }
}

- (void)reloadMoreData
{
    if (!_isLoading && !_loadFinish)
    {
        [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
        
        if ([self.orderArray count])
        {
            _pageNumber++;
            [self loadHotelOrder];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderArray count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    v.image = [[UIImage imageNamed:@"ticket_bg_gray_g5"] stretchableImageWithLeftCapWidth:2
                                                                             topCapHeight:4];
    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.userInfo.userType == Enterprise_User)
    {
        return 134;
    }
    else
    {
        return 120;
    }
}

//footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 10.0f;
    if (section == 0)
    {
        height = 0;
    }
    return height;
}

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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifer = @"HotelOrderCellId";
    
    HYHotelOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (cell == nil)
    {
        cell = [[HYHotelOrderCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifer];
    }
    
    if (indexPath.row < [self.orderArray count])
    {
        HYHotelOrderDetail *order = [self.orderArray objectAtIndex:indexPath.row];
        [cell setOrder:order];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [self.orderArray count])
    {
        HYHotelOrderBase *order = [self.orderArray objectAtIndex:indexPath.row];
        HYHotelOrderDetailViewController *vc = [[HYHotelOrderDetailViewController alloc] init];
        vc.hotelOrder = (HYHotelOrderDetail*)order;
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
