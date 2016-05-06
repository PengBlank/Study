//
//  HYPaymentViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPaymentViewController.h"
#import "HYFlightWapPayViewController.h"
#import "HYBaseLineCell.h"
#import "HYPayAccountBalanceCell.h"
#import "HYPayWaysCell.h"
#import "HYBankViewController.h"
#import "HYGetPaymentTypeRequest.h"
#import "HYGetPayNORequest.h"
#import "HYLoadHubView.h"
#import "HYUserInfo.h"
#import "HYAppDelegate.h"
#import "HYPaymentSuccViewController.h"

#import "HYMallOrderDetailRequest.h"
#import "HYFlowerGetOrderInfoRequest.h"
#import "HYFlightGetOrderInfoRequest.h"
#import "HYHotelOrderDetailRequest.h"
#import "HYUserVirtualAccountInfoRequest.h"
#import "HYUserVirtualAccountResponse.h"
#import "HYUserCashAccountInfoRequest.h"
#import "HYSiRedPacketsViewController.h"
#import "HYNavigationController.h"
#import "HYMineInfoViewController.h"
#import "HYMallOrderListViewController.h"

#import "DataSigner.h"
#import "NSString+Addition.h"

#import "DefineConfig.h"


NSString * const ThreePartyPaymentResultNotification;

