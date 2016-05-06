//
//  HYPaymentViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPaymentViewController.h"
#import "HYGetPaymentTypeRequest.h"
#import "HYGetPayNORequest.h"
//#import "HYGetFlowerPayNORequest.h"
//#import "HYGetFlightPayNORequest.h"
//#import "HYHotelPayNOrequest.h"
#import "HYUserInfo.h"
#import "HYAppDelegate.h"
#import "UIAlertView+Utils.h"
#import "HYQuickActive2ViewController.h"
#import "UINavigationItem+Margin.h"

//#import "HYMallMultiOrderStatusRequest.h"
//#import "HYFlowerGetOrderInfoRequest.h"
//#import "HYFlightGetOrderInfoRequest.h"
//#import "HYHotelOrderDetailRequest.h"

/*
 必填项;
 接入模式设定,两个值: @"00":代表接入生产环境(正式版 本需要); @"01":代表接入开发测试环境(测 试版本需要);
 */
#define kMode             @"00"

NSString * const ThreePartyPaymentResultNotification;

NSString * const AlipayResultNotification;

@interface HYPaymentViewController ()
<
UIAlertViewDelegate
>
{
    HYGetPaymentTypeRequest *_payTypeRequest;
    HYGetPayNORequest *_payNORequest;
    
    BOOL _isGetPayNO;
    BOOL _paySuccess;
    
    UIAlertView *_alertView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *payTypes;
@property (nonatomic, copy) NSString *paymentType;

//回调地址
@property (nonatomic, copy) NSString *alipayNotifyUrl;

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
    
    _alertView.delegate = nil;
    _alertView = nil;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    UILabel* nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10,0,50, 44)];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textColor = [UIColor darkTextColor];
    nameLab.font = [UIFont systemFontOfSize:18.0f];
    nameLab.text = @"金额:";
    [self.view addSubview:nameLab];
    
    UILabel* moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(60,0,240,44)];
    moneyLab.backgroundColor = [UIColor clearColor];
    moneyLab.textColor = [UIColor colorWithRed:1.0f green:0.49f blue:0.075 alpha:1.0f];
    moneyLab.font = [UIFont systemFontOfSize:18.0f];
    moneyLab.text = [NSString stringWithFormat:@"¥%.02f",self.amountMoney];
    [self.view addSubview:moneyLab];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
    [self.view addSubview:lineView];
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, frame.origin.y+44, frame.size.width, frame.size.height - 108)
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.scrollEnabled = NO;
    tableview.separatorColor = [UIColor grayColor];
    tableview.sectionFooterHeight = 0;
    tableview.sectionHeaderHeight = 45;
    tableview.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"支付方式";
    
    UIImage *back = [UIImage imageNamed:@"icon_back.png"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:back forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = backItem;
    [self.navigationItem setLeftBarButtonItemWithMargin:backItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ThreePartyPaymentResultNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alipayResultNotification:)
                                                 name:ThreePartyPaymentResultNotification
                                               object:nil];
    
    [self getPaymentType];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)backItemAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payTypes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    return height;
}

//- (void)tableView:(UITableView *)tableView
//  willDisplayCell:(UITableViewCell *)cell
//forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
//    if(indexPath.row == totalRow -1){
//        //this is the last row in section.
//        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
//        lineCell.separatorLeftInset = 0.0f;
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *hotelNameCell = @"hotelNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotelNameCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:hotelNameCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row < [self.payTypes count])
    {
        NSString *str = [self.payTypes objectAtIndex:indexPath.row];
        if ([str isEqualToString:@"alipay"])
        {
            cell.imageView.image = [UIImage imageNamed:@"person_icon_t2"];
            cell.textLabel.text = @"支付宝支付";
        }
        else if ([str isEqualToString:@"chinapay"])
        {
            cell.imageView.image = [UIImage imageNamed:@"person_icon_t3"];
            cell.textLabel.text = @"银联支付";
        }
        else if ([str isEqualToString:@"wechat"])
        {
            cell.imageView.image = [UIImage imageNamed:@"person_icon_t1"];
            cell.textLabel.text = @"微信支付";
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row < [self.payTypes count])
    {
        self.paymentType = [self.payTypes objectAtIndex:indexPath.row];
        [self getPayNOWithPaymentType];
    }
}

