//
//  HYMallOrderDetailViewController.m
//  Teshehui
//
//  Created by HYZB on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//
#import <TencentOpenAPI/QQApiInterface.h>

#import "HYMallOrderDetailViewController.h"
#import "HYMallOrderDetailStatusCell.h"
#import "HYMallOrderDetailBuyerCell.h"
#import "HYMallOrderDetailGoodsCell.h"
#import "HYCustomerServiceCell.h"
#import "HYMallOrderDetailHandleView.h"
#import "HYMallOrderListViewController.h"
#import "HYProductDetailViewController.h"
#import "HYMallOrderDetailRequest.h"
#import "HYLoadHubView.h"

#import "HYMallCancelOrderRequest.h"
#import "HYConfirmRequest.h"
#import "HYMallDelOrderRequest.h"
#import "HYMallOrderReturnListRequest.h"
#import "HYMallRemindDeliverRequest.h"
#import "HYOrderReturnDetailRequest.h"

#import "HYMallStoreInfo.h"
#import "HYMallHomeItemsInfo.h"
#import "HYMallReturnsInfo.h"

#import "HYCommentAddViewController.h"
#import "HYPaymentViewController.h"
#import "HYMallLogisticsTrackViewController.h"
#import "HYMallProductLIstViewController.h"
#import "HYGoodsReturnViewViewController.h"
#import "HYGoodsRetStatViewController.h"
#import "HYMallOrderDetailAbroadBuyUserInfoCell.h"

#import "METoast.h"
#import "HYUserInfo.h"

#import "HYAddressInfo.h"
#import "HYMallOrderDetailStoreNameCell.h"

#import "HYApplyAfterServiceListViewController.h"
#import "HYExpensiveAlertViewController.h"


#import "HYCommentAddOneStepViewController.h"


#import "HYIndemnityProgressViewController.h"
/// 环信
#import "HYChatManager.h"


#define CancelAlertViewTag  10
#define DeleteAlertViewTag  11
#define ConfirmAlertViewTag 12

@interface HYMallOrderDetailViewController ()
<
HYMallOrderHandleCellDelegate,
HYMallOrderDetailGoodsCellDelegate,
UIActionSheetDelegate,
HYCustomerServiceCellDelegate
>
{
    UIButton *_contactSeller;
    UIButton *_handleBtn;
    
    HYMallOrderDetailRequest *_orderDetailReq;
    HYMallOrderReturnListRequest *_returnReq;
    HYMallCancelOrderRequest *_cancelReq;
    HYConfirmRequest *_confirmReq;
    HYMallDelOrderRequest *_deleteReq;
    HYOrderReturnDetailRequest *_retDetailReq;
    HYMallRemindDeliverRequest *_remindReq;
    
    HYMallOrderDetailHandleView *_tootlView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYMallOrderSummary *handleOrder;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation HYMallOrderDetailViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_orderDetailReq cancel];
    _orderDetailReq = nil;
    
    [_returnReq cancel];
    _returnReq = nil;
    
    [_cancelReq cancel];
    _cancelReq = nil;
    
    [_confirmReq cancel];
    _confirmReq = nil;
    
    [_deleteReq cancel];
    _deleteReq = nil;
    
    [_remindReq cancel];
    _remindReq = nil;
    
    [_retDetailReq cancel];
    _retDetailReq = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"订单详情";
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    tableview.contentInset = UIEdgeInsetsMake(0, 0, TFScalePoint(44), 0);
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
    
    _tootlView = [[HYMallOrderDetailHandleView alloc]
                  initWithFrame:CGRectMake(0, frame.size.height - TFScalePoint(44), frame.size.width,TFScalePoint(44))];
    _tootlView.delegate = self;
    [self.view insertSubview:_tootlView aboveSubview:tableview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateToolView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadOrderDetail];
}

- (void)backToRootViewController:(id)sender
{
    if (self.loadFromPayResult)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [super backToRootViewController:sender];
    }
}

