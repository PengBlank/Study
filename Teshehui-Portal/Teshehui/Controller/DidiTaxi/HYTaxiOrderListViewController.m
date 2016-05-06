//
//  HYTaxiOrderListViewController.m
//  Teshehui
//
//  Created by HYZB on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiOrderListViewController.h"
#import "UIImage+Addition.h"
#import "HYEarnTicketViewController.h"
#import "HYTabbarViewController.h"
#import "HYTaxiOrderListCell.h"
#import "MJRefresh.h"
#import "HYTaxiOrderListRequest.h"
#import "HYTaxiOrderListResponse.h"
#import "HYUserInfo.h"
#import "HYTaxiOrder.h"
#import "HYLoadHubView.h"
#import "HYPaymentViewController.h"
#import "HYTaxiProcessViewController.h"
#import "HYTaxiPaySuccViewController.h"

#define kHYTaxiOrderListCellID @"HYTaxiOrderListCellID"



@interface HYTaxiOrderListViewController ()<UITableViewDataSource,UITableViewDelegate,HYTaxiOrderListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *beginAndUnfinishedDataSource;
@property (nonatomic, strong) NSMutableArray *closedAndFinishedDataSource;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, strong) HYTaxiOrderListRequest *taxiOrderReq;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation HYTaxiOrderListViewController

- (void)dealloc
{
    [_taxiOrderReq cancel];
    _taxiOrderReq = nil;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"打车订单";
    
    self.pageSize = @"20";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    HYTabbarViewController *tab = (HYTabbarViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tab setTabbarShow:NO];
    
    self.pageNo = 1;
    [self getData];
}


- (void)getData
{
    _isLoading = YES;
    if (!_taxiOrderReq) {
        _taxiOrderReq = [[HYTaxiOrderListRequest alloc] init];
    }
    
    _taxiOrderReq.pageSize = self.pageSize;
    _taxiOrderReq.pageNo = [NSString stringWithFormat:@"%d", self.pageNo];
    _taxiOrderReq.type = @"";
    
    // 真实用户账号
    _taxiOrderReq.userId = [HYUserInfo getUserInfo].userId;
    
    [HYLoadHubView show];
    __weak typeof(self) weakSelf = self;
    [_taxiOrderReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        HYTaxiOrderListResponse *response = (HYTaxiOrderListResponse*)result;
        
        [weakSelf.beginAndUnfinishedDataSource removeAllObjects];
        [weakSelf.closedAndFinishedDataSource removeAllObjects];
        
        // 根据有无数据判断界面
        if (!response.dataList.count) {

            [weakSelf createShowEmptyImageViewWhenNoData];
        } else {

            // 获得数据
            for (NSInteger i = 0; i < response.dataList.count; i++)
            {
                
                HYTaxiOrder *orderModel = response.dataList[i];
                didiTaxiStatus status = orderModel.status;
                if (status == didiTaxiStatusBegin || status == didiTaxiStatusUnfinished) {
                    
                    [weakSelf.beginAndUnfinishedDataSource addObject:response.dataList[i]];
                } else {
                    
                    [weakSelf.closedAndFinishedDataSource addObject:response.dataList[i]];
                }
            }
            
            if (!weakSelf.tableView) {
                
                // 创建列表视图
                CGRect frame = [[UIScreen mainScreen] bounds];
                frame.size.height -= 64.0;
                //tableview
                UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                                      style:UITableViewStylePlain];
                tableview.delegate = weakSelf;
                tableview.dataSource = weakSelf;
                tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
                
                [weakSelf.view addSubview:tableview];
                weakSelf.tableView = tableview;
                
                [weakSelf.tableView registerNib:[UINib nibWithNibName:@"HYTaxiOrderListCell" bundle:nil] forCellReuseIdentifier:kHYTaxiOrderListCellID];
                }
            
            if (!weakSelf.tableView.footer)
            {
                
                if (response.dataList.count == 20)
                {
                    
                    weakSelf.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(getMoreTaxiOrder)];
                }
            }
        }
        _isLoading = NO;
      //  [weakSelf.dataSource addObjectsFromArray:response.dataList];
//        if (!weakSelf.dataSource.count) {
//           
//            [weakSelf createShowEmptyImageViewWhenNoData];
//        } else {
//           
//            CGRect frame = [[UIScreen mainScreen] bounds];
//            frame.size.height -= 64.0;
//            //tableview
//            UITableView *tableview = [[UITableView alloc] initWithFrame:frame
//                                                                  style:UITableViewStylePlain];
//            tableview.delegate = weakSelf;
//            tableview.dataSource = weakSelf;
//            tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//            
//            [weakSelf.view addSubview:tableview];
//            weakSelf.tableView = tableview;
//            
//            [weakSelf.tableView registerNib:[UINib nibWithNibName:@"HYTaxiOrderListCell" bundle:nil] forCellReuseIdentifier:kHYTaxiOrderListCellID];
//            
//            weakSelf.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(getMoreTaxiOrder)];
//        }
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - 上拉加载
- (void)getMoreTaxiOrder
{
    self.pageNo++;
    if (_isLoading == NO) {
        
        [self getMoreData];
    }
}

