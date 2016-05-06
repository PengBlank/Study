//
//  HYPayWaysViewController.m
//  Teshehui
//
//  Created by Kris on 15/5/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYPayWaysViewController.h"
#import "HYBaseLineCell.h"
#import "HYPaymentViewController.h"
#import "HYTranscationFailViewController.h"
#import "HYTranscationSuccViewController.h"

#import "NSString+Addition.h"

#import "HYUserInfo.h"

#import "HYGetPaymentTypeRequest.h"
#import "HYGetPayNORequest.h"
#import "HYPayWaysRequest.h"

#import <AlipaySDK/AlipaySDK.h>
#import "UPPayPlugin.h"
#import "WXApi.h"
#import "HYAlipayOrder.h"
#import "DataSigner.h"

#import "ZXMultiFormatWriter.h"
#import "ZXImage.h"

NSString * const ThreePartyPaymentResultNotification;

@interface HYPayWaysViewController ()<UPPayPluginDelegate, UIAlertViewDelegate>
{
    HYGetPaymentTypeRequest *_payTypeRequest;
    HYGetPayNORequest *_payNORequest;
    HYPayWaysRequest *_getPayInfoReq;
    
    BOOL _isGetPayNO;
    BOOL _paySuccess;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *pay;
@property (nonatomic, strong) UIButton *QRcode;


@property (nonatomic, strong) NSArray *payTypes;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *paymentType;
@property (nonatomic, strong) HYPayWays *orderInfo;
@property (nonatomic, strong) HYAlipayOrder *alipayOrder;  //支付宝的订单对象


@end

@implementation HYPayWaysViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ThreePartyPaymentResultNotification
                                                  object:nil];
    
    [HYLoadHubView dismiss];
}
- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    tableview.contentInset = UIEdgeInsetsZero;
    tableview.rowHeight = 50;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ThreePartyPaymentResultNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alipayResultNotification:)
                                                 name:ThreePartyPaymentResultNotification
                                               object:nil];
    
    [self getPayInfoReq];
    [self getPaymentType];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择支付方式";

