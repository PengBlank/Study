//
//  PaymentConfirmViewController.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "PaymentConfirmViewController.h"
#import "PaymentConfirmTableViewCell.h"
#import "TYTicketCountModel.h"
#import "TravelTicketsListModel.h"
#import "TYOrderNumModel.h"
#import "DefineConfig.h"
#import "TravelPurchaseRequest.h"
#import "HYUserInfo.h"
#import "MJExtension.h"
#import "METoast.h"

#import "HYPaymentViewController.h"
#import "TicketPaySuccessViewController.h"

#import "HYNormalLeakViewController.h"
#import "HYExperienceLeakViewController.h"

#define CSS_ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString * const STATIC_PAYCELLNIBNAME     = @"PaymentConfirmTableViewCell";
static NSString * const STATIC_PAYCELL_IDENTIFIER = @"paymentCell";

// 特奢汇价 = 1 //原价 = 2
typedef enum PaymentPayType : NSInteger {
    PaymentPayTypeTSH      = 1,
    PaymentPayTypeOriginal = 2
}PaymentPayType;

@interface PaymentConfirmViewController ()
<UITableViewDataSource,UITableViewDelegate>
{
    NSArray         *_arrCountSelected;        //  门票数量大于0的 allkeys (cell用)
    NSArray         *_arrRequestPost;          //  传给接口的门票数组
    TYOrderNumModel *_orderResult;             // 支付成功后返回的订单数据，用于传给付款成功页面
    float           _fOriginalAllPrice;
    BOOL            _isCouponInadequatePopBack;// 是现金券不足页面返回的
}
@property (weak, nonatomic  ) IBOutlet UITableView    *tbTickets;
@property (weak, nonatomic  ) IBOutlet UILabel        *lblAllPrice;
@property (weak, nonatomic  ) IBOutlet UIButton       *btnSavePrice;
@property (nonatomic ,assign) PaymentPayType payType;
@property (nonatomic ,strong) TravelPurchaseRequest *travelBuyRequest;

@end

@implementation PaymentConfirmViewController

//- (void)dealloc{
//    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
//}

// 这里是判断是不是从现金券不足的页面返回的
// 因为现金券不足的页面是总部写的，不好改代码，所以在这里用这个笨办法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isMovingToParentViewController == NO) {
        
        // 如果是现金券不足页面返回的，就选中原价
        if (_isCouponInadequatePopBack) {
            _isCouponInadequatePopBack = NO;
            NSIndexPath *originalCell  = [NSIndexPath indexPathForRow:2 inSection:1];
            [self tableView:_tbTickets didSelectRowAtIndexPath:originalCell];
        }
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title                 = @"确认支付信息";
    _tbTickets.tableFooterView = [UIView new];
    
    if (_dicTicketSelected) {
        
        //　遍历保存的门票数量
        NSMutableArray *__block arrKeys = [[NSMutableArray alloc]initWithCapacity:_dicTicketSelected.count];
        NSMutableArray *__block arrPost = [[NSMutableArray alloc]initWithCapacity:_dicTicketSelected.count];

        [_dicTicketSelected enumerateKeysAndObjectsUsingBlock:^(id key, TYTicketCountModel *tModel, BOOL *stop) {
            // 门票数量不为0时
            if (tModel.countAdilt > 0 || tModel.countChild > 0) {
                // 这里显示用
                [arrKeys addObject:[NSNumber numberWithInteger:[key integerValue]]];
                
                TravelSightInfo *tInfo = _ticketsModel.tickets[[key integerValue]];
                // 这里计算出每种票的总价，不是票的单价，重新组装数组，再传给接口（谁知道接口非要我们算、我们传）
                TravelPurchaseRequestTicket *ticket = [[TravelPurchaseRequestTicket alloc]init];
                ticket.ticketName   = tInfo.ticketName;
                ticket.days         = tInfo.days;
                ticket.adultTickets = [NSString stringWithFormat:@"%@",@(tModel.countAdilt)];
                ticket.childTickets = [NSString stringWithFormat:@"%@",@(tModel.countChild)];
                float price = ([tInfo.adultPrice floatValue]* tModel.countAdilt) + ([tInfo.childPrice floatValue]* tModel.countChild);
                float pricetsh = ([tInfo.tshAdultPrice floatValue]* tModel.countAdilt) + ([tInfo.tshChildPrice floatValue]* tModel.countChild);
                float coupon = ([tInfo.tshAdultCoupon floatValue]* tModel.countAdilt) + ([tInfo.tshChildCoupon floatValue]* tModel.countChild);
                ticket.price    = [NSString stringWithFormat:@"%@",@(price)];
                ticket.tshPrice = [NSString stringWithFormat:@"%@",@(pricetsh)];
                ticket.coupon   = [NSString stringWithFormat:@"%@",@(coupon)];
                ticket.tId      = tInfo.tId;
                [arrPost addObject:[ticket keyValues]];
            }
        }];
        
        // 将有门票数量大于1的key数组重新排序
        _arrCountSelected    = [arrKeys sortedArrayUsingSelector:@selector(compare:)];
        _arrRequestPost      = arrPost;// 将计算好的门票数据赋值
        _payType             = PaymentPayTypeTSH;// 默认选中特奢汇价
        NSIndexPath *tshCell = [NSIndexPath indexPathForRow:1 inSection:1];
        [_tbTickets selectRowAtIndexPath:tshCell animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self setAllPriceLabelText];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [HYLoadHubView dismiss];
}