@interface HYPaymentViewController ()
<
HYPayWaysCellDelegate,
UIAlertViewDelegate,
HYFlightWapPayViewControllerDelegate
>
{
    HYGetPaymentTypeRequest *_payTypeRequest;
    HYGetPayNORequest *_payNORequest;
    
    HYMallOrderDetailRequest *_mallOrderDetailRq;
    HYFlowerGetOrderInfoRequest *_flowerOrderDetailRq;
    HYFlightGetOrderInfoRequest *_flightOrderDetailRq;
    HYHotelOrderDetailRequest *_hotelOrderDetailRq;
    
    HYUserVirtualAccountInfoRequest *_virtualAccReq;
    HYUserCashAccountInfoRequest *_cashAccReq;

    BOOL _isGetPayNO;
    BOOL _paySuccess;
    
    NSInteger _selectIndex;
    NSString *_walletAmout;
    
    BOOL _selectedOfSectionZero;
    BOOL _IsselectedOfSectionZero;
    
    UIAlertView *_alertView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *payTypes;
@property (nonatomic, strong) UIButton *choosePayment;
@property (nonatomic, strong) UIButton *senderButton;
@property (nonatomic, copy) NSString *paymentType;
@property (nonatomic, copy) NSString *alipayNotifyUrl;
@property (nonatomic, copy) NSString *tradeItemCode;
@property (nonatomic, strong) HYUserCashAccountInfo *cashAccountInfo;
@property (nonatomic, copy) NSString *stillNeedPay;  //还需要支付的金额

/**
 * 余额支付方式
 */
@property (nonatomic, assign, getter=isBalance) BOOL balance;


@end

@implementation HYPaymentViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ThreePartyPaymentResultNotification
                                                  object:nil];
    
    [HYLoadHubView dismiss];
    
    [_payTypeRequest cancel];
    _payTypeRequest = nil;
    
    [_payNORequest cancel];
    _payNORequest = nil;
    
    [_mallOrderDetailRq cancel];
    _mallOrderDetailRq = nil;
    
    [_flowerOrderDetailRq cancel];
    _flowerOrderDetailRq = nil;
    
    [_flightOrderDetailRq cancel];
    _flightOrderDetailRq = nil;
    
    [_hotelOrderDetailRq cancel];
    _hotelOrderDetailRq = nil;
    
    [_virtualAccReq cancel];
    _virtualAccReq = nil;
    
    [_cashAccReq cancel];
    _cashAccReq = nil;
    
    _alertView.delegate = nil;
    _alertView = nil;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    //    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    UILabel* nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10,0,50, 44)];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textColor = [UIColor darkTextColor];
    nameLab.font = [UIFont systemFontOfSize:18.0f];
    nameLab.text = @"金额:";
    //    [self.view addSubview:nameLab];
    
    
    
    //    [self.view addSubview:moneyLab];
    //
    //    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1.0)];
    //    lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
    //                                                                                   topCapHeight:0];
    //    [self.view addSubview:lineView];
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, frame.origin.y-20, frame.size.width, frame.size.height)
                                                          style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.scrollEnabled = YES;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionFooterHeight = 0;
    tableview.sectionHeaderHeight = 10;
    [tableview registerClass:[HYPayAccountBalanceCell class] forCellReuseIdentifier:@"HYPayAccountBalanceCell"];
    [tableview registerClass:[HYPayWaysCell class] forCellReuseIdentifier:@"hotelNameCell"];
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    UIButton *checkOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [[UIImage imageNamed:@"btn_pay_bj"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [checkOutBtn setBackgroundImage:img forState:UIControlStateNormal];
    [checkOutBtn setTitle:@"去结算" forState:UIControlStateNormal];
    checkOutBtn.frame = TFRectMake(30, 370 , 260, 40);
    [checkOutBtn addTarget:self
                    action:@selector(beginCheckOut:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:checkOutBtn];
    
    //初始化的状态为-1
    _selectIndex = -1;
    //默认选中使用余额
    _selectedOfSectionZero = YES;
    _walletAmout = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"支付方式";
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ThreePartyPaymentResultNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alipayResultNotification:)
                                                 name:ThreePartyPaymentResultNotification
                                               object:nil];
    
    
    [self getPaymentType];
    
    [self getCashAccountInfo];
    
    
    [self.tableView reloadData];
    
    /// 如果只有一个controller,可以取消
    if (self.navigationController && self.navigationController.viewControllers.count == 1 &&
        self.navigationController.presentingViewController)
    {
        self.navigationItem.leftBarButtonItem = self.cancelItemBar;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)backToRootViewController:(id)sender
{
    //新式回调试返回
    if (_cancelCallback)
    {
        _cancelCallback(self);
    }
    else
    {
        [super backToRootViewController:sender];
    }
}


#pragma mark setter/getter
- (NSString *)payMoney
{
    if (!_payMoney)
    {
        _payMoney = self.amountMoney;
    }
    
    return _payMoney;
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 不允许使用余额的情况
    if (!self.isBalance)
    {
        self.stillNeedPay = self.payMoney;
        return 2;
    }
    
    return 2-(self.stillNeedPay.doubleValue<=0);  //余额足够的时候， 不需要选择支付方式;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.isBalance)
    {
        if (0 == section)
        {
            return 1;
        }
    }
    else
    {
        if (0 == section)
        {
            return 1+(self.cashAccountInfo.balance.floatValue > 0);
        }
    }
    
    return [self.payTypes count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    return height;
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
    if (0 == indexPath.section)
    {
        HYPayAccountBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYPayAccountBalanceCell" forIndexPath:indexPath];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        if (0 == indexPath.row)
        {
            CGFloat amountmoneyF = self.amountMoney.floatValue;
            NSString *text = [NSString stringWithFormat:@"商品金额:¥%.2f",amountmoneyF];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:text];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, text.length-4)];
            cell.rightBtn.hidden = YES;
            cell.textLabel.attributedText = attrStr;
            
            return cell;
        }
        else
        {
            [cell setData:_cashAccountInfo];
            [cell setIsSelected:_selectedOfSectionZero];
            _IsselectedOfSectionZero = _selectedOfSectionZero;
            
            return cell;
        }
        
    }else
    {
        static NSString *hotelNameCell = @"hotelNameCell";
        HYPayWaysCell *cell = [tableView dequeueReusableCellWithIdentifier:hotelNameCell forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        
        if (self.stillNeedPay.doubleValue > 0)
        {
            if (0 == indexPath.row)
            {
                CGFloat stillNeedPayF = self.stillNeedPay.floatValue;
                NSString *text = [NSString stringWithFormat:@"还需支付:¥%.2f",stillNeedPayF];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:text];
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, text.length-4)];
                cell.textLabel.attributedText = attrStr;
                cell.imageView.image = nil;
                cell.rightBtn.hidden = YES;
                cell.userInteractionEnabled = NO;
            }
            else if (indexPath.row-1 < [self.payTypes count])
            {
                NSString *str = [self.payTypes objectAtIndex:indexPath.row-1];
                if ([str hasPrefix:@"ZFB"])
                {
                    cell.imageView.image = [UIImage imageNamed:@"pay_alipay"];
                    cell.textLabel.text = @"支付宝支付";
                }
                else if ([str hasPrefix:@"ZGYL"])
                {
                    cell.imageView.image = [UIImage imageNamed:@"pay_unionpay"];
                    cell.textLabel.text = @"银联支付";
                }
                else if ([str hasPrefix:@"WX"])
                {
                    cell.imageView.image = [UIImage imageNamed:@"pay_weixinpay"];
                    cell.textLabel.text = @"微信支付";
                }
                else if ([str isEqualToString:@"wap"])
                {
                    cell.imageView.image = [UIImage imageNamed:@"ctrip_icon"];
                    cell.textLabel.text = @"携程支付";
                }
                cell.rightBtn.tag = indexPath.row - 1;
                
                [cell setIsSelected:(indexPath.row == _selectIndex)];
            }
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section)
    {
        if (indexPath.row > 0)
        {
            _selectedOfSectionZero = !_IsselectedOfSectionZero;
            [self caculateExtraPayment];
            
            //刷新界面
            [self.tableView reloadData];
        }
    }else
    {
        //选择支付方式
        _selectIndex = indexPath.row;
    }
    
    [tableView reloadData];
}