- (void)getMoreData
{
    _isLoading = YES;
    if (!_taxiOrderReq) {
        _taxiOrderReq = [[HYTaxiOrderListRequest alloc] init];
    }
    
    _taxiOrderReq.pageSize = self.pageSize;
    _taxiOrderReq.pageNo = [NSString stringWithFormat:@"%d", self.pageNo];
    _taxiOrderReq.type = @"";
    _taxiOrderReq.userId = [HYUserInfo getUserInfo].userId;
    
    [HYLoadHubView show];
    
    __weak typeof(self) weakSelf = self;
    [_taxiOrderReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        HYTaxiOrderListResponse *response = (HYTaxiOrderListResponse*)result;
        
        // 获得数据
        for (NSInteger i = 0; i < response.dataList.count; i++)
        {
            
            HYTaxiOrder *orderModel = response.dataList[i];
            didiTaxiStatus status = orderModel.status;
            if (status == didiTaxiStatusBegin || status == didiTaxiStatusUnfinished) {
                
                [weakSelf.beginAndUnfinishedDataSource addObject:response.dataList[i]];
            } else {
                
                [weakSelf.closedAndFinishedDataSource addObject:response.dataList[i]];
            }
        }
      //  [weakSelf.dataSource addObjectsFromArray:response.dataList];
        [weakSelf.tableView.footer endRefreshing];
        [weakSelf.tableView reloadData];
        
        if (response.dataList.count < 20) {
            
            weakSelf.tableView.footer.hidden = YES;
        } else {
            
            weakSelf.tableView.footer.hidden = NO;
        }
        _isLoading = NO;
    }];
    
}

#pragma mark - 无数据显示界面
- (void)createShowEmptyImageViewWhenNoData
{
    
    UIImageView *emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TFScalePoint(110), 100, TFScalePoint(100), TFScalePoint(100))];
    emptyImageView.image = [UIImage imageWithNamedAutoLayout:@"icon_empty"];
    [self.view addSubview:emptyImageView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(10), 240, TFScalePoint(300), 20)];
    titleLab.font = [UIFont systemFontOfSize:25];
    titleLab.text = @"暂无此类订单";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor colorWithRed:110/255.0f green:110/255.0f blue:110/255.0f alpha:1.0];
    [self.view addSubview:titleLab];
    
    UILabel *descLab = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(10), 280, TFScalePoint(300), 20)];
    descLab.text = @"打车可以赚现金券哦~";
    descLab.textAlignment = NSTextAlignmentCenter;
    descLab.textColor = [UIColor colorWithRed:110/255.0f green:110/255.0f blue:110/255.0f alpha:1.0];
    [self.view addSubview:descLab];
    
    UIButton *goToTaxiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goToTaxiBtn.frame = CGRectMake(TFScalePoint(100), 320, TFScalePoint(120), 40);
    [goToTaxiBtn setTitle:@"去打车" forState:UIControlStateNormal];
    [goToTaxiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goToTaxiBtn.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    goToTaxiBtn.layer.borderWidth = 1.0;
    [goToTaxiBtn addTarget:self action:@selector(goToTaxi:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goToTaxiBtn];
}

#pragma mark - 点击事件
- (void)goToTaxi:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    HYTabbarViewController *tab = (HYTabbarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tab setCurrentSelectIndex:2];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.beginAndUnfinishedDataSource.count) {
        return 2;
    } else {
        return 1;
    };
//    if (self.beginAndUnfinishedDataSource.count) {
//        return 2;
//    } else {
//        return 1;
//    }
//    HYTaxiOrder *model = self.dataSource[0];
//    didiTaxiStatus status = model.status;
//    if (status == didiTaxiStatusBegin && self.dataSource.count > 1)
//    {   //等接单、应答 、到达等上车、开始行程   进行中
//        return 2;
//    }
//    else if (status == didiTaxiStatusUnfinished && self.dataSource.count > 1)
//    { // 行程结束(未支付)   未完成
//        return 2;
//    }
//    else
//    {   // 已完成、已关闭    已完成
//        return 1;
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 15, 15)];
    imageView.image = [UIImage imageNamed:@"mallOrder_order"];
    [headerView addSubview:imageView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 200, 20)];
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.textColor = [UIColor grayColor];
    
    if (self.beginAndUnfinishedDataSource.count) {
        
        if (section == 0) {
            
            titleLab.text = @"未完成订单";
        } else {
            
            titleLab.text = @"已完成订单";
        }
    } else {
        titleLab.text = @"已完成订单";
    }
    
    [headerView addSubview:titleLab];
    return headerView;
