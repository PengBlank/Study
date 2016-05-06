//
//  HYMallFullOrderViewController.m
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallFullOrderViewController.h"
#import "HYMallFullOrderToolView.h"
#import "HYMallFullOrderGoodsInfoCell.h"
#import "HYMallOrderAddressCell.h"
#import "HYMallOrderGuestbookCell.h"
#import "HYMallOrderExpandSectionView.h"
#import "HYMallOrderListViewController.h"
#import "HYMallFullOrderSectionView.h"
#import "HYDeliveryAddressViewController.h"
#import "HYLoadHubView.h"
#import "HYMallOrderListViewController.h"
#import "HYPaymentViewController.h"
#import "UIAlertView+BlocksKit.h"
#import "HYMineInfoViewController.h"

#import "HYExpressSelectViewController.h"
#import "HYUserInfo.h"
#import "HYMallCartShopInfo.h"

#import "HYGetAdressListRequest.h"
#import "HYGetAdressListResponse.h"
#import "HYMallSubmitOrderRequest.h"
#import "HYGetExpressPriceRequest.h"
#import "HYPaymentSuccViewController.h"
#import "HYProductDefaultDeliveryRequest.h"
#import "HYAbroadBuyAlertView.h"

#import "HYMallCartService.h"

#import "HYAnalyticsManager.h"
#import "UIAlertView+BlocksKit.h"
#import "HYAddressEditViewController.h"
#import "HYMallHomeViewController.h"
#import "NSString+Addition.h"

//现金券不足跳转
//status != 200 code = 29901002
#import "HYExperienceLeakViewController.h"
#import "HYNormalLeakViewController.h"

@interface HYMallFullOrderViewController ()
<
HYMallFullOrderSectionDelegate,
HYMallOrderExpandSectionViewDelegate,
DeliverAdreeDelegate,
HYMallFullOrderToolViewDelegate,
HYExpressSelectViewControllerDelegate,
HYAddressEditViewControllerDelegate,
UITextFieldDelegate,
UIAlertViewDelegate,
HYAbroadBuyAlertViewDelegate
>
{
    HYMallFullOrderToolView *_toolView;
    HYMallOrderExpandSectionView *_sectionView;
    
    HYGetAdressListRequest *_getAddressReq;
    HYMallSubmitOrderRequest *_submitOrderReq;
    HYGetExpressPriceRequest *_getExpFareReq;
    HYProductDefaultDeliveryRequest *_getDefaultDelivery;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYAddressInfo *adressInfo;
@property (nonatomic, strong) NSMutableDictionary *sectionsView;
@property (nonatomic, copy) NSString *priceDesc;

@property (nonatomic, strong) HYMallOrderSummary *orderGoods;
@property (nonatomic, strong) UIAlertView *goodsAdressAlert;
@property (nonatomic, strong) NSArray *defaultProductDeliveryArr;
@property (nonatomic, copy) NSString *totalQueryAmount;

@property (nonatomic, strong) HYAbroadBuyAlertView *alertV;

@end

@implementation HYMallFullOrderViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_getAddressReq cancel];
    _getAddressReq = nil;
    
    [_submitOrderReq cancel];
    _submitOrderReq = nil;
    
    [_getExpFareReq cancel];
    _getExpFareReq = nil;
    
    [_getDefaultDelivery cancel];
    _getDefaultDelivery = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"确认订单";
        _sectionsView = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    frame.size.height -= 44;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;

    if (CheckIOS7)
    {
        [tableview setSeparatorInset:UIEdgeInsetsMake(0, 2, 0, 2) ];
    }
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
    
    _toolView = [[HYMallFullOrderToolView alloc] initWithFrame:CGRectMake(0,
                                                                          frame.size.height,
                                                                          TFScalePoint(320),
                                                                          44)];
    _toolView.delegate = self;
    [self.view addSubview:_toolView];
    
    HYAbroadBuyAlertView *alertV = [[HYAbroadBuyAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertV.delegate = self;
    _alertV = alertV;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDefaultAddress];
    
    //
    [self updatePrice];
    
    //查询促销价
    [self queryPromotionInfo];
}

#pragma mark - HYAbroadBuyAlertViewDelegate
- (void)commitBtnActionWithIdentification:(NSString *)identification
                                 realName:(NSString *)realName;
{
    [self commitOrderWithIdCard:identification realName:realName];
}


