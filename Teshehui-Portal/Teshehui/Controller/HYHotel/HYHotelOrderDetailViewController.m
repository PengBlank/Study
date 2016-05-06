//
//  HYHotelOrderDetailViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//
#import <TencentOpenAPI/QQApiInterface.h>

#import "HYHotelOrderDetailViewController.h"
#import "HYHotelOrderDetailInfoCell.h"
#import "HYHotelOrderDetailHandleCell.h"
#import "HYHotelOrderDetailAccessoryCell.h"
#import "HYHotelDetailViewController.h"
#import "HYPaymentViewController.h"
#import "HYUserInfo.h"
#import "HYCustomerServiceCell.h"
#import "HYHotelOrderDetailTitleCell.h"
#import "HYHotelPaymentFootView.h"

#import "HYHotelOrderDetailRequest.h"
#import "HYHotelOrderCancelRequest.h"
#import "HYHotelOrderCancelResponse.h"
#import "HYHotelDelOrderRequest.h"

#import "METoast.h"
#import "HYLoadHubView.h"

#import "HYHotelGuestPO.h"
#import "HYHotelOrderItemPO.h"

#import "NSDate+Addition.h"
#import "NSString+Addition.h"
#import "PTDateFormatrer.h"
#import "HYHotelMapViewController.h"
#import "HYMineInfoServiceCell.h"

/// 环信
#import "HYChatManager.h"

