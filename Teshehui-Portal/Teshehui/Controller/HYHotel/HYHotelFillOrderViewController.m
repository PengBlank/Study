//
//  HYHotelOrderViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelFillOrderViewController.h"
#import "HYHotelFillOrderCell.h"
#import "HYHotelFillUserEmailInfoCell.h"
#import "HYHotelFillOrderSummaryCell.h"
#import "HYHotelOrderSettingCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "NSString+Addition.h"
#import "NSDate+Addition.h"
#import "METoast.h"
#import "HYHotelOrderResultViewController.h"
#import "HYPassengerListViewController.h"
#import "HYPaymentViewController.h"
#import "HYHotelFillOrderFooterView.h"
#import "HYPassengers.h"
#import "HYUserInfo.h"
#import "HYLoadHubView.h"
#import "HYAppDelegate.h"
#import "HYHotelPaymentFootView.h"

#import "HYHotelOrderRequest.h"
#import "HYHotelOrderResponse.h"

#import "HYHotelValidRequest.h"
#import "HYHotelValidResponse.h"
#import "HYHotelInvoiceViewController.h"
#import "Masonry.h"

@interface HYHotelFillOrderViewController ()
<
ABPeoplePickerNavigationControllerDelegate,
HYPassengerDelegate>
{
    HYHotelOrderRequest *_orderRequest;
    HYHotelValidRequest *_orderVaildRequest;

//    UILabel *_priceLab;
//    UILabel *_pointLab;
//    UIButton *_orderBtn;
    HYHotelPaymentFootView *_paymentView;
    BOOL _guarantee;
    BOOL _isEdit;
    BOOL _isOrdering;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYPickerToolView *pickerView;
@property (nonatomic, strong) HYHotelFillOrderFooterView *tableFooterView;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) CGFloat amountBeforeTax;

@property (nonatomic, copy) NSString *lastArrivalTime;
@property (nonatomic, copy) NSString *arrivalTimeShow;
@property (nonatomic, copy) NSString *spacialContent;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *orderSpecial;  //担保和预付的特殊说明

@property (nonatomic, strong) NSArray *hotelGuest;
@property (nonatomic, strong) NSArray *times;

@property (nonatomic, strong) HYUserInfo *userInfo;
@property (nonatomic, assign) HYSpendingPatterns spendPattern;  //消费方式
@property (nonatomic, strong) HYPickerToolView *spPickerView;

@property (nonatomic, strong) HYHotelInvoiceModel *invoiceModel;    //发票

- (NSString *)arrivalTime;
@end

@implementation HYHotelFillOrderViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_orderRequest cancel];
    _orderRequest = nil;
    
    [_orderVaildRequest cancel];
    _orderVaildRequest = nil;
    
    [HYLoadHubView dismiss];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _quantity = 1;
        _guarantee = NO;
        _isEdit = NO;
        _isOrdering = NO;
        _spendPattern = Undefind_SP;
        
        self.contact = [[HYUserInfo getUserInfo] realName];
        self.phone = [[HYUserInfo getUserInfo] mobilePhone];
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
    frame.size.height -= 45.0;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionFooterHeight = 10;
    tableview.sectionHeaderHeight = 0;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"hotel_order_fill", nil);
    self.amountBeforeTax = [self.roomInfo.price floatValue];
    self.times = @[@"18:00之前", @"22:00之前", @"23:59之前", @"凌晨06:00之前"];
    
    //foot 下单
    _paymentView = [[HYHotelPaymentFootView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 44, self.view.frame.size.width, 44)];
    _paymentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_paymentView];
    
    NSString *orderTitle = self.roomInfo.isPrePay ? @"预付" : @"预订";
    [_paymentView.orderBtn setTitle:orderTitle forState:UIControlStateNormal];
    [_paymentView.orderBtn addTarget:self action:@selector(orderHotel:) forControlEvents:UIControlEventTouchUpInside];
    _paymentView.price = [NSString stringWithFormat:@"%@", @(_roomInfo.averageFee)];
    _paymentView.points = _roomInfo.points;
    
    [self initDefLateArrivalTime];
    
    if ([self.lastArrivalTime length] > [self.checkInDate length])
    {
        NSString *time = [self.lastArrivalTime substringWithRange:NSMakeRange([self.checkInDate length], 6)];
        self.arrivalTimeShow = [NSString stringWithFormat:@"%@前", time];
    }

    [self verifyOrderVaild];
    [self updatePriceInfo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_pickerView dismissWithAnimation:NO];
    [_spPickerView dismissWithAnimation:NO];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (![self.view window])
    {
        [_paymentView removeFromSuperview];
        
        [_tableView removeFromSuperview];
        _tableView = nil;
        
        self.view = nil;
    }
}