#pragma mark - private methods
- (void)commitOrderWithIdCard:(NSString *)idCard realName:(NSString *)realName
{
    // 底部-确认
    if (self.storeList)
    {
        NSDictionary *dict = @{@"ProudctID":self.storeList};
        [MobClick event:@"v430_shangcheng_querendingdan_dibu_querenanniu_jishu" attributes:dict];
    }
    
    BOOL selectExpress = NO;
    
    _submitOrderReq = [HYMallSubmitOrderRequest requestWithStoreList:self.storeList
                                                     isSelectExpress:&selectExpress];
    _submitOrderReq.userAddressId = _adressInfo.addr_id;
    _submitOrderReq.isCommonlyAddress = NO;
    if (idCard.length > 0 && realName.length > 0)
    {
        _submitOrderReq.idCard = idCard;
        _submitOrderReq.realName = realName;
    }
    [_alertV dismiss];
    
    if (selectExpress)
    {
        [HYLoadHubView show];
        __weak typeof(self) b_self = self;
        [_submitOrderReq sendReuqest:^(id result, NSError *error)
         {
             HYMallSubmitOrderResponse *response = nil;
             if ([result isKindOfClass:[HYMallSubmitOrderResponse class]])
             {
                 response = (HYMallSubmitOrderResponse *)result;
             }
             
             [b_self updateWithOrderResponse:response error:error];
         }];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"请选择配送的物流"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

/**
 *查询促销信息用于订单校验
 */
- (void)queryPromotionInfo
{
//    HYMallCartService *service = [HYMallCartService new];
//    [service getPromotionInfoWithProductList:self.storeList callback:^(CGFloat totalQueryAmount) {
//        _totalQueryAmount = totalQueryAmount;
//    }];
}

- (void)getDefaultAddress
{
    _getAddressReq = [[HYGetAdressListRequest alloc] init];
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    _getAddressReq.userId = user.userId;
    
    __weak typeof(self) b_self = self;
    [_getAddressReq sendReuqest:^(HYGetAdressListResponse *result, NSError *error) {
        /*
        地址信息不会返回{status: 500;code:20401163; message:"收货地址升级，请小主重新编辑地址并保存"
         */
        if (result.status == 500
            && result.code == 20401163)
        {
            UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"收货地址升级，请小主重新编辑地址并保存" cancelButtonTitle:@"取消" otherButtonTitles:@[@"编辑"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (1 == buttonIndex)
                {
                    HYAddressEditViewController *vc = [[HYAddressEditViewController alloc]init];
                    vc.type = HYAddressManageEdit;
                    vc.delegate = b_self;
                    vc.navbarTheme = b_self.navbarTheme;
                    [b_self.navigationController pushViewController:vc animated:YES];
                }
            }];
            [alert show];
        }
        else if (!error && [result isKindOfClass:[HYGetAdressListResponse class]])
        {
            HYGetAdressListResponse *response = (HYGetAdressListResponse *)result;
            if ([response.addressList count] > 0)
            {
                b_self.adressInfo = [response.addressList objectAtIndex:0];
                [b_self.tableView reloadData];
                
                if (b_self.adressInfo) {
                    [b_self getDefaultDelivery];
                }
            }
            //没有收货地址
            else
            {
                UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"您还没有收货地址，请添加收货地址" cancelButtonTitle:@"取消" otherButtonTitles:@[@"添加"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (1 == buttonIndex)
                    {
                        HYAddressEditViewController *vc = [[HYAddressEditViewController alloc]init];
                        vc.type = HYAddressManageAdd;
                        vc.delegate = b_self;
                        vc.navbarTheme = self.navbarTheme;
                        [b_self.navigationController pushViewController:vc animated:YES];
                    }
                }];
                [alert show];
            }
        }
    }];
}


/**
 *  支付
 */
