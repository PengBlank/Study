//
//  HYFlightOrderViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "HYFlightFillOrderViewController.h"
#import "HYFlightOrderRequest.h"
#import "HYCheckChildTicketReqeust.h"
#import "HYFlightGetJourneyPriceReq.h"
#import "HYFlightStockReqeust.h"

#import "HYCabins.h"
#import "HYFlightCity.h"
#import "HYFlightDetailInfo.h"
#import "HYUserInfo.h"
#import "HYPassengers.h"
#import "METoast.h"
#import "HYLoadHubView.h"
#import "HYFlightFillOrderSummaryCell.h"
#import "HYFlightFillOrderCabinInfoCell.h"
#import "HYFlightPassengerCell.h"
#import "HYFlightAddPassengerCell.h"
#import "HYFlightOrderHeaderView.h"
#import "HYPassengerListViewController.h"
#import "HYFlightInvoiceViewController.h"
#import "HYDeliveryAddressViewController.h"
#import "HYPickerToolView.h"
#import "HYEidtPassengerViewController.h"
#import "HYAddressInfo.h"
#import "HYBaseLineCell.h"
#import "HYLoadHubView.h"
#import "HYFlightOrder.h"
#import "HYPaymentViewController.h"
#import "HYFlightPaymentSelectViewController.h"
#import "HYAppDelegate.h"
#import "HYFlightInvoiceCell.h"



#define kFlightPhoneNumber @"flightPhoneNumber"

@interface HYFlightFillOrderViewController ()
<
ABPeoplePickerNavigationControllerDelegate,
UITextFieldDelegate,
UIAlertViewDelegate,
HYFlightInvoiceDelegate,
HYPassengerDelegate,
HYPickerToolViewDelegate,
HYFlightOrderCabinInfoCellDelegate,
HYFlightPassengerCellDelegate,
DeliverAdreeDelegate
>
{
    HYFlightOrderRequest *_orderRequest;
    HYFlightGetJourneyPriceReq *_journeyPriceReq;
    HYCheckChildTicketReqeust *_rChildren;
    HYFlightStockReqeust *_stockRequest;
    
    UITextField *_phoneTextFeild;
//    UILabel *_totalFee;
    UILabel *_priceLab;
    UILabel *_pointLab;
    UILabel *_returnAmount;
    UIButton *_orderBtn;
    HYFlightOrderHeaderView *_headerView;
    
    BOOL _isExpand;
    BOOL _needInvoice; //是否需要行程单的参数
    BOOL _isOrder;
    BOOL _showNeedInvoice;
    CGFloat _prevContentOffsetY;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *passengers;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, strong) HYPickerToolView *pickerView;
@property (nonatomic, strong) HYPickerToolView *spPickerView;
@property (nonatomic, strong) HYFlightRTRules *rules;
@property (nonatomic, strong) HYAddressInfo *address;
@property (nonatomic, strong) HYUserInfo *userInfo;
@property (nonatomic, assign) HYSpendingPatterns spendPattern;  //消费方式

//儿童票的信息
//@property (nonatomic, assign) BOOL hasGetChildTicket;
//@property (nonatomic, assign) BOOL supportChild;
//
//@property (nonatomic, assign) CGFloat bbPrice;  //婴儿票
//@property (nonatomic, assign) CGFloat bbFee;
//@property (nonatomic, assign) CGFloat bbPoint;
//
//@property (nonatomic, assign) CGFloat cPirce;  //儿童票
//@property (nonatomic, assign) CGFloat cAirport;
//@property (nonatomic, assign) CGFloat cFuel;
//@property (nonatomic, assign) CGFloat cPoint;
@property (nonatomic, strong) HYFlightSKUStock *childStockInfo;

@property (nonatomic, assign) CGFloat journeyPrice;
@property (nonatomic, assign) CGFloat journeyPoint;

@end

@implementation HYFlightFillOrderViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_orderRequest cancel];
    _orderRequest = nil;
    
    [_journeyPriceReq cancel];
    _journeyPriceReq = nil;
    
    [_rChildren cancel];
    _rChildren = nil;
    
    [_stockRequest cancel];
    
    [HYLoadHubView dismiss];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isExpand = NO;
        _needInvoice = NO;
        _prevContentOffsetY = 0;
        _spendPattern = Undefind_SP;
        _journeyPrice = 20;
        _journeyPoint = 20;
        
        NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] stringForKey:kFlightPhoneNumber];
        if (!phoneNumber) {
            phoneNumber = self.userInfo.mobilePhone;
        }
        self.phoneNumber = phoneNumber;
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
    frame.size.height -= 65.0;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionFooterHeight = 0;
    tableview.sectionHeaderHeight = 10;
    [tableview setAllowsSelectionDuringEditing:YES];
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
    
    CGRect frame = self.view.frame;
    frame.origin.y = (frame.size.height-65.0f);
    frame.size.height = 65.0f;
    UIImageView *toolBgView = [[UIImageView alloc] initWithFrame:frame];
    toolBgView.userInteractionEnabled = YES;
    toolBgView.backgroundColor = [UIColor whiteColor];
