//
//  HYFlightOrderDetailViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <TencentOpenAPI/QQApiInterface.h>

#import "HYFlightOrderDetailViewController.h"
#import "HYFlightOrderSummaryCell.h"
#import "HYFlightOrderAirlineCell.h"
#import "HYFlightOrderPassengerCell.h"
#import "HYFlightOrderContactsCell.h"
#import "HYFlightOrderInvoiceInfoCell.h"
#import "HYFlightOrderRTCell.h"
#import "HYFlightRiseCabinCell.h"
#import "HYFlightAlertedCell.h"
#import "HYCustomerServiceCell.h"
#import "HYFlightCancelCell.h"
#import "HYPaymentViewController.h"
#import "HYFlightOrderListViewController.h"

#import "HYFlilghtCancelRequest.h"
#import "METoast.h"
#import "HYUserInfo.h"
#import "HYLoadHubView.h"
#import "HYFlightDelOrderRequest.h"
#import "HYFlightGetOrderInfoRequest.h"
/// 环信
#import "HYChatManager.h"

@interface HYFlightOrderDetailViewController ()
<
UIActionSheetDelegate,
UIAlertViewDelegate,
HYCustomerServiceCellDelegate,
HYFlightCancelCellDelegate
>
{
    HYFlilghtCancelRequest *_cancelRequest;
    HYFlightDelOrderRequest *_delRequest;
    HYFlightGetOrderInfoRequest *_flightOrderDetailRq;

    UILabel *_priceLab;
    UILabel *_pointLab;
    UIButton *_orderBtn;
    UIImageView *_toolBgView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYUserInfo *userInfo;

@end

@implementation HYFlightOrderDetailViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    [_cancelRequest cancel];
    _cancelRequest = nil;
    
    [_flightOrderDetailRq cancel];
    _flightOrderDetailRq = nil;
    
    [_delRequest cancel];
    _delRequest = nil;
    
    _orderListVC = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    tableview.separatorColor = [UIColor clearColor];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    tableview.sectionFooterHeight = 0.0;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.userInfo.userType == Enterprise_User)
    {
        if ([self.flightOrder.userName length] > 0)
        {
            self.title = [NSString stringWithFormat:@"%@的订单详情", self.flightOrder.userName];
        }
        else
        {
            self.title = NSLocalizedString(@"order_detail_info", nil);
        }
    }
    else
    {
        self.title = NSLocalizedString(@"order_detail_info", nil);
    }
    
    [self queryFlightOrderDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)queryFlightOrderDetail
{
    [HYLoadHubView show];
    
    __weak typeof(self) b_self = self;
    
    _flightOrderDetailRq = [[HYFlightGetOrderInfoRequest alloc] init];
    _flightOrderDetailRq.orderCode = self.flightOrder.orderCode;
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    _flightOrderDetailRq.user_id = user.userId;

    //如果为企业用户
    if (user.userType==Enterprise_User && self.flightOrder.orderType==1)
    {
        _flightOrderDetailRq.isEnterprise = 1;
        _flightOrderDetailRq.employeeId = self.flightOrder.buyerId;
    }
    
    [_flightOrderDetailRq sendReuqest:^(id result, NSError *error) {
        HYFlightOrder *order = nil;
        if (!error && [result isKindOfClass:[HYFlightGetOrderInfoResponse class]])
        {
            HYFlightGetOrderInfoResponse *response = (HYFlightGetOrderInfoResponse *)result;
            order = response.flightOrder;
        }
        [b_self queruOrderDetailResult:order error:error];
    }];
}

- (void)queruOrderDetailResult:(HYFlightOrder *)order error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (!error && order)
    {
        self.flightOrder = order;
        [self.tableView reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:error.domain
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self updateToolView];
}