#pragma mark - private methods
- (void)updateToolView
{
    [_tootlView setOrderInfo:_orderInfo];
}

- (void)reloadOrderDetail
{
    [HYLoadHubView show];
    
    _orderDetailReq = [[HYMallOrderDetailRequest alloc] init];
    _orderDetailReq.order_code = _orderInfo.orderCode;
    
    __weak typeof(self) b_self = self;
    [_orderDetailReq sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        
        if (!error && [result isKindOfClass:[HYMallOrderDetailResponse class]])
        {
            HYMallOrderDetailResponse *response = (HYMallOrderDetailResponse *)result;
            b_self.orderInfo = response.orderDetail;
            
            //更新订单列表的状态
            //这里为什么使用refounded?
//            [b_self.orderListView updateWithOrder:response.orderDetail
//                                             type:Refounded];
            //这里已被转移至退换货的回调方法中
            
            [b_self.tableView reloadData];
            [b_self updateToolView];
        }
    }];
}

- (void)paymentWithOrder:(HYMallOrderSummary *)order
{
    if (order)
    {
        /*
         * 支付宝说明: 13-8-22;
         * 在多订单付款的时候，支付宝订单号使用订单的order_id，单订单的时候使用order_sn
         * 传递到支付界面的id必须都是订单id
         * 支付宝得回调都是订单id
         */
        HYAlipayOrder *alOrder = [[HYAlipayOrder alloc] init];
        alOrder.partner = PartnerID;
        alOrder.seller = SellerID;
        alOrder.tradeNO = order.orderCode; //订单号 (显示订单号)
        alOrder.productName = [NSString stringWithFormat:@"【特奢汇商城】商城订单: %@", order.orderCode]; //商品标题 (显示订单号)
        alOrder.productDescription = [NSString stringWithFormat:@"【特奢汇商城】商城订单: %@", order.orderCode]; //商品描述
        alOrder.amount = [NSString stringWithFormat:@"%0.2f",order.orderPayAmount.floatValue]; //待支付金额
        
        HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
        payVC.navbarTheme = self.navbarTheme;
        payVC.alipayOrder = alOrder;
        payVC.amountMoney = order.orderActualAmount;  //总价
        payVC.payMoney = order.orderPayAmount;  //待支付金额
        payVC.point = order.orderTbAmount.floatValue;
        payVC.orderID = order.orderId;
        payVC.orderCode = order.orderCode;
        payVC.type = Pay_Mall;
        payVC.adressInfo = order.address;
        __weak typeof(self) bself = self;
        
        payVC.payCallback = ^(BOOL succ, NSError *error){
            //刷新订单列表
            [bself reloadOrderDetail];
        };
        
        [self.navigationController pushViewController:payVC animated:YES];
    }
}

//确认收货
- (void)confirmReceipt
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"确定收到货了吗?"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定",nil];
    alert.tag = ConfirmAlertViewTag;
    [alert show];
}

- (void)confirmFinished:(NSInteger)status error:(NSError *)error
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    
    if (status == 200)
    {
        [METoast toastWithMessage:@"确认成功" duration:1.0f andCompleteBlock:^{
            [self reloadOrderDetail];
            [self updateToolView];
//            
//            [self.orderListView updateWithOrder:self.orderInfo
//                                           type:RecvConfig_Order];
        }];
    }
    else if(error)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:error.domain
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [METoast toastWithMessage:@"网络出现问题,请稍后再试"];
    }
}

