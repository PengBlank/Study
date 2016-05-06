//
//  HYFolwerOrderListViewController.m
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerOrderListViewController.h"
#import "HYFlowerOrderListRequest.h"
#import "HYFlowerOrderListResponse.h"
#import "HYFlowerOrderListCell.h"
#import "HYCustomerServiceCell.h"
#import "HYUserInfo.h"
#import "HYFlowerOrderSummary.h"
#import "HYNullView.h"
#import "HYLoadHubView.h"
#import "METoast.h"
#import "HYFlowerDelOrderRequest.h"
#import "HYTableViewFooterView.h"
/// 环信
#import "HYChatManager.h"

#import <TencentOpenAPI/QQApiInterface.h>

const NSInteger pageSize= 5;

@interface HYFlowerOrderListViewController ()
<
UIActionSheetDelegate,
HYCustomerServiceCellDelegate
>
{
    HYFlowerOrderListRequest *_getOrderListReq;
    HYFlowerDelOrderRequest *_delOrderRequest;
    
    HYCustomerServiceCell *_customerView;
    BOOL _isLoading;
    BOOL _hasMore;
}

@property (nonatomic, strong) HYUserInfo *userInfo;

@end

@implementation HYFlowerOrderListViewController

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _page = 1;
        _isLoading = NO;
        _hasMore = YES;
    }
    
    return self;
}

-(void)dealloc
{
    [_getOrderListReq cancel];
    _getOrderListReq = nil;
    
    [_delOrderRequest cancel];
    _delOrderRequest = nil;
    
    [HYLoadHubView dismiss];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"鲜花订单";
    self.view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                                green:237.0f/255.0f
                                                 blue:237.0f/255.0f
                                                alpha:1.0];
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HYFlowerOrderListCell"];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           self.view.frame.size.width,
                                                                           self.view.frame.size.height-108)
                                                          style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableview];
    
    HYTableViewFooterView *footer = [[HYTableViewFooterView alloc] initWithFrame:
                                     CGRectMake(0, 0, 320, 44)];
    [footer stopLoadMore];
    tableview.tableFooterView = footer;
    self.tableView = tableview;
    
    if (!_customerView)
    {
        _customerView =[[HYCustomerServiceCell alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
        _customerView.selectionStyle = UITableViewCellSelectionStyleNone;
        _customerView.delegate = self;
        [self.view addSubview:_customerView];
    }
    
    [self reloadOrderList];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _customerView.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
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

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",@"4008066528"];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
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

#pragma mark - Overloaded

- (void)callCustomnerService
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"特奢汇客服竭诚为您服务"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"拨打电话400-806-6528"
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)connectOnlineCustomnerService
{
//    QQApiWPAObject *wpaObj = [QQApiWPAObject objectWithUin:kCustomerQQForFlower];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:wpaObj];
//    [QQApiInterface sendReq:req];
    
    //检查登录
    [[HYChatManager sharedManager] chatLogin];
    
    //鲜花的客服不是针对某一个特定的订单，所以是直接找客服
    ChatViewController *vc = [[ChatViewController alloc] initWithChatter:kCustomerHXId
                                                                    type:eAfterSaleType];
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //    [self handleSendResult:sent];
}

- (IBAction)backToHomeViewController:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)reloadOrderList
{
    _page = 1;
    _recommendList = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self loadOrderLIst];
}

- (void)loadMoreData
{
    self.page++;
    [(HYTableViewFooterView*)self.tableView.tableFooterView startLoadMore];
    [self loadOrderLIst];
}

-(void)loadOrderLIst
{
    _getOrderListReq = [[HYFlowerOrderListRequest alloc] init];
    _getOrderListReq.userId = self.userInfo.userId;
    _getOrderListReq.pageNo = _page;
    _getOrderListReq.pageSize = pageSize;
    
    //如果为企业用户
    if (self.userInfo.userType == Enterprise_User)
    {
        _getOrderListReq.isEnterprise = 1;
    }
    
    [HYLoadHubView show];
    _isLoading = YES;
    __weak typeof(self) b_self = self;
    [_getOrderListReq sendReuqest:^(id result, NSError *error) {
        NSArray *orderList = nil;
        if (!error && [result isKindOfClass:[HYFlowerOrderListResponse class]])
        {
            HYFlowerOrderListResponse *response = (HYFlowerOrderListResponse *)result;
            orderList = response.orderList;
        }
         [b_self updateViewWithData:orderList error:error];
    }];
}