- (void)payment
{
    /*
     * 支付宝说明: 13-8-22;
     * 在多订单付款的时候，支付宝订单号使用订单的order_id，单订单的时候使用order_sn
     * 传递到支付界面的id必须都是订单id
     * 支付宝得回调都是订单id
     */
    //现在只用主订单号
    if (self.orderGoods)
    {
        HYMallOrderSummary *order = self.orderGoods;
        
        HYAlipayOrder *alOrder = [[HYAlipayOrder alloc] init];
        alOrder.partner = PartnerID;
        alOrder.seller = SellerID;
        alOrder.tradeNO = order.orderCode; //订单号 (显示订单号)
        alOrder.productName = [NSString stringWithFormat:@"【特奢汇商城】商城订单: %@", order.orderCode]; //商品标题 (显示订单号)
        alOrder.productDescription = [NSString stringWithFormat:@"【特奢汇商城】商城订单: %@", order.orderCode]; //商品描述
        alOrder.amount = [NSString stringWithFormat:@"%0.2f",order.orderPayAmount.floatValue]; //商品价格
        
        HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
        payVC.navbarTheme = self.navbarTheme;
        payVC.alipayOrder = alOrder;
        payVC.amountMoney = order.orderPayAmount;
        payVC.point = order.orderTbAmount.floatValue;
        payVC.orderID = order.orderId;
        payVC.orderCode = order.orderCode;
        payVC.type = Pay_Mall;
        payVC.adressInfo = self.adressInfo;
        payVC.canDragBack = NO;
        payVC.cancelCallback = ^(HYPaymentViewController *payVC){
            [UIAlertView bk_showAlertViewWithTitle:nil message:@"您还没有完成支付，确定要退出？" cancelButtonTitle:@"确认离开" otherButtonTitles:@[@"继续支付"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (0 == buttonIndex)
                {
                    NSMutableArray *vcs = [payVC.navigationController.viewControllers mutableCopy];
                    NSUInteger index = [vcs indexOfObject:payVC];
                    HYMallOrderListViewController *insertedVC = [[HYMallOrderListViewController alloc]init];
                    [vcs replaceObjectAtIndex:index-1 withObject:insertedVC];
                    payVC.navigationController.viewControllers = vcs;
                    [payVC.navigationController popViewControllerAnimated:YES];
                }
            }];
        };
        [self.navigationController pushViewController:payVC animated:YES];
    }
//    else if ([self.orderGoods count] > 1)
//    {
//        NSMutableString* nameStr = [[NSMutableString alloc] initWithString:@"【特奢汇商城】商城订单:"];
//        
//        NSMutableString *muOrderID = [[NSMutableString alloc] init];
//        NSMutableString *muOrderSN = [[NSMutableString alloc] init];
//        
//        NSString *orderIDs = nil;
//        NSString *orderSNs = nil;
//        
//        CGFloat money = 0.0f;
//        
//        for (HYMallOrderSummary *order in self.orderGoods)
//        {
//            [muOrderID appendString:[NSString stringWithFormat:@"%@N", order.orderId]];
//            [muOrderSN appendString:[NSString stringWithFormat:@"%@|", order.orderCode]];
//            money += order.orderTotalAmount.floatValue;
//        }
//        
//        if([muOrderID length] > 0)
//            orderIDs = [muOrderID substringToIndex:([muOrderID length]-1)];
//        
//        if([muOrderSN length] > 0)
//            orderSNs = [muOrderSN substringToIndex:([muOrderSN length]-1)];
//        
//        [nameStr appendString:orderSNs];
//        
//        HYAlipayOrder *order = [[HYAlipayOrder alloc] init];
//        order.partner = PartnerID;
//        order.seller = SellerID;
//        order.tradeNO = orderIDs; //订单ID (显示订单id)
//        order.productName = nameStr; //商品标题 (显示订单号)
//        order.productDescription = nameStr; //商品描述
//        order.amount = [NSString stringWithFormat:@"%0.2f",money]; //商品价格
//        
//        HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
//        payVC.navbarTheme = self.navbarTheme;
//        payVC.alipayOrder = order;
//        payVC.amountMoney = money;
//        payVC.orderID = orderIDs;
//        payVC.type = Pay_Mall;
//        payVC.adressInfo = self.adressInfo;
//        [self.navigationController pushViewController:payVC animated:YES];
//    }
}

- (void)updatePrice
{
    NSString *price = nil;
    CGFloat point = 0;
    for (HYMallCartShopInfo *item in self.storeList)
    {
        if (!price)
        {
            price = item.totalPrice;
        }
        else
        {
            price = [price stringDecimalByAdding:item.totalPrice];
        }
        point += item.totalPoint;
    }
    
    _toolView.point = point;
    _toolView.price = price;
    self.totalQueryAmount = price;
}