@interface HYHotelOrderDetailViewController ()
<
UIAlertViewDelegate,
UIActionSheetDelegate,
HYMineINfoServiceCellDelegate
>
{
    HYHotelOrderDetailRequest *_orderRequest;
    HYHotelOrderCancelRequest *_cancelRequest;
    HYHotelDelOrderRequest *_delOrderRequest;
    
    //支付信息
    UILabel *_priceLab;
    UILabel *_pointLab;
    UIButton *_orderBtn;
    UIImageView *_toolBgView;
    
    HYHotelPaymentFootView *_paymentView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYHotelOrderDetail *orderDetail;
@property (nonatomic, strong) HYUserInfo *userInfo;
@property (nonatomic, strong) HYHotelGuestPO *guestPO;
@property (nonatomic, strong) HYHotelOrderItemPO *orderItemPO;
@property (nonatomic, strong) HYDeliveryAddressPO *deliveryAddressPO;

@end

@implementation HYHotelOrderDetailViewController

- (void)dealloc
{
    [_orderRequest cancel];
    _orderRequest = nil;
    
    [_cancelRequest cancel];
    _cancelRequest = nil;
    
    [_delOrderRequest cancel];
    _delOrderRequest = nil;
    
    [HYLoadHubView dismiss];
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
    tableview.sectionFooterHeight = 0;
    tableview.sectionHeaderHeight = 45;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    [tableview registerClass:[HYHotelOrderDetailTitleCell class] forCellReuseIdentifier:@"orderTitleId"];
    [tableview registerClass:[HYHotelOrderDetailHandleCell class] forCellReuseIdentifier:@"orderHandleId"];
    [tableview registerClass:[HYHotelOrderDetailInfoCell class] forCellReuseIdentifier:@"orderInfoId"];
    [tableview registerClass:[HYHotelOrderDetailAccessoryCell class] forCellReuseIdentifier:@"accInfoId"];
    [tableview registerClass:[HYMineInfoServiceCell class] forCellReuseIdentifier:@"service"];
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1.0)];
    lineView.image =[[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                  topCapHeight:0];
    tableview.tableHeaderView = lineView;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.userInfo.userType == Enterprise_User)
    {
        if ([self.hotelOrder.buyerNick length] > 0)
        {
            self.title = [NSString stringWithFormat:@"%@的订单详情", self.hotelOrder.buyerNick];
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
    
    //加载订单详情
    [self loadOrderDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methdos
- (void)updateToolView
{
    BOOL canPay = ([self.orderDetail.buyerId isEqualToString:self.userInfo.userId]);
    
    //预付酒店，并且未支付
    if (self.orderDetail.isPrePay && self.orderDetail.status == Unpaid && canPay)
    {
        CGRect tframe = self.view.frame;
        tframe.origin.y = 0;
        tframe.size.height -= 46;
        self.tableView.frame = tframe;
        
        _paymentView = [[HYHotelPaymentFootView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-45, CGRectGetWidth(self.view.frame), 45)];
        _paymentView.price = self.orderDetail.orderPayAmount;
        _paymentView.points = self.orderItemPO.points;
        [_paymentView.orderBtn setTitle:@"支付" forState:UIControlStateNormal];
        [_paymentView.orderBtn addTarget:self action:@selector(hotelPayment:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_paymentView];
    }
//    else
//    {
//        [_toolBgView removeFromSuperview];
//    }
}

- (void)hotelPayment:(id)sender
{
    if ([self.orderDetail.orderId length] > 0)
    {
        HYAlipayOrder *aliOrder = [[HYAlipayOrder alloc] init];
        aliOrder.partner = PartnerID;
        aliOrder.seller = SellerID;
        
        NSMutableString* nameStr = [[NSMutableString alloc]initWithCapacity:0];
        [nameStr appendString:@"【特奢酒店】订单编号:"];
        
        aliOrder.tradeNO = self.orderDetail.orderCode; //订单号（由商家自行制定）
        aliOrder.productName = [NSString stringWithFormat:@"%@%@",nameStr,self.orderDetail.orderCode]; //商品标题
        aliOrder.productDescription = [NSString stringWithFormat:@"%@%@",nameStr,self.orderDetail.orderCode]; //商品描述
        aliOrder.amount = [NSString stringWithFormat:@"%0.2f",[self.orderDetail.orderCash floatValue]]; //应付金额
        
        HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
        payVC.navbarTheme = self.navbarTheme;
        payVC.alipayOrder = aliOrder;
        payVC.amountMoney = self.orderDetail.orderTotalAmount;  //总金额
        payVC.payMoney = aliOrder.amount;  //待支付金额
        payVC.orderID = self.orderDetail.orderId;
        payVC.orderCode = self.orderDetail.orderCode;
        payVC.type = Pay_Hotel;
        __weak typeof(self) bself = self;
        
        payVC.payCallback = ^(BOOL succ, NSError *error){
            //刷新订单列表
            [bself loadOrderDetail];
        };
        
        [self.navigationController pushViewController:payVC animated:YES];
    }
}

- (void)loadOrderDetail
{
    _orderRequest = [[HYHotelOrderDetailRequest alloc] init];
    
    _orderRequest.orderId = self.hotelOrder.orderId;
//    _orderRequest.userId = self.hotelOrder.user_id;
    _orderRequest.userId = self.userInfo.userId;
    if (self.hotelOrder.orderType == 1 && self.userInfo.userType == Enterprise_User)
    {
        _orderRequest.is_enterprise = @"1";
        _orderRequest.employeeId = self.hotelOrder.buyerId;
    }
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_orderRequest sendReuqest:^(id result, NSError *error) {
        if (!error && [result isKindOfClass:[HYHotelOrderDetailResponse class]])
        {
            HYHotelOrderDetailResponse *response = (HYHotelOrderDetailResponse *)result;
            [b_self updateTableviewWithOrderInfo:response.orderDetail];
        }
    }];
}

- (void)updateTableviewWithOrderInfo:(HYHotelOrderDetail *)order
{
    [HYLoadHubView dismiss];
    self.orderDetail = order;
    [self.tableView reloadData];
    
    [self updateToolView];
}

- (void)cancelHotelOrder
{
    [HYLoadHubView show];
    
    [_cancelRequest cancel];
    _cancelRequest = nil;
    
    _cancelRequest = [[HYHotelOrderCancelRequest alloc] init];
    _cancelRequest.orderId = self.orderDetail.orderId;
    _cancelRequest.userId = self.orderDetail.buyerId;
    
    __weak typeof(self) b_self = self;
    [_cancelRequest sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        if (!error && [result isKindOfClass:[HYHotelOrderCancelResponse class]])
        {
            b_self.orderDetail.status = Cancel;
            b_self.hotelOrder.status = Cancel;
            [b_self.tableView reloadData];
        }
        else
        {
            [METoast toastWithMessage:error.domain];
        }
    }];
}

/*
 *删除酒店订单
 */
- (void)deleteHotelOrder
{
    [HYLoadHubView show];
    
    [_delOrderRequest cancel];
    _delOrderRequest = nil;
    
    _delOrderRequest = [[HYHotelDelOrderRequest alloc] init];
    _delOrderRequest.orderId = self.orderDetail.orderId;
    _delOrderRequest.userId = self.orderDetail.buyerId;
    
    
    __weak typeof(self) b_self = self;
    [_delOrderRequest sendReuqest:^(id result, NSError *error) {
        if (!error && [result isKindOfClass:[HYHotelDelOrderResponse class]])
        {
            HYHotelDelOrderResponse *response = (HYHotelDelOrderResponse *)result;
            if (response.succ)
            {
                [METoast toastWithMessage:@"订单删除成功"
                                 duration:1.0
                         andCompleteBlock:nil];
            }
            else
            {
                [METoast toastWithMessage:@"订单删除失败"
                                 duration:1.0
                         andCompleteBlock:nil];
            }
        }
        else
        {
            [METoast toastWithMessage:@"订单删除失败"
                             duration:1.5
                     andCompleteBlock:nil];
        }
        
        [b_self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

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
    //检查登录
    [[HYChatManager sharedManager] chatLogin];
    
    /// 对象
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    [muDic setObject:@"order"
              forKey:@"type"];
    [muDic setObject:@"酒店订单"
              forKey:@"title"];
    [muDic setObject:self.orderItemPO.productName
              forKey:@"desc"];
    [muDic setObject:self.orderItemPO.pictureSmallUrl
              forKey:@"img_url"];
    [muDic setObject:self.orderDetail.orderPayAmount
              forKey:@"price"];
    [muDic setObject:[NSString stringWithFormat:@"订单号:%@", self.orderDetail.orderCode]
              forKey:@"order_title"];
    
    ChatViewController *vc = [[ChatViewController alloc] initWithChatter:kCustomerHXId
                                                                    type:eAfterSaleType];
    vc.commodityInfo = [muDic copy];

    [self.navigationController pushViewController:vc
                                         animated:YES];
    
//    QQApiWPAObject *wpaObj = [QQApiWPAObject objectWithUin:kCustomerQQForHotel];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:wpaObj];
//    [QQApiInterface sendReq:req];
    
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //    [self handleSendResult:sent];
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

- (HYHotelOrderItemPO *)orderItemPO
{
    if (!_orderItemPO)
    {
        _orderItemPO = self.orderDetail.orderItemPOList[0];
    }
    return _orderItemPO;
}

- (HYHotelGuestPO *)guestPO
{
    if (!_guestPO)
    {
        _guestPO = self.orderDetail.guestPOList[0];
    }
    return _guestPO;
}

- (HYDeliveryAddressPO *)deliveryAddressPO
{
    if (!_deliveryAddressPO)
    {
        _deliveryAddressPO = self.orderDetail.deliveryAddressPOList[0];
    }
    return _deliveryAddressPO;
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    switch (section)
    {
        case 0:
            if (self.userInfo.userType == Enterprise_User)  //企业用户不可以删除订单
            {
                if ((self.hotelOrder.status<Cancel) && (self.hotelOrder.orderType==0))  //如果订单是企业订单，并且可以取消，则可以取消
                {
                    count = 9;
                }
                else
                {
                    count = 8;
                }
            }
            else
            {
                count = 9;
            }
            break;
        case 1:
            count = 7;
            break;
        case 2:
            count = 5;
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 35;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 8)
        {
            height = 50;
        }
    }
    else if (indexPath.section == 3)
    {
        return 60;
    }
    return height;
//    if (indexPath.section == 0)
//    {
//        if (indexPath.row == 0)
//        {
//            height = 82;
//        }
//        else if (indexPath.row == 1)
//        {
//            height = 58;
//        }
//        else
//        {
//            height = 44;
//        }
//    }
//    else if (indexPath.section == 1)
//    {
//        height = 44;
//    }
//    else if (indexPath.section == 2)
//    {
//        if (indexPath.row == 0)
//        {
//            height = 44;
//        }
//        else if (indexPath.row == 1)
//        {
//            height = 82;
//        }
//        else
//        {
//            height = 88;
//        }
//    }
//    else
//    {
//        if (self.orderDetail.invoiceTitle)
//        {
//            height = 130;
//        }
//        else
//        {
//            height = 100;
//        }
//    }
    
//    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    v.backgroundColor = [UIColor colorWithWhite:.93 alpha:1];
    return v;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -1 && [cell isKindOfClass:[HYBaseLineCell class]])
    {
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *orderTitleId = @"orderTitleId";
            HYBaseLineCell *orderTitleCell = [tableView dequeueReusableCellWithIdentifier:orderTitleId];
            orderTitleCell.textLabel.text = @"订单信息";
            return orderTitleCell;
        }
        else if (indexPath.row == 8)
        {
            HYHotelOrderDetailHandleCell *handleCell = [tableView dequeueReusableCellWithIdentifier:@"orderHandleId"];
            handleCell.userInfo = self.userInfo;
            handleCell.orderDetail = self.orderDetail;
            [handleCell.handelBtn addTarget:self
                                     action:@selector(handleOrder)
                           forControlEvents:UIControlEventTouchUpInside];
            return handleCell;
        }
        else
        {
            HYHotelOrderDetailInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"orderInfoId"];
            if (indexPath.row == 1)
            {
                infoCell.infoName = @"订单状态:";
                infoCell.infoValue = self.orderDetail.orderStatusDesc;
            }
            else if (indexPath.row == 2)
            {
                infoCell.infoName = @"订单总额:";
                infoCell.infoValue = [NSString stringWithFormat:@"￥%@", self.orderDetail.orderTotalAmount];
                infoCell.isRed = YES;
            }
            else if (indexPath.row == 3)
            {
                infoCell.infoName = @"赠送现金券:";
                infoCell.infoValue = [NSString stringWithFormat:@"%@", self.orderItemPO.points];
                infoCell.isRed = YES;
            }
            else if (indexPath.row == 4)
            {
                infoCell.infoName = @"订单号:";
                infoCell.infoValue = self.orderDetail.orderCode;
            }
            else if (indexPath.row == 5)
            {
                infoCell.infoName = @"预订日期:";
                infoCell.infoValue = self.orderDetail.creationTime;
            }
            else if (indexPath.row == 6)
            {
                infoCell.infoName = @"支付方式:";
                infoCell.infoValue = self.orderDetail.payTypeDesc;
            }
            else if (indexPath.row == 7)
            {
                infoCell.infoName = @"担保情况";
                infoCell.infoValue = self.orderItemPO.guaranteeType;
            }
            return infoCell;
        }
    }
    else if (indexPath.section == 3)
    {
        HYMineInfoServiceCell *serviceCell = [tableView dequeueReusableCellWithIdentifier:@"service"];
        if (!serviceCell)
        {
            serviceCell = [[HYMineInfoServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"service"];
        }
        serviceCell.delegate = self;
        return serviceCell;
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            static NSString *orderTitleId = @"orderTitleId";
            HYBaseLineCell *orderTitleCell = [tableView dequeueReusableCellWithIdentifier:orderTitleId];
            orderTitleCell.textLabel.text = @"酒店信息";
            return orderTitleCell;
        }
        else if (indexPath.row == 1 || indexPath.row == 5 || indexPath.row == 6)
        {
            HYHotelOrderDetailAccessoryCell *accessoryCell = [tableView dequeueReusableCellWithIdentifier:@"accInfoId"];
            if (indexPath.row == 1) //酒店名
            {
                accessoryCell.icon.image = [UIImage imageNamed:@""];
                accessoryCell.infoLabl.text = self.orderItemPO.productName;
            }
            else if (indexPath.row == 5)    //酒店地址
            {
                accessoryCell.icon.image = [UIImage imageNamed:@"icon_hotel_address"];
                accessoryCell.infoLabl.text = self.orderItemPO.address;
            }
            else if (indexPath.row == 6)    //电话
            {
                accessoryCell.icon.image = [UIImage imageNamed:@"phone_icon"];
                accessoryCell.infoLabl.text = self.orderItemPO.telephone;
            }
            return accessoryCell;
        }
        else
        {
            HYHotelOrderDetailInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"orderInfoId"];
            if (indexPath.row == 2)
            {
                infoCell.infoName = self.orderItemPO.roomName;
                infoCell.infoValue = [NSString stringWithFormat:@"%@间", self.orderItemPO.quantity];
            }
            else if (indexPath.row == 3)
            {
                infoCell.infoName = @"入住时间";
                if (self.orderDetail.startTimeSpan && self.orderDetail.endTimeSpan)
                {
                    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
                    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *start = [fmt dateFromString:self.orderDetail.startTimeSpan];
                    NSDate *end = [fmt dateFromString:self.orderDetail.endTimeSpan];
                    NSString *checkInDate = [NSString stringWithFormat:@"%@-%@",
                                             [start localDescription],[end localDescription]];
                    infoCell.infoValue = checkInDate;
                }
                
            }
            else if (indexPath.row == 4)
            {
                infoCell.infoName = @"最晚到店时间";
                infoCell.infoValue = self.orderDetail.latestArrivalTime;
            }
            return infoCell;
        }
    }
    else
    {
        
        if (indexPath.row == 0)
        {
            static NSString *orderTitleId = @"orderTitleId";
            HYBaseLineCell *orderTitleCell = [tableView dequeueReusableCellWithIdentifier:orderTitleId];
            orderTitleCell.textLabel.text = @"其他信息";
            return orderTitleCell;
        }
        else
        {
            HYHotelOrderDetailInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"orderInfoId"];
            if (indexPath.row == 1)
            {
                infoCell.infoName = @"入住人:";
                infoCell.infoValue = self.guestPO.name;
            }
            else if (indexPath.row == 2)
            {
                infoCell.infoName = @"联系人:";
                infoCell.infoValue = self.orderDetail.contactName;
            }
            else if (indexPath.row == 3)
            {
                infoCell.infoName = @"特殊要求:";
                infoCell.infoValue = self.orderDetail.remark;
            }
            else if (indexPath.row == 4)
            {
                infoCell.infoName = @"发票:";
                infoCell.infoValue = [NSString stringWithFormat:@"%@ %@",self.orderDetail.invoiceTitle,self.deliveryAddressPO.remark];
            }
            return infoCell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        HYHotelListSummary *hSummary = [[HYHotelListSummary alloc] init];
        hSummary.productId = self.orderItemPO.productId;
        hSummary.productName = self.orderItemPO.productName;
        hSummary.address = self.orderItemPO.address;

        HYHotelCityInfo *city = [[HYHotelCityInfo alloc] init];
        city.cityId = self.orderItemPO.cityId;
        city.cityName = self.orderItemPO.cityName;
        
        HYHotelDetailViewController *vc = [[HYHotelDetailViewController alloc] init];
        vc.navbarTheme = self.navbarTheme;
        vc.hotleSummary = hSummary;
        vc.hotleCity = city;
//        vc.checkInDate = self.orderDetail.startTimeSpanDate;
//        vc.checkOutDate = self.orderDetail.endTimeSpanDate;
        NSDate *today = [NSDate date];
        NSDate *tomorow = [today dateByAddingTimeInterval:(60*60*24)];
        NSString *todays = [PTDateFormatrer stringFromDate:today format:@"yyyy-MM-dd"];
        NSString *tommorows = [PTDateFormatrer stringFromDate:tomorow format:@"yyyy-MM-dd"];
        vc.checkInDate = todays;
        vc.checkOutDate = tommorows;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 5)
    {
        if (self.orderItemPO.lat.length > 0 && self.orderItemPO.lon.length > 0)
        {
            HYHotelMapViewController *mapV = [[HYHotelMapViewController alloc] init];
            //mapV.hotelInfo = self.hotelInfoDetail;
            mapV.showAroundShops = YES;
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.orderItemPO.lat.doubleValue, self.orderItemPO.lon.doubleValue);
            mapV.location = location;
            mapV.annotationTitle = self.orderItemPO.productName;
            mapV.navbarTheme = self.navbarTheme;
            mapV.coorType = HYCoorGeneral;
            [self.navigationController pushViewController:mapV animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"酒店地理信息为空，地图暂不可用。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (indexPath.section == 1 && indexPath.row == 6)
    {
        NSString *phone = self.orderItemPO.telephone;
        if (phone.length > 0)
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"联系酒店客服"
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:[NSString stringWithFormat:@"拨打电话%@", phone]
                                          otherButtonTitles:nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            actionSheet.tag = 100;
            [actionSheet showInView:self.view];
        }
    }
}

- (void)handleOrder
{
    /*
     //预付得暂时不支持取消 9.26
     if (self.orderDetail.status!=Unpaid &&
     (self.orderDetail.status == Failed || self.orderDetail.status >= Cancel))  //删除订单
     */
    if (self.orderDetail.status == Failed || self.orderDetail.status >= Cancel)  //删除订单
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定删除该订单?"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"删除", nil];
        alert.tag = 10;
        [alert show];
    }
    else  //取消订单
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"确定取消该酒店订单？"
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"done", nil), nil];
        [alertView show];
    }
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (actionSheet.tag == 100)
        {
            NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"telprompt:%@", self.orderItemPO.telephone]];
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSURL *url = [[NSURL alloc] initWithString:@"telprompt:4008066528"];
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if (alertView.tag == 10)
        {
            [self deleteHotelOrder];
        }
        else
        {
            [self cancelHotelOrder];
        }
    }
}

- (void)didClickPhone
{
    [self callCustomnerService];
}
- (void)didClickQQ
{
    [self connectOnlineCustomnerService];
}

@end