- (void)updateToolView
{
    //必须为自己的订单
    BOOL canPay = self.flightOrder.orderType == 0;
    
    BOOL orderStatus = (self.flightOrder.status == 1); //待付款
    
    //升舱处理中 而且 待付款
    BOOL riseCabinStatus = (self.flightOrder.status == 1024 && self.flightOrder.cabinInfo.status == 1);
    
    //改签处理中 而且 待付款
    BOOL alterdedStatus  = (self.flightOrder.status == 32 && self.flightOrder.alteredInfo.status == 1);
    
    //行程单
//    BOOL invoiceStatus  = (self.flightOrder.journeyInfo.status == 2);
    
    CGFloat price = 0;
//    CGFloat point = 0;
    
    if (orderStatus)
    {
        price = self.flightOrder.orderTotalAmount;
//        point = self.flightOrder.orderTbAmount;
    }
    
    if (riseCabinStatus)
    {
        price += self.flightOrder.cabinInfo.payTotal;
//        point += self.flightOrder.cabinInfo.points;
    }
    else if (alterdedStatus)
    {
        price += self.flightOrder.alteredInfo.payTotal;
//        point += self.flightOrder.alteredInfo.points;
    }

    //退改签的价格已经在订单价格里面了，后台贾波 10-20说明
//    if (invoiceStatus)
//    {
//        price += self.flightOrder.journeyInfo.payTotal;
//        point += self.flightOrder.journeyInfo.points;
//    }
    
    if (canPay && price>0)
    {
        CGRect tframe = self.view.bounds;
        tframe.size.height -= 46;
        self.tableView.frame = tframe;
        
        CGRect frame = self.view.bounds;
        frame.origin.y = (frame.size.height-45.0f);
        frame.size.height = 45.0f;
        _toolBgView = [[UIImageView alloc] initWithFrame:frame];
        _toolBgView.userInteractionEnabled = YES;
//        _toolBgView.image = [[UIImage imageNamed:@"btn_price"] stretchableImageWithLeftCapWidth:2
//                                                                                   topCapHeight:0];
        _toolBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_toolBgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, 60, 18)];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.text = @"待付款:";
        label.backgroundColor = [UIColor clearColor];
        [_toolBgView addSubview:label];
        
        UILabel *plabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 6, 14, 18)];
        plabel.font = [UIFont systemFontOfSize:15];
        plabel.textColor = [UIColor whiteColor];
        plabel.text = @"￥";
        plabel.backgroundColor = [UIColor clearColor];
        [_toolBgView addSubview:plabel];
        
        _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 11, 40, 18)];
        _pointLab.font = [UIFont systemFontOfSize:14];
        _pointLab.textColor = [UIColor blackColor];
        _pointLab.textAlignment = NSTextAlignmentLeft;
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.text = [NSString stringWithFormat:@"总额:"];
        [_toolBgView addSubview:_pointLab];
        
        //总额
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(45, 11, 120, 20)];
        _priceLab.font = [UIFont systemFontOfSize:19];
        _priceLab.textColor = [UIColor redColor];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.text = [NSString stringWithFormat:@"￥%0.2f", price];
        [_toolBgView addSubview:_priceLab];
        
        _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _orderBtn.frame = CGRectMake(ScreenRect.size.width-100, 0, 100, 45);
        UIImage *nImage = [[UIImage imageNamed:@"btn_pay"] stretchableImageWithLeftCapWidth:2
                                                                               topCapHeight:0];
        UIImage *pImage = [[UIImage imageNamed:@"btn_paypress"] stretchableImageWithLeftCapWidth:2
                                                                                    topCapHeight:0];
        [_orderBtn setBackgroundImage:nImage forState:UIControlStateNormal];
        [_orderBtn setBackgroundImage:pImage forState:UIControlStateHighlighted];
        [_orderBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_orderBtn setTitle:NSLocalizedString(@"payment", nil)
                   forState:UIControlStateNormal];
        [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_orderBtn addTarget:self
                      action:@selector(flightPayment:)
            forControlEvents:UIControlEventTouchUpInside];
        [_toolBgView addSubview:_orderBtn];
        
        [self.view addSubview:_toolBgView];
    }
}