#pragma mark - 点击事件
//　去支付
- (IBAction)btnPaymentClick:(id)sender {
    
    [self networkGetTicketOrderNum];
}

//　设置总价
- (void)setAllPriceLabelText{
    
    //　计算原价总额
    CGFloat __block fPrice = .0f;
    [_dicTicketSelected enumerateKeysAndObjectsUsingBlock:^(id key, TYTicketCountModel *tModel, BOOL *stop) {
        TravelSightInfo *tInfo = _ticketsModel.tickets[[key integerValue]];
        CGFloat price = ([tInfo.adultPrice floatValue] * tModel.countAdilt) + ([tInfo.childPrice floatValue] * tModel.countChild);
        fPrice += price;
    }];
    
    _fOriginalAllPrice = fPrice;
    
    if (_payType == PaymentPayTypeTSH) {
        
        NSString *tPrice  = [_strAllPrice stringByReplacingOccurrencesOfString:@"￥" withString:@""];
        NSString *title   = [NSString stringWithFormat:@"%.2f",_fOriginalAllPrice - tPrice.floatValue];
        NSString *title2  = [NSString stringWithFormat:@"%.0f",_fOriginalAllPrice - tPrice.floatValue];
        
        if (title.floatValue < 0) {
            title = @"0";
        }
        
        if (title2.floatValue < 0) {
            title2 = @"0";
        }
        
        _lblAllPrice.text = [NSString stringWithFormat:@"%@+%@现金券",_strAllPrice,_strAllCoupon];
        [_btnSavePrice setTitle:title forState:UIControlStateNormal];
        // 如果是0或者整数 不要小数点后两位 有更简单的方法么？..
        if (title.floatValue-title2.floatValue == 0.00f) {
            [_btnSavePrice setTitle:title2 forState:UIControlStateNormal];
        }
        
    }else{
        self.lblAllPrice.text = [NSString stringWithFormat:@"￥%.2f",_fOriginalAllPrice];
    }
}