- (void)backToRootViewController:(id)sender
{
    if (_isEdit)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"您的订单尚未填写完成，是否确定要离开当前页面"
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"done", nil), nil];
        
        [alertView show];
    }
    else
    {
        [super backToRootViewController:sender];
    }
}

#pragma mark private methods
- (void)updatePriceInfo
{
    CGFloat price = self.amountBeforeTax;
    _paymentView.price = [NSString stringWithFormat:@"%@", @(price)];
    _paymentView.points = [NSString stringWithFormat:@"%.0f", price];
}

- (void)initDefLateArrivalTime
{
    //关于最晚到店时间的策略是，如果在房间的价格计划中有则使用，如果没有，则判读是否早于当前本地时间，如果
//    self.lastArrivalTime = [self.roomInfo.selectRate lateArriveTime];
    
    if (!self.lastArrivalTime)
    {
        NSDate *nowTime = [NSDate date];
        BOOL earlierDate = NO;
        NSArray *array = @[@"18:00:00", @"22:00:00", @"23:59:00"];
        NSInteger index = 0;
        while (!earlierDate && index<[array count])
        {
            NSString *str = [array objectAtIndex:index];
            self.lastArrivalTime = [NSString stringWithFormat:@"%@ %@", self.checkInDate, str];
            NSDate *date = [NSDate formateDateWithString:self.lastArrivalTime];
            earlierDate = ([date timeIntervalSinceDate:nowTime] > 0);//(60*30));
            index++;
        }
        
        //超过凌晨12点, 就是第二天凌晨六点
        if (!earlierDate && index>=[array count])
        {
            NSDate *date = [NSDate date];
            NSString *string = [date timeDescription];
            self.lastArrivalTime =  [NSString stringWithFormat:@"%@ 06:00:00", string];
        }
    }
}

//检查酒店是否可订
- (void)verifyOrderVaild
{
    [HYLoadHubView show];
    
    self.orderSpecial = nil;
    
    if (_orderVaildRequest)
    {
        [_orderVaildRequest cancel];
        _orderVaildRequest = nil;
    }
    
    _orderVaildRequest = [[HYHotelValidRequest alloc] init];
    _orderVaildRequest.productSKUId = self.roomInfo.productSKUId;
    _orderVaildRequest.hotelRoomTypeId = self.roomInfo.commonRoomTypeId;
    _orderVaildRequest.latestArrivalTime = self.arrivalTime;
//    _orderVaildRequest.startDate = self.checkInDate;
//    _orderVaildRequest.endDate = self.checkOutDate;
    _orderVaildRequest.roomNumber = [NSString stringWithFormat:@"%ld",self.quantity];
    _orderVaildRequest.customerNumber = [NSString stringWithFormat:@"%ld",self.quantity];
    
    //现在可订检查不需要这些参数
//    if (self.invoiceModel)
//    {
//        _orderVaildRequest.shippingMethodId = self.invoiceModel.method.shippingMethodId;
//    }
    
    __weak typeof(self) b_self = self;
    [_orderVaildRequest sendReuqest:^(id result, NSError *error) {
        
        HYHotelValidResponse *response = nil;
        if ([result isKindOfClass:[HYHotelValidResponse class]])
        {
            response = (HYHotelValidResponse *)result;
        }
        
        [b_self updateRoomSaleStatusWithReponse:response
                                          error:error];
    }];
}