#pragma mark private methods
- (void)beginCheckOut:(UIButton *)sender
{
    //底部-去结算
    if (self.orderCode)
    {
        NSDictionary *dict = @{@"OrderID":self.orderCode};
        [MobClick event:@"v430_teshehuishouyintai_dibu_qujiesuananniu_jishu"
             attributes:dict];
    }
    
    //使用余额支付的情况,在没有选择任何支付方式或者使用余额支付，余额不足时提示选择支付方式
    if ((!_IsselectedOfSectionZero && -1==_selectIndex) ||  //没有选择余额也没有选择支付方式
        (_IsselectedOfSectionZero && -1==_selectIndex &&
         self.stillNeedPay.doubleValue>0))  //选择了余额但是余额不够
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"请选择支付方式"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles: nil];
        [alert show];
    }
    else if (_selectIndex>0 && (_selectIndex-1) < [self.payTypes count])  //选择了支付方式（余额不够支付所需金额才会出现选择支付方式）
    {
        NSString *str = [self.payTypes objectAtIndex:(_selectIndex-1)];
        if ([str isEqualToString:@"wap"])
        {
            HYFlightWapPayViewController *wap = [[HYFlightWapPayViewController alloc] init];
            wap.orderNO = self.orderCode;
            wap.delegate = self;
            wap.navbarTheme = self.navbarTheme;
            [self.navigationController pushViewController:wap animated:YES];
        }
        else
        {
            
            if (!_isGetPayNO)
            {
                _isGetPayNO = YES;
                self.paymentType = [self.payTypes objectAtIndex:(_selectIndex-1)];
                [self getPayNOWithPaymentType];
            }
        }
    }
    else  //全部使用余额支付
    {
        if (!_isGetPayNO)
        {
            _isGetPayNO = YES;
            self.paymentType = @"tsh_wallet";
            [self getPayNOWithPaymentType];
        }
    }
}

- (void)caculateExtraPayment
{
    //计算还需支付的金额
    if (_selectedOfSectionZero)
    {
        if (self.payMoney.doubleValue <= self.cashAccountInfo.balance.doubleValue)
        {
            self.stillNeedPay = nil;
        }
        else
        {
            self.stillNeedPay = [self.payMoney stringDecimalBySubtracting:self.cashAccountInfo.balance];
        }
    }
    else
    {
        self.stillNeedPay = self.payMoney;
    }
}

