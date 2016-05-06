//
//  HYPhoneChargeOrderListViewController.m
//  Teshehui
//
//  Created by HYZB on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYPhoneChargeOrderListViewController.h"
#import "HYNullView.h"
#import "HYPhoneChargeOrderListResponse.h"
#import "HYPhoneChargeOrderListRequest.h"
#import "HYLoadHubView.h"
#import "HYUserInfo.h"
#import "MJRefresh.h"
#import "METoast.h"
#import "HYPhoneChargeOrderListDeleteRequest.h"
#import "HYPhoneChargeOrderListDeleteResponse.h"
#import "HYPhoneChargeOrderListModel.h"
#import "HYPhoneChargeOrderListCancelResponse.h"
#import "HYPhoneChargeOrderListCancelRequest.h"
#import "HYPaymentViewController.h"
#import "HYAlipayOrder.h"
#import "HYPhoneChargeViewController.h"
#import "HYPhoneChargeOrderListCell.h"



@interface HYPhoneChargeOrderListViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
HYPhoneChargeOrderListCellDelegate
>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) HYNullView *nullView;

@property (nonatomic, strong) UIButton *phoneCharge;
@property (nonatomic, strong) UIButton *dataCharge;

@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) RechargeType orderListType; // 2 话费  5 流量

@property (nonatomic, assign) BOOL isLoading; // 是否加载中
@property (nonatomic, assign) BOOL hasMore; // 是否为上拉加载数据default is no

@property (nonatomic, strong) HYPhoneChargeOrderListRequest *phoneChargeOrderListReq;
@property (nonatomic, strong) HYPhoneChargeOrderListDeleteRequest *deleteReq;
@property (nonatomic, strong) HYPhoneChargeOrderListCancelRequest *cancelRequest;


@end

@implementation HYPhoneChargeOrderListViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_phoneChargeOrderListReq cancel];
    _phoneChargeOrderListReq = nil;
    
    [_deleteReq cancel];
    _deleteReq = nil;
    
    [_cancelRequest cancel];
    _cancelRequest = nil;
}

/*
 *  这里在外部进入时用到，需要重设显示的订单类型
 *  但是，如果界面刚刚展示，会发生一个问题，即，如果正在加载中，那么调用小波原有的转换方法会不成功。
 *  这里使用一个奇怪的方法，即，每次去检测_loading变量是否为yes，如果是，那么继续等待直到该变量变为no
 */