//    toolBgView.image = [[UIImage imageNamed:@"btn_price"] stretchableImageWithLeftCapWidth:2
//                                                                              topCapHeight:0];
    [self.view addSubview:toolBgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 22, 80, 20)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor grayColor];
    label.text = @"总额:";
    label.backgroundColor = [UIColor clearColor];
    [toolBgView addSubview:label];
    
    UILabel *plabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 14, 20)];
    plabel.font = [UIFont systemFontOfSize:14];
    plabel.textColor = [UIColor redColor];
    plabel.text = @"￥";
    plabel.backgroundColor = [UIColor clearColor];
    [toolBgView addSubview:plabel];
    
    CGFloat maxWidth = frame.size.width-100;
    
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(74, 5, (maxWidth-60)/2 - 10, 20)];
    _priceLab.font = [UIFont systemFontOfSize:15];
    _priceLab.textColor = [UIColor redColor];
    _priceLab.backgroundColor = [UIColor clearColor];
    [toolBgView addSubview:_priceLab];
    
    _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 42, (maxWidth-60)/2 + 5, 20)];
    _pointLab.font = [UIFont systemFontOfSize:12];
    _pointLab.textColor = [UIColor orangeColor];
//    _pointLab.textAlignment = NSTextAlignmentRight;
    _pointLab.backgroundColor = [UIColor clearColor];
    [toolBgView addSubview:_pointLab];
    
    // 返现
    _returnAmount = [[UILabel alloc] initWithFrame:CGRectMake(60, 24, (maxWidth-60)/2 + 5, 20)];
    _returnAmount.font = [UIFont systemFontOfSize:12];
    _returnAmount.textColor = [UIColor orangeColor];
    _returnAmount.hidden = YES;
    _pointLab.frame = _returnAmount.frame;
    [toolBgView addSubview:_returnAmount];
    
    _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderBtn.frame = CGRectMake(maxWidth, 0, 100, 65);
    UIImage *nImage = [[UIImage imageNamed:@"btn_pay"] stretchableImageWithLeftCapWidth:2
                                                                           topCapHeight:0];
    UIImage *pImage = [[UIImage imageNamed:@"btn_paypress"] stretchableImageWithLeftCapWidth:2
                                                                                topCapHeight:0];
    [_orderBtn setBackgroundImage:nImage forState:UIControlStateNormal];
    [_orderBtn setBackgroundImage:pImage forState:UIControlStateHighlighted];
    [_orderBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    //如果为携程，则是下一步
    NSString *btnTitle = (self.orgCabin.expandedResponse.sourceFrom == 1) ? @"下一步" : @"提交订单";
    [_orderBtn setTitle:btnTitle
               forState:UIControlStateNormal];
    [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_orderBtn addTarget:self
                  action:@selector(orderFlight:)
        forControlEvents:UIControlEventTouchUpInside];
    [toolBgView addSubview:_orderBtn];
    
    [self.view addSubview:toolBgView];
    
    //line
//    _headerView = [[HYFlightOrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    _headerView.dateInfoLab.text = self.flight.flightDate;
//    _headerView.airlineLab.text = self.flight.airlineName;
//    _headerView.airlineNOLab.text = self.flight.flightNo;
//    if (self.flight.planeType.length > 0)
//    {
//        _headerView.planTypeLab.text = [NSString stringWithFormat:@"机型%@", self.flight.planeType];
//    }
//    _headerView.backgroundColor = self.view.backgroundColor;
//    self.tableView.tableHeaderView = _headerView;
    //机票大致信息
    HYFlightSummaryView *headerView = [[HYFlightSummaryView alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 140)];
    headerView.flightSummary = self.flightSummary;
    headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = headerView;
    
    //获取仓位的改签规则
    [self getCabinRules];
    [self getChildrenTicketInfo];
    [self updatePriceInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //隐藏弹出框
    [_pickerView dismissWithAnimation:NO];
    [_spPickerView dismissWithAnimation:NO];
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

- (HYPickerToolView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[HYPickerToolView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        _pickerView.delegate = self;
        _pickerView.dataSouce = @[@"不需要配送", @"快递报销凭证"];
        _pickerView.title = @"选择配送方式";
    }
    
    return _pickerView;
}

- (HYPickerToolView *)spPickerView
{
    if (!_spPickerView)
    {
        _spPickerView = [[HYPickerToolView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        _spPickerView.delegate = self;
        _spPickerView.dataSouce = @[@"个人消费", @"企业消费"];
        _spPickerView.title = @"选择消费种类";
    }
    
    return _spPickerView;
}

#pragma mark private methods
- (void)updatePriceInfo
{
    CGFloat price = 0.0f;
    CGFloat point = 0.0f;
    CGFloat returnAmount = 0;
    
    for (HYPassengers *p in self.passengers)
    {
        
        if (!self.orgCabin.expandedResponse.supportChild)
        {
            
            if (p.type == Baby)
            {
                price += self.childStockInfo.babyFee + self.childStockInfo.babyPrice;
                point += self.childStockInfo.babyPoints;
            }
            else
            {
                price += self.orgCabin.price.floatValue +
                self.orgCabin.expandedResponse.fuelTax +
                self.orgCabin.expandedResponse.airportTax;
                point += self.orgCabin.points.intValue;
                
                // 成人票显示返现金额
                int i = self.childStockInfo.returnAmount.intValue;
                if (self.childStockInfo.returnAmount && i != 0) {
                    
                    _returnAmount.hidden = NO;
                    _pointLab.frame = CGRectMake(60, 42, ([UIScreen mainScreen].bounds.size.width-160)/2 + 5, 20);
                } else {
                    
                    _returnAmount.hidden = YES;
                    _pointLab.frame = _returnAmount.frame;
                }
                returnAmount += [self.childStockInfo.returnAmount floatValue];
            }
        }
        else
        {
            //如果非儿童或者不购买儿童票，则按照成人票计算价格
            if (![p isChildren] || ![p buyChildren])
            {
                price += self.orgCabin.price.floatValue +
                self.orgCabin.expandedResponse.fuelTax +
                self.orgCabin.expandedResponse.airportTax;
                point += self.orgCabin.points.intValue;
                
                // 成人票显示返现金额
                int i = self.childStockInfo.returnAmount.intValue;
                if (self.childStockInfo.returnAmount && i != 0) {
                    
                    _returnAmount.hidden = NO;
                    _pointLab.frame = CGRectMake(60, 42, ([UIScreen mainScreen].bounds.size.width-160)/2 + 5, 20);
                } else {
                    
                    _returnAmount.hidden = YES;
                    _pointLab.frame = _returnAmount.frame;
                }
                returnAmount += [self.childStockInfo.returnAmount floatValue];
            }
            else if ([p buyChildren] && p.type == Children)
            {
                price += self.childStockInfo.childSinglePrice + self.childStockInfo.childFuelTax + self.childStockInfo.childAirportTax;
                point += self.childStockInfo.childPoints;
            }
            else if (p.type == Baby)
            {
                price += self.childStockInfo.babyFee + self.childStockInfo.babyPrice;
                point += self.childStockInfo.babyPoints;
            }
        }
    }
    
    //如果需要行程单
    if (_needInvoice)
    {
        price += self.journeyPrice;
        point += self.journeyPoint;
    }
    
    _pointLab.text = [NSString stringWithFormat:@"现金券:%.0f", point];
    _priceLab.text = [NSString stringWithFormat:@"%.02f", price];
    _returnAmount.text = [NSString stringWithFormat:@"返现:%.02f", returnAmount];
}

- (void)getCabinRules
{
    HYFlightRTRules *r = [[HYFlightRTRules alloc] init];
    r.Change = self.orgCabin.expandedResponse.alertedRule;
    r.Refund = self.orgCabin.expandedResponse.refundRule;
    r.Remark = self.orgCabin.expandedResponse.otherRule;
    self.rules = r;
}

- (void)getChildrenTicketInfo
{
    [HYLoadHubView show];
    
    if (_stockRequest)
    {
        [_stockRequest cancel];
        _stockRequest = nil;
    }
    
    _stockRequest = [[HYFlightStockReqeust alloc] init];
    _stockRequest.userId = self.userInfo.userId;
    _stockRequest.skuId = self.orgCabin.productSKUId;
    
    __weak typeof(self) b_self = self;
    [_stockRequest sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        
        if (!error && [result isKindOfClass:[HYFlightStockResponse class]])
        {
            HYFlightStockResponse *reponse = (HYFlightStockResponse *)result;
            b_self.childStockInfo = reponse.skuStock;
            
            //更新是否支持儿童票和婴儿票
            b_self.orgCabin.expandedResponse.supportBaby = (reponse.skuStock.babyPrice>0);
            b_self.orgCabin.expandedResponse.supportChild = (reponse.skuStock.childSinglePrice>0);
            [b_self.tableView reloadData];
            
        }
        else
        {
            [b_self updatePriceInfo];
            [b_self.tableView reloadData];
            
        }
    }];
}

- (void)orderFlight:(id)sender
{
    BOOL _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (!_isLogin)
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
    else
    {
        if (!_isOrder)
        {
            NSString *error = nil;
            if ([self.passengers count] <= 0)
            {
                error = @"请添加乘机人";
            }
            else if ([_phoneTextFeild.text length] <= 0)
            {
                error = @"请输入手机号码";
            }
            else if (self.userInfo.enterpriseId.intValue>0 && self.spendPattern<=Undefind_SP)
            {
                [self.spPickerView showWithAnimation:YES];
                return;
            }
            
            if (error)
            {
                [METoast toastWithMessage:error];
            }
            else if (![self checkPassengersCountOver])
            {
                //记忆电话号码
                if (self.phoneNumber)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumber
                                                              forKey:kFlightPhoneNumber];
                }
                
                //如果为携程机票,并且支持信用卡支付
                if (self.orgCabin.expandedResponse.sourceFrom==1)   //sorucefrom 为票源
                {
                    if (_needInvoice)
                    {
                        NSString *str = nil;
                        if ([self.address.consignee length] <= 0)
                        {
                            str = @"请填写行程单收件信息";
                        }
                        
                        if ([self.address.phoneMobile length] <= 0)
                        {
                            str = @"请填写行程单收件信息";
                        }
                        
                        if ([self.address.provinceName length] <= 0)
                        {
                            str = @"请填写行程单收件信息";
                        }
                        
                        if (str)
                        {
                            [METoast toastWithMessage:str];
                            return;
                        }
                    }
                    
                    HYFlightPaymentSelectViewController *vc = [[HYFlightPaymentSelectViewController alloc] init];
                    vc.cabin = self.orgCabin;
                    vc.flight = self.flight;
                    vc.passengers = self.passengers;
                    
                    if (_needInvoice)
                    {
                        vc.invoiceAdds = self.address;
                    }
                    
                    vc.spendPattern = self.spendPattern;
                    vc.phoneNumber = _phoneTextFeild.text;
                    vc.totalPrice = [_priceLab.text floatValue];
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                }
                else
                {
                    if (_orderRequest)
                    {
                        [_orderRequest cancel];
                        _orderRequest = nil;
                    }
                    
                    _orderRequest = [[HYFlightOrderRequest alloc] init];
                    _orderRequest.contactPhone = _phoneTextFeild.text;
                    _orderRequest.guestItems = self.passengers;
                    _orderRequest.cabin = self.orgCabin;
                    _orderRequest.flight = self.flight;
                    
                    if (self.spendPattern == Enterprise_SP)
                    {
                        _orderRequest.isEnterprise = self.userInfo.enterpriseId;
                    }
                    
                    if (_needInvoice)
                    {
                        NSString *str = nil;
                        if ([self.address.consignee length] <= 0)
                        {
                            str = @"请填写行程单收件信息";
                        }
                        
                        if ([self.address.phoneMobile length] <= 0)
                        {
                            str = @"请填写行程单收件信息";
                        }
                        
                        if ([self.address.provinceName length] <= 0)
                        {
                            str = @"请填写行程单收件信息";
                        }
                        
                        if (str)
                        {
                            [METoast toastWithMessage:str];
                            return;
                        }
                        else
                        {
                            _orderRequest.isNeenJourney = YES;
                            _orderRequest.userAddressId = self.address.addr_id;
                        }
                    }
                    
                    _isOrder = YES;
                    [HYLoadHubView show];
                    
                    __weak typeof(self) b_self = self;
                    [_orderRequest sendReuqest:^(id result, NSError *error) {
                        
                        [HYLoadHubView dismiss];
                        
                        HYFlightOrder *order = nil;
                        if ([result isKindOfClass:[HYFlightOrderResponse class]])
                        {
                            HYFlightOrderResponse *rs = (HYFlightOrderResponse *)result;
                            order = rs.filghtOrder;
                        }
                        
                        [b_self orderFlightResult:order error:error];
                    }];
                }
            }
        }
    }
}

- (void)orderFlightResult:(HYFlightOrder *)order error:(NSError *)error
{
    if (!error && [order.orderId length] > 0)
    {
        //记忆电话号码
        if (self.phoneNumber)
        {
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumber
                                                      forKey:kFlightPhoneNumber];
        }
        
        HYAlipayOrder *alPay = [[HYAlipayOrder alloc] init];
        alPay.partner = PartnerID;
        alPay.seller = SellerID;

        NSMutableString* nameStr = [[NSMutableString alloc]initWithCapacity:0];
        [nameStr appendString:@"【特奢机票】订单编号:"];
        
        HYFlightOrderItem *orderitem = [order.orderItems objectAtIndex:0];
        CGFloat price = order.orderTotalAmount;
        alPay.tradeNO = order.orderCode; //订单号（由商家自行制定）
        alPay.productName = nameStr;
        alPay.productDescription = [NSString stringWithFormat:@"%@机票订单", orderitem.airlineName]; //商品描述
        alPay.amount = [NSString stringWithFormat:@"%0.2f",price]; //商品价格

       
        HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
        payVC.navbarTheme = self.navbarTheme;
        payVC.alipayOrder = alPay;
        payVC.amountMoney = [[NSNumber numberWithFloat:price] stringValue];
        payVC.payMoney = [[NSNumber numberWithFloat:price] stringValue];
        payVC.orderID = order.orderId;
        payVC.orderCode = order.orderCode;
        payVC.type = Pay_Flight;
        [self.navigationController pushViewController:payVC
                                             animated:YES];
    }
    else
    {
        NSString *msg = error.domain;
        if (!msg)
        {
            msg = @"机票下单失败, 建议您重新选择航班";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    _isOrder = NO;
}

- (void)selectFromAddressBook:(id)sender
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    
    picker.peoplePickerDelegate = self;
    // Display only a person's phone, email, and birthdate
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
    picker.displayedProperties = displayedItems;
    // Show the picker
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)addNewPassenger
{
    HYPassengerListViewController *vc = [[HYPassengerListViewController alloc] init];
    vc.navbarTheme = self.navbarTheme;
    vc.delegate = self;
    vc.type = Passenger;
    vc.selectPassengers = [self.passengers mutableCopy];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)selectInvoice
{
    HYFlightInvoiceViewController *vc = [[HYFlightInvoiceViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)childrenTicketError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"该仓位不支持儿童票"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"知道了", nil];
    [alert show];
}

//检查舱位余票是否足够
- (BOOL)checkPassengersCountOver
{
    int adultCount = 0;
    for (HYPassengers *p in self.passengers)
    {
        //设置出行日期,判断是否为儿童/婴儿需要使用该值
        p.tripDate = self.flight.flightDate;
        
        //如果有婴儿或者儿童
        if (p.type == Adult)
        {
            adultCount++;
        }
    }
    
    //如果选择的成人人数大于机票张数，需要提示
    BOOL result = (adultCount > self.orgCabin.stock.integerValue);
    if (result)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"当前舱位余票不足"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    return result;
}

//获得?价格
- (void)getJourneyPrice
{
    [_journeyPriceReq cancel];
    _journeyPriceReq = nil;
    
    _journeyPriceReq = [[HYFlightGetJourneyPriceReq alloc] init];
    
    __weak typeof(self) bself = self;
    [_journeyPriceReq sendReuqest:^(id result, NSError *error) {
        if (!error && [result isKindOfClass:[HYFlightGetJourneyPriceResp class]])
        {
            HYFlightGetJourneyPriceResp *resp = (HYFlightGetJourneyPriceResp *)result;
            bself.journeyPrice = resp.price;
            bself.journeyPoint = resp.point;
        }
        
        [bself updatePriceInfo];
    }];
}

#pragma mark－ UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex != alertView.cancelButtonIndex)
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

#pragma mark - DeliverAdreeDelegate
- (void)getAdress:(HYAddressInfo *)info
{
    self.address = info;
    [self.tableView reloadData];
}

#pragma mark -HYFlightPassengerCellDelegate
- (void)childUpdateBuyTicketType:(HYPassengers *)passenger
{
    [self updatePriceInfo];
}

- (void)deletePassengerCellForIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 &&(indexPath.row-1) < [self.passengers count])
    {
        if ((indexPath.row-1) >= 0)
        {
            [self.passengers removeObjectAtIndex:(indexPath.row-1)];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationLeft];
            
            NSIndexSet *indexSets = [[NSIndexSet alloc]initWithIndex:indexPath.section];
            [_tableView reloadSections:indexSets
                      withRowAnimation:UITableViewRowAnimationAutomatic];
            //更新价格
            [self updatePriceInfo];
        }
    }
}