- (void)getLogisticsTrack
{
    HYMallLogisticsTrackViewController *vc = [[HYMallLogisticsTrackViewController alloc] init];
    vc.orderCode = self.orderInfo.orderCode;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)remindStoreSend
{
    if (!_isLoading)
    {
        _isLoading = YES;
        [HYLoadHubView show];
        
        _remindReq = [[HYMallRemindDeliverRequest alloc] init];
        _remindReq.order_id = self.handleOrder.orderId;
        
        __weak typeof(self) b_self = self;
        [_remindReq sendReuqest:^(id result, NSError *error) {
            [HYLoadHubView dismiss];
            b_self.isLoading = NO;
            
            if (!error && [result isKindOfClass:[HYMallRemindDeliverResponse class]])
            {
                HYMallRemindDeliverResponse *response = (HYMallRemindDeliverResponse *)result;
                if (response.result)
                {
                    [METoast toastWithMessage:@"已经发送给卖家提醒发货"];
                }
                else
                {
                    [METoast toastWithMessage:@"提醒卖家发货失败"];
                }
            }
            else
            {
                [METoast toastWithMessage:error.domain];
            }
        }];
    }
}

- (void)cancelResult:(BOOL)result error:(NSError *)error
{
    [HYLoadHubView dismiss];
    _isLoading = NO;
    
    if (error)
    {
        [METoast toastWithMessage:error.domain
                 andCompleteBlock:nil];
    }
    else if (result)
    {
        self.handleOrder.status = 0;
        [self updateToolView];
        
        [self.orderListView updateWithOrder:self.orderInfo
                                       type:Cancel_Order];
    }
    else
    {
        [METoast toastWithMessage:@"取消订单失败"
                 andCompleteBlock:nil];
    }
}

- (void)deleteResult:(BOOL)result error:(NSError *)error
{
    [HYLoadHubView dismiss];
    _isLoading = NO;
    
    if (error)
    {
        [METoast toastWithMessage:error.domain
                         duration:1.5
                 andCompleteBlock:nil];
    }
    else if (result)
    {
        [self.orderListView updateWithOrder:self.orderInfo
                                       type:Delete_Order];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [METoast toastWithMessage:@"删除订单失败"
                 andCompleteBlock:nil];
    }
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",@"4008066528"];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)connectOnlineCustomnerService
{
    [[HYChatManager sharedManager] chatLogin];
    
    /// 对象
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    [muDic setObject:@"order"
              forKey:@"type"];
    [muDic setObject:@"商城订单"
              forKey:@"title"];
    [muDic setObject:[[self.orderInfo.orderItemPOList objectAtIndex:0] productName]
              forKey:@"desc"];
    [muDic setObject:[[self.orderInfo.orderItemPOList objectAtIndex:0] pictureSmallUrl]
              forKey:@"img_url"];
    [muDic setObject:self.orderInfo.orderPayAmount
              forKey:@"price"];
    [muDic setObject:[NSString stringWithFormat:@"订单号:%@", self.orderInfo.orderCode]
              forKey:@"order_title"];
    
    ChatViewController *vc = [[ChatViewController alloc] initWithChatter:kCustomerHXId
                                                                    type:eAfterSaleType];
    vc.commodityInfo = [muDic copy];

    [self.navigationController pushViewController:vc
                                         animated:YES];
    
//    QQApiWPAObject *wpaObj = [QQApiWPAObject objectWithUin:kCustomerQQForMall];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:wpaObj];
//    [QQApiInterface sendReq:req];
    
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //    [self handleSendResult:sent];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ConfirmAlertViewTag
        && buttonIndex == 1)
    {
        if (!_isLoading)
        {
            _isLoading = YES;
            [HYLoadHubView show];
            
            _confirmReq = [[HYConfirmRequest alloc] init];
            _confirmReq.order_code = self.handleOrder.orderCode;
            
            __weak typeof(self) b_self = self;
            [_confirmReq sendReuqest:^(id result, NSError *error) {
                
                if (result && [result isKindOfClass:[HYConfirmResponse class]])
                {
                    HYConfirmResponse *response = (HYConfirmResponse *)result;
                    [b_self confirmFinished:response.status error:error];
                }
            }];
        }
    }
}


