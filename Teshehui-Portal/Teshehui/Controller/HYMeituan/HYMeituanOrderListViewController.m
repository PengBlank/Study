//
//  HYMeituanOrderListViewController.m
//  Teshehui
//
//  Created by HYZB on 2014/12/16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//
#import <TencentOpenAPI/QQApiInterface.h>
#import "HYMeituanOrderListViewController.h"
#import "HYNavigationController.h"
#import "HYMeituanOrderListCell.h"
#import "HYCustomerServiceCell.h"
#import "HYLoadHubView.h"
#import "HYNullView.h"
#import "HYTableViewFooterView.h"
#import "HYGetGroupOrderListReq.h"
#import "HYUserInfo.h"
/// 环信∫
#import "HYChatManager.h"

@interface HYMeituanOrderListViewController ()
<
UIActionSheetDelegate,
HYCustomerServiceCellDelegate
>
{
    BOOL _isLoading;
    BOOL _loadFinish;
    NSInteger _pageNumber;
    
    HYGetGroupOrderListReq *_orderListReq;
    HYCustomerServiceCell *_customerView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderArray;

@end

@implementation HYMeituanOrderListViewController

- (void)dealloc
{
    [_orderListReq  cancel];
    _orderListReq = nil;
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
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
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
    
    [self.view addSubview:tableview];
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    tableview.tableFooterView = v;
    
    self.tableView = tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团购订单";
    // Do any additional setup after loading the view.
    [self relaodData];
    
    UIImage *back_s = [UIImage imageNamed:@"ico_phone_pressed"];
    UIImage *back_n = [UIImage imageNamed:@"ico_phone"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    
    [backButton setAdjustsImageWhenHighlighted:NO];
    [backButton setImage:back_n forState:UIControlStateNormal];
    [backButton setImage:back_s forState:UIControlStateHighlighted];
    [backButton addTarget:self
                   action:@selector(connectMeituan:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    if (!_customerView)
    {
        _customerView =[[HYCustomerServiceCell alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

#pragma mark private methods
- (void)connectOnlineCustomnerService
{
//    QQApiWPAObject *wpaObj = [QQApiWPAObject objectWithUin:kCustomerQQForGroup];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:wpaObj];
//    [QQApiInterface sendReq:req];
    
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //    [self handleSendResult:sent];
    
    //检查登录
    [[HYChatManager sharedManager] chatLogin];
    
    //团购的客服不是针对某一个特定的订单，所以是直接找客服
    ChatViewController *vc = [[ChatViewController alloc] initWithChatter:kCustomerHXId
                                                                    type:eAfterSaleType];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)connectMeituan:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"如有疑问请拨打美团客服电话"
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                          destructiveButtonTitle:@"拨打电话400-660-5335"
                                               otherButtonTitles:nil];
    action.tag = 10;
    [action showInView:self.view];
}

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

- (void)relaodData
{
    _pageNumber = 1;
    [self.orderArray removeAllObjects];
    [self.tableView reloadData];
    
    [self queryGroupOrder];
}

- (void)queryGroupOrder
{
    if (!_isLoading)
    {
        _isLoading = YES;
        
        [HYLoadHubView show];
        
        HYUserInfo *user = [HYUserInfo getUserInfo];
        
        _orderListReq = [[HYGetGroupOrderListReq alloc] init];
        _orderListReq.page = _pageNumber;
        _orderListReq.buyerId = user.userId;
        
        __weak typeof(self) b_self = self;
        [_orderListReq sendReuqest:^(id result, NSError *error) {
            NSArray *array = nil;
            if (!error && [result isKindOfClass:[HYGetGroupOrderListResq class]])
            {
                HYGetGroupOrderListResq *response = (HYGetGroupOrderListResq *)result;
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
        rect.size.height -= 45;
        HYNullView *v = [[HYNullView alloc] initWithFrame:rect];
        
        if (error)
        {
            v.descInfo = @"团购订单查询失败，请稍后再试";
        }
        else
        {
            v.descInfo = @"您暂无团购订单";
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
            [self queryGroupOrder];
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        NSString *phone = [NSString stringWithFormat:@"telprompt://4006605335"];
        NSURL *url = [NSURL URLWithString:phone];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.orderArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *groupOrderListCellId = @"groupOrderListCellId";
    HYMeituanOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:groupOrderListCellId];
    if (!cell)
    {
        cell = [[HYMeituanOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:groupOrderListCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section < [self.orderArray count])
    {
        HYGroupOrderInfo *order = [self.orderArray  objectAtIndex:indexPath.section];
        [cell setOrderInfo:order];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    //    if(indexPath.row == totalRow -1)
    //    {
    //        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
    //        lineCell.separatorLeftInset = 0.0f;
    //    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 187;
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