- (void)setType:(NSInteger)type
{
    if (_type != type)
    {
        _type = type;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (_isLoading) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (type == 2)
                {
                    [self phoneChargeBtnClicked:nil];
                }
                else
                {
                    [self dataChargeBtnClicked:nil];
                }
            });
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机充值订单";
    _pageNo = 1;
    _pageSize = 20;
    _isLoading = NO;
    _hasMore = NO;
    _orderListType = kRechargeTypePhoneNum;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-94)
                                                          style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    [self setupHeaderView];
    
    _nullView = [[HYNullView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-94)];
    _nullView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    _nullView.icon = [UIImage imageNamed:@"icon_empty"];
    _nullView.eventBtn.hidden = NO;
    [_nullView.eventBtn setTitle:@"我要充值" forState:UIControlStateNormal];
    [_nullView.eventBtn addTarget:self action:@selector(goToCharge:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nullView];
    _nullView.hidden = YES;
    
    if (_type)
    {
        _orderListType = _type;
    }
    
    switch (_orderListType)
    {
        case kRechargeTypedata:
            [_phoneCharge setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0f] forState:UIControlStateNormal];
            [_dataCharge setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            break;
        case kRechargeTypePhoneNum:
            [_phoneCharge setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_dataCharge setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0f] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    if (!_isLoading) {
        [self loadData];
    }
}

#pragma mark - privateMethod
- (void)payAction:(HYPhoneChargeOrderListModel *)model
{
    [self setupPageNo];
    
    HYAlipayOrder *aliOrder = [[HYAlipayOrder alloc] init];
    aliOrder.partner = PartnerID;
    aliOrder.seller = SellerID;
     
//    NSMutableString* nameStr = [[NSMutableString alloc]initWithCapacity:0];
//    [nameStr appendString:@"【特奢酒店】订单编号:"];
    
    aliOrder.tradeNO = model.orderCode; //订单号（由商家自行制定）
//    aliOrder.productName = [NSString stringWithFormat:@"%@%@",nameStr,self.orderDetail.orderCode]; //商品标题
//    aliOrder.productDescription = [NSString stringWithFormat:@"%@%@",nameStr,self.orderDetail.orderCode]; //商品描述
    aliOrder.amount = [NSString stringWithFormat:@"%0.2f",[model.notPayAmount floatValue]]; //应付金额
    
    HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
    payVC.navbarTheme = self.navbarTheme;
    payVC.alipayOrder = aliOrder;
    payVC.amountMoney = model.orderTradeAmount;  //总金额
    payVC.payMoney = aliOrder.amount;  //待支付金额
    payVC.orderID = [NSString stringWithFormat:@"%ld", (long)model.orderId];
    payVC.orderCode = model.orderCode;
    payVC.type = pay_phoneCharge;
    
    WS(weakSelf)
    payVC.paymentCallback = ^(HYPaymentViewController *vc, id data)
    {
        [vc.navigationController popViewControllerAnimated:YES];
        weakSelf.hasMore = NO;
        //刷新订单列表
        [weakSelf loadData];
    };

    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)deleteAction:(HYPhoneChargeOrderListModel *)model
{
    [self setupPageNo];
    
    if (!_deleteReq)
    {
        _deleteReq = [[HYPhoneChargeOrderListDeleteRequest alloc] init];
    }
    
    _deleteReq.orderId = model.orderId;
    [HYLoadHubView show];
    _isLoading = YES;
    WS(b_self)
    [_deleteReq sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        b_self.isLoading = NO;
        
        HYPhoneChargeOrderListDeleteResponse *resp = (HYPhoneChargeOrderListDeleteResponse *)result;
        if (resp.status == 200)
        {
            [METoast toastWithMessage:@"删除订单成功"];
            b_self.hasMore = NO;
            [b_self loadData];
        }
        else
        {
            [METoast toastWithMessage:@"删除订单失败"];
        }
    }];
}

- (void)cancelBtnAction:(HYPhoneChargeOrderListModel *)model
{
    [self setupPageNo];
    
    if (!_cancelRequest)
    {
        _cancelRequest = [[HYPhoneChargeOrderListCancelRequest alloc] init];
    }
    
    _cancelRequest.orderId = model.orderId;
    _cancelRequest.orderCode = model.orderCode;
    
    [HYLoadHubView show];
    _isLoading = YES;
    WS(b_self)
    [_cancelRequest sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        b_self.isLoading = NO;
        
        HYPhoneChargeOrderListCancelResponse *resp = (HYPhoneChargeOrderListCancelResponse *)result;
        if (resp.status == 200)
        {
            [METoast toastWithMessage:@"取消订单成功"];
            b_self.hasMore = NO;
            [b_self loadData];
        }
        else
        {
            [METoast toastWithMessage:@"取消订单失败"];
        }
    }];
}

