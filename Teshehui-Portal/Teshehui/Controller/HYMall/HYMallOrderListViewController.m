//
//  HYMallOrderListViewController.m
//  Teshehui
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderListViewController.h"
#import "HYHYMallOrderListFilterView.h"
#import "HYMallOrderDetailViewController.h"

#import "HYUserInfo.h"

#import "HYLoadHubView.h"
#import "HYTableViewFooterView.h"
#import "HYNullView.h"

#import "HYMallOrderHandleCell.h"
#import "HYMallOrderListStatusCell.h"
#import "HYMallOrderListGoodsCell.h"
#import "HYMallOrderListPriceCell.h"

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

#import "HYOrderReturnDetailRequest.h"
#import "HYMallRemindDeliverRequest.h"

#import "METoast.h"

#import "HYExpensiveAlertViewController.h"
#import "HYMallOrderGoodsInfo.h"

#import "HYMallChildOrder.h"
#import "HYMallNullView.h"
#import "HYMineInfoViewController.h"

//MJRefresh
#import "MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import "UIAlertView+BlocksKit.h"

#define CancelAlertViewTag  10
#define DeleteAlertViewTag  11



@interface HYMallOrderListViewController ()
<
HYMallOrderHandleCellDelegate,
HYMallOrderListGoodsCellDelegate,
UIAlertViewDelegate,
HYMallOrderListHandleDelegate,
HYMallNullViewDelegate,
UINavigationControllerDelegate
>
{
    HYMallOrderListRequest *_orderListReq;
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
@property (nonatomic, strong) NSMutableArray *isShowChildOrderStatusOfAllSections;
@property (nonatomic, assign) NSInteger filterType;
@property (nonatomic, strong) HYMallNullView *nullView;
@property (nonatomic, strong) HYMallOrderSummary *handleOrder;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation HYMallOrderListViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_orderListReq cancel];
    _orderListReq = nil;
    
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
    DebugNSLog(@"orderlist released");
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
        _isShowReturnOrder = NO;
        self.title = @"商城订单";
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
    
    _filterView = [[HYHYMallOrderListFilterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 34)];
    _filterView.conditions = @[@"全部", @"待付款", @"待发货", @"待收货"];
    _filterView.userInteractionEnabled = YES;
    [_filterView addTarget:self
                    action:@selector(filterOrder:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_filterView];
    
    //tableview
    frame.origin.y += 34;
    frame.size.height -= 34;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    tableview.header = [MJRefreshNormalHeader
                        headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /// 根据外部设定的显示订单类型设定
    if (self.showOrderType > 0)
    {
        switch (self.showOrderType)
        {
            case 1:
            {
                [MobClick event:kMineOrderWaitToPay];
                break;
            }
            case 2:
            {
                [MobClick event:kMineOrderWaitToSendGood];
                break;
            }
            case 3:
            {
                [MobClick event:kMineOrderWaitToReceiveGood];
                break;
            }
            default:
                break;
        }
        self.filterType = self.showOrderType;
        _filterView.currentIndex = self.showOrderType;
    }
    
    [self reloadOrderData];
}

#pragma mark 下拉刷新数据
- (void)loadNewData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadOrderData];
        [self.tableView.header endRefreshing];
    });
}

#pragma mark - Overloaded
- (void)updateWithOrder:(HYMallOrderSummary *)order type:(MallOrderHandleType)type
{
    NSInteger index = 0;
    for (HYMallOrderSummary *item in self.orderList)
    {
        if ([item.orderId isEqualToString:order.orderId])
        {
            break;
        }
        
        index++;
    }
    
    switch (type)
    {
        case Cancel_Order:  //取消
            if (index < [self.orderList count])
            {
                HYMallOrderSummary *item = [self.orderList objectAtIndex:index];
                item.status = 0;
                [self.tableView reloadData];
            }
            break;
        case Delete_Order:  //删除
        {
            if (index < [self.orderList count])
            {
                [self.orderList removeObjectAtIndex:index];
                [self.tableView reloadData];
            }
        }
            break;
        case RecvConfig_Order:  //确认收货
            if (index < [self.orderList count])
            {
                HYMallOrderSummary *order = [self.orderList objectAtIndex:index];
                order.status = 40;
//                order.evaluable = HYCanEvaluation;
                for (HYMallOrderItem *item in order.orderItem)
                {
                    item.isEvaluable = HYCanEvaluation;
                }
                [self.tableView reloadData];
            }
            break;
        default:
            [self.tableView reloadData];
            break;
    }
}