- (void)flightPayment:(id)sender
{
    if ([self.flightOrder.orderId length] > 0)
    {
        HYAlipayOrder *order = [[HYAlipayOrder alloc] init];
        order.partner = PartnerID;
        order.seller = SellerID;

        NSMutableString* nameStr = [[NSMutableString alloc]initWithCapacity:0];
        [nameStr appendString:@"【特奢机票】订单编号:"];
        
        BOOL orderStatus = (self.flightOrder.status == 1);
        BOOL riseCabinStatus = (self.flightOrder.status == 1024 && self.flightOrder.cabinInfo.status == 1);
        BOOL alterdedStatus  = (self.flightOrder.status == 32 && self.flightOrder.alteredInfo.status == 1);
        BOOL invoiceStatus  = (self.flightOrder.journeyInfo.status == 2);
        
        CGFloat payPrice = 0.0f;
        CGFloat amoutPrice = 0.0f;
        NSString *orderCode = self.flightOrder.orderCode;
        if (orderStatus)
        {
            payPrice = self.flightOrder.orderCash;
            amoutPrice = self.flightOrder.orderTotalAmount;
        }
        else if (riseCabinStatus)
        {
            orderCode = [NSString stringWithFormat:@"%@_R_%@", orderCode, self.flightOrder.cabinInfo.riseId];
            payPrice = self.flightOrder.cabinInfo.orderCash;
            amoutPrice = self.flightOrder.cabinInfo.payTotal;
        }
        else if (alterdedStatus)
        {
            orderCode = [NSString stringWithFormat:@"%@_A_%@", orderCode, self.flightOrder.alteredInfo.alterId];
            payPrice = self.flightOrder.alteredInfo.orderCash;
            amoutPrice = self.flightOrder.alteredInfo.payTotal;
        }
        
        //机票行程单价格在订单里面，不需要单独添加
        if (invoiceStatus)
        {
            payPrice += self.flightOrder.journeyInfo.orderCash;
        }
        
        HYFlightOrderItem *item = [self.flightOrder.orderItems objectAtIndex:0];
        
        order.tradeNO = orderCode;
        order.productName = nameStr;
        order.productDescription = [NSString stringWithFormat:@"%@机票订单", item.airlineName]; //商品描述
        order.amount = [NSString stringWithFormat:@"%0.2f",payPrice]; //商品价格
        
        HYPaymentViewController *vc = [[HYPaymentViewController alloc] init];
        vc.navbarTheme = self.navbarTheme;
        vc.alipayOrder = order;
        vc.amountMoney = [[NSNumber numberWithFloat:amoutPrice] stringValue];
        vc.payMoney = [[NSNumber numberWithFloat:payPrice] stringValue];
        vc.orderID = self.flightOrder.orderId;
        vc.orderCode = orderCode;
        vc.originCode = self.flightOrder.orderCode;
        vc.type = Pay_Flight;
        
        __weak typeof(self) bself = self;
        
        vc.payCallback = ^(BOOL succ, NSError *error){
            //刷新订单列表
            [bself queryFlightOrderDetail];
        };
        
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else
    {
        [METoast toastWithMessage:@"订单支付失败:订单号为空"];
    }
}

- (void)cancelFilghtOrder
{
    [HYLoadHubView show];
    
    _cancelRequest = [[HYFlilghtCancelRequest alloc] init];
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    _cancelRequest.user_id = user.userId;
    _cancelRequest.orderCode = self.flightOrder.orderCode;
    
    __weak typeof(self) b_self = self;
    [_cancelRequest sendReuqest:^(id result, NSError *error) {
        [b_self cancelOrderResult:result error:error];
    }];
}

- (void)cancelOrderResult:(id)result error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (!error && [result isKindOfClass:[HYFlilghtCancelResponse class]])
    {
        HYFlilghtCancelResponse *response = (HYFlilghtCancelResponse *)result;
        if (response.status == 200)
        {
            self.flightOrder.status = 512;  //取消
            [self removeToolBar];
            [self.tableView reloadData];
        }
        else
        {
            [METoast toastWithMessage:@"订单取消失败"];
        }
        
        [self.orderListVC cancelOrder:self.flightOrder];
    }
    else
    {
        [METoast toastWithMessage:@"订单取消失败"];
    }
}