//    if (section == 0) {
//        
//        if (status == didiTaxiStatusBegin)
//        {  // 等接单、应答 、到达等上车、开始行程   进行中
//            titleLab.text = @"进行中订单";
//        }
//        else if (status == didiTaxiStatusUnfinished)
//        { // 行程结束未支付   未完成
//            titleLab.text = @"未完成订单";
//        }
//        else
//        {
//            titleLab.text = @"已完成订单";
//        }
//    } else {
//            titleLab.text = @"已完成订单";
//    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowNumber;
    
    if (self.beginAndUnfinishedDataSource.count)
    {
        
        if (indexPath.section == 0)
        {
            
            for (NSInteger i = 0; i < self.beginAndUnfinishedDataSource.count; i++)
            {
                
                HYTaxiOrder *model = self.beginAndUnfinishedDataSource[i];
                didiTaxiStatus status = model.status;
                if (status == didiTaxiStatusBegin)
                {
                    rowNumber = 120;
                }
                else
                {
                    rowNumber = 170;
                }
            }
        }
        else
        {
            
            rowNumber = 170;
        }
    }
    else
    {
        rowNumber = 170;
    }
    
    return rowNumber;
//    HYTaxiOrder *model = self.dataSource[0];
//    didiTaxiStatus status = model.status;
//    if (indexPath.section == 0 && status == didiTaxiStatusBegin)
//    {   // 等接单、应答 、到达等上车、开始行程   进行中
//        i = 120;
//    }
//    else
//    {
//        i = 170;
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGFloat rowNumber = 0;

    if (self.beginAndUnfinishedDataSource.count) { // 存在进行中及未完成订单时
        
        if (section == 0) {
            rowNumber = self.beginAndUnfinishedDataSource.count;
        } else {
            rowNumber = self.closedAndFinishedDataSource.count;
        }
    } else { // 不存在进行中及未完成订单
        
        rowNumber = self.closedAndFinishedDataSource.count;
    }
    
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYTaxiOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:kHYTaxiOrderListCellID forIndexPath:indexPath];
    tableView.separatorInset = UIEdgeInsetsZero;
    cell.delegate = self;
    
    if (self.beginAndUnfinishedDataSource.count) {
        
        if (indexPath.section == 0) {
            
            HYTaxiOrder *model = self.beginAndUnfinishedDataSource[indexPath.row];
            didiTaxiStatus status = model.status;
            if (status == didiTaxiStatusBegin) {
                [cell setCellOtherStatusTypeWithPartsIsHiden:YES];
                [cell setCellInfoWithModel:model];
            } else {
                [cell setCellOtherStatusTypeWithPartsIsHiden:NO];
                [cell setCellInfoWithModel:model];
            }
        } else {
            HYTaxiOrder *model = self.closedAndFinishedDataSource[indexPath.row];
            [cell setCellCompleteType];
            [cell setCellInfoWithModel:model];
        }
    } else {
        HYTaxiOrder *model = self.closedAndFinishedDataSource[indexPath.row];
        [cell setCellCompleteType];
        [cell setCellInfoWithModel:model];
    }
    
    return cell;