- (void)updateViewWithData:(NSArray *)array error:(NSError *)error
{
    [HYLoadHubView dismiss];
    _isLoading = NO;
    _hasMore = array.count > 0;
    [(HYTableViewFooterView*)self.tableView.tableFooterView stopLoadMore];
    
    if ([array count] > 0)
    {
        if (!_recommendList)
        {
            _recommendList = [[NSMutableArray alloc] init];
        }
        
        [_recommendList addObjectsFromArray:array];
        
        [self.tableView reloadData];
    }
    else if ([self.recommendList count] <= 0)
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
        
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        rect.size.height -= 45;
        HYNullView *v = [[HYNullView alloc] initWithFrame:rect];
        
        if (error)
        {
            v.descInfo = @"鲜花订单查询失败，请稍后再试";
        }
        else
        {
            v.descInfo = @"您暂无鲜花订单";
        }
        
        [self.view addSubview:v];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _recommendList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 10)];
    v.image = [[UIImage imageNamed:@"ticket_bg_gray_g5"] stretchableImageWithLeftCapWidth:2
                                                                             topCapHeight:4];
    
    return v;
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderListCell";
    HYFlowerOrderListCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[HYFlowerOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
        [cell setHiddenLine:YES];
        cell.pushViewController = self;
    }
    
    if (indexPath.section < [_recommendList count])
    {
        HYFlowerOrderSummary* cellInfo = (HYFlowerOrderSummary*)[_recommendList
                                                                 objectAtIndex:indexPath.section];
        [cell setOrderListInfo:cellInfo];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYFlowerOrderSummary* orderListInfo = [_recommendList objectAtIndex:indexPath.section];
    
    if (self.userInfo.userType == Enterprise_User)
    {
        if ([orderListInfo.status integerValue] == 1 && orderListInfo.orderType.intValue == 0)
        {
            return orderListInfo.contentHeight + 60;
        }
        else
        {
            return orderListInfo.contentHeight+20;
        }
    }
    else
    {
        if ([orderListInfo.status integerValue] == 1)
        {
            return orderListInfo.contentHeight+40;
        }
        else
        {
            return orderListInfo.contentHeight;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //加载更多
    if (scrollView.contentSize.height >= scrollView.frame.size.height)
    {
        float scrollOffset = scrollView.contentOffset.y;
        float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (scrollOffset >= maximumOffset && !_isLoading &&_hasMore)
        {
            [self loadMoreData];
        }
    }
}

#pragma mark - pulic methods
- (void)deleteOrderAndCell:(HYFlowerOrderListCell *)cell
{
    NSString *orderId = cell.orderListInfo.orderCode;
    if ([orderId length]>0)
    {
        [HYLoadHubView show];
        
        _delOrderRequest = [[HYFlowerDelOrderRequest alloc] init];
        _delOrderRequest.orderNo = orderId;
        _delOrderRequest.userId = self.userInfo.userId;
        
        __weak typeof(self) b_self = self;
        [_delOrderRequest sendReuqest:^(id result, NSError *error) {
            
            [HYLoadHubView dismiss];
            
            if (!error && [result isKindOfClass:[HYFlowerDelOrderResponse class]])
            {
                HYFlowerDelOrderResponse *response = (HYFlowerDelOrderResponse *)result;
                
                if (response.status == 200)
                {
                    NSInteger index = [[b_self.tableView indexPathForCell:cell] section];
                    
                    [b_self.recommendList removeObjectAtIndex:index];
                    
                    [b_self.tableView beginUpdates];
                    [b_self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index]
                                  withRowAnimation:UITableViewRowAnimationLeft];
                    [b_self.tableView endUpdates];
                }
            }
            else
            {
                [METoast toastWithMessage:error.domain
                                 duration:1.5
                         andCompleteBlock:nil];
            }
        }];
    }
    else
    {
        [METoast toastWithMessage:@"订单删除失败"];
    }
}

@end