/// 获取支付方式
- (void)getPaymentType
{
    [HYLoadHubView show];
    
    _payTypeRequest = [[HYGetPaymentTypeRequest alloc] init];
    
    switch (self.type)
    {
        case Pay_Flight:
            _payTypeRequest.businessType = BusinessType_Flight;
            break;
        case Pay_Flower:
            _payTypeRequest.businessType = BusinessType_Flower;
            break;
        case Pay_Hotel:
            _payTypeRequest.businessType = BusinessType_Hotel;
            break;
        case Pay_Mall:
            _payTypeRequest.businessType = BusinessType_Mall;
            break;
        case Pay_BuyCard:
        case Pay_Renewal:
        case Pay_Upgrad:
            _payTypeRequest.businessType = BusinessType_Flight;
            break;
        case Pay_O2O_QRScan:
            _payTypeRequest.businessType = BusinessType_O2O_QRScan;
            break;
        case Pay_DidiTaxi:
            _payTypeRequest.businessType = BusinessType_DidiTaxi;
            break;
        case pay_phoneCharge:
            _payTypeRequest.businessType = BusinessType_PhoneCharge;
            break;
        default:
            break;
    }

    __weak typeof(self) b_self = self;
    [_payTypeRequest sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        
        if ([result isKindOfClass:[HYGetPaymentTypeResponse class]])
        {
            HYGetPaymentTypeResponse *response = (HYGetPaymentTypeResponse *)result;
            
            //如果无法微信支付 则不显示,否则可能会审核无法通过
            if ((![WXApi isWXAppInstalled]) && (![WXApi isWXAppSupportApi]))
            {
                NSMutableArray *muArray = [response.payTypes mutableCopy];
                
                if ([muArray containsObject:@"wechat"])
                {
                    [muArray removeObject:@"wechat"];
                }
                
                b_self.payTypes = muArray;
            }
            else
            {
                b_self.payTypes = [response.payTypes mutableCopy];
            }
            // 是否允许余额支付
            [b_self.payTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                if ([obj rangeOfString:@"BALANCE"].location != NSNotFound)
                {
                    b_self.balance = YES;
                    [b_self.payTypes removeObjectAtIndex:idx];
                    *stop = YES;
                }
            }];
            
            [b_self.tableView reloadData];
        }
    }];
}

#pragma mark - 支付完成流程