//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.section ==1 &&(indexPath.row-1) < [self.passengers count])
//    {
//        return YES;
//    }
//
//    return NO;
//}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (void)tableView:(UITableView *)tableView
//commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
//forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        if ((indexPath.row-1) >= 0)
//        {
//            [self.passengers removeObjectAtIndex:(indexPath.row-1)];
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                             withRowAnimation:UITableViewRowAnimationLeft];
//            //更新价格
//            [self updatePriceInfo];
//        }
//    }
//}

#pragma mark -HYPassengerDelegate
- (void)didSelectPassengers:(NSArray *)passengers
{
    if ([passengers count] > 0)
    {
//        [self.tableView setEditing:YES];
     
        self.passengers = [passengers mutableCopy];
        
        BOOL hasChild = NO;
        BOOL adultCount = [passengers count];
        for (HYPassengers *p in self.passengers)
        {
            //设置出行日期,判断是否为儿童/婴儿需要使用该值
            p.tripDate = self.flight.flightDate;
            
            //如果有婴儿或者儿童
            if (p.type > Adult)
            {
                hasChild = YES;
                adultCount--;
            }
        }
        
        //如果有儿童，并且是携程的仓位，则不可以预订
        if (hasChild && self.orgCabin.expandedResponse.sourceFrom==1)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"当前舱位由携程出票，暂不支持儿童/婴儿票，您可以更换特奢汇航班"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
        //更新价格
        [self updatePriceInfo];
        [self.tableView reloadData];
        [self checkPassengersCountOver];
    }
    else
    {
        self.passengers = nil;
        
        //更新价格
        [self updatePriceInfo];
        [self.tableView reloadData];
    }
}