#pragma mark - 网络事件
- (void)networkGetTicketOrderNum{
    
    [HYLoadHubView show];
    
    HYUserInfo *userInfo  = [HYUserInfo getUserInfo];
    
    [_travelBuyRequest cancel];
    _travelBuyRequest = nil;
    
    _travelBuyRequest = [[TravelPurchaseRequest alloc] init];
    _travelBuyRequest.interfaceURL       = [NSString stringWithFormat:@"%@/v3/travel/BuyTicket",TRAVEL_API_URL];
    _travelBuyRequest.interfaceType      = DotNET2;
    _travelBuyRequest.postType           = JSON;
    _travelBuyRequest.httpMethod         = @"POST";
    
    // 基础数据
    _travelBuyRequest.userId       = userInfo.userId ? : @"";
    _travelBuyRequest.mobile       = userInfo.mobilePhone ? : @"";  //增加mobile参数  12-23
    _travelBuyRequest.merId        = _ticketsModel.merId;
    _travelBuyRequest.cardNo       = userInfo.number ? : @"";
    _travelBuyRequest.priceType    = [NSString stringWithFormat:@"%@",@(_payType)];
    _travelBuyRequest.merchantName = _ticketsModel.touristName;
    _travelBuyRequest.userName     = userInfo.realName ? : @"";
    _travelBuyRequest.userDate     = _strSeletedDate;
    _travelBuyRequest.tickets      = _arrRequestPost;// 门票数据
    
    self.view.userInteractionEnabled = NO;
    WS(weakSelf);
    [_travelBuyRequest sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if(result){
             NSDictionary *objDic = [result jsonDic];
             NSInteger code = [objDic[@"code"] integerValue];
             if (code == 0) { //状态值为0 代表请求成功  其他为失败
                 TYOrderNumModel *order = [TYOrderNumModel objectWithKeyValues:objDic[@"data"]];
                 [weakSelf gotoPay:order];
             }else{
                 NSString *msg = objDic[@"msg"];
                 
                 if([msg isEqualToString:@"现金券不足"]){
                     
                     /*** 这里进行现金券不足页面跳转 页面由总部那边提供***/
                     
                     _isCouponInadequatePopBack = YES;
                     if (userInfo.userLevel == 0) { //体验用户跳转到体验用户的页面
                         HYExperienceLeakViewController *vc = [[HYExperienceLeakViewController alloc] init];
                         [weakSelf.navigationController pushViewController:vc animated:YES];
                     }
                     else {//正式会员用户跳转到正式会员的页面
                         HYNormalLeakViewController *vc = [[HYNormalLeakViewController alloc] init];
                         [weakSelf.navigationController pushViewController:vc animated:YES];
                     }
                     
                 }else{
                     [METoast toastWithMessage:msg ? : @"生成订单失败"];
                 }
             }
             
         }else{
             [METoast toastWithMessage:@"服务器请求异常"];
         }
          self.view.userInteractionEnabled = YES;
     }];
}