- (void)removeToolBar
{
    [_toolBgView removeFromSuperview];
    CGRect tframe = self.view.frame;
    tframe.origin.y = 0;
    self.tableView.frame = tframe;
}

- (void)telphone
{
    //如果为携程
    if (self.flightOrder.source == 1)
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"联系携程客服"
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                              destructiveButtonTitle:@"拨打电话 400-821-6666"
                                                   otherButtonTitles:nil];
        [action showInView:self.view];
    }
    else
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"特奢汇客服竭诚为您服务"
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                              destructiveButtonTitle:@"拨打电话 400-806-6528"
                                                   otherButtonTitles:nil];
        [action showInView:self.view];
    }
}

- (void)deleteOrderWith:(NSString *)orderid
{
    if (orderid)
    {
        [HYLoadHubView show];
        
        [_delRequest cancel];
        _delRequest = nil;
        
        _delRequest = [[HYFlightDelOrderRequest alloc] init];
        _delRequest.order_id = orderid;
        _delRequest.user_id = [HYUserInfo getUserInfo].userId;
        
        __weak typeof(self) b_self = self;
        [_delRequest sendReuqest:^(id result, NSError *error) {
            
            [b_self deleteFlightOrderResult:result
                                      error:error];
        }];
    }
}

- (void)deleteFlightOrderResult:(id)result error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (!error && [result isKindOfClass:[HYFlightDelOrderResponse class]])
    {
        BOOL suc = ([(HYFlightDelOrderResponse *)result status] == 200);
        if (suc)
        {
            [METoast toastWithMessage:@"订单删除成功"
                             duration:1.0
                     andCompleteBlock:nil];
        }
        else
        {
            [METoast toastWithMessage:@"订单删除失败"
                             duration:2.0
                     andCompleteBlock:nil];
        }
        
        //刷新订单列表
        [self.orderListVC deleteOrder:self.flightOrder];
    }
    else
    {
        [METoast toastWithMessage:error.domain
                         duration:2.0
                 andCompleteBlock:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 5;
    if (self.flightOrder.hasJourney)
    {
        count += 1;
    }
    
    if (self.flightOrder.hasAlteredInfo)
    {
        count += 1;
    }
    
    if (self.flightOrder.hasRiseCabinInfo)
    {
        count += 1;
    }
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    
    if (section == 0)
    {
        if (self.userInfo.userType == Enterprise_User)  //企业用户不可以删除订单
        {
            if (self.flightOrder.orderType == 1 || //0为自身订单   =1为下属员工的订单
                (self.flightOrder.status==512||  //已取消
                 self.flightOrder.status==8192))  //退款成功
            {
                count = 1;
            }
            else if (self.flightOrder.status==1)
            {
                count = 2;
            }
        }
        else if (self.flightOrder.status==1||  // 待付款（取消订单）
                 self.flightOrder.status==512||  //已取消
                 self.flightOrder.status==8192)  //退款成功
        {
            count = 2;
        }
    }
    else if (section == 1)
    {
        count = self.flightOrder.guests.count;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    switch (indexPath.section)
    {
        case 0:
            if (indexPath.row == 0)
            {
                height = 380;
            }else
            {
                height = 40;
            }
            break;
        case 1:
            height = 108;
            break;
        case 3:
            if (self.flightOrder.hasJourney ||
                self.flightOrder.hasRiseCabinInfo ||
                self.flightOrder.hasAlteredInfo)
            {
                height = 240;
            }
            break;
        case 4:
            if (self.flightOrder.hasJourney &&
                (self.flightOrder.hasRiseCabinInfo||self.flightOrder.hasAlteredInfo))
            {
                height = 240;
            }
            break;
        case 5:
            if (self.flightOrder.hasJourney &&
                self.flightOrder.hasRiseCabinInfo &&
                self.flightOrder.hasAlteredInfo)
            {
                height = 240;
            }
            break;
        default:
            break;
    }
    return height;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    v.image = [[UIImage imageNamed:@"ticket_bg_gray_g5"] stretchableImageWithLeftCapWidth:2
                                                                             topCapHeight:4];
    if (1 == section)
    {
        UIImage *img = [UIImage imageNamed:@"flight_suihua"];
        UIImageView *suihua = [[UIImageView alloc]initWithImage:img];
        suihua.frame = CGRectMake(0, 0, TFScalePoint(320), 8);
        
        UIView *container = [UIView new];
        container.frame = CGRectMake(0, 0, TFScalePoint(320), 10);
        container.backgroundColor = [UIColor clearColor];
        [container addSubview:suihua];
        
        return container;
    }else if (section==3)
    {
        v.frame = CGRectMake(0, 0, 320, 40);
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 20, 100, 18)];
        titleLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [titleLab setFont:[UIFont systemFontOfSize:16]];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.text = @"乘机人";
        [v addSubview:titleLab];
    }
    else if (section ==5)
    {
        v.frame = CGRectMake(0, 0, 320, 40);
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 20, 100, 18)];
        titleLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [titleLab setFont:[UIFont systemFontOfSize:16]];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textAlignment = NSTextAlignmentLeft;
        if (self.flightOrder.hasJourney)
        {
            titleLab.text = @"行程单配送";
        }
        else if (self.flightOrder.hasRiseCabinInfo)
        {
            titleLab.text = @"升舱信息";
        }
        else if (self.flightOrder.hasAlteredInfo)
        {
            titleLab.text = @"改签信息";
        }
        [v addSubview:titleLab];
    }
    else if (section == 6)
    {
        v.frame = CGRectMake(0, 0, 320, 40);
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 20, 100, 18)];
        titleLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [titleLab setFont:[UIFont systemFontOfSize:16]];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textAlignment = NSTextAlignmentLeft;
        if (self.flightOrder.hasJourney && self.flightOrder.hasRiseCabinInfo)
        {
            titleLab.text = @"升舱信息";
        }
        else if (self.flightOrder.hasRiseCabinInfo && self.flightOrder.hasAlteredInfo)
        {
            titleLab.text = @"改签信息";
        }
        [v addSubview:titleLab];
    }
    else if (section == 7 && self.flightOrder.hasJourney && self.flightOrder.hasRiseCabinInfo && self.flightOrder.hasAlteredInfo)
    {
        v.frame = CGRectMake(0, 0, 320, 40);
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 20, 100, 18)];
        titleLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [titleLab setFont:[UIFont systemFontOfSize:16]];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.text = @"改签信息";
        [v addSubview:titleLab];
    }
    return v;
}
*/