/// 所有支付方式支付结果统一处理入口
/// 以后请统一在此处理支付结果
- (void)paymentResultHandle
{
    switch (self.type)
    {
        case Pay_Hotel:
        {
            _hotelOrderDetailRq = [[HYHotelOrderDetailRequest alloc] init];
            _hotelOrderDetailRq.orderId = self.orderID;
            HYUserInfo *user = [HYUserInfo getUserInfo];
            _hotelOrderDetailRq.userId = user.userId;
            
            if (user.userType == Enterprise_User)
            {
                _hotelOrderDetailRq.is_enterprise = @"1";
            }
            
            __weak typeof(self) b_self = self;
            [_hotelOrderDetailRq sendReuqest:^(id result, NSError *error) {
                if (!error && [result isKindOfClass:[HYHotelOrderDetailResponse class]])
                {
                    HYHotelOrderDetailResponse *response = (HYHotelOrderDetailResponse *)result;
                    if (response.orderDetail.status == Cancel) //订单被取消
                    {
                        [b_self updatePaymentStatus:@"订单超时异常，请联系客服" succ:NO];
                    }
                    else
                    {
                        [b_self updatePaymentStatus:@"支付成功"succ:YES];
                    }
                }
                else
                {
                    [b_self updatePaymentStatus:@"网络异常，订单状态获取失败"succ:NO];
                }
            }];
        }
            break;
        case Pay_Flight:
        {
            __weak typeof(self) b_self = self;
            _flightOrderDetailRq = [[HYFlightGetOrderInfoRequest alloc] init];
            
            if (self.originCode.length > 0)
            {
                _flightOrderDetailRq.orderCode = self.originCode;
            }
            else if ([self.orderCode length] > 0)
            {
                _flightOrderDetailRq.orderCode = self.orderCode;
            }
            else
            {
                _flightOrderDetailRq.orderCode = self.orderID;
            }
            
            HYUserInfo *user = [HYUserInfo getUserInfo];
            _flightOrderDetailRq.user_id = user.userId;
            //如果为企业用户
            if (user.userType == Enterprise_User)
            {
                _flightOrderDetailRq.isEnterprise = 1;
            }
            
            [_flightOrderDetailRq sendReuqest:^(id result, NSError *error) {
                if (!error && [result isKindOfClass:[HYFlightGetOrderInfoResponse class]])
                {
                    HYFlightGetOrderInfoResponse *response = (HYFlightGetOrderInfoResponse *)result;
                    if (response.flightOrder.status == 512) //订单被取消
                    {
                        [b_self updatePaymentStatus:@"订单超时异常，请联系客服"succ:NO];
                    }
                    else
                    {
                        [b_self updatePaymentStatus:@"支付成功"succ:YES];
                    }
                }
                else
                {
                    [b_self updatePaymentStatus:@"网络异常，订单状态获取失败"succ:NO];
                }
            }];
        }
            break;
        case Pay_Flower:
        {
            __weak typeof(self) b_self = self;
            _flowerOrderDetailRq = [[HYFlowerGetOrderInfoRequest alloc] init];
            _flowerOrderDetailRq.OrderNo = self.orderID;
            
            HYUserInfo *user = [HYUserInfo getUserInfo];
            if (user.userType == Enterprise_User)
            {
                _flowerOrderDetailRq.IsEnterprise = 1;
            }
            
            [_flowerOrderDetailRq sendReuqest:^(id result, NSError *error) {
                if (!error && [result isKindOfClass:[HYFlowerGetOrderInfoResponse class]])
                {
                    HYFlowerGetOrderInfoResponse *response = (HYFlowerGetOrderInfoResponse *)result;
                    if (response.flowerOrder.order_status == 6) //订单被取消
                    {
                        [b_self updatePaymentStatus:@"订单超时异常，请联系客服"succ:NO];
                    }
                    else
                    {
                        [b_self updatePaymentStatus:@"支付成功"succ:YES];
                    }
                }
                else
                {
                    [b_self updatePaymentStatus:@"网络异常，订单状态获取失败"succ:NO];
                }
            }];
        }
            break;
        case Pay_Mall:
        {
            /**
             * 2016.02.22 modify by Charse
             * 因为订单迁移导致的处理流程变化，去掉该查询
             */
            HYPaymentSuccViewController *vc = [[HYPaymentSuccViewController alloc] init];
            vc.adressInfo = self.adressInfo;
            vc.price = self.amountMoney;
            vc.orderCode = self.orderCode;
            vc.navbarTheme = self.navbarTheme;
            vc.point = self.point;
            [self.navigationController pushViewController:vc animated:YES];
            
            /*
            __weak typeof(self) b_self = self;
            _mallOrderDetailRq = [[HYMallOrderDetailRequest alloc] init];
            _mallOrderDetailRq.order_code = self.orderCode;
            
            [_mallOrderDetailRq sendReuqest:^(id result, NSError *error) {
                if (!error && [result isKindOfClass:[HYMallOrderDetailResponse class]])
                {
                    HYMallOrderDetailResponse *response = (HYMallOrderDetailResponse *)result;
                    if ([response isValid]) //订单被取消
                    {
                        HYPaymentSuccViewController *vc = [[HYPaymentSuccViewController alloc] init];
                        vc.adressInfo = b_self.adressInfo;
                        vc.price = b_self.amountMoney;
                        vc.orderCode = b_self.orderCode;
                        vc.navbarTheme = b_self.navbarTheme;
                        vc.point = b_self.point;
                        [b_self.navigationController pushViewController:vc animated:YES];
                    }
                    else
                    {
                        [b_self updatePaymentStatus:@"订单超时异常，请联系客服"succ:NO];
                    }
                }
                else
                {
                    [b_self updatePaymentStatus:@"网络异常，订单状态获取失败"succ:NO];
                }
            }];
             */
        }
            break;
        case Pay_O2O_QRScan:
        {
            [self goToPayResultPage];
        }
            break;
        case Pay_DidiTaxi:
            if (_paymentCallback) {
                _paymentCallback(self, nil);
            }
            break;
        default:
            /// 如果有支付回调，使用支付回调
            if (_paymentCallback)
            {
                _paymentCallback(self, nil);
            }
            break;
    }
}

/// 提示支付结果
- (void)updatePaymentStatus:(NSString *)msg succ:(BOOL)succ
{
    _paySuccess = succ;
    
    _alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                            message:msg
                                           delegate:self
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
    [_alertView show];
}