- (void)updateRoomSaleStatusWithReponse:(HYHotelValidResponse *)response error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"该时间段该房型不可订，请修改入住日期和到店时间或重新选择房型\n该房型暂不可订，请重新查询"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else
    {
        CGFloat amountBeforeTax = response.totalAmount;
        CGFloat shipFee = self.invoiceModel.method.shippingMethodFee;   //发票配送价
        if (amountBeforeTax > 0)
        {
            self.amountBeforeTax = amountBeforeTax;
            if (shipFee > 0)
            {
                self.amountBeforeTax += shipFee;
            }
            [self updatePriceInfo];
        }
        
        //更新时间段，和担保信息
        if (response.productTypeCode <= 1 && response.guaranteeAmount <= 0)  //不需要担保
        {
            _guarantee = NO;
            
            if (self.roomInfo.isPrePay)  //预付
            {
                self.orderSpecial = response.guaranteeDescription;
                
                [_paymentView.orderBtn setTitle:@"支付"
                           forState:UIControlStateNormal];
            }
            else
            {
                [_paymentView.orderBtn setTitle:NSLocalizedString(@"submit_order", nil)
                           forState:UIControlStateNormal];
            }
        }
        else  //需要担保
        {
            self.orderSpecial = response.guaranteeDescription;
            
            if (self.roomInfo.isPrePay)
            {
                [_paymentView.orderBtn setTitle:@"支付"
                           forState:UIControlStateNormal];
            }
            else
            {
                _guarantee = YES;
                [_paymentView.orderBtn setTitle:NSLocalizedString(@"guarantee", nil)
                           forState:UIControlStateNormal];
            }
        }
        
        if ([self.orderSpecial length] > 0)
        {
            [_tableFooterView setHidden:NO];
            
            CGSize size = [self.orderSpecial sizeWithFont:self.tableFooterView.descLab.font
                                        constrainedToSize:CGSizeMake(ScreenRect.size.width-30, 120)];
            CGRect frame = self.tableFooterView.frame;
            if (frame.size.height < (size.height+30))
            {
                frame.size.height = (size.height+30);
                self.tableFooterView.frame = frame;
            }
            
            self.tableFooterView.descLab.text = self.orderSpecial;
            self.tableView.tableFooterView = self.tableFooterView;
        }
        else
        {
            [_tableFooterView setHidden:YES];
        }
        
        [self.tableView reloadData];
    }
}

/*
- (void)updateRoomSaleStatus:(BOOL)stauts
             AmountBeforeTax:(CGFloat)AmountBeforeTax
                   guarantee:(HYHotelGuaranteePayment *) Guarantee
{
    [HYLoadHubView dismiss];
    
    if (!stauts)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"该时间段该房型不可订，请修改入住日期和到店时间或重新选择房型\n该房型暂不可订，请重新查询"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else
    {
        if (AmountBeforeTax > 0)
        {
            self.AmountBeforeTax = AmountBeforeTax;
            [self updatePriceInfo];
        }
        
        //更新时间段，和担保信息
        if (!Guarantee)  //不需要担保
        {
            _guarantee = NO;
            self.times = @[@"18:00之前", @"22:00之前", @"23:59之前", @"凌晨06:00之前"];
            //@[self.arrivalTimeShow, @"23:59之前", @"凌晨06:00之前"];
            
            if (self.roomInfo.ratePlan.isPrePay)
            {
                [_orderBtn setTitle:@"支付"
                           forState:UIControlStateNormal];
            }
            else
            {
                [_orderBtn setTitle:NSLocalizedString(@"submit_order", nil)
                           forState:UIControlStateNormal];
            }
        }
        else  //需要担保
        {
            if (self.roomInfo.ratePlan.isPrePay)
            {
                [_orderBtn setTitle:@"支付"
                           forState:UIControlStateNormal];
            }
            else
            {
                _guarantee = YES;
                
                [_orderBtn setTitle:NSLocalizedString(@"guarantee", nil)
                           forState:UIControlStateNormal];
            }
 
//            self.times = @[self.arrivalTimeShow,
//                           [NSString stringWithFormat:@"23:59之前(担保￥%@)",Guarantee.Amount],
//                           [NSString stringWithFormat:@"凌晨06:00之前(担保￥%@)",Guarantee.Amount]];
 
            self.times = @[@"18:00之前", @"22:00之前", @"23:59之前", @"凌晨06:00之前"];
        }
        
        [self.tableView reloadData];
    }
}
*/

- (BOOL)checkVailedNmber
{
    if (self.phone.length > 0)
    {
        return [self.phone checkPhoneNumberValid];
    }
    
    return NO;
}

- (NSString *)arrivalTime
{
    return self.lastArrivalTime;
}