- (void)getDefaultDelivery
{
    if (self.storeList) {
        
        if (!_getDefaultDelivery) {
            _getDefaultDelivery = [[HYProductDefaultDeliveryRequest alloc] init];
        }
        
        NSMutableArray *productStoreList = [NSMutableArray array];
        for (NSInteger i = 0; i < self.storeList.count; i++) {
            
            HYMallCartShopInfo *info = self.storeList[i];
            
            NSMutableArray *productSKUList = [NSMutableArray array];
            for (NSInteger j = 0; j < info.goods.count; j++) {
                
               HYMallCartProduct *product = info.goods[j];
                NSDictionary *goodDict = @{@"productSKUCode":product.productSKUId,@"quantity":product.quantity};
                [productSKUList addObject:goodDict];
            }
            NSDictionary *productSKUListDict = @{@"productSKUList":productSKUList,@"storeId":info.store_id};
            [productStoreList addObject:productSKUListDict];
        }
        
        _getDefaultDelivery.userAddressId = self.adressInfo.addr_id;
        _getDefaultDelivery.productStoreList = productStoreList;
        
        [HYLoadHubView show];
        WS(weakSelf)
        [_getDefaultDelivery sendReuqest:^(id result, NSError *error) {
           
            [HYLoadHubView dismiss];
            HYProductDefaultDeliveryResponse *response = (HYProductDefaultDeliveryResponse *)result;
            if (response.companyList) {
                
                weakSelf.defaultProductDeliveryArr = response.companyList;
                [weakSelf updateStoreList];
                [weakSelf didSelectExperss:nil];
            }
            
            [weakSelf.tableView reloadData];
        }];
        
        
    }
}

/**
 * 将请求到的默认快递赋值到店铺列表信息
 */
- (void)updateStoreList
{
    for (NSInteger i = 0; i < self.defaultProductDeliveryArr.count; i++)
    {
        
        HYMallDefaultProductDeliveryModel *model = self.defaultProductDeliveryArr[i];
        
        for (NSInteger j = 0; j < self.storeList.count; j++)
        {
            
            HYMallCartShopInfo *shop = self.storeList[j];
            if ([model.storeId isEqualToString:shop.store_id])
            { // 默认快递店铺id与店铺id对应
                
                HYExpressInfo *expressInfo = [[HYExpressInfo alloc] init];
                expressInfo.expressId = model.deliveryId;
                expressInfo.expressName = model.deliveryName;
                expressInfo.price = model.deliveryFee;
                expressInfo.is_support = [model.isAvailable boolValue];
                expressInfo.is_default = [model.isMajor boolValue];
                shop.expressInfo = expressInfo;
                /*
                 @property (nonatomic, strong) NSString *expressId;  // 快递模板ID
                 @property (nonatomic, strong) NSString *expressName;  //快递模板名称
                 @property (nonatomic, assign) BOOL is_support;  //1：支持配送，0：不支持配送
                 @property (nonatomic, assign) BOOL is_default;  //1：表示店铺默认快递模板
                 @property (nonatomic, assign) CGFloat price;  //运费
                 */
            }
        }
    }
}

#pragma mark - HYMallFullOrderToolViewDelegate
- (void)didCommitOrder
{
    BOOL abroadBuy = NO;// 是否海淘
    for (HYMallCartShopInfo *shop in self.storeList)
    {
        HYMallCartProduct *goods = shop.goods[0];
        if ([goods.supplierType isEqualToString:kAbroadBuy])
        {
            abroadBuy = YES;
        }
    }
    
    if (abroadBuy)
    {
        [_alertV show];
    }
    else
    {
        [self commitOrderWithIdCard:nil realName:nil];
    }
}