/// 提示支付结果的回调
/// 如果到了弹出框处理，说明前面没有调用回调，所以这里
/// 如果有回调的话就调用回调，否则直接返回吧
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_paySuccess)
    {
        if (_paymentCallback)
        {
            _paymentCallback(self, nil);
        }
        /// 遗留，为了不影响其他逻辑
        else if (self.type == Pay_Mall)
        {
            HYPaymentSuccViewController *vc = [[HYPaymentSuccViewController alloc] init];
            vc.adressInfo = self.adressInfo;
            vc.price = self.amountMoney;
            vc.orderCode = self.orderCode;
            vc.navbarTheme = self.navbarTheme;
            vc.point = self.point;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    //支付失败
    else
    {
        //商城订单支付失败后，跳转到商品订单列表
        switch (self.type)
        {
            case Pay_Mall:
            {
                HYMineInfoViewController *vc = (HYMineInfoViewController*)self.navigationController.viewControllers[0];
                [vc.baseViewController setCurrentSelectIndex:3];
                HYMallOrderListViewController *pushVc = [[HYMallOrderListViewController alloc]init];
                [vc.navigationController pushViewController:pushVc animated:YES];
                
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
                break;
                default:
                break;
        }
    }
}

#pragma mark -
#pragma mark -  支付准备参数

/// 获取支付参数
- (void)getPayNOWithPaymentType
{
    [HYLoadHubView show];
    
    if (!_IsselectedOfSectionZero)
    {
        _walletAmout = nil;
    }
    else if ([_cashAccountInfo.balance doubleValue] >= self.payMoney.doubleValue)  //完全使用余额
    {
        self.paymentType = @"tsh_wallet";
        _walletAmout = self.payMoney;
    }
    else if (_stillNeedPay.doubleValue)  //余额不够
    {
        _walletAmout = _cashAccountInfo.balance;
    }
    
    if (!_payNORequest)
    {
        _payNORequest = [[HYGetPayNORequest alloc] init];
    }
    
    [_payNORequest cancel];
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    
    _payNORequest.orderId = self.orderID;
    _payNORequest.orderCode = self.orderCode;
    _payNORequest.channelCode = self.paymentType;
    _payNORequest.cardNumber = user.number;
    _payNORequest.walletAmount = _walletAmout;
    _payNORequest.orderAmount = self.amountMoney;
    
    switch (self.type)
    {
        case Pay_Flight:
            _payNORequest.businessType = BusinessType_Flight;
            break;
        case Pay_Flower:
            _payNORequest.businessType = BusinessType_Flower;
            break;
        case Pay_Hotel:
            _payNORequest.businessType = BusinessType_Hotel;
            break;
        case Pay_Mall:
            _payNORequest.businessType = BusinessType_Mall;
            break;
        case Pay_BuyCard:
        case Pay_Renewal:
        case Pay_Upgrad:
            _payNORequest.businessType = BusinessType_Mall;
            break;
        case Pay_O2O_QRScan:
            _payNORequest.businessType = BusinessType_O2O_QRScan;
            break;
        case Pay_DidiTaxi:
            _payNORequest.businessType = BusinessType_DidiTaxi;
            break;
        case pay_phoneCharge:
            _payNORequest.businessType = BusinessType_PhoneCharge;
            break;
        default:
            break;
    }
    
    __weak typeof(self) b_self = self;
    [_payNORequest sendReuqest:^(id result, NSError *error) {
        
        NSString *tn = nil;
        NSString *orderCash = nil;
        NSString *orderAmount = nil;
        
        PayReq *pay = nil;
        
        if ([result isKindOfClass:[HYGetPayNOResponse class]])
        {
            HYGetPayNOResponse *response = (HYGetPayNOResponse *)result;
            tn = response.ylPrepayNo;
            orderCash = response.cashAmount;
            
            pay = response.wxPayInfo;
            
            b_self.tradeItemCode = response.tradeItemCode;
            b_self.alipayNotifyUrl = response.notifyUrl;  //支付宝回调地址
        }
        
        [b_self payWithCreditCardWithTN:tn
                              orderCash:orderCash
                            orderAmount:orderAmount
                                  wxPay:pay
                                  error:error];
    }];
}

/// 获取用户余额
- (void)getCashAccountInfo
{
    [HYLoadHubView show];
    
    _cashAccReq = [[HYUserCashAccountInfoRequest alloc] init];
    
    __weak typeof(self) b_self = self;
    [_cashAccReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        
        if ([result isKindOfClass:[HYUserCashAccountInfoResponse class]])
        {
            HYUserCashAccountInfoResponse *response = (HYUserCashAccountInfoResponse *)result;
            b_self.cashAccountInfo = response.cashAccountInfo;
            [b_self caculateExtraPayment];
            [b_self.tableView reloadData];
        }
    }];
}

#pragma mark - 支付过程

- (void)payWithCreditCardWithTN:(NSString *)tn
                      orderCash:(NSString *)orderCash
                    orderAmount:(NSString *)orderAmount
                          wxPay:(PayReq *)wxPay
                          error:(NSError *)error
{
    [HYLoadHubView dismiss];
    _isGetPayNO = NO;
    
    if (!error)
    {
        //钱包里面的钱已经支付了，需要更新支付金额
        if (orderCash.floatValue > 0)
        {
            self.payMoney = orderCash;
            [self getCashAccountInfo];
        }
        
        //如果选择了支付并且使用了钱包支付，应该更新支付状态
        if (_walletAmout && self.payCallback)
        {
            self.payCallback(NO, nil);
        }
        
        
        if ([self.paymentType hasPrefix:@"ZFB"])
        {
            //支付宝支付
            [MobClick event:@"v430_teshehuishouyintai_zhifubaozhifu_jishu"];
            
            [self payAlipayWithPrice:orderCash];
        }
        else if ([self.paymentType hasPrefix:@"ZGYL"])
        {
            //银联支付
            [MobClick event:@"v430_teshehuishouyintai_yinlianzhifu_jishu"];
            
            if ([tn length] > 0)
            {
                [UPPayPlugin startPay:tn
                                 mode:kUPPayMode
                       viewController:self
                             delegate:self];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                                message:@"银联交易流水号获取失败，请选择其它支付方式"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else if ([self.paymentType hasPrefix:@"WX"])
        {
            //微信支付
            [MobClick event:@"v430_teshehuishouyintai_weixinzhifu_jishu"];
            
            NSString *errorMsg = nil;
            if (!wxPay)
            {
                errorMsg = @"微信支付信息获取失败，暂不能使用微信支付!";
            }
            else if (![WXApi isWXAppInstalled])
            {
                errorMsg = @"抱歉，您尚未安装微信客户端，暂不能使用微信支付!";
            }
            else if (![WXApi isWXAppSupportApi])
            {
                errorMsg = @"抱歉，您的微信客户端版本过低，暂不能使用微信支付!";
            }
            else if (![WXApi sendReq:wxPay])
            {
                errorMsg = @"微信支付失败，请选择其它支付方式";
            }
            
            if (errorMsg)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:errorMsg
                                                               delegate:nil
                                                      cancelButtonTitle:@"选择其他支付方式"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else if ([self.paymentType isEqualToString:@"tsh_wallet"])  //使用余额支付，立即成功结束支付
        {
            if (self.type == Pay_O2O_QRScan)
            {
                [self goToPayResultPage];
                
            }
            else
            {
                if (self.paymentCallback)
                {
                    self.paymentCallback(self, nil);
                }
                else
                {
                    [self updatePaymentStatus:@"支付成功！" succ:YES];
                }
            }
        }
    }
    else if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                        message:error.domain
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
//
//- (void)payWithBankCard
//{
//    HYBankViewController *vc = [[HYBankViewController alloc] init];
//    [self.navigationController pushViewController:vc
//                                         animated:YES];
//}

#pragma mark -支付宝支付

- (void)payAlipayWithPrice:(NSString *)price
{
    NSString *appScheme = @"Teshehui";
    /*
    HYAlipayOrder *alOrder = [[HYAlipayOrder alloc] init];
    alOrder.partner = PartnerID;
    alOrder.seller = SellerID;
    alOrder.tradeNO = response.orderNumber; //订单号 (显示订单号)
    alOrder.productName = response.orderNumber; //商品标题 (显示订单号)
    alOrder.productDescription = [NSString stringWithFormat:@"【特奢汇】在线购卡: %@", response.orderNumber]; //商品描述
    alOrder.amount = response.orderAmount; //商品价格
     */
    self.alipayOrder = [[HYAlipayOrder alloc] init];
    self.alipayOrder.partner = PartnerID;
    self.alipayOrder.seller = SellerID;
    self.alipayOrder.tradeNO = self.orderCode;
    self.alipayOrder.productName = self.orderCode;
    self.alipayOrder.productDescription = self.productDesc;
    self.alipayOrder.amount = self.amountMoney;
    self.alipayOrder.service = @"mobile.securitypay.pay";
    self.alipayOrder.paymentType = @"1";
    self.alipayOrder.inputCharset = @"utf-8";
    self.alipayOrder.itBPay = @"30m";
    self.alipayOrder.showUrl = @"m.alipay.com";
    
    if (price)
    {
        self.alipayOrder.amount = price;
    }
    
    if (self.tradeItemCode)
    {
        self.alipayOrder.tradeNO = self.tradeItemCode;
    }
    
    if (self.alipayNotifyUrl)
    {
        self.alipayOrder.notifyURL = self.alipayNotifyUrl;
    }
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [self.alipayOrder description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        __weak typeof(self) bself = self;
        [[AlipaySDK defaultService] payOrder:orderString
                                  fromScheme:appScheme
                                    callback:^(NSDictionary *resultDic) {
                                        [bself alipayResultHandle:resultDic];
                                    }];
    }
}


- (void)alipayResultHandle:(NSDictionary *)result
{
    DebugNSLog(@"reslut = %@",result);
    
    NSNumber *resultStatus = [result objectForKey:@"resultStatus"];
    NSString *memo = [result objectForKey:@"memo"];
    
    _paySuccess = (resultStatus.intValue == 9000);
    
    if ([memo length] <= 0)
    {
        memo = @"您已经取消支付宝支付";
    }
    
    if (_paySuccess)
    {
        [self paymentResultHandle];
    }
    else
    {
        //如果选择了支付并且使用了钱包支付，应该更新支付状态
        if (_walletAmout && self.payCallback)
        {
            self.payCallback(NO, nil);
        }
        
        //交易失败
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                             message:memo
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)alipayResultNotification:(NSNotification *)notify
{
    id obj = notify.object;
    
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* result = (NSDictionary *)obj;
        [self alipayResultHandle:result];
    }
    else if ([obj isKindOfClass:[PayResp class]])
    {
        PayResp *payResp = (PayResp *)obj;
        [self handlerWeChatPayResult:payResp];
    }
}

#pragma mark - 银联支付

/**
 * 银联支付完成的回调
 */
- (void)UPPayPluginResult:(NSString *)result
{
    _paySuccess = [result isEqualToString:@"success"];
    
    if (_paySuccess)
    {
        [self paymentResultHandle];
    }
    else
    {
        NSString* msg = @"支付失败";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"知道了", nil];
        [alertView show];
    }
}

#pragma mark - 微信支付

- (void)handlerWeChatPayResult:(PayResp *)payResp
{
    NSString *errorMsg = nil;
    
    switch (payResp.errCode)
    {
        case WXSuccess:
            _paySuccess = YES;
            break;
        case WXErrCodeCommon:
            errorMsg = @"微信支付失败";
            break;
        case WXErrCodeUserCancel:
            errorMsg = @"您已取消微信支付";
            break;
        case WXErrCodeSentFail:
            errorMsg = @"微信支付发生失败";
            break;
        case WXErrCodeAuthDeny:  //验证失败
            errorMsg = @"微信支付验证失败";
            break;
        case WXErrCodeUnsupport:
            errorMsg = @"抱歉，您的微信客户端版本过低，暂不能使用微信支付!";
            break;
        default:
            break;
    }
    
    if (errorMsg)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:errorMsg
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"知道了", nil];
        [alertView show];
    }
    else
    {
        [self paymentResultHandle];
    }
}

#pragma mark 检查O2O商家付款状态
- (void)goToPayResultPage{
    
    
    if(self.O2OpayType == TravelPay){
        //旅游跳转 结果是已经成功的，所以是无参的
        if (_travelTicketsPaymentSuccess)
        {
            self.travelTicketsPaymentSuccess();
        }
    }else{
        //跳转到支付成功的页面
        if (_businessPaymentSuccess)
        {
            self.businessPaymentSuccess(self.O2OpayType);
        }
    }
}

#pragma mark 页面跳转



#pragma mark Cell Delegate
//-(void)useAccountBalance:(UIButton *)sender
//{
//    sender.selected = !sender.isSelected;
//
//    if (sender.isSelected)
//    {
//        [self caculateExtraPayment];
//    }else _stillNeedPay = 0;
//
//    [self.tableView reloadData];
//}

//-(void)choosePayment:(UIButton *)sender
//{
//    self.senderButton = sender;
//    if (sender != _choosePayment)
//    {
//        self.choosePayment.selected = NO;
//    }
//    sender.selected = !sender.isSelected;
//    self.choosePayment = sender;
//}
@end