//Header高度
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYBaseLineCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:  //机票基础信息
        {
            if (indexPath.row == 0)
            {
                static NSString *summaryCellId = @"summaryCellId";
                HYFlightOrderSummaryCell *summaryCell = [tableView dequeueReusableCellWithIdentifier:summaryCellId];
                if (summaryCell == nil)
                {
                    summaryCell = [[HYFlightOrderSummaryCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                 reuseIdentifier:summaryCellId];
                    summaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    summaryCell.hiddenLine = YES;
                }
                
                [summaryCell setOrder:self.flightOrder];
                cell = summaryCell;
            }
            else
            {
                static NSString *cancelCellId = @"cancelCellId";
                HYFlightCancelCell *cancelCell = [tableView dequeueReusableCellWithIdentifier:cancelCellId];
                if (cancelCell == nil)
                {
                    cancelCell = [[HYFlightCancelCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                          reuseIdentifier:cancelCellId];
                    cancelCell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cancelCell.textLabel.font = [UIFont systemFontOfSize:18];
                    cancelCell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cancelCell.textLabel.textColor = [UIColor colorWithRed:18.0/255.0
                                                                     green:146.0/255.0
                                                                      blue:203.0/255.0
                                                                     alpha:1.0];
                    cancelCell.hiddenLine = YES;
                    cancelCell.delegate = self;
                }
                
                cancelCell.orderStatus = self.flightOrder.status;
                cell = cancelCell;
            }
        }
            break;
        case 1:  //乘机人信息
        {
            if (indexPath.row < [self.flightOrder.guests count])
            {
                static NSString *passengerCellId = @"passengerCellId";
                HYFlightOrderPassengerCell *pCell = [tableView dequeueReusableCellWithIdentifier:passengerCellId];
                if (pCell == nil)
                {
                    pCell = [[HYFlightOrderPassengerCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                             reuseIdentifier:passengerCellId];
                    pCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                if (indexPath.row < [self.flightOrder.guests count])
                {
                    HYFlightGuest *p = [self.flightOrder.guests objectAtIndex:indexPath.row];
                    [pCell setPassenger:p];
                }
                cell = pCell;
            }
        }
            break;
        case 2:  //联系人信息
        {
            static NSString *contactsCellId = @"contactsCellId";
            HYFlightOrderContactsCell *cCell = [tableView dequeueReusableCellWithIdentifier:contactsCellId];
            if (cCell == nil)
            {
                cCell = [[HYFlightOrderContactsCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                        reuseIdentifier:contactsCellId];
                cCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            NSString *contacts = self.flightOrder.buyerNick;
//            if (contacts)
//            {
//                if (self.flightOrder.buyerMobile)
//                {
//                    contacts = [NSString stringWithFormat:@"%@  %@", contacts,
//                                        self.flightOrder.buyerMobile];
//                }
//            }
//            else
//            {
                contacts = self.flightOrder.buyerMobile;
//            }
            
            cCell.detailTextLabel.text = contacts;
            cell = cCell;
        }
            break;
        case 3:  //行程单/退改签/升舱/联系客服
        {
            if (self.flightOrder.hasJourney)  //行程单
            {
                static NSString *invoiceCellId = @"invoiceCellId";
                HYFlightOrderInvoiceInfoCell *iCell = [tableView dequeueReusableCellWithIdentifier:invoiceCellId];
                if (iCell == nil)
                {
                    iCell = [[HYFlightOrderInvoiceInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                               reuseIdentifier:invoiceCellId];
                    iCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [iCell setJourney:self.flightOrder.journeyInfo];
                cell = iCell;
            }
            else if (self.flightOrder.hasRiseCabinInfo)   //升舱
            {
                static NSString *riseCabinCellId = @"riseCabinCellId";
                HYFlightRiseCabinCell *iCell = [tableView dequeueReusableCellWithIdentifier:riseCabinCellId];
                if (iCell == nil)
                {
                    iCell = [[HYFlightRiseCabinCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:riseCabinCellId];
                    iCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [iCell setRiseCabin:self.flightOrder.cabinInfo];
                cell = iCell;
            }
            else if (self.flightOrder.hasAlteredInfo)  //改签
            {
                static NSString *alertedCellId = @"alertedCellId";
                HYFlightAlertedCell *iCell = [tableView dequeueReusableCellWithIdentifier:alertedCellId];
                if (iCell == nil)
                {
                    iCell = [[HYFlightAlertedCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:alertedCellId];
                    iCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [iCell setAlertInfo:self.flightOrder.alteredInfo];
                cell = iCell;
            }
            else   //联系客服
            {
                static NSString *rtCellId = @"rtCellId";
                HYBaseLineCell *rtCell = [tableView dequeueReusableCellWithIdentifier:rtCellId];
                if (rtCell == nil)
                {
                    rtCell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:rtCellId];
                    rtCell.selectionStyle = UITableViewCellSelectionStyleGray;
                    rtCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    rtCell.textLabel.font = [UIFont systemFontOfSize:14];
                    rtCell.textLabel.textColor = [UIColor colorWithRed:18.0/255.0
                                                                 green:146.0/255.0
                                                                  blue:203.0/255.0
                                                                 alpha:1.0];
                }
                
                //如果为携程
                if (self.flightOrder.source == 1)
                {
                    rtCell.textLabel.text = @"退改签，升舱请联系客服 400-821-6666";
                }
                else
                {
                    rtCell.textLabel.text = @"退改签，升舱请联系客服 400-806-6528";
                }
                
                cell = rtCell;
            }
        }
            break;
        case 4:  //退改签/升舱/联系客服
        {
            if (self.flightOrder.hasJourney && self.flightOrder.hasRiseCabinInfo)   //升舱
            {
                static NSString *riseCabinCellId = @"riseCabinCellId";
                HYFlightRiseCabinCell *iCell = [tableView dequeueReusableCellWithIdentifier:riseCabinCellId];
                if (iCell == nil)
                {
                    iCell = [[HYFlightRiseCabinCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:riseCabinCellId];
                    iCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [iCell setRiseCabin:self.flightOrder.cabinInfo];
                cell = iCell;
            }
            else if (self.flightOrder.hasJourney && self.flightOrder.hasAlteredInfo)  //改签
            {
                static NSString *alertedCellId = @"alertedCellId";
                HYFlightAlertedCell *iCell = [tableView dequeueReusableCellWithIdentifier:alertedCellId];
                if (iCell == nil)
                {
                    iCell = [[HYFlightAlertedCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:alertedCellId];
                    iCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [iCell setAlertInfo:self.flightOrder.alteredInfo];
                cell = iCell;
            }
            else if (self.flightOrder.hasJourney+
                     self.flightOrder.hasRiseCabinInfo+
                     self.flightOrder.hasAlteredInfo)   //联系客服
            {
                static NSString *rtCellId = @"rtCellId";
                HYBaseLineCell *rtCell = [tableView dequeueReusableCellWithIdentifier:rtCellId];
                if (rtCell == nil)
                {
                    rtCell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:rtCellId];
                    rtCell.selectionStyle = UITableViewCellSelectionStyleGray;
                    rtCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    rtCell.textLabel.font = [UIFont systemFontOfSize:14];
                    rtCell.textLabel.textColor = [UIColor colorWithRed:18.0/255.0
                                                                 green:146.0/255.0
                                                                  blue:203.0/255.0
                                                                 alpha:1.0];
                }
                
                //如果为携程
                if (self.flightOrder.source == 1)
                {
                    rtCell.textLabel.text = @"退改签，升舱请联系客服 400-821-6666";
                }
                else
                {
                    rtCell.textLabel.text = @"退改签，升舱请联系客服 400-806-6528";
                }
                
                cell = rtCell;
            }
            else
            {
                static NSString *customerCellId = @"customerCellId";
                HYCustomerServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:customerCellId];
                if (cell == nil)
                {
                    cell = [[HYCustomerServiceCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:customerCellId];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                }
                
                return cell;
            }
        }
            break;
        case 5:  //升舱/联系客服
        {
            if (self.flightOrder.hasRiseCabinInfo && self.flightOrder.hasAlteredInfo)  //升舱
            {
                static NSString *alertedCellId = @"alertedCellId";
                HYFlightAlertedCell *iCell = [tableView dequeueReusableCellWithIdentifier:alertedCellId];
                if (iCell == nil)
                {
                    iCell = [[HYFlightAlertedCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:alertedCellId];
                    iCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [iCell setAlertInfo:self.flightOrder.alteredInfo];
                cell = iCell;
            }
            else if ((self.flightOrder.hasJourney+
                     self.flightOrder.hasRiseCabinInfo+
                     self.flightOrder.hasAlteredInfo)>1) //联系客服
            {
                static NSString *rtCellId = @"rtCellId";
                HYBaseLineCell *rtCell = [tableView dequeueReusableCellWithIdentifier:rtCellId];
                if (rtCell == nil)
                {
                    rtCell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:rtCellId];
                    rtCell.selectionStyle = UITableViewCellSelectionStyleGray;
                    rtCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    rtCell.textLabel.font = [UIFont systemFontOfSize:14];
                    rtCell.textLabel.textColor = [UIColor colorWithRed:18.0/255.0
                                                                 green:146.0/255.0
                                                                  blue:203.0/255.0
                                                                 alpha:1.0];
                }
                
                //如果为携程
                if (self.flightOrder.source == 1)
                {
                    rtCell.textLabel.text = @"退改签，升舱请联系客服 400-821-6666";
                }
                else
                {
                    rtCell.textLabel.text = @"退改签，升舱请联系客服 400-806-6528";
                }
                
                cell = rtCell;
            }
            else
            {
                static NSString *customerCellId = @"customerCellId";
                HYCustomerServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:customerCellId];
                if (cell == nil)
                {
                    cell = [[HYCustomerServiceCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:customerCellId];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                }
                
                return cell;
            }
        }
            break;
        case 6:  //
        {
            if (self.flightOrder.hasJourney &&
                self.flightOrder.hasRiseCabinInfo &&
                self.flightOrder.hasAlteredInfo)
            {
                static NSString *rtCellId = @"rtCellId";
                HYBaseLineCell *rtCell = [tableView dequeueReusableCellWithIdentifier:rtCellId];
                if (rtCell == nil)
                {
                    rtCell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:rtCellId];
                    rtCell.selectionStyle = UITableViewCellSelectionStyleGray;
                    rtCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    rtCell.textLabel.font = [UIFont systemFontOfSize:14];
                    rtCell.textLabel.textColor = [UIColor colorWithRed:18.0/255.0
                                                                 green:146.0/255.0
                                                                  blue:203.0/255.0
                                                                 alpha:1.0];
                }
                
                //如果为携程
                if (self.flightOrder.source == 1)
                {
                    rtCell.textLabel.text = @"退改签，升舱请联系客服 400-821-6666";
                }
                else
                {
                    rtCell.textLabel.text = @"退改签，升舱请联系客服 400-806-6528";
                }
                
                cell = rtCell;
            }
            else
            {
                static NSString *customerCellId = @"customerCellId";
                HYCustomerServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:customerCellId];
                if (cell == nil)
                {
                    cell = [[HYCustomerServiceCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:customerCellId];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                }
                
                return cell;
            }
        }
            break;
        case 7:  //
        {
            static NSString *customerCellId = @"customerCellId";
            HYCustomerServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:customerCellId];
            if (cell == nil)
            {
                cell = [[HYCustomerServiceCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:customerCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            
            return cell;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ((indexPath.section-self.flightOrder.hasJourney-self.flightOrder.hasAlteredInfo-self.flightOrder.hasRiseCabinInfo)==3)
    {
        [self telphone];
    }
}

- (void)connectOnlineCustomnerService
{
    //检查登录
    [[HYChatManager sharedManager] chatLogin];
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    [muDic setObject:@"order"
              forKey:@"type"];
    [muDic setObject:@"机票订单"
              forKey:@"title"];
    [muDic setObject:[NSString stringWithFormat:@"订单号:%@", self.flightOrder.orderCode]
              forKey:@"order_title"];
    [muDic setObject:@"order"
              forKey:@"type"];
    
//     @{@"type":@"order",
//       @"title":@"测试order1",
//       @"order_title":@"订单号：123456",
//       @"imageName":@"mallImage1.png",
//       @"desc":@"露肩名媛范套装",
//       @"price":@"￥518",
//       @"img_url":@"http://www.lagou.com/upload/indexPromotionImage/ff8080814cffb587014d09af023a0204.jpg",
//       @"item_url":@"http://www.lagou.com/"};
    
    ChatViewController *vc = [[ChatViewController alloc] initWithChatter:kCustomerHXId
                                                                    type:eAfterSaleType];
    vc.commodityInfo = [muDic copy];
    [self.navigationController pushViewController:vc
                                         animated:YES];
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
        [self telphone];
    }
}

#pragma mark - cancelCellDelegate
- (void)cancelFilghtOrder:(HYFlightOrder *)order
{
    if (self.flightOrder.status == 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"确定取消该航班订单？"
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"done", nil), nil];
        [alertView show];
    }
    else if (self.flightOrder.status==512)  //已取消
        //                 || self.flightOrder.status==8192)  //退款成功 (河塔市10月21说退款成功的也不可以删除)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定删除该订单?"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"删除", nil];
        alert.tag = 10;
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if (alertView.tag == 10)
        {
            [self deleteOrderWith:self.flightOrder.orderId];
        }
        else
        {
            [self cancelFilghtOrder];
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        NSString *phone = [NSString stringWithFormat:@"telprompt://4008066528"];
        if (self.flightOrder.source == 1)
        {
            phone = [NSString stringWithFormat:@"telprompt://4008216666"];
        }
        
        NSURL *url = [NSURL URLWithString:phone];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