-(void)updateWithOrderResponse:(HYMallSubmitOrderResponse *)response error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (response.status == 200)
    {
        self.orderGoods = response.orderList;
        
        [self payment];
        /*
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"订单提交成功"
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"去支付", @"查看订单",nil];
        [alert show];
         */
        
        //统计
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        
        for (HYMallCartShopInfo *store in self.storeList)
        {
            for (HYMallCartProduct *goods in store.goods)
            {
                if (goods.isSelect && goods.productSKUId)
                {
                    HYOrderItem *item = [[HYOrderItem alloc] init];
                    item.item_code = goods.productId;
                    item.sku_code = goods.productSKUId;
                    item.quantity = goods.quantity;
                    item.tsh_price = goods.salePrice;
                    item.color = goods.attributeValue1;
                    item.size = goods.attributeValue2;
                    item.brand_code = goods.brandId;
                    [tempArr addObject:item];
                }
            }
        }
        
        [[[HYAnalyticsManager alloc] init] purchaseEventWith:tempArr
                                               withOrderCode:response.orderList.orderCode
                                                       stgid:self.stgId];
    }
    else if (response.code == 29901002)
    {
        if ([HYUserInfo getUserInfo].userLevel == 0)
        {
            HYExperienceLeakViewController *vc = [[HYExperienceLeakViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            HYNormalLeakViewController *vc = [[HYNormalLeakViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    /*
     针对此需求，服务端会对用户收货地址校验返回指定的错误code(下单：29901036收货地址升级，请小主重新编辑地址并保存，退换货：29901037退换货地址升级，请小主重新编辑地址并保存），请APP配合调整！
     */
    else if (error)
    {
        if (response.code == 29901036
            || response.code == 29901037)
        {
            ///增加红边框
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            HYMallOrderAddressCell *cell = [_tableView cellForRowAtIndexPath:index];
            if (cell)
            {
                cell.layer.borderColor = [UIColor redColor].CGColor;
                cell.layer.borderWidth = 2;
                cell.layer.cornerRadius = 2.0;
            }
        }
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:error.domain
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - HYMallOrderExpandSectionViewDelegate
- (void)didExpandAllCell:(BOOL)expand
{
    for (HYMallCartShopInfo *shop in self.storeList)
    {
        shop.isSelect = expand;
        [self.tableView reloadData];
    }
}
#pragma mark - HYMallFullOrderSectionDelegate
- (void)didExpandCellWithSection:(NSInteger)section
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - DeliverAdreeDelegate
- (void)getAdress:(HYAddressInfo *)info
{
    if (info != self.adressInfo)
    {
        //去除红边框
//        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
//        HYMallOrderAddressCell *cell = [_tableView cellForRowAtIndexPath:index];
//        if (cell)
//        {
//            cell.layer.borderColor = [UIColor clearColor].CGColor;
//            cell.layer.borderWidth = 0;
//        }
        
        self.adressInfo = info;
        [self getDefaultDelivery];
        //清空物流信息
        for (HYMallCartShopInfo *item in self.storeList)
        {
            item.expressInfo = nil;
        }
        
        _toolView.hasExpress = NO;
        [self.tableView reloadData];
    }
}

#pragma mark - HYExpressSelectViewControllerDelegate
- (void)didSelectExperss:(HYExpressInfo *)express
{
    [self.tableView reloadData];
    _toolView.hasExpress = YES;
    [self updatePrice];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _goodsAdressAlert) {
        if (buttonIndex == 0) {
            
            //选择配送物流提示浮层-确定按钮
            [MobClick event:@"v430_shangcheng_querendingdan_peisongfangshixuanzefuceng_querenanniu_jishu"];
        }
    }
    /*
    else if (buttonIndex == alertView.firstOtherButtonIndex)  //支付
    {
        [self payment];
    }
    else
    {
        HYMallOrderListViewController *vc = [[HYMallOrderListViewController alloc] init];
        vc.title = @"商城订单";
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
     */
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGFloat height = self.tableView.contentOffset.y-254;
    height = height>0 ? height : 0;
    [self.tableView setContentOffset:CGPointMake(0, height) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat offset = 164;
    if (bounds.size.height > 480)
    {
        offset = 214;
    }
    CGRect rect = [self.tableView rectForSection:textField.tag];
    CGFloat height = rect.origin.y + rect.size.height;
    CGPoint point = CGPointMake(0, height-offset);
    [self.tableView setContentOffset:point animated:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        
        //买家留言栏
        [MobClick event:@"v430_shangcheng_querendingdan_maijialiuyanlan_jishu"];
    }
    
    NSInteger index = textField.tag-1;
    if (index>=0 && index < [self.storeList count])
    {
        HYMallCartShopInfo *shop = [self.storeList objectAtIndex:index];
        shop.guestbook = textField.text;
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + [self.storeList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    if (section >= 1 && (section-1)<[self.storeList count])
    {
        HYMallCartShopInfo *shop = [self.storeList objectAtIndex:(section-1)];
        if (shop.isSelect)
        {
            count = [shop.goods count]+2;
        }
        else
        {
            count = 0;
        }
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *addressInfoCellId = @"addressInfoCellId";
        HYMallOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressInfoCellId];
        if (!cell)
        {
            cell = [[HYMallOrderAddressCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:addressInfoCellId];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        [cell setAdressInfo:self.adressInfo];
        return cell;
    }
    else
    {
        HYMallCartShopInfo *shop = [self.storeList objectAtIndex:(indexPath.section-1)];
        
        if (indexPath.row == [shop.goods count])
        {
            static NSString *expressInfoCellId = @"expressInfoCellId";
            HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:expressInfoCellId];
            if (!cell)
            {
                cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:expressInfoCellId];
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = @"配送方式:";
            
            if (shop.expressInfo) // 店铺快递信息
            {
                if (shop.expressInfo.price.floatValue > 0)
                {
                    _priceDesc = [NSString stringWithFormat:@"%@  运费：¥%@", shop.expressInfo.expressName, shop.expressInfo.price];
                }
                else if (!shop.expressInfo.is_support)
                {
                    _priceDesc = @"该地址不在配送范围";
                }
                else
                {
                    _priceDesc = [NSString stringWithFormat:@"%@  免运费", shop.expressInfo.expressName];
                }
                
                cell.detailTextLabel.text = _priceDesc;
            }
            else
            {
                cell.detailTextLabel.text = nil;
            }
            return cell;
        }
        else if (indexPath.row > [shop.goods count])
        {
            static NSString *guestbookInfoCellId = @"guestbookInfoCellId";
            HYMallOrderGuestbookCell *cell = [tableView dequeueReusableCellWithIdentifier:guestbookInfoCellId];
            if (!cell)
            {
                cell = [[HYMallOrderGuestbookCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:guestbookInfoCellId];
                cell.fieldDelegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.guestbookField.tag = indexPath.section;
            cell.guestbookField.text = shop.guestbook;
            return cell;
        }
        else
        {
            static NSString *goodsInfoCellId = @"goodsInfoCellId";
            HYMallFullOrderGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellId];
            if (!cell)
            {
                cell = [[HYMallFullOrderGoodsInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                          reuseIdentifier:goodsInfoCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
//            for (HYMallCartShopInfo *shop in self.storeList)
//            {
//                if (shop.supplierType) {
//                    
//                }
//            }
            HYMallCartProduct *goods = [shop.goods objectAtIndex:indexPath.row];
//            [cell setSupplierType:shop.supplierType];
            [cell setGoodsInfo:goods];
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}

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
    CGFloat height = 0;
    
    if (indexPath.section >= 1 && (indexPath.section-1)<[self.storeList count])
    {
        HYMallCartShopInfo *shop = [self.storeList objectAtIndex:(indexPath.section-1)];
        
        if (indexPath.row < [shop.goods count])
        {
            height = 106;  //商品信息
        }
        else
        {
            height = 44;  //留言/配送方式
        }
    }
    else
    {
        height = self.adressInfo ? 114 : 44;
    }

    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > 0)
    {
        return 60;
    }
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 40;
    }
    
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (!_sectionView)
        {
            _sectionView = [[HYMallOrderExpandSectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 40)];
            _sectionView.delegate = self;
        }
        
        return _sectionView;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger index = section-1;
    if (index >= 0 && index<[self.storeList count])
    {
        HYMallCartShopInfo *shop = [self.storeList objectAtIndex:index];
        
        HYMallFullOrderSectionView *sectionView = [self.sectionsView objectForKey:[NSNumber numberWithInteger:section]];
        if (!sectionView)
        {
            sectionView = [[HYMallFullOrderSectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 60)];
            sectionView.tag = section;
            sectionView.delegate = self;
            [sectionView setStore:shop];
            
            [self.sectionsView setObject:sectionView forKey:[NSNumber numberWithInteger:section]];
        }
        
        sectionView.isExpend = shop.isSelect;
        
        return sectionView;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)  //address
    {
        //收货信息栏
        [MobClick event:@"v430_shangcheng_querendingdan_shouhuoxinxilan_jishu"];
        
        HYDeliveryAddressViewController* adressVC = [[HYDeliveryAddressViewController alloc]init];
        adressVC.navbarTheme = self.navbarTheme;
        adressVC.delegate = self;
        adressVC.type = 1;
        [self.navigationController pushViewController:adressVC animated:YES];
    }
    else
    {
        //配送方式栏
        [MobClick event:@"v430_shangcheng_querendingdan_peisongfangshilan_jishu"];
        
        HYMallCartShopInfo *shop = [self.storeList objectAtIndex:(indexPath.section-1)];
        if (indexPath.row == [shop.goods count])
        {
            if (!self.adressInfo)
            {
                _goodsAdressAlert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"请选择您的收货地址之后再选择物流"
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [_goodsAdressAlert show];
            }
            else
            {
                HYExpressSelectViewController *vc = [[HYExpressSelectViewController alloc] init];
                vc.address = self.adressInfo;
                vc.storeInfo = shop;
                vc.price = self.totalQueryAmount;
                vc.delegate = self;
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }
        }
    }
}

@end