- (void)orderHotel:(id)sender
{
    BOOL _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (!_isLogin)
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
    else
    {
        //校验数据的完整性
        if (!_isOrdering)
        {
            BOOL hasName = ([self.contact length] > 0);
            
            if (!hasName)
            {
                [METoast toastWithMessage:@"请填写联系人姓名"];
            }
            else if (self.userInfo.enterpriseId.intValue>0 && self.spendPattern<=Undefind_SP)
            {
                [self.spPickerView showWithAnimation:YES];
            }
            else if (! [self checkVailedNmber])
            {
                [METoast toastWithMessage:@"请输入正确的手机号码"];
            }
            else if (self.hotelGuest.count <= 0)
            {
                [METoast toastWithMessage:@"请添加入住人"];
            }
            else
            {
                //担保
                if (_guarantee)
                {
                    HYHotelCreditCardViewController *vc = [[HYHotelCreditCardViewController alloc] init];
                    vc.hotelInfo = self.hotelInfo;
                    vc.roomInfo = self.roomInfo;
                    vc.checkInDate = self.checkInDate;
                    vc.checkOutDate = self.checkOutDate;
                    vc.price = self.amountBeforeTax;
                    vc.contact = self.contact;
                    vc.phoneNumber = self.phone;
                    vc.hotelGuest = self.hotelGuest;
                    vc.spacialContent = self.spacialContent;
                    vc.quantity = self.quantity;
                    vc.arrivalTime = [self arrivalTime];
                    vc.lastArrivalTime = self.lastArrivalTime;
                    vc.navbarTheme = self.navbarTheme;
                    vc.spendPattern = self.spendPattern;
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                }
                else
                {
                    _isOrdering = YES;
                    
                    [HYLoadHubView  show];
                    
                    _orderRequest = [[HYHotelOrderRequest alloc] init];
                    _orderRequest.userId = self.userInfo.userId;
                    _orderRequest.price = self.roomInfo.price;
                    _orderRequest.quantity = self.quantity;
                    _orderRequest.startTimeSpan = self.checkInDate;
                    _orderRequest.endTimeSpan = self.checkOutDate;
                    _orderRequest.latestArrivalTime = self.lastArrivalTime;
                    _orderRequest.contactName = self.contact;
                    _orderRequest.contactPhone = self.phone;
                    _orderRequest.contactEmail = self.email;
                    _orderRequest.productSKUCode = self.roomInfo.productSKUId;
                    _orderRequest.latestArrivalTime = self.lastArrivalTime;
                    _orderRequest.guestPOList = self.hotelGuest;
                    _orderRequest.remark = self.spacialContent;
                    
                    if (self.spendPattern == Enterprise_SP)
                    {
                        _orderRequest.isEnterprise = self.userInfo.enterpriseId;
                    }
                    
                    //预付
                    if (self.roomInfo.isPrePay)
                    {
                        _orderRequest.contactEmail = self.email;
                        _orderRequest.invoiceModel = self.invoiceModel;
                        _orderRequest.isNeedInvoice = self.invoiceModel != nil;
                    }
                    
                    __weak typeof(self) b_self = self;
                    [_orderRequest sendReuqest:^(id result, NSError *error)
                     {
                         
                         HYHotelOrderBase *order = nil;
                         
                         if (!error && [result isKindOfClass:[HYHotelOrderResponse class]])
                         {
                             HYHotelOrderResponse *response = (HYHotelOrderResponse *)result;
                             if (response.orders.count > 0)
                             {
                                 order = response.orders[0];
                             }
                         }
                         
                         //界面更新
                         [b_self showOrderResult:order error:(NSError *)error];
                     }];
                }
            }
        }
    }
}