#pragma mark setter/getter
- (HYMallNullView *)nullView
{
    if (!_nullView)
    {
        CGRect frame = self.view.frame;
        frame.origin = CGPointMake(0, 34);
        
        _nullView = [[HYMallNullView alloc] initWithFrame:frame];
        _nullView.delegate = self;
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
        
        //这里其实已经被干掉，但是先保留下来
        _isShowReturnOrder = (filter.currentIndex==5);
        
        switch (filter.currentIndex)
        {
            case 0: //所有
                self.filterType = 0;
                break;
            case 1: //待付款
                self.filterType = 1;
                break;
            case 2: //待发货
                self.filterType = 2;
                break;
            case 3: //已发货
                self.filterType = 3;
                break;
            case 4: //待评价
                self.filterType = 4;
                break;
            case 5: //退换货
                self.filterType = 5;
                break;
            default:
                break;
        }
        
        [self reloadOrderData];
    }
}

- (void)reloadOrderData
{
    _pageNumber = 1;
    _hasMore = YES;
    [_orderList removeAllObjects];
    [_isShowChildOrderStatusOfAllSections removeAllObjects];
    
    [self loadOrderData];
}

- (void)loadOrderData
{
    if (!_isLoading)
    {
        _isLoading = YES;
        
        [HYLoadHubView show];
        
        if (_isShowReturnOrder)
        {
            _returnReq = [[HYMallOrderReturnListRequest alloc] init];
            _returnReq.page = _pageNumber;
            _returnReq.num_per_page = _pageSize;
            
            __weak typeof(self) b_self = self;
            [_returnReq sendReuqest:^(id result, NSError *error) {
                NSArray *orderList = nil;
                if (!error && [result isKindOfClass:[HYMallOrderReturnListResponse class]])
                {
                    HYMallOrderReturnListResponse *reposne = (HYMallOrderReturnListResponse *)result;
                    orderList = reposne.returnList;
                }
                [b_self updateViewWithData:orderList error:error];
            }];
        }
        else
        {
            if (!_orderListReq)
            {
               _orderListReq = [[HYMallOrderListRequest alloc] init];
            }
            [_orderListReq cancel];
            _orderListReq.userId = [[HYUserInfo getUserInfo] userId];
            _orderListReq.pageNo = _pageNumber;
            _orderListReq.pageSize = _pageSize;
            _orderListReq.type = self.filterType;
            
            __weak typeof(self) b_self = self;
            [_orderListReq sendReuqest:^(id result, NSError *error) {
                
                NSArray *orderList = nil;
                if (result && [result isKindOfClass:[HYMallOrderListResponse class]])
                {
                    HYMallOrderListResponse *response = (HYMallOrderListResponse *)result;
                    orderList = response.ordersArray;
                }
                
                [b_self updateViewWithData:orderList error:error];
            }];
        }
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
        
        if (!_isShowChildOrderStatusOfAllSections)
        {
            _isShowChildOrderStatusOfAllSections = [NSMutableArray arrayWithCapacity:_orderList.count];
        }
        //根据每次刷新的订单数记录状态
        for (int i = 0; i < array.count; i++)
        {
            NSNumber *markNumber = @(-1);
            [_isShowChildOrderStatusOfAllSections addObject:markNumber];
        }
        
        [self.tableView reloadData];
    }
    else if ([self.orderList count] <= 0)
    {
        _hasMore = YES;
        _pageNumber = 1;
        
        [self.tableView setHidden:YES];
        [self.nullView setHidden:NO];
        self.nullView.filterype = _filterType;
        
        if ([error.domain isEqualToString:@"网络请求出现异常"])
        {
            [self.nullView setNeedTouch:YES];
            self.nullView.descInfo = @"由于网络原因加载失败，请点击重新加载";
        }
        else
        {
            [self.nullView setNeedTouch:(0==_filterType)];
            
            NSString *str = error.domain;
            if ([str length] <= 0)
            {
                str = (0==_filterType) ? @"暂无任何订单信息" : @"暂无此类订单信息";
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

- (void)paymentWithOrder:(HYMallOrderSummary *)order
{
    //去付款
    [MobClick event:@"v430_shangcheng_shangchengdingdanliebiao_qufukuananniu_jishu"];
    
    if (order)
    {
        /*
         * 支付宝说明: 13-8-22;
         * 在多订单付款的时候，支付宝订单号使用订单的order_id，单订单的时候使用order_sn
         * 传递到支付界面的id必须都是订单id
         * 支付宝得回调都是订单id
         */
        HYAlipayOrder *alOrder = [[HYAlipayOrder alloc] init];
        alOrder.partner = PartnerID;
        alOrder.seller = SellerID;
        alOrder.tradeNO = order.orderCode; //订单号 (显示订单号)
        alOrder.productName = [NSString stringWithFormat:@"【特奢汇商城】商城订单: %@", order.orderCode]; //商品标题 (显示订单号)
        alOrder.productDescription = [NSString stringWithFormat:@"【特奢汇商城】商城订单: %@", order.orderCode]; //商品描述
        alOrder.amount = [NSString stringWithFormat:@"%0.2f",order.orderPayAmount.floatValue]; //待支付金额
        
        HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
        payVC.navbarTheme = self.navbarTheme;
        payVC.alipayOrder = alOrder;
        payVC.amountMoney = order.orderActualAmount;  //总价
        payVC.payMoney = order.orderPayAmount;  //待支付金额
        payVC.point = order.orderTbAmount.floatValue;
        payVC.orderID = order.orderId;
        payVC.orderCode = order.orderCode;
        payVC.type = Pay_Mall;
        payVC.adressInfo = order.address;
        
        __weak typeof(self) bself = self;
        payVC.payCallback = ^(BOOL succ, NSError *error){
            //刷新订单列表
            [bself reloadOrderData];
        };
        
        [self.navigationController pushViewController:payVC animated:YES];
    }
}

- (void)cancelWithOrder
{
//    HYExpensiveAlertViewController *expensive = [[HYExpensiveAlertViewController alloc] initWithNibName:@"HYExpensiveAlertViewController" bundle:nil];
//    expensive.order_id = self.handleOrder.order_id;
//    expensive.goods_id = [[self.handleOrder.goods objectAtIndex:0] goods_id];
//    [self.navigationController pushViewController:expensive
//                                         animated:YES];
//    return;
    
//    HYCommentAddViewController *comment = [[HYCommentAddViewController alloc] init];
//    comment.orderInfo = self.handleOrder;
//    __weak HYMallOrderListViewController *b_self = self;
//    comment.addCommentCallback = ^(BOOL success)
//    {
//        b_self.pageNumber = 1;
//        b_self.hasMore = YES;
//        [b_self.orderList removeAllObjects];
//        [b_self reloadOrderData];
//    };
//    [self.navigationController pushViewController:comment animated:YES];
//    return;
    
    // 删除订单
    [MobClick event:@"v430_shangcheng_shangchengdingdanliebiao_shanchudingdananniu_jishu"];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"您确定要取消该订单吗?"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定",nil];
    alert.tag = CancelAlertViewTag;
    [alert show];
}

- (void)deleteOrder
{
    // 取消订单
    [MobClick event:@"v430_shangcheng_shangchengdingdanliebiao_quxiaodingdananniu_jishu"];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"您确定要删除该订单吗?"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"删除",nil];
    alert.tag = DeleteAlertViewTag;
    [alert show];
}

//进入评价订单界面
- (void)commentOrder:(HYMallOrderSummary *)order
{
    HYCommentAddViewController *comment = [[HYCommentAddViewController alloc] init];
    comment.orderInfo = order;
    __weak HYMallOrderListViewController *b_self = self;
    comment.addCommentCallback = ^(BOOL success)
    {
        //这里直接刷新，最好是本地更改
        [b_self reloadOrderData];
    };
    
    [self.navigationController pushViewController:comment animated:YES];
}

//确认收货
- (void)confirmReceipt
{
    // 确认收货
    [MobClick event:@"v430_shangcheng_shangchengdingdanliebiao_querenshouhuoanniu_jishu"];
    
    if (!_isLoading)
    {
        [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                       message:@"确定已收到商品了吗?"
                             cancelButtonTitle:@"取消"
                             otherButtonTitles:@[@"确定"]
                                       handler:^(UIAlertView *alertView, NSInteger buttonIndex)
        {
            if (buttonIndex == 1) {
                _isLoading = YES;
                [HYLoadHubView show];
                
                _confirmReq = [[HYConfirmRequest alloc] init];
                _confirmReq.order_id = self.handleOrder.orderId;
                _confirmReq.order_code = self.handleOrder.orderCode;
                
                __weak typeof(self) b_self = self;
                [_confirmReq sendReuqest:^(id result, NSError *error) {
                    
                    if (result && [result isKindOfClass:[HYConfirmResponse class]])
                    {
                        HYConfirmResponse *response = (HYConfirmResponse *)result;
                        [b_self confirmFinished:response.status error:error];
                    }
                }];
            }
        }];
    }
}

- (void)confirmFinished:(NSInteger)status error:(NSError *)error
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    
    if (status == 200)
    {
        self.handleOrder.status = 50;
      
        [self reloadOrderData];
    }
    else if(error)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:error.domain
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [METoast toastWithMessage:@"网络出现问题,请稍后再试"];
    }
}

//物流跟踪
- (void)getLogisticsTrack
{
    HYMallLogisticsTrackViewController *vc = [[HYMallLogisticsTrackViewController alloc] init];
    vc.orderCode = self.handleOrder.orderCode;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

//提醒发货
- (void)remindStoreSend
{
    if (!_isLoading)
    {
        _isLoading = YES;
        [HYLoadHubView show];
        
        _remindReq = [[HYMallRemindDeliverRequest alloc] init];
        _remindReq.order_id = self.handleOrder.orderId;
        _remindReq.order_code = self.handleOrder.orderCode;
        
        __weak typeof(self) b_self = self;
        [_remindReq sendReuqest:^(id result, NSError *error) {
            [HYLoadHubView dismiss];
            b_self.isLoading = NO;
            
            if (!error && [result isKindOfClass:[HYMallRemindDeliverResponse class]])
            {
                HYMallRemindDeliverResponse *response = (HYMallRemindDeliverResponse *)result;
                if (response.status == 200)
                {
                    [METoast toastWithMessage:@"已经发送给卖家提醒发货"];
                }
                else
                {
                    [METoast toastWithMessage:@"提醒卖家发货失败"];
                }
            }
            else
            {
                [METoast toastWithMessage:error.domain];
            }
        }];
    }
}

//检查详情
- (void)checkOrderDetail
{
    if ([self.handleOrder isKindOfClass:[HYMallReturnsInfo class]])
    {
        HYMallReturnsInfo *returnInfo = (HYMallReturnsInfo *)self.handleOrder;
        HYGoodsRetStatViewController *vc = [HYGoodsRetStatViewController statViewControllerWithRetusnInfo:returnInfo];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        HYMallOrderDetail *orderDetail = (HYMallOrderDetail *)self.handleOrder;
        HYMallOrderDetailViewController *vc = [[HYMallOrderDetailViewController alloc] init];
        vc.orderInfo = orderDetail;
        vc.orderListView = self;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

//取消结果
- (void)cancelResult:(BOOL)result error:(NSError *)error
{
    [HYLoadHubView dismiss];
    _isLoading = NO;
    
    if (error)
    {
        [METoast toastWithMessage:error.domain
                 andCompleteBlock:nil];
    }
    else if (result)
    {
        self.handleOrder.status = -20;
        [self reloadOrderData];
    }
    else
    {
        [METoast toastWithMessage:@"取消订单失败"
                 andCompleteBlock:nil];
    }
}

//删除结果
- (void)deleteResult:(BOOL)result error:(NSError *)error
{
    [HYLoadHubView dismiss];
    _isLoading = NO;
    
    if (error)
    {
        [METoast toastWithMessage:error.domain
                         duration:1.5
                 andCompleteBlock:nil];
    }
    else if (result)
    {
        NSInteger index = 0;
        for (HYMallOrderSummary *order in self.orderList)
        {
            if ([order.orderId isEqualToString:self.handleOrder.orderId])
            {
                break;
            }
            
            index++;
        }
        
        if (index < [self.orderList count])
        {
            [self.orderList removeObjectAtIndex:index];
            [_isShowChildOrderStatusOfAllSections removeObjectAtIndex:index];
            
            [self.tableView beginUpdates];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index]
                          withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
        }
    }
    else
    {
        [METoast toastWithMessage:@"删除订单失败"
                 andCompleteBlock:nil];
    }
    
}

#pragma mark HYMallNullView delegate
- (void)goBackToMallHomeFromButton:(UIButton *)sender
{
    HYMineInfoViewController *vc = (HYMineInfoViewController*)self.navigationController.viewControllers[0];
    [vc.baseViewController setCurrentSelectIndex:0];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if (alertView.tag == CancelAlertViewTag)
        {
            if (!_isLoading)
            {
                _isLoading = YES;
                
                _cancelReq = [[HYMallCancelOrderRequest alloc] init];
                _cancelReq.order_code = self.handleOrder.orderCode;
                
                __weak typeof(self) b_self = self;
                [_cancelReq sendReuqest:^(id result, NSError *error) {
                    
                    BOOL succ = NO;
                    if (!error && [result isKindOfClass:[HYMallCancelOrderReponse class]])
                    {
                        HYMallCancelOrderReponse *response = (HYMallCancelOrderReponse *)result;
                        succ = (response.status == 200);
                    }
                    [b_self cancelResult:succ error:error];
                }];
            }
        }
        else if (alertView.tag == DeleteAlertViewTag)
        {
            if (!_isLoading)
            {
                _isLoading = YES;
                
                _deleteReq = [[HYMallDelOrderRequest alloc] init];
                _deleteReq.order_code = self.handleOrder.orderCode;
                
                __weak typeof(self) b_self = self;
                [_deleteReq sendReuqest:^(id result, NSError *error) {
                    
                    BOOL succ = NO;
                    
                    if (!error && [result isKindOfClass:[HYMallDelOrderResponse class]])
                    {
                        HYMallDelOrderResponse *response = (HYMallDelOrderResponse *)result;
                        succ = response.status == 200;
                    }
                    
                    [b_self deleteResult:succ error:error];
                }];
            }
        }
    }
}

#pragma mark - HYMallOrderListGoodsCellDelegate
- (void)didRequestReturnGoods:(HYMallOrderItem *)goods inOrder:(HYMallOrderSummary *)order
{
    if (goods.returnable == 1)
    {
        HYGoodsReturnViewViewController *goodsReturn = [[HYGoodsReturnViewViewController alloc] init];
        goodsReturn.orderItem = goods;
        __weak HYMallOrderListViewController *b_self = self;
        goodsReturn.returnCallback = ^(BOOL success)
        {
            b_self.pageNumber = 1;
            b_self.hasMore = YES;
            [b_self.orderList removeAllObjects];
            [b_self reloadOrderData];
        };
        [self.navigationController pushViewController:goodsReturn animated:YES];
    }
    else  //退换货详情
    {
        if ([order isKindOfClass:[HYMallOrderDetail class]])
        {
            if (goods.returnId && !self.isLoading)
            {
                [HYLoadHubView show];
                self.isLoading = YES;
                
                _retDetailReq = [[HYOrderReturnDetailRequest alloc] init];
                _retDetailReq.return_id = goods.returnId;
                __weak HYMallOrderListViewController *b_self = self;
                [_retDetailReq sendReuqest:^(id result, NSError *error)
                 {
                     [HYLoadHubView dismiss];
                     b_self.isLoading = NO;
                     
                     HYOrderReturnDetailResponse *rs = (HYOrderReturnDetailResponse *)result;
                     if (!error && [rs isKindOfClass:[HYOrderReturnDetailResponse class]])
                     {
                         HYGoodsRetStatViewController *vc = [HYGoodsRetStatViewController statViewControllerWithRetusnInfo:rs.retInfo];
                         if (vc)
                         {
                             [b_self.navigationController pushViewController:vc animated:YES];
                         }
                         else
                         {
                             [METoast toastWithMessage:[NSString stringWithFormat:@"未知的订单状态%d", rs.retInfo.refund_status]];
                         }
                         
                     }
                     else
                     {
                         [METoast toastWithMessage:@"获取售后信息失败"];
                     }
                 }];
            }
        }
        else
        {
            HYMallReturnsInfo *returnInfo = (HYMallReturnsInfo *)order;
            HYGoodsRetStatViewController *vc = [HYGoodsRetStatViewController statViewControllerWithRetusnInfo:returnInfo];
            __weak typeof(self) b_self = self;
            vc.refundCallback = ^(HYMallReturnsInfo *returnInfo, HYRefundStatus status)
            {
                [b_self.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//贵就赔处理
- (void)didHandleIndemnity:(HYMallOrderItem *)goods inOrder:(HYMallOrderSummary *)order
{
    if (goods.isCanApplyGuijiupei == HYCanIndemnity)
    {
        HYExpensiveAlertViewController *expensive = [[HYExpensiveAlertViewController alloc] initWithNibName:@"HYExpensiveAlertViewController" bundle:nil];
        expensive.orderCode = order.orderCode;
        expensive.productCode = goods.productCode;
        expensive.productSKUCode = goods.productSKUCode;
        [self.navigationController pushViewController:expensive
                                             animated:YES];
    }
    else
    {
        HYIndemnityProgressViewController *vc = [[HYIndemnityProgressViewController alloc] init];
        vc.goodsInfo = goods;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

#pragma mark - HYMallOrderHandleCellDelegate
- (void)handleOrderWithEventType:(HYMallOrderSummary *)order
                       eventType:(MallOrderHandleType)type
{
    self.handleOrder = order;
    switch (type)
    {
        case Payment_Order:  //付款
            [self paymentWithOrder:order];
            break;
        case Cancel_Order:  //取消
            [self cancelWithOrder];
            break;
        case Delete_Order:  //删除
            [self deleteOrder];
            break;
        case RecvConfig_Order:  //确认收货
            [self confirmReceipt];
            break;
        case Logistics:  //物流跟踪
            [self getLogisticsTrack];
            break;
        case Commend:  //评价
        case AddCommend:  //追评
        {
            [self commentOrder:order];
            break;
        }
        case RemindStore:  //提醒发货
            [self remindStoreSend];
            break;
        case CheckDetail:
            [self checkOrderDetail];
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.orderList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < [self.orderList count])
    {
        HYMallOrderSummary *order = [self.orderList objectAtIndex:section];
        NSInteger mark = -1;
        
        if (_isShowChildOrderStatusOfAllSections.count > 0)
        {
            mark = [_isShowChildOrderStatusOfAllSections[section] integerValue];
        }
        
        //只有部分状态(待发货或者部分返货)的才不会显示状态处理cell
        NSInteger itemCount = 3- (30==order.status || 31==order.status);
        return (section == mark)? itemCount+(order.orderItem.count) : itemCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMallOrderSummary *order = nil;
    HYMallChildOrder *childOrderInfo = nil;
    NSInteger mark = -1;
    
    if (indexPath.section < [self.orderList count])
    {
        order = [self.orderList objectAtIndex:indexPath.section];
        if (_isShowChildOrderStatusOfAllSections.count > 0)
        {
            mark = [_isShowChildOrderStatusOfAllSections[indexPath.section] integerValue];;
        }
    }
    
    if (indexPath.row == 0)  //main order title
    {
        static NSString *orderStatusCellId = @"orderStatusCellId";
        HYMallOrderListStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:orderStatusCellId];
        if (!cell)
        {
            cell = [[HYMallOrderListStatusCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:orderStatusCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setMainOrderTitle:order.orderCode];
        [cell setStatusDesc:order.orderShowStatus];
        
        return cell;
    }
    //订单数据
    else if (indexPath.row == 1)
    {
        static NSString *amountCellId = @"amountCellId";
        HYMallOrderListPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:amountCellId];
        if (!cell)
        {
            cell = [[HYMallOrderListPriceCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                  reuseIdentifier:amountCellId];

        }
        cell.order = order;
        
        return cell;
    }
    //子订单数据
    else if (indexPath.row < ([order.orderItem count]+2)
             && indexPath.section == mark)
    {
        //商品数据
        static NSString *statusInfoCellId = @"statusInfoCellId";
        HYMallOrderListGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:statusInfoCellId];
        if (!cell)
        {
            cell = [[HYMallOrderListGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:statusInfoCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        cell.userinfo = [HYUserInfo getUserInfo];
        cell.order = order;
        
        if (order.orderItem.count > 0)
        {
            childOrderInfo = order.orderItem[indexPath.row - 2];
            cell.childOrderInfo = childOrderInfo;
            
            if (childOrderInfo.orderItemPOList.count > 0)
            {
                HYMallOrderItem *goodsInfo = childOrderInfo.orderItemPOList[0];
                [cell setGoodsInfo:goodsInfo];
            }
        }
        return cell;
    }
    else
    {
        static NSString *statusHandleCellId = @"statusHandleCellId";
        HYMallOrderHandleCell *cell = [tableView dequeueReusableCellWithIdentifier:statusHandleCellId];
        if (!cell)
        {
            cell = [[HYMallOrderHandleCell alloc]initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:statusHandleCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [cell setOrderInfo:order];
        return cell;
    }
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
    if (indexPath.section < [self.orderList count])
    {
        HYMallOrderSummary *order = [self.orderList objectAtIndex:indexPath.section];
        NSInteger mark= -1;
        if (_isShowChildOrderStatusOfAllSections.count > 0)
        {
            mark = [_isShowChildOrderStatusOfAllSections[indexPath.section] integerValue];
        }
     
        if (indexPath.row == 0)  //main order title
        {
            height = 38;
        }
        else if (indexPath.row == 1) //main order info
        {
            height = 70;
        }
        else if (indexPath.row < ([order.orderItem count]+2)
                 && indexPath.section == mark)//child order info
        {
            height = 70;
        }
        else
        {
            height = 45;
        }
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
    
    if (indexPath.section < [self.orderList count])
    {
        HYMallOrderSummary *orderSummary = [self.orderList objectAtIndex:indexPath.section];
        NSArray *childOrderList = orderSummary.orderItem;
        
        //取出当前section是否展示子订单的状态
        if ([_isShowChildOrderStatusOfAllSections count] > 0)
        {
            NSNumber *isShowChildOrder = _isShowChildOrderStatusOfAllSections[indexPath.section];
            
            if (indexPath.row == 1)
            {
                HYMallOrderListPriceCell *cell = (HYMallOrderListPriceCell*)[tableView cellForRowAtIndexPath:indexPath];
                [cell setExpand:(-1 == [isShowChildOrder integerValue])? YES : NO];
                
                if (childOrderList.count > 0)
                {
                    NSMutableArray *indexPathsArray = [NSMutableArray array];
                    
                    for (int i = 0; i < childOrderList.count; i++)
                    {
                        [indexPathsArray addObject:[NSIndexPath indexPathForRow:i + 2 inSection:indexPath.section]];
                    }
                    
                    if (-1 == [isShowChildOrder integerValue])
                    {
                        [_isShowChildOrderStatusOfAllSections setObject:@(indexPath.section)
                                                     atIndexedSubscript:indexPath.section];
                        [tableView beginUpdates];
                        [tableView insertRowsAtIndexPaths:indexPathsArray
                                         withRowAnimation:UITableViewRowAnimationTop];
                        [tableView endUpdates];
                    }
                    else
                    {
                        [_isShowChildOrderStatusOfAllSections setObject:@(-1)
                                                     atIndexedSubscript:indexPath.section];
                        [tableView beginUpdates];
                        [tableView deleteRowsAtIndexPaths:indexPathsArray
                                         withRowAnimation:UITableViewRowAnimationTop];
                        [tableView endUpdates];
                    }
                }
            }
            //订单详情
            else if (indexPath.row < childOrderList.count+2
                     && indexPath.row > 1)
            {
                HYMallChildOrder *childOrder = childOrderList[indexPath.row - 2];
                
                HYMallOrderDetailViewController *vc = [[HYMallOrderDetailViewController alloc] init];
                vc.orderInfo = childOrder;
                vc.orderListView = self;
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }
        }
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