#pragma mark - HYMallOrderHandleDelegate
- (void)handleOrderWithEventType:(HYMallOrderSummary *)order
                       eventType:(MallOrderHandleType)type
{
    self.handleOrder = order;
    
    switch (type)
    {
        case Payment_Order:  //付款
            [self paymentWithOrder:order];
            break;
        case ApplyAfterSaleService:
        {
            HYApplyAfterServiceListViewController *vc = [[HYApplyAfterServiceListViewController alloc]init];
            vc.orderCode = self.orderInfo.orderCode;
            vc.addressInfo = self.orderInfo.deliveryAddressPO;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Logistics:  //物流跟踪
            [self getLogisticsTrack];
            break;
        case Commend:  //评价
        {
//            HYCommentAddViewController *comment = [[HYCommentAddViewController alloc] init];
//            comment.orderInfo = self.orderInfo;
            HYCommentAddOneStepViewController *commentOneStep = [[HYCommentAddOneStepViewController alloc] init];
            commentOneStep.orderCode = _orderInfo.orderCode;
            [self.navigationController pushViewController:commentOneStep animated:YES];
            
        }
            break;
//        case AddCommend:  //追评
//        {
//            HYCommentAddViewController *comment = [[HYCommentAddViewController alloc] init];
//            comment.orderInfo = order;
//            [self.navigationController pushViewController:comment animated:YES];
//        }
//            break;
        case RemindStore:  //提醒发货
            [self remindStoreSend];
            break;
        case RecvConfig_Order:
            [self confirmReceipt];
            break;
        default:
            break;
    }
}

#pragma mark - HYMallOrderDetailGoodsCellDelegate
- (void)didRequestGuijiupei:(HYMallOrderItem *)goods
{
    if (1 == goods.isCanApplyGuijiupei)  //申请贵就赔
    {
        HYExpensiveAlertViewController *vc = [[HYExpensiveAlertViewController alloc]initWithNibName:@"HYExpensiveAlertViewController" bundle:nil];
        vc.orderCode = _orderInfo.orderCode;
        vc.productSKUCode = goods.productSKUCode;
        vc.productCode = goods.productCode;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (2 == goods.isCanApplyGuijiupei)  //查看进度
    {
        HYIndemnityProgressViewController *vc = [[HYIndemnityProgressViewController alloc]init];
        vc.goodsInfo = goods;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//- (void)didRequestReturnGoods:(HYMallOrderItem *)goods
//{
//    if (goods.isCanApplyReturn)
//    {
//        /*
//        HYGoodsReturnViewViewController *goodsReturn = [[HYGoodsReturnViewViewController alloc] init];
//        goodsReturn.orderItem = goods;
//        __weak typeof(self)b_self = self;
//        goodsReturn.returnCallback = ^(BOOL success)
//        {  
//            [b_self reloadOrderDetail];
//            [b_self.orderListView updateWithOrder:self.orderInfo
//                                             type:Refounded];
//        };
//        [self.navigationController pushViewController:goodsReturn animated:YES];
//         */
//    }
//    else
//    {
//        if ([self.orderInfo isKindOfClass:[HYMallOrderDetail class]])
//        {
//            if (goods.returnId && !_isLoading)
//            {
//                [HYLoadHubView show];
//                self.isLoading = YES;
//                
//                _retDetailReq = [[HYOrderReturnDetailRequest alloc] init];
//                _retDetailReq.return_id = goods.returnId;
//                __weak typeof(self)b_self = self;
//                [_retDetailReq sendReuqest:^(id result, NSError *error)
//                 {
//                     [HYLoadHubView dismiss];
//                     b_self.isLoading = NO;
//                     
//                     HYOrderReturnDetailResponse *rs = (HYOrderReturnDetailResponse *)result;
//                     if (!error && [rs isKindOfClass:[HYOrderReturnDetailResponse class]])
//                     {
//                         HYGoodsRetStatViewController *vc = [HYGoodsRetStatViewController statViewControllerWithRetusnInfo:rs.retInfo];
//                         if (vc)
//                         {
//                             [b_self.navigationController pushViewController:vc animated:YES];
//                         }
//                         else
//                         {
//                             [METoast toastWithMessage:[NSString stringWithFormat:@"未知的订单状态%d", rs.retInfo.refund_status]];
//                         }
//                         
//                     }
//                     else
//                     {
//                         [METoast toastWithMessage:@"获取售后信息失败"];
//                     }
//                 }];
//            }
//        }
//    }
//}

#pragma mark - HYCustomerServiceCellDelegate
- (void)didConnectCustomerServiceWithTpye:(CustomerServiceType)type
{
    if (type == OnlineService)
    {
        [self connectOnlineCustomnerService];
    }
    else
    {
        [self callCustomnerService];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    if (section == 3)
    {
        count = ([self.orderInfo.orderItemPOList count] + 2);
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *statusInfoCellId = @"statusInfoCellId";
        HYMallOrderDetailStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:statusInfoCellId];
        if (!cell)
        {
            cell = [[HYMallOrderDetailStatusCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                reuseIdentifier:statusInfoCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.childOrder = _orderInfo;
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString *addressInfoCellId = @"addressInfoCellId";
        HYMallOrderDetailBuyerCell *cell = [tableView dequeueReusableCellWithIdentifier:addressInfoCellId];
        if (!cell)
        {
            cell = [[HYMallOrderDetailBuyerCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:addressInfoCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        [cell setAdressInfo:_orderInfo.deliveryAddressPO];
        return cell;
        
    }
    else if (indexPath.section == 2) // 海淘用户信息
    {
        HYMallOrderDetailAbroadBuyUserInfoCell *cell = [HYMallOrderDetailAbroadBuyUserInfoCell cellWithTableView:tableView];
        [cell setUserInfoWithOrderInfo:_orderInfo];
        return cell;
    }
    else
    {
        if (indexPath.row == 0)  //店铺名
        {
            static NSString *storeNameInfoCellId = @"storeNameInfoCellId";
            HYMallOrderDetailStoreNameCell *cell = [tableView dequeueReusableCellWithIdentifier:storeNameInfoCellId];
            if (!cell)
            {
                cell = [[HYMallOrderDetailStoreNameCell alloc]initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:storeNameInfoCellId];
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = self.orderInfo.storeName;
            return cell;
        }
        //商品数据
        else if (indexPath.row < _orderInfo.orderItemPOList.count+1)
        {
            static NSString *goodsInfoCellId = @"goodsInfoCellId";
            HYMallOrderDetailGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellId];
            if (!cell)
            {
                cell = [[HYMallOrderDetailGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:goodsInfoCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            
            HYMallOrderItem *goods = [_orderInfo.orderItemPOList objectAtIndex:(indexPath.row-1)];
            cell.isSears = _orderInfo.isSears;
            [cell setGoodsInfo:goods];
            
            return cell;
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
}

#pragma mark - UITableViewDelegate
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 78;

    switch (indexPath.section)
    {
        case 0:
            height = 120;
            break;
        case 1:
            height = TFScalePoint(90);
            break;
        case 2:
            if (_orderInfo.isSears == 1)
            {
                height = 50;
            }
            else
            {
                height = 0;
            }
            break;
        case 3:
        {
            if (indexPath.row == 0)
            {
                height = 30;
            }
            else if (indexPath.row < [self.orderInfo.orderItemPOList count]+1)
            {
                height = 130;  //商品信息
            }
            else
            {
                height = 44;  //留言/配送方式
            }
        }
            break;
        default:
            break;
    }
    
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3 )
    {
        if (indexPath.row == 0)  //店铺
        {
             HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc]
                                            initReqWithStoreId:self.orderInfo.storeId];
             req.searchType = @"10";
            
             HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
             vc.title = self.orderInfo.storeName;
             vc.getSearchDataReq = req;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
        else
        {
            if (indexPath.row < [self.orderInfo.orderItemPOList count]+1)
            {
                HYMallOrderItem *goods = [self.orderInfo.orderItemPOList objectAtIndex:(indexPath.row-1)];
                
                HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
                vc.goodsId = goods.productCode;
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }
        }
    }
}

@end