- (void)showOrderResult:(HYHotelOrderBase *)order error:(NSError *)error
{
    _isOrdering = NO;
    [HYLoadHubView dismiss];
    
    if (order)
    {
        if (order.isPrePay && order.status == Unpaid)  //预付酒店
        {
            HYAlipayOrder *aliOrder = [[HYAlipayOrder alloc] init];
            aliOrder.partner = PartnerID;
            aliOrder.seller = SellerID;
            
            NSMutableString* nameStr = [[NSMutableString alloc]initWithCapacity:0];
            [nameStr appendString:@"【特奢酒店】订单编号:"];
            
            aliOrder.tradeNO = order.orderCode; //订单号（由商家自行制定）
            aliOrder.productName = [NSString stringWithFormat:@"%@%@",nameStr,order.orderCode]; //商品标题
            aliOrder.productDescription = [NSString stringWithFormat:@"%@%@",nameStr,order.orderCode]; //商品描述
            aliOrder.amount = [NSString stringWithFormat:@"%0.2f", order.orderTotalAmount.floatValue]; //商品价格
            
            HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
            payVC.navbarTheme = self.navbarTheme;
            payVC.alipayOrder = aliOrder;
            payVC.amountMoney = order.orderTotalAmount;
            payVC.orderID = order.orderId;
            payVC.orderCode = order.orderCode;
            payVC.type = Pay_Hotel;
            [self.navigationController pushViewController:payVC animated:YES];
        }
        else
        {
            HYHotelOrderResultViewController *vc = [[HYHotelOrderResultViewController alloc] init];
            vc.hotelOrder = order;
            vc.hotelInfo = self.hotelInfo;
            vc.navbarTheme = self.navbarTheme;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
    }
    else if(error)
    {
        [METoast toastWithMessage:error.domain];
    }
}

- (void)showRoomQuantitySetting
{
    self.pickerView.dataSouce = @[@"1间", @"2间", @"3间", @"4间", @"5间", @"6间", @"7间", @"8间"];
    self.pickerView.title = @"房间数";
    self.pickerView.pType = HotelRoomCount;
    [self.pickerView showWithAnimation:YES];
}

- (void)showArrivalTimeSettingView
{
    self.pickerView.dataSouce = self.times;
    self.pickerView.title = @"到店时间";
    self.pickerView.pType = HotelArrivalTime;
    [self.pickerView showWithAnimation:YES];
}

#pragma mark getter
- (HYPickerToolView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[HYPickerToolView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        _pickerView.delegate = self;
    }
    
    return _pickerView;
}

- (HYUserInfo *)userInfo
{
    if (!_userInfo)
    {
        _userInfo = [HYUserInfo getUserInfo];
    }
    
    return _userInfo;
}

- (HYPickerToolView *)spPickerView
{
    if (!_spPickerView)
    {
        _spPickerView = [[HYPickerToolView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 260)];
        _spPickerView.delegate = self;
        _spPickerView.dataSouce = @[@"个人消费", @"企业消费"];
        _spPickerView.title = @"选择消费种类";
    }
    
    return _spPickerView;
}

- (HYHotelFillOrderFooterView *)tableFooterView
{
    if (!_tableFooterView)
    {
        _tableFooterView = [[HYHotelFillOrderFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    }
    
    return _tableFooterView;
}

#pragma mark - HYPassengerDelegate
- (void)didSelectPassengers:(NSArray *)passengers
{
    
    self.hotelGuest = passengers;
    [self.tableView reloadData];
}

#pragma mark - HYPickerToolViewDelegate
- (void)selectComplete:(HYPickerToolView *)pickerView
{
    if (pickerView == _pickerView)
    {
        switch (pickerView.pType)
        {
            case HotelRoomCount:
                self.quantity = (pickerView.currentIndex+1);
                
                //如果把房间数量变小
                if (self.quantity < [self.hotelGuest count])
                {
                    NSMutableArray *muTempArr = [[NSMutableArray alloc] initWithArray:self.hotelGuest];
                    NSRange range = NSMakeRange(self.quantity, [self.hotelGuest count]-self.quantity);
                    [muTempArr removeObjectsInRange:range];
                    
                    self.hotelGuest = [muTempArr copy];
                }

                //更新金额
                [self updatePriceInfo];
                
                //查询担保情况
                [self verifyOrderVaild];
                break;
            case HotelArrivalTime:
            {
                NSString *str = [pickerView.dataSouce objectAtIndex:pickerView.currentIndex];
                self.arrivalTimeShow = str;
                NSArray *array = @[@"18:00:00", @"22:00:00", @"23:59:00"];
                
                if (pickerView.currentIndex < [array count])
                {
                    NSString *time = [array objectAtIndex:pickerView.currentIndex];
                    self.lastArrivalTime = [NSString stringWithFormat:@"%@ %@", self.checkInDate, time];
                }
                else
                {
                    //超过凌晨12点, 就是第二天凌晨六点
                    NSCalendar *cal = [NSCalendar currentCalendar];
                    NSDate *date = [NSDate dateFromString:self.checkInDate];
                    NSUInteger unit = NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
                    NSDateComponents *components = [cal components:unit fromDate:date];
                    [components setDay:([components day] + 1)];
                    NSDate *nextDay = [cal dateFromComponents:components];
                    NSString *string = [nextDay timeDescription];
                    self.lastArrivalTime =  [NSString stringWithFormat:@"%@ 06:00:00", string];
                }
                
                //查询酒店的到店时间
                [self verifyOrderVaild];
            }
                break;
            default:
                break;
        }
        
        [self.tableView reloadData];
    }
    else
    {
        switch (pickerView.currentIndex)
        {
            case 0:
                self.spendPattern = Personal_SP;
                break;
            case 1:
                self.spendPattern = Enterprise_SP;
                break;
            default:
                break;
        }
        
        [self.tableView reloadData];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person
{
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:NULL];
    
    CFStringRef chineseName = ABRecordCopyCompositeName(person);
    
    if ([(__bridge NSString *)chineseName length] > 0)
    {
        self.contact = (__bridge NSString *)chineseName;
    }
    else
    {
        ABMultiValueRef orgName = ABRecordCopyValue(person, kABPersonOrganizationProperty);
        
        if ([(__bridge NSString *)orgName length] > 0)
        {
            self.contact = (__bridge NSString *)orgName;
        }
        
        if (orgName)
            CFRelease(orgName);
    }
    
    if (chineseName)
    {
        CFRelease(chineseName);
    }
    
    //phones
    ABMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFArrayRef values = ABMultiValueCopyArrayOfAllValues(phoneMulti);
    
    if ([(__bridge NSArray*)values count] > 0)
    {
        NSString *number = [(__bridge NSArray*)values objectAtIndex:0];
        NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        self.phone = [[number componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    }
    
    if (values)
        CFRelease(values);
    if (phoneMulti)
        CFRelease(phoneMulti);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    if ([self.tableView cellForRowAtIndexPath:indexPath])
    {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
}

// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:NULL];
    
    CFStringRef chineseName = ABRecordCopyCompositeName(person);
    
    if ([(__bridge NSString *)chineseName length] > 0)
    {
        self.contact = (__bridge NSString *)chineseName;
    }
    else
    {
        ABMultiValueRef orgName = ABRecordCopyValue(person, kABPersonOrganizationProperty);
        
        if ([(__bridge NSString *)orgName length] > 0)
        {
            self.contact = (__bridge NSString *)orgName;
        }
        
        if (orgName)
            CFRelease(orgName);
    }
    
    if (chineseName)
    {
        CFRelease(chineseName);
    }
    
    //phones
    ABMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFArrayRef values = ABMultiValueCopyArrayOfAllValues(phoneMulti);
    
    if ([(__bridge NSArray*)values count] > 0)
    {
        NSString *number = [(__bridge NSArray*)values objectAtIndex:0];
        NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        self.phone = [[number componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    }
    
    if (values)
        CFRelease(values);
    if (phoneMulti)
        CFRelease(phoneMulti);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    if ([self.tableView cellForRowAtIndexPath:indexPath])
    {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
    
	return NO;
}

// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
								property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}

// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self.navigationController dismissViewControllerAnimated:YES
                                                  completion:NULL];
}

#pragma mark - HYHotelFillUserInfoCellDelegate
- (void)displayAllContacts
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];

    picker.peoplePickerDelegate = self;
	// Display only a person's phone, email, and birthdate
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
	picker.displayedProperties = displayedItems;
	// Show the picker
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)didNameInputComplete:(UITableViewCell *)cell;
{
    if ([cell isKindOfClass:[HYHotelFillUserInfoCell class]])
    {
        HYHotelFillUserInfoCell *userCell = (HYHotelFillUserInfoCell *)cell;
        self.contact = userCell.nameField.text;
        self.phone = userCell.phoneField.text;
    }
}

- (void)didSelectHotelPassenger
{
    HYPassengerListViewController *vc = [[HYPassengerListViewController alloc] init];
    vc.navbarTheme = self.navbarTheme;
    vc.delegate = self;
    vc.type = HotelGuest;
    vc.max = self.quantity;
    vc.selectPassengers = [self.hotelGuest mutableCopy];
    vc.navbarTheme = self.navbarTheme;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)cellBecomeFirstResponder:(UITableViewCell *)cell
{
    _isEdit = YES;

    CGRect frame = self.view.frame;
    if (cell.frame.origin.y+cell.frame.size.height > frame.size.height-266)
    {
        CGPoint offset = CGPointMake(0, (cell.frame.origin.y+cell.frame.size.height+286)-frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    if (section == 1)
    {
        count = 2;
    }
    else if (section == 2)
    {
        count = (self.userInfo.enterpriseId.intValue > 0) ? 4 : 3;
        if (self.roomInfo.isPrePay && [self.roomInfo.attributeValue1 isEqualToString:HotelRatePlanCrip])
        {
            count += 1;
        }
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    if (indexPath.section == 0)
    {
        height = 60.0;
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        height = self.quantity*32.0f+12;
    }
    else if (indexPath.section == 2 && indexPath.row == 0)
    {
        height = 88.0f;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    v.image = [[UIImage imageNamed:@"ticket_bg_gray_g5"] stretchableImageWithLeftCapWidth:2
                                                                             topCapHeight:4];
    
    return v;
}

//footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -1){
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *orderSummaryCellId = @"orderSummaryCellId";
        HYHotelFillOrderSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:orderSummaryCellId];
        if (cell == nil)
        {
            cell = [[HYHotelFillOrderSummaryCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                     reuseIdentifier:orderSummaryCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setHotelName:self.hotelInfo.productName];
        [cell setCheckInDate:self.checkInDate];
        [cell setCheckOutDate:self.checkOutDate];
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            static NSString *orderSettingCellId = @"orderSettingCellId";
            HYHotelOrderSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:orderSettingCellId];
            if (cell == nil)
            {
                cell = [[HYHotelOrderSettingCell alloc]initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:orderSettingCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            
            cell.textLabel.text = self.roomInfo.roomTypeName;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld间", self.quantity];
            return cell;
        }
        else
        {
            static NSString *fillOrderCellId = @"fillOrderCellId";
            HYHotelFillOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:fillOrderCellId];
            if (cell == nil)
            {
                cell = [[HYHotelFillOrderCell alloc]initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:fillOrderCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            
            cell.textLabel.text = NSLocalizedString(@"hotel_user", nil);
            cell.guests = self.hotelGuest;
            [cell setRoomCount:self.quantity];
            return cell;
        }
    }
    else    //section = 2
    {
        if (indexPath.row == 0)
        {
            static NSString *fillUserCellId = @"fillUserCellId";
            
            HYHotelFillUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:fillUserCellId];
            if (cell == nil)
            {
                cell = [[HYHotelFillUserInfoCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                     reuseIdentifier:fillUserCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            
            cell.nameField.text = self.contact;
            cell.phoneField.text = self.phone;
            return cell;
            /*
            //处理预付填写邮箱
            if (self.roomInfo.expandedResponse.isPrePay) //预付
            {
                HYHotelFillUserEmailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:fillUserCellId];
                if (cell == nil)
                {
                    cell = [[HYHotelFillUserEmailInfoCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                              reuseIdentifier:fillUserCellId];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                }
                
                cell.nameField.text = self.contact;
                cell.phoneField.text = self.phone;
                cell.emailField.text = self.email;
                return cell;
            }
            else
            {
                HYHotelFillUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:fillUserCellId];
                if (cell == nil)
                {
                    cell = [[HYHotelFillUserInfoCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                         reuseIdentifier:fillUserCellId];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                }
                
                cell.nameField.text = self.contact;
                cell.phoneField.text = self.phone;
                return cell;
            }
             */
        }
        else
        {
            static NSString *orderSettingCellId = @"orderSettingCellId";
            HYHotelOrderSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:orderSettingCellId];
            if (cell == nil)
            {
                cell = [[HYHotelOrderSettingCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                     reuseIdentifier:orderSettingCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            
            if (indexPath.row == 1)
            {
                cell.textLabel.text = NSLocalizedString(@"arrival_time", nil);
                cell.detailTextLabel.text = self.arrivalTimeShow;
            }
            else
            {
                NSInteger idx = self.userInfo.enterpriseId.intValue > 0 ? indexPath.row : indexPath.row + 1;
                if (idx == 2)
                {
                    cell.textLabel.text = @"消费类型";
                    
                    switch (self.spendPattern)
                    {
                        case Personal_SP:
                            cell.detailTextLabel.text = @"个人消费";
                            break;
                        case Enterprise_SP:
                            cell.detailTextLabel.text = @"企业消费";
                            break;
                        default:
                            cell.detailTextLabel.text = nil;
                            break;
                    }
                }
                else if (idx == 3)
                {
                    cell.textLabel.text = NSLocalizedString(@"special_request", nil);
                    cell.detailTextLabel.text = self.spacialContent;
                }
                else
                {
                    cell.textLabel.text = @"发票";
                    cell.detailTextLabel.text = _invoiceModel ? _invoiceModel.invoice_title : @"不需要";
                }
            }
            
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:2];
    HYHotelFillUserInfoCell *cell = (HYHotelFillUserInfoCell *)[self.tableView cellForRowAtIndexPath:index];
    [cell fieldResignFirstResponder];
    
    if (self.userInfo.enterpriseId.intValue <= 0)
    {
        if (indexPath.section==1 && indexPath.row==0)
        {
            [self showRoomQuantitySetting];
        }
        else if (indexPath.section==2 && indexPath.row==1)
        {
            [self showArrivalTimeSettingView];
        }
        else if (indexPath.section==2 && indexPath.row==2)
        {
            HYSpecialRequestViewController *vc = [[HYSpecialRequestViewController alloc] init];
            vc.delegate = self;
            vc.navbarTheme = self.navbarTheme;
            vc.content = self.spacialContent;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
        else if (indexPath.section == 2 && indexPath.row == 3)
        {
            HYHotelInvoiceViewController *invoice = [[HYHotelInvoiceViewController alloc] initWithNibName:@"HYHotelInvoiceViewController" bundle:nil];
            invoice.needInvoice = _invoiceModel != nil;
            invoice.invoiceModel = self.invoiceModel;
            invoice.navbarTheme = self.navbarTheme;
            __weak typeof(self) b_self = self;
            invoice.invoiceCallback = ^(HYHotelInvoiceModel *model)
            {
                b_self.invoiceModel = model;
                [b_self.tableView reloadData];
                //查询担保情况
                [b_self verifyOrderVaild];
            };
            [self.navigationController pushViewController:invoice animated:YES];
        }
    }
    else
    {
        if (indexPath.section==1 && indexPath.row==0)
        {
            [self showRoomQuantitySetting];
        }
        else if (indexPath.section==2 && indexPath.row==1)
        {
            [self showArrivalTimeSettingView];
        }
        else if (indexPath.section==2 && indexPath.row==2)
        {
            [self.spPickerView showWithAnimation:YES];
        }
        else if (indexPath.section==2 && indexPath.row==3)
        {
            HYSpecialRequestViewController *vc = [[HYSpecialRequestViewController alloc] init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
        else if (indexPath.section == 2 && indexPath.row == 4)
        {
            HYHotelInvoiceViewController *invoice = [[HYHotelInvoiceViewController alloc] initWithNibName:@"HYHotelInvoiceViewController" bundle:nil];
            invoice.needInvoice = _invoiceModel != nil;
            invoice.invoiceModel = self.invoiceModel;
            invoice.navbarTheme = self.navbarTheme;
            __weak typeof(self) b_self = self;
            invoice.invoiceCallback = ^(HYHotelInvoiceModel *model)
            {
                b_self.invoiceModel = model;
                [b_self.tableView reloadData];
                //查询担保情况
                [b_self verifyOrderVaild];
            };
            [self.navigationController pushViewController:invoice animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging)
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:2];
        HYHotelFillUserInfoCell *cell = (HYHotelFillUserInfoCell *)[self.tableView cellForRowAtIndexPath:index];
        [cell fieldResignFirstResponder];
    }
}

#pragma mark - HYSpecialRequestViewControllerDelegale
- (void)specialInputComplete:(NSString *)content
{
    self.spacialContent = content;
    [self.tableView reloadData];
}
@end