//    if (indexPath.section == 0)
//    {
//        HYTaxiOrder *model = self.dataSource[0];
//        didiTaxiStatus status = model.status;
//        if (status == didiTaxiStatusBegin)
//        { //开始行程   进行中
//            [cell setCellOtherStatusTypeWithPartsIsHiden:YES];
//            [cell setCellInfoWithModel:model];
//        }
//        else if (status == didiTaxiStatusUnfinished)
//        { //行程结束   未完成
//            [cell setCellOtherStatusTypeWithPartsIsHiden:NO];
//            [cell setCellInfoWithModel:model];
//        } else if (status == didiTaxiStatusFinished || status == didiTaxiStatusClosed) {
//            HYTaxiOrder *model = self.dataSource[indexPath.row];
//            [cell setCellCompleteType];
//            [cell setCellInfoWithModel:model];
//        }
//    }
//    else
//    {
//        HYTaxiOrder *model = self.dataSource[indexPath.row + 1];
//        [cell setCellCompleteType];
//        [cell setCellInfoWithModel:model];
//    }
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     * 关于订单的状态的处理，需要考虑周全
     */
    HYTaxiOrder *model = self.beginAndUnfinishedDataSource[indexPath.row];
    didiTaxiStatus status = model.status;
    if (status == didiTaxiStatusBegin)
    { // 跳转打车进行中页面 开始行程   进行中
        
        HYTaxiProcessViewController *onWayVC = [[HYTaxiProcessViewController alloc] init];
        onWayVC.taxiOrder = model;
        [self.navigationController pushViewController:onWayVC animated:YES];
    }
    else if (status == didiTaxiStatusUnfinished)
    { // 跳转打车收银台页面 行程结束   未完成支付
        
        HYAlipayOrder *alPay = [[HYAlipayOrder alloc] init];
        alPay.partner = PartnerID;
        alPay.seller = SellerID;
        
        NSMutableString* nameStr = [[NSMutableString alloc]initWithCapacity:0];
        [nameStr appendString:@"【滴滴打车】订单编号:"];
        
        CGFloat price = model.orderTotalAmount.floatValue;
        alPay.tradeNO = model.orderCode; //订单号（由商家自行制定）
        alPay.productName = nameStr;
        alPay.productDescription = [NSString stringWithFormat:@"%@机票订单", model.passengerPhone]; //商品描述
        alPay.amount = [NSString stringWithFormat:@"%0.2f",price]; //商品价格
        
        HYPaymentViewController *payVC = [[HYPaymentViewController alloc] init];
        payVC.amountMoney = model.orderTotalAmount;
        payVC.payMoney = model.orderPayAmount;
        payVC.type = Pay_DidiTaxi;
        payVC.orderCode = model.orderCode;
        payVC.orderID = model.orderId;
        payVC.navbarTheme = self.navbarTheme;
        payVC.alipayOrder = alPay;
        
        //支付成功, 成功界面
        payVC.paymentCallback = ^(HYPaymentViewController *vc,id order)
        {
            HYTaxiPaySuccViewController *succVc = [[HYTaxiPaySuccViewController alloc] init];
            [vc.navigationController pushViewController:succVc animated:YES];
            NSMutableArray *vcs = [vc.navigationController.viewControllers mutableCopy];
            [vcs removeObject:vc];
            vc.navigationController.viewControllers = vcs;
        };
        [self.navigationController pushViewController:payVC animated:YES];
    }
}

#pragma mark - HYTaxiOrderListCellDelegate
// 跳转打车收银台页面
- (void)payTaxiMoneyWithBtn:(UIButton *)btn
{
    HYTaxiOrderListCell * cell = (HYTaxiOrderListCell *)[btn superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    HYTaxiOrder *model = self.beginAndUnfinishedDataSource[path.row];
    
    
    HYAlipayOrder *alPay = [[HYAlipayOrder alloc] init];
    alPay.partner = PartnerID;
    alPay.seller = SellerID;
    
    NSMutableString* nameStr = [[NSMutableString alloc]initWithCapacity:0];
    [nameStr appendString:@"【滴滴打车】订单编号:"];
    
    CGFloat price = model.orderTotalAmount.floatValue;
    alPay.tradeNO = model.orderCode; //订单号（由商家自行制定）
    alPay.productName = nameStr;
    alPay.productDescription = [NSString stringWithFormat:@"%@打车订单", model.passengerPhone]; //商品描述
    alPay.amount = [NSString stringWithFormat:@"%0.2f",price]; //商品价格
    
    HYPaymentViewController *payVC = [[HYPaymentViewController alloc] init];
    payVC.amountMoney = model.orderTotalAmount;
    payVC.payMoney = model.orderPayAmount;
    payVC.type = Pay_DidiTaxi;
    payVC.orderCode = model.orderCode;
    payVC.orderID = model.orderId;
    payVC.navbarTheme = self.navbarTheme;
    payVC.alipayOrder = alPay;
    
    //支付成功, 成功界面
    payVC.paymentCallback = ^(HYPaymentViewController *vc,id order)
    {
        HYTaxiPaySuccViewController *succVc = [[HYTaxiPaySuccViewController alloc] init];
        [vc.navigationController pushViewController:succVc animated:YES];
        NSMutableArray *vcs = [vc.navigationController.viewControllers mutableCopy];
        [vcs removeObject:vc];
        vc.navigationController.viewControllers = vcs;
    };
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)beginAndUnfinishedDataSource
{
    if (!_beginAndUnfinishedDataSource) {
        _beginAndUnfinishedDataSource = [[NSMutableArray alloc] init];
    }
    return _beginAndUnfinishedDataSource;
}

- (NSMutableArray *)closedAndFinishedDataSource
{
    if (!_closedAndFinishedDataSource) {
        _closedAndFinishedDataSource = [[NSMutableArray alloc] init];
    }
    return _closedAndFinishedDataSource;
}

@end