- (void)didUpdateWithPassenger:(HYPassengers *)passenger
{
    BOOL hasChild = NO;
    for (HYPassengers *p in self.passengers)
    {
        if ([p.passengerId isEqualToString:passenger.passengerId])
        {
            p.name = passenger.name;
            p.phone = passenger.phone;
            p.cardID = passenger.cardID;
            
            //设置出行日期,判断是否为儿童/婴儿需要使用该值
            p.tripDate = self.flight.flightDate;
            
            //如果有婴儿或者儿童
            if (p.type > Adult)
            {
                hasChild = YES;
                
            }
            
            break;
        }
    }
    
    //如果有儿童，并且是携程的仓位，则不可以预订
    if (hasChild && self.orgCabin.expandedResponse.sourceFrom==1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"当前舱位由携程出票，暂不支持儿童/婴儿票，您可以更换特奢汇航班"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    //更新价格
    [self checkPassengersCountOver];
    [self updatePriceInfo];
    [self.tableView reloadData];
}


#pragma mark - HYPickerToolViewDelegate
- (void)selectComplete:(HYPickerToolView *)pickerView
{
    if (pickerView == _pickerView)
    {
        if (self.orgCabin.expandedResponse.sourceFrom != 1)
        {
            _needInvoice = (pickerView.currentIndex == 1);
        }
        
        [self getJourneyPrice];
        
        if (_needInvoice)
        {
            HYDeliveryAddressViewController* addAdress = [[HYDeliveryAddressViewController alloc]init];
            addAdress.navbarTheme = self.navbarTheme;
            addAdress.type = 1;
            addAdress.delegate = self;
            _showNeedInvoice = NO;
            [self.navigationController pushViewController:addAdress animated:YES];
        }
        else
        {
            self.address = nil;
            _showNeedInvoice = YES;
            [self.tableView reloadData];
        }
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

#pragma mark - HYFlightOrderCabinInfoCellDelegate
- (void)cellExpand:(BOOL)expand
{
    _isExpand = expand;
    
    [self.tableView reloadData];
    return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if ([self.tableView cellForRowAtIndexPath:indexPath])
    {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    if (section == 0)
    {
        count = 1;
    }
    else if (section == 1)
    {
        NSInteger a = [self.address.consignee length]>0 ? 2 : 0;
        if (self.userInfo.enterpriseId.intValue > 0)
        {
            count = (4+[self.passengers count] + a);
        }
        else
        {
            count = (3+[self.passengers count] + a);
        }
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50.0f;
    
    if (indexPath.section == 0)
    {
//        if (indexPath.row == 0)
//        {
//            height = 60.0f;
//        }
//        else
//        {
            if (_isExpand)
            {
                if (self.rules.changeHeight > 0)
                {
                    height += (self.rules.changeHeight+26);
                }
                
                if (self.rules.refundHeight > 0)
                {
                    height += (self.rules.refundHeight+26);
                }
                
                if (self.rules.remarkHeight > 0)
                {
                    height += (self.rules.remarkHeight+26);
                }
                
                height += 40;
            }
            else
            {
                height = 90;
            }
//        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row >0 && indexPath.row<=[self.passengers count])
        {
            HYPassengers *p = [self.passengers objectAtIndex:(indexPath.row-1)];
            
            height = 50.0f;
            if ((p.type == Baby&&self.orgCabin.expandedResponse.supportBaby) ||
                (p.type == Children&&self.orgCabin.expandedResponse.supportChild))
            {
                height = 90.0f;
            }
        }
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
    }else
    {
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TFScalePoint(320), 10)];
        v.image = [[UIImage imageNamed:@"ticket_bg_gray_g5"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:4];
        
        if (self.orgCabin.expandedResponse.sourceFrom == 1)
        {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, TFScalePoint(300), 40)];
            lab.text = @"＊该航班由携程出票，暂不支持儿童/婴儿票，不便之处敬请谅解。";
            lab.textColor = [UIColor grayColor];
            lab.font = [UIFont systemFontOfSize:14];
            lab.backgroundColor = [UIColor clearColor];
            lab.lineBreakMode = NSLineBreakByWordWrapping;
            lab.numberOfLines = 2;
            [v addSubview:lab];
        }
        return v;
    }
}

//header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //携程的需要提醒
    
    CGFloat height =  (self.orgCabin.expandedResponse.sourceFrom == 1) ? 60.0f : 10.0f;
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
    if (indexPath.section == 0)
    {
//        if (indexPath.row == 0)
//        {
//            static NSString *flightSummaryCellId = @"flightSummaryCellId";
//            HYFlightFillOrderSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:flightSummaryCellId];
//            if (cell == nil)
//            {
//                cell = [[HYFlightFillOrderSummaryCell alloc]initWithStyle:UITableViewCellStyleDefault
//                                             reuseIdentifier:flightSummaryCellId];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            
//            cell.flight = self.flight;
//            return cell;
//        }
//        else
        {
            static NSString *cabinRTInfoCellId = @"cabinRTInfoCellId";
            HYFlightFillOrderCabinInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cabinRTInfoCellId];
            if (cell == nil)
            {
                cell = [[HYFlightFillOrderCabinInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:cabinRTInfoCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.hiddenLine = YES;
                cell.delegate = self;
            }
            
            cell.cabin = self.orgCabin;
            cell.rules = self.rules;
            return cell;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            static NSString *addPassengerCellId = @"addPassengerCellId";
            HYFlightAddPassengerCell *cell = [tableView dequeueReusableCellWithIdentifier:addPassengerCellId];
            if (cell == nil)
            {
                cell = [[HYFlightAddPassengerCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:addPassengerCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            
            return cell;
        }
        else if((indexPath.row-1) < [self.passengers count])
        {
            static NSString *passengerCellId = @"passengerCellId";
            HYFlightPassengerCell *cell = [tableView dequeueReusableCellWithIdentifier:passengerCellId];
            if (cell == nil)
            {
                cell = [[HYFlightPassengerCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:passengerCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
             cell.indexPath = indexPath;
            
            if ((indexPath.row-1) >= 0)
            {
                HYPassengers *p = [self.passengers objectAtIndex:(indexPath.row-1)];
                
                NSString *price = nil;
                if ([p isChildren] && self.orgCabin.expandedResponse.supportChild)
                {
                    price = [NSString stringWithFormat:@"￥%0.2f+￥%0.0f", self.childStockInfo.childSinglePrice, self.childStockInfo.childFuelTax];
                }
                
                //如果非儿童或者不购买儿童票，则按照成人票计算价格
                if (![p isChildren] || ![p buyChildren])
                {
                    price = [NSString stringWithFormat:@"￥%0.2f+￥%0.2f", self.orgCabin.price.floatValue,
                             (self.orgCabin.expandedResponse.fuelTax+self.orgCabin.expandedResponse.airportTax)];
                }
                else if ([p buyChildren] && p.type == Children)
                {
                    price = [NSString stringWithFormat:@"￥%0.2f+￥%0.2f", self.childStockInfo.childSinglePrice, (self.childStockInfo.childFuelTax+self.childStockInfo.childAirportTax)];
                }
                else if (p.type == Baby)
                {
                    price = [NSString stringWithFormat:@"￥%0.2f+￥%0.2f", self.childStockInfo.babyPrice, self.childStockInfo.babyFee];
                }
                
                BOOL support = (p.type==Children)?self.orgCabin.expandedResponse.supportChild:self.orgCabin.expandedResponse.supportBaby;
                [cell updateWithPassenger:p
                                    price:price
                                  support:support];
            }
            return cell;
        }
        else if(indexPath.row == ([self.passengers count]+1))
        {
            static NSString *fullMobileCellId = @"fullMobileCellId";
            HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:fullMobileCellId];
            if (cell == nil)
            {
                cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:fullMobileCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.backgroundColor = [UIColor clearColor];
                
                _phoneTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(100, 18, TFScalePoint(150), 18)];
                _phoneTextFeild.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                _phoneTextFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
                _phoneTextFeild.font = [UIFont systemFontOfSize:16];
                _phoneTextFeild.returnKeyType = UIReturnKeyDone;
                _phoneTextFeild.placeholder = @"用于接收短信";
                _phoneTextFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                _phoneTextFeild.delegate = self;
                [cell.contentView addSubview:_phoneTextFeild];
                
                UIButton *contactsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                contactsBtn.frame = CGRectMake(TFScalePoint(280), 12, 20, 20);
                [contactsBtn setImage:[UIImage imageNamed:@"flight_cellPhone"]
                             forState:UIControlStateNormal];
//                [contactsBtn setImage:[UIImage imageNamed:@"icon_addbook_down_flight"]
//                             forState:UIControlStateHighlighted];
                [contactsBtn addTarget:self
                                action:@selector(selectFromAddressBook:)
                      forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:contactsBtn];
            }
            cell.textLabel.text = @"手机号";
            _phoneTextFeild.text = self.phoneNumber;
            
            return cell;
        }
        else
        {
            static NSString *invoiceCellId = @"invoiceCellId";
            HYFlightInvoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:invoiceCellId];
            if (cell == nil)
            {
                cell = [[HYFlightInvoiceCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:invoiceCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.backgroundColor = [UIColor clearColor];
                
                cell.detailTextLabel.textColor = [UIColor colorWithRed:23.0/255.0
                                                                 green:126.0/255.0
                                                                  blue:184.0/255.0
                                                                 alpha:1.0];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            }
            
            for (UIView *v in [cell.contentView subviews])
            {
                if ([v isKindOfClass:[UIImageView class]])
                {
                    [v removeFromSuperview];
                    break;
                }
            }
            
            NSInteger index = indexPath.row - ([self.passengers count]+2);
            if (self.userInfo.enterpriseId.intValue <= 0)
            {
                index += 1;
            }
            
            cell.detailTextLabel.text = nil;
            if (_showNeedInvoice)
            {
                cell.detailTextLabel.text = @"不需要配送";
            }
            
            switch (index)
            {
                case 0:
                {
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                    cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                    cell.textLabel.text = @"消费类型";
                    
                    if (self.spendPattern == Undefind_SP)
                    {
                        UIImage *arrIcon = [UIImage imageNamed:@"ico_arrow_list"];
                        UIImageView *arrView1 = [[UIImageView alloc] initWithFrame:CGRectMake(TFScalePoint(300), 17.5, 10, 15)];
                        arrView1.image = arrIcon;
                        [cell.contentView addSubview:arrView1];
                    }
                    else
                    {
                        switch (self.spendPattern)
                        {
                            case Personal_SP:
                                cell.detailTextLabel.text = @"个人消费";
                                break;
                            case Enterprise_SP:
                                cell.detailTextLabel.text = @"企业消费";
                                break;
                            default:
                                break;
                        }
                    }
                }
                    break;
                case 1:
                {
                    if (self.orgCabin.expandedResponse.supportJourney)
                    {
                        cell.textLabel.textAlignment = NSTextAlignmentLeft;
                        cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                        cell.textLabel.text = @"报销凭证配送";
                        
                        UIImage *arrIcon = [UIImage imageNamed:@"ico_arrow_list"];
                        UIImageView *arrView1 = [[UIImageView alloc] initWithFrame:CGRectMake(TFScalePoint(300), 17.5, 10, 15)];
                        arrView1.image = arrIcon;
                        [cell.contentView addSubview:arrView1];
                    }
                    else
                    {
                        cell.textLabel.textAlignment = NSTextAlignmentCenter;
                        cell.textLabel.textColor = [UIColor colorWithRed:23.0/255.0
                                                                   green:126.0/255.0
                                                                    blue:184.0/255.0
                                                                   alpha:1.0];
                        cell.textLabel.text = @"该航班不支持报销凭证配送";
                    }
                }
                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:@"联系人：%@", self.address.consignee];
                    break;
                case 3:
                {
                    NSString *add = [NSString stringWithFormat:@"地址：%@", self.address.fullAddress];
                    cell.textLabel.text = add;
                }
                    break;
                default:
                    break;
            }
            
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_phoneTextFeild resignFirstResponder];
    
    if (indexPath.section == 1)
    {
        //乘机人
        if (self.userInfo.enterpriseId.intValue <= 0)
        {
            if (indexPath.row==0)
            {
                [self addNewPassenger];
            }
            else if (indexPath.row == ([self.passengers count]+2))
            {
                if (self.orgCabin.expandedResponse.supportJourney)
                {
                    [self.pickerView showWithAnimation:YES];
                }
            }
            else if((indexPath.row-1) < [self.passengers count])
            {
                if ((indexPath.row-1) >= 0)
                {
                    HYPassengers *p = [self.passengers objectAtIndex:(indexPath.row-1)];
                    HYEidtPassengerViewController *vc = [[HYEidtPassengerViewController alloc] init];
                    vc.navbarTheme = self.navbarTheme;
                    vc.type = Passenger;
                    vc.passenger = p;
                    vc.delegate = self;
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                }
            }
        }
        else
        {
            if (indexPath.row==0)
            {
                [self addNewPassenger];
            }
            else if (indexPath.row == ([self.passengers count]+2))
            {
                [self.spPickerView showWithAnimation:YES];
            }
            else if (indexPath.row == ([self.passengers count]+3))
            {
                if (self.orgCabin.expandedResponse.supportJourney)
                {
                    [self.pickerView showWithAnimation:YES];
                }
            }
            else if((indexPath.row-1) < [self.passengers count])
            {
                if ((indexPath.row-1) >= 0)
                {
                    HYPassengers *p = [self.passengers objectAtIndex:(indexPath.row-1)];
                    HYEidtPassengerViewController *vc = [[HYEidtPassengerViewController alloc] init];
                    vc.navbarTheme = self.navbarTheme;
                    vc.type = Passenger;
                    vc.passenger = p;
                    vc.delegate = self;
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                }
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _prevContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging)
    {
        CGFloat deltaY = scrollView.contentOffset.y-_prevContentOffsetY;
        _prevContentOffsetY = MAX(scrollView.contentOffset.y, -scrollView.contentInset.top);
        
        if (deltaY < 0)
        {
            [_phoneTextFeild resignFirstResponder];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGFloat height = self.tableView.contentOffset.y-252;
    if (height < 0 )
    {
        height = 0;
    }
    [self.tableView setContentOffset:CGPointMake(0, height) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGFloat height = self.tableView.contentSize.height;
    if ([[UIScreen mainScreen] bounds].size.height > 480)
    {
        height = height-260;
    }
    else
    {
        height -= 220;
    }
    
    [self.tableView setContentOffset:CGPointMake(0, height) animated:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.phoneNumber = textField.text;
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods

// Called after a person has been selected by the user. only ios8
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person
{
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:NULL];
    
    //phones
    ABMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFArrayRef values = ABMultiValueCopyArrayOfAllValues(phoneMulti);
    
    if ([(__bridge NSArray*)values count] > 0)
    {
        NSString *number = [(__bridge NSArray*)values objectAtIndex:0];
        NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        self.phoneNumber = [[number componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
        _phoneTextFeild.text = self.phoneNumber;
    }
    
    if (values)
    {
        CFRelease(values);
    }
    CFRelease(phoneMulti);
}

// Called after a property has been selected by the user. only ios8
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:NULL];
    
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, property);
    CFStringRef cfPhone = ABMultiValueCopyValueAtIndex(multi, identifier);
    
    NSString *phone = (__bridge NSString *)cfPhone;
    
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    self.phoneNumber = [[phone componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    _phoneTextFeild.text = self.phoneNumber;
    
    if (cfPhone)
    {
        CFRelease(cfPhone);
    }
    CFRelease(multi);
}

// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:NULL];
    
    //phones
    ABMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFArrayRef values = ABMultiValueCopyArrayOfAllValues(phoneMulti);
    
    if ([(__bridge NSArray*)values count] > 0)
    {
        NSString *number = [(__bridge NSArray*)values objectAtIndex:0];
        NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        self.phoneNumber = [[number componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
        _phoneTextFeild.text = self.phoneNumber;
    }
    
    if (values)
    {
        CFRelease(values);
    }
    CFRelease(phoneMulti);
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

@end