#pragma mark - HYFlightWapPayViewControllerDelegate
- (void)didPaymentResult:(BOOL)succ
{
    if (succ)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_paySuccess)
    {
        if (self.pre_vc)
        {
            [self.pre_vc clearInfo];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark private methods
- (void)getPaymentType
{
    [HYLoadHubView show];
    
    _payTypeRequest = [[HYGetPaymentTypeRequest alloc] init];
    
    __weak typeof(self) b_self = self;
    [_payTypeRequest sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        
        if ([result isKindOfClass:[HYGetPaymentTypeResponse class]])
        {
            HYGetPaymentTypeResponse *response = (HYGetPaymentTypeResponse *)result;
            //如果无法微信支付 则不显示,否则可能会审核无法通过
            if ((![WXApi isWXAppInstalled]) &&  (![WXApi isWXAppSupportApi]))
            {
                NSMutableArray *muArray = [response.payTypes mutableCopy];
                if ([muArray containsObject:@"wechat"])
                {
                    [muArray removeObject:@"wechat"];
                }
                
                b_self.payTypes = [muArray copy];
            }
            else
            {
                b_self.payTypes = response.payTypes;
            }
            
            [b_self.tableView reloadData];        }
    }];
}

- (void)getPayNOWithPaymentType
{
    if (!_isGetPayNO)
    {
        _isGetPayNO = YES;
        
        [self showLoadingView];
        
        _payNORequest = [[HYGetPayNORequest alloc] init];
        _payNORequest.order_id = self.orderID;
        _payNORequest.payment = self.paymentType;
        _payNORequest.type = Pay_BuyCard;
        
        __weak typeof(self) b_self = self;
        [_payNORequest sendReuqest:^(id result, NSError *error)
        {
            NSString *tn = nil;
            NSString *orderCash = nil;
            NSString *orderAmount = nil;
            
            PayReq *pay = nil;
            
            if ([result isKindOfClass:[HYGetPayNOResponse class]])
            {
                HYGetPayNOResponse *response = (HYGetPayNOResponse *)result;
                tn = response.payNO;
                orderAmount = response.order_amount;
                orderCash = response.order_cash;
                
                pay = response.wxPayInfo;
                
                b_self.alipayNotifyUrl = response.call_back_url;  //支付宝回调地址
            }
            
            [b_self payWithCreditCardWithTN:tn
                                  orderCash:orderCash
                                orderAmount:orderAmount
                                      wxPay:pay
                                      error:error];
        }];
    }
}

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
        if ([self.paymentType isEqualToString:@"alipay"])
        {
            [self payAlipayWithPrice:orderCash];
        }
        else if ([self.paymentType isEqualToString:@"chinapay"])
        {
            if ([tn length] > 0)
            {
                [UPPayPlugin startPay:tn
                                 mode:kMode
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
        else if ([self.paymentType isEqualToString:@"wechat"])
        {
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
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                        message:error.domain
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)payAlipayWithPrice:(NSString *)price
{
    NSString *appScheme = @"TshManagementDept";
    
    self.alipayOrder.service = @"mobile.securitypay.pay";
    self.alipayOrder.paymentType = @"1";
    self.alipayOrder.inputCharset = @"utf-8";
    self.alipayOrder.itBPay = @"30m";
    self.alipayOrder.showUrl = @"m.alipay.com";
    
    if (price)
    {
        self.alipayOrder.amount = price;
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
                                        [bself paymentResultHandle:resultDic];
                                    }];
    }
}

- (void)updatePaymentStatus:(NSString *)msg
{
    _alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                            message:msg
                                           delegate:self
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
    [_alertView show];
}

//支付回调通知
- (void)alipayResultNotification:(NSNotification *)notify
{
    id obj = notify.object;
    
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* result = (NSDictionary *)obj;
        [self paymentResultHandle:result];
    }
    else if ([obj isKindOfClass:[PayResp class]])
    {
        PayResp *payResp = (PayResp *)obj;
        [self handlerWeChatPayResult:payResp];
    }
}

//微信回调处理
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
}

//支付宝回调
- (void)paymentResultHandle:(NSDictionary *)result
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
        memo = @"会员卡购买成功，请注意查收短信。根据短信提供的卡号密码登录";
    }
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                         message:memo
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
    alertView.delegate = self;
    [alertView show];
}

/**
 * 银联支付完成的回调
 */
- (void)UPPayPluginResult:(NSString *)result
{
    _paySuccess = [result isEqualToString:@"success"];

    if (_paySuccess)
    {
        //[self getOrderDetailInfo];
        [self paySuccess];
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

- (void)paySuccess
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.tag = 200;
    [alert show];
}


@end