//    UILabel *illustration = [[UILabel alloc]init];
//    illustration.text = @"说明:支付rmb成功后，系统会自动扣除现金券";
//    illustration.textColor = [UIColor darkGrayColor];
//    illustration.font = [UIFont systemFontOfSize:13];
//    CGSize illSize = [illustration.text sizeWithFont:[UIFont systemFontOfSize:13]];
//    illustration.frame = (CGRect){{(self.view.frame.size.width - illSize.width) * 0.5, self.view.frame.size.height - 20}, illSize};
//    illustration.numberOfLines = 0;
//    [self.view addSubview:illustration];
    
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = TFRectMake(0, 0, 320, 250);
    _tableView.tableHeaderView = headerView;
    
    UIButton *QRcode = [[UIButton alloc] initWithFrame:TFRectMake(140*0.5, 30, 180, 180)];
    QRcode.userInteractionEnabled = NO;
    [QRcode setImage:[UIImage imageNamed:@"sm_zhifu01"]
            forState:UIControlStateNormal];
    //生成二维码图片
    if (self.QRcodeStr)
    {
        ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
        ZXBitMatrix *result = [writer encode:self.QRcodeStr
                                      format:kBarcodeFormatQRCode
                                       width:QRcode.frame.size.width
                                      height:QRcode.frame.size.width
                                       error:nil];
        
        if (result)
        {
            ZXImage *image = [ZXImage imageWithMatrix:result];
            [QRcode setBackgroundImage:[UIImage imageWithCGImage:image.cgimage]
                              forState:UIControlStateNormal];
        } else {
            [QRcode setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
    self.QRcode = QRcode;
    
    UILabel *pay = [[UILabel alloc]init];
    self.pay = pay;
    
    [headerView addSubview:QRcode];
    [headerView addSubview:pay];
}

#pragma mark - UITableViewDataSource
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *paymentTypeCellId = @"paymentTypeCellId";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:paymentTypeCellId];
    if (cell == nil)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:paymentTypeCellId];
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
        else if ([str isEqualToString:@"wap"])
        {
            cell.imageView.image = [UIImage imageNamed:@"ctrip_icon"];
            cell.textLabel.text = @"携程支付";
        }
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.payTypes count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [self.payTypes count])
    {
        NSString *str = [self.payTypes objectAtIndex:indexPath.row];
        if (![str isEqualToString:@"wap"])
        {
            self.paymentType = [self.payTypes objectAtIndex:indexPath.row];
            [self getPayNOWithPaymentType];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

#pragma mark pulice methods
- (IBAction)backToRootViewController:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"是否确定放弃支付"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark private methods
- (void)getPayInfoReq
{
    [HYLoadHubView show];
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    
    _getPayInfoReq = [[HYPayWaysRequest alloc] init];
    _getPayInfoReq.buyer_id = user.userId;
    _getPayInfoReq.voucher_code = self.payCode;
    
    __weak typeof(self) bself = self;
    [_getPayInfoReq sendReuqest:^(id result, NSError *error) {
        
        if (result && [result isKindOfClass:[HYPayWaysResponse class]])
        {
            bself.orderInfo = [(HYPayWaysResponse *)result payWays];
        }
        
        [bself updateViewWithData:bself.orderInfo error:error];
    }];
}

//更新界面数据
- (void)updateViewWithData:(HYPayWays *)orderInfo error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (!error)
    {
        NSNumber *tePoints = [NSNumber numberWithInteger:[self.orderInfo.points integerValue]];
        NSNumber *order_amount = [NSNumber numberWithFloat:[self.orderInfo.order_amount floatValue]];
        
        NSString *pointsStr = [NSString stringWithFormat:@"%@", tePoints];
        NSString *amountStr = [NSString stringWithFormat:@"%@", order_amount];
        NSString *str = [NSString stringWithFormat:@"您将支付￥%@ 现金券%@",
                         amountStr,
                         pointsStr];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor]
                     range:NSMakeRange(4, amountStr.length + 1 )];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]
                     range:NSMakeRange(4 + amountStr.length + 2, pointsStr.length + 2)];
        _pay.attributedText = attr;
        
        CGSize paySize = [_pay.text sizeWithFont:[UIFont systemFontOfSize:18]];
        CGFloat payW = paySize.width;
        _pay.frame = (CGRect){{(self.view.frame.size.width -payW) * 0.5, CGRectGetMaxY(_QRcode.frame) + 10}, paySize};
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:error.domain
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)getPaymentType
{
    [HYLoadHubView show];
    
    _payTypeRequest = [[HYGetPaymentTypeRequest alloc] init];
    _payTypeRequest.order_no = self.orderInfo.order_id;
    _payTypeRequest.order_type = @"voucher";
    
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
            
            [b_self.tableView reloadData];
        }
    }];
}

- (void)getPayNOWithPaymentType
{
    if (!_isGetPayNO)
    {
        _isGetPayNO = YES;
        
        [HYLoadHubView show];
        
        _payNORequest = [[HYGetPayNORequest alloc] init];
        _payNORequest.order_id = self.orderInfo.order_id;
        _payNORequest.order_type = @"voucher";
        _payNORequest.payment = self.paymentType;
        _payNORequest.isOnlineBuyCard = YES;
        
        __weak typeof(self) b_self = self;
        [_payNORequest sendReuqest:^(id result, NSError *error) {
            
            NSString *string = nil;
            PayReq *pay = nil;
            
            if ([result isKindOfClass:[HYGetPayNOResponse class]])
            {
                HYGetPayNOResponse *response = (HYGetPayNOResponse *)result;
                string = response.payNO;
                pay = response.wxPayInfo;
            }
            
            [b_self payWithCreditCardWithTN:string wxPay:pay error:error];
        }];
    }
}