- (void)loadData
{
    if (!_phoneChargeOrderListReq)
    {
        _phoneChargeOrderListReq = [[HYPhoneChargeOrderListRequest alloc] init];
    }
    
    NSString *userId = [HYUserInfo getUserInfo].userId;
    if (userId)
    {
        _phoneChargeOrderListReq.userId = userId;
    }
    _phoneChargeOrderListReq.pageNo = _pageNo;
    _phoneChargeOrderListReq.pageSize = _pageSize;
    _phoneChargeOrderListReq.type = [NSString stringWithFormat:@"%ld", (long)_orderListType];
    
    [HYLoadHubView show];
    _isLoading = YES;
    WS(b_self)
    [_phoneChargeOrderListReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        b_self.isLoading = NO;
        
        HYPhoneChargeOrderListResponse *resp = (HYPhoneChargeOrderListResponse *)result;
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
        
        self.tableView.hidden = NO;
        self.nullView.hidden = YES;
    }
    else
    {
        self.tableView.hidden = YES;
        self.nullView.hidden = NO;
        _nullView.needTouch = YES;
        
        if (error)
        {
            _nullView.descInfo = error.domain;
        }
        else
        {
            switch (self.orderListType)
            {
                case kRechargeTypePhoneNum:
                    _nullView.descInfo = @"您暂时没有话费充值订单";
                    break;
                case kRechargeTypedata:
                    _nullView.descInfo = @"您暂时没有流量充值订单";
                    break;
                default:
                    break;
            }
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

- (void)setupHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIButton *phoneCharge = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneCharge = phoneCharge;
    phoneCharge.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 40);
    [phoneCharge setTitle:@"话费充值订单" forState:UIControlStateNormal];
    [phoneCharge setTitleColor:[UIColor redColor]
                      forState:UIControlStateNormal];
    phoneCharge.titleLabel.font = [UIFont systemFontOfSize:16];
    [phoneCharge addTarget:self action:@selector(phoneChargeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:phoneCharge];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneCharge.frame)+1, 10, 0.5, 20)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [headerView addSubview:lineView];
    
    UIButton *dataCharge = [UIButton buttonWithType:UIButtonTypeCustom];
    _dataCharge = dataCharge;
    dataCharge.frame = CGRectMake(CGRectGetMaxX(phoneCharge.frame)+1, 0, CGRectGetWidth(phoneCharge.frame)-1, 40);
    [dataCharge setTitle:@"流量充值订单" forState:UIControlStateNormal];
    [dataCharge setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0f]
                      forState:UIControlStateNormal];
    dataCharge.titleLabel.font = [UIFont systemFontOfSize:16];
    [dataCharge addTarget:self action:@selector(dataChargeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:dataCharge];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    bottomLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [headerView addSubview:bottomLineView];
}

- (void)phoneChargeBtnClicked:(UIButton *)btn
{
    if (!_isLoading)
    {
        _orderListType = kRechargeTypePhoneNum;
        _pageNo = 1;
        _hasMore = NO;
        [_phoneCharge setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_dataCharge setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0f] forState:UIControlStateNormal];
        [self.dataArr removeAllObjects];
        [self loadData];
    }
}

- (void)dataChargeBtnClicked:(UIButton *)btn
{
    if (!_isLoading)
    {
        _orderListType = kRechargeTypedata;
        _pageNo = 1;
        _hasMore = NO;
        [_phoneCharge setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0f] forState:UIControlStateNormal];
        [_dataCharge setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.dataArr removeAllObjects];
        [self loadData];
    }
}

- (void)goToCharge:(UIButton *)btn
{
    HYPhoneChargeViewController *phoneVC = nil;
    
    if (kRechargeTypedata == _orderListType)
    {
        phoneVC = [[HYPhoneChargeViewController alloc]
                   initWithChildControllerType:FlowChargeController];
    }
    else
    {
        phoneVC = [[HYPhoneChargeViewController alloc]
                   initWithChildControllerType:PhoneChargeController];
    }
    
    [self.navigationController pushViewController:phoneVC animated:YES];
}

/**
  * 重置页面数据为第一页数据
  */
- (void)setupPageNo
{
    _pageNo = 1;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArr.count)
    {
        HYPhoneChargeOrderListModel *model = self.dataArr[indexPath.row];
        return model.cashCoupon.intValue == 0 ? 200 : 220;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYPhoneChargeOrderListCell *cell = [HYPhoneChargeOrderListCell cellWithTableView:tableView];
    if (indexPath.row < self.dataArr.count) {
        cell.model = self.dataArr[indexPath.row];
    }
    cell.delegate = self;
    return cell;
}


@end