- (void)gotoPay:(TYOrderNumModel *)order{
    
    // 传给付款成功页面用
    _orderResult = order;
    
    // 特奢汇价的时候，传上个页面计算出来的总价
    NSString *price = [_strAllPrice stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    // 原价的时候，传这个页面计算出来的总价
    if (_payType == PaymentPayTypeOriginal)
        price = [NSString stringWithFormat:@"%@",@(_fOriginalAllPrice)];
    
    //　提交的订单信息
    HYAlipayOrder *alOrder = [[HYAlipayOrder alloc] init];
    alOrder.partner            = PartnerID;
    alOrder.seller             = SellerID;
    alOrder.tradeNO            = order.c2b_trade_no;//订单号 (显示订单号)
    alOrder.productName        = [NSString stringWithFormat:@"【特奢汇】O2O旅游购票订单: %@", order.c2b_trade_no];//商品标题 (显示订单号)
    alOrder.productDescription = [NSString stringWithFormat:@"【特奢汇】O2O旅游购票订单: %@", order.c2b_trade_no];//商品描述
    alOrder.amount             = [NSString stringWithFormat:@"%0.2f",price.floatValue];//商品价格
    
    HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
    payVC.navbarTheme   = self.navbarTheme;
    payVC.alipayOrder   = alOrder;
    payVC.amountMoney   = price;//付款总额
    payVC.point         = _strAllCoupon.floatValue;//  现金券
    payVC.orderID       = order.c2b_order_id;//用户获取银联支付流水号
    payVC.orderCode     = order.c2b_trade_no;//订单号
//    payVC.O2O_OrderNo   = order.o2o_trade_no;
//    payVC.O2O_storeName = _ticketsModel.touristName;
    payVC.type          = Pay_O2O_QRScan;
    payVC.O2OpayType    = TravelPay;
    
    // 支付成功后，跳转到显示付款成功页面
    __weak typeof(self) weakSelf = self;
    payVC.travelTicketsPaymentSuccess = ^{
        [weakSelf pushPaySuccess];
    };

    [self.navigationController pushViewController:payVC animated:YES];
}
//　回调支付成功
- (void)pushPaySuccess{

    TicketPaySuccessViewController *paySuccessController = [[TicketPaySuccessViewController alloc]initWithNibName:@"TicketPaySuccessViewController" bundle:nil];
    paySuccessController.arrCountSelected  = _arrCountSelected;
    paySuccessController.arrTicketsList    = _ticketsModel.tickets;
    paySuccessController.dicTicketSelected = _dicTicketSelected;
    paySuccessController.strScenicName     = _ticketsModel.touristName;
//     paySuccessController.strPayDate = 暂时显示手机的时间
    paySuccessController.strPaymentPrice   = _lblAllPrice.text;
    paySuccessController.strAllPrice       = _strAllPrice;
    paySuccessController.strTicketDate     = _strSeletedDate;
    paySuccessController.orderModel        = _orderResult;
    if (_payType == PaymentPayTypeTSH) 
        paySuccessController.strSavePrce = _btnSavePrice.titleLabel.text;
    
    paySuccessController.O2O_OrderNo = _orderResult.o2o_trade_no;

    [self.navigationController pushViewController:paySuccessController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 3;
    }
    return _arrCountSelected.count + 1;
}

// 解决cell线不靠边的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![cell isKindOfClass:[PaymentConfirmTableViewCell class]]) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
            [cell setSeparatorInset:UIEdgeInsetsZero];
        
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
            [cell setPreservesSuperviewLayoutMargins:NO];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
            [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //　代替的section高度
    if (indexPath.row == 0) {
        return 50.0f;
    }else{
        //　门票cell高度
        if (indexPath.section == 0){
            if (indexPath.row == _arrCountSelected.count)
                return 180.0f;
            return 170.0f;
        }
        //　会员价、原价的高度
        return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 第一行cell代替section header view
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TicketingTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
        }
        
        UIImageView *image       = [cell viewWithTag:101];
        UILabel *lblTitle        = [cell viewWithTag:102];
        UILabel *lblDate         = [cell viewWithTag:103];
        UIImageView *imageRignht = [cell viewWithTag:104];
        imageRignht.hidden       = YES;
        
        if (indexPath.section == 0) {
            image.image        = [UIImage imageNamed:@"ticketlist"];
            lblTitle.text      = @"购票";
            lblDate.text = [NSString stringWithFormat:@"票使用日期:%@",_strSeletedDate];
            lblDate.hidden     = NO;
        }else{
            image.image        = [UIImage imageNamed:@"payment"];
            lblTitle.text      = @"支付类型";
            lblDate.hidden     = YES;
        }
        return cell;
        
    }else{
        //　门票单元格
        if (indexPath.section == 0) {
            PaymentConfirmTableViewCell *cell = (PaymentConfirmTableViewCell *)[tableView dequeueReusableCellWithIdentifier:STATIC_PAYCELL_IDENTIFIER];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle]loadNibNamed:STATIC_PAYCELLNIBNAME owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            //　得到allkeys中的值
            id key                     = _arrCountSelected[indexPath.row - 1];
            //　得到保存的门票数量
            TYTicketCountModel *tModel = _dicTicketSelected[[key stringValue]];
            //　得到每个门票的信息
            TravelSightInfo *tInfo     = _ticketsModel.tickets[[key integerValue]];
            //　绑定数据
            [cell configureCell:tInfo TicketCount:tModel atIndexPath:indexPath isOriginal:(_payType == PaymentPayTypeOriginal)];
            return cell;
            
        }else{
            //　支付类型单元格
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle        = UITableViewCellSelectionStyleNone;
                UIImageView *accessory     = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choosePriceType"]];
                accessory.highlightedImage = [UIImage imageNamed:@"choosePriceTypeSeleted"];
                cell.accessoryView         = accessory;
                cell.textLabel.textColor = CSS_ColorFromRGB(0x343434);
                cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            }
            if (indexPath.row == 1)
                cell.textLabel.text = @"会员价";
            else
                cell.textLabel.text = @"原价";
            ((UIImageView *)cell.accessoryView).highlighted = (_payType == indexPath.row);
            return cell;
        }
        
    }
}

// 选中的时候，这里主要是切换会员价和原价
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0) || (indexPath.row == 0))
        return;
    UITableViewCell *cell                           = [tableView cellForRowAtIndexPath:indexPath];
    ((UIImageView *)cell.accessoryView).highlighted = YES;
    self.payType                                    = (PaymentPayType)indexPath.row;
    self.btnSavePrice.hidden                        = (_payType != PaymentPayTypeTSH);
    [tableView reloadData];
    [self setAllPriceLabelText];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0) || (indexPath.row == 0))
        return;
    UITableViewCell *cell                           = [tableView cellForRowAtIndexPath:indexPath];
    ((UIImageView *)cell.accessoryView).highlighted = NO;
}
@end