- (void)payWithCreditCardWithTN:(NSString *)tn
                          wxPay:(PayReq *)wxPay
                          error:(NSError *)error
{
    [HYLoadHubView dismiss];
    _isGetPayNO = NO;
    
    if (!error)
    {
        if ([self.paymentType isEqualToString:@"alipay"])
        {
            [self payWhitAlipay];
        }
        else if ([self.paymentType isEqualToString:@"chinapay"])
        {
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
//                HYTranscationFailViewController *vc = [[HYTranscationFailViewController alloc] init];
//                vc.errorMsg = errorMsg;
//                [self.navigationController pushViewController:vc
//                                                     animated:YES];
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
//        HYTranscationFailViewController *vc = [[HYTranscationFailViewController alloc] init];
//        vc.errorMsg = error.domain;
//        [self.navigationController pushViewController:vc
//                                             animated:YES];
    }
}

- (void)payWhitAlipay
{
    NSString *appScheme = @"Teshehui";
    
    if (!self.alipayOrder)
    {
        _alipayOrder = [[HYAlipayOrder alloc] init];
    }
    
    _alipayOrder.partner = PartnerID;
    _alipayOrder.seller = SellerID;
    _alipayOrder.tradeNO = self.orderInfo.order_sn; //订单号 (显示订单号)
    _alipayOrder.productName = [NSString stringWithFormat:@"特奢汇扫码订单: %@", self.orderInfo.order_sn]; //商品标题 (显示订单号)
    _alipayOrder.productDescription = [NSString stringWithFormat:@"特奢汇扫码订单: %@", self.orderInfo.order_sn]; //商品描述
    _alipayOrder.amount = [NSString stringWithFormat:@"%0.2f",self.orderInfo.order_amount.floatValue]; //商品价格
    
    //支付宝回调全部是订单id
    NSString *notifyStr = [NSString stringWithFormat:@"%@%@", kAlipayQRScanCallBackURL, self.orderInfo.order_id];
    NSString *callBackUrl = [notifyStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    _alipayOrder.notifyURL = callBackUrl; //回调URL
    _alipayOrder.service = @"mobile.securitypay.pay";
    _alipayOrder.paymentType = @"1";
    _alipayOrder.inputCharset = @"utf-8";
    _alipayOrder.itBPay = @"30m";
    _alipayOrder.showUrl = @"m.alipay.com";
    
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
        HYTranscationSuccViewController *vc = [[HYTranscationSuccViewController alloc] initWithNibName:@"HYTranscationSuccViewController"
                                                          bundle:nil];
        vc.order_amount = self.orderInfo.order_amount;
        vc.points = self.orderInfo.points;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else
    {
        HYTranscationFailViewController *vc = [[HYTranscationFailViewController alloc] initWithNibName:@"HYTranscationFailViewController" bundle:nil];
        vc.errorMsg = memo;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

- (void)handlerWeChatPayResult:(PayResp *)payResp
{
    NSString *errorMsg = nil;
    
    switch (payResp.errCode)
    {
        case WXSuccess:
        {
            _paySuccess = YES;
            HYTranscationSuccViewController *vc = [[HYTranscationSuccViewController alloc] initWithNibName:@"HYTranscationSuccViewController"
                                                          bundle:nil];
            vc.order_amount = self.orderInfo.order_amount;
            vc.points = self.orderInfo.points;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
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
        HYTranscationFailViewController *vc = [[HYTranscationFailViewController alloc] initWithNibName:@"HYTranscationFailViewController" bundle:nil];
        vc.errorMsg = errorMsg;
        [self.navigationController pushViewController:vc
                                             animated:YES];
        
    }
}

- (void)updatePaymentStatus:(NSString *)msg succ:(BOOL)succ
{
    _paySuccess = succ;
    
    UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                            message:msg
                                           delegate:self
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
    [_alertView show];
}


#pragma mark- UPPayPluginDelegate
/**
 * 银联支付完成的回调
 */
- (void)UPPayPluginResult:(NSString *)result
{
    _paySuccess = [result isEqualToString:@"success"];
    
    if (_paySuccess)
    {
        HYTranscationSuccViewController *vc = [[HYTranscationSuccViewController alloc] initWithNibName:@"HYTranscationSuccViewController"
                                                          bundle:nil];
        vc.order_amount = self.orderInfo.order_amount;
        vc.points = self.orderInfo.points;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else
    {
        NSString* msg = @"支付失败";
        if ([result isEqualToString:@"cancel"])
        {
            msg = @"您已取消银联支付";
        }
        
        HYTranscationFailViewController *vc = [[HYTranscationFailViewController alloc] initWithNibName:@"HYTranscationFailViewController" bundle:nil];
        vc.errorMsg = msg;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

#pragma mark- AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
