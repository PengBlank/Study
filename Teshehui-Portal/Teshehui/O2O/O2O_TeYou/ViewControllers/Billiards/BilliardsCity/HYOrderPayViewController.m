//
//  HYOrderPayViewController.m
//  Teshehui
//
//  Created by macmini7 on 15/11/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//  订单支付列表

#import "HYOrderPayViewController.h"
#import "HYBuyDrinksTableViewCell.h"
#import "HYPayTypeTableViewCell.h"
#import "Masonry.h"
#import "HYBilliardsCity.h"
#import "goodsInfo.h"
#import "HYUserInfo.h"
#import "METoast.h"
#import "HYAlipayOrder.h"
#import "DefineConfig.h"
#import "HYPaymentViewController.h"
#import "BilliardsCreateOrderRequest.h"
#import "MemberCardPayRequest.h"
#import "HYNormalLeakViewController.h"
#import "HYExperienceLeakViewController.h"
#import "PaySuccessViewController.h"
#import "CheckCardStatusReqeust.h"
#import "BilliardsOrderListRequest.h"
#import "TYBilliardsOrderInfo.h"
#import "TYBuyModelListInfo.h"
#import "BuyDrinksRequest.h"
#import "DefineConfig.h"
#import "UIImage+Common.h"
#import "UIColor+expanded.h"
#import "BilliardOrderViewController.h"
#import "BilliardsRateCell.h"
#import "FLCustomAlertView.h"
#import "UIColor+hexColor.h"
#import "PageBaseLoading.h"
typedef enum {
    PayTypeTSH = 0,
    PayTypeOther
} PayType;

@interface HYOrderPayViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

/**订单结算列表*/
@property (nonatomic,strong ) UITableView                 *bdPayTableView;
/**数据源*/
@property (nonatomic,strong ) NSMutableArray              *opArray;
/**确认支付*/
@property (nonatomic,strong ) UIButton                    *orderBut;
/**消费金额标签*/
@property (nonatomic,strong ) UILabel                     *bdMoneyLable;
/**现金券标签*/
@property (nonatomic,strong ) UILabel                     *bdCashLable;
/**消费金额*/
@property (nonatomic,strong ) UILabel                     *bdMoney;
/**现金券*/
@property (nonatomic,strong ) UILabel                     *bdCash;
/**表头*/
@property (nonatomic,strong ) NSArray                     *headArr;
/**表头图标*/
@property (nonatomic,strong ) NSArray                     *headImgArr;
/**支付-选中时的状态图标*/
@property (nonatomic,strong ) UIImageView                 *selectImg;
/**支付-非选中时的状态图标*/
@property (nonatomic,strong ) UIImageView                 *noSelectImg;
@property (nonatomic, strong) NSArray                     *billiardTitles;
@property (nonatomic, strong) NSArray                     *billiardDetails;

@property (nonatomic,strong ) BilliardsCreateOrderRequest *createOrderRequest;
@property (nonatomic,strong ) MemberCardPayRequest        *memberCardPayRequest;
@property (nonatomic,strong ) CheckCardStatusReqeust      *checkCardStatusReqeust;

@property (nonatomic,strong ) NSString                    *c2b_trade_no;
@property (nonatomic,strong ) NSString                    *o2o_trade_no;
@property (nonatomic,strong ) NSString                    *c2b_order_id;

@property (nonatomic,strong ) BuyDrinksRequest   *orderListRequest;
@property (nonatomic ,strong) NSMutableArray              *dataSource;
@property (nonatomic, strong) TYBilliardsOrderInfo        *myOrderInfo;
@property (nonatomic, assign) PayType                     payType;// 选择支付类型

@property (nonatomic, strong) NSString                 *merID;
@property (nonatomic, strong) NSString                 *btId;
@property (nonatomic, strong) NSString                 *tableID;
@property (nonatomic, strong) NSString                 *orderID;
@property (nonatomic, strong) NSString                 *merName;

@end

@implementation HYOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_orderInfo == nil) {
        self.tableID = _billiardsTableInfo.TableId;
        self.merID = _billiardsTableInfo.MerchantId;
        self.btId = _billiardsTableInfo.TableId;
        self.orderID = _billiardsTableInfo.OrderId;
        self.merName = _billiardsTableInfo.MerchantName;
    }else{
        self.tableID = _orderInfo.TableNo;
        self.merID = _orderInfo.MerchantId;
        self.btId = _orderInfo.BallTableId;
        self.orderID = _orderInfo.OrderId;
        self.merName = _orderInfo.MerchantName;
    }
    

    [self initPayUikDate];
    
    [self loadData];
}


- (void)loadData
{
    [HYLoadHubView show];
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    WS(weakSelf);
    self.orderListRequest               = [[BuyDrinksRequest alloc] init];
    self.orderListRequest.interfaceURL  = [NSString stringWithFormat:@"%@/Share/GetOrderByOrId",BILLIARDS_API_URL];
    self.orderListRequest.interfaceType = DotNET2;
    self.orderListRequest.postType      = JSON;
    self.orderListRequest.httpMethod    = @"POST";
    
    self.orderListRequest.merId = self.merID;//  商户id
    self.orderListRequest.orId = self.orderID;
    self.orderListRequest.uId = userInfo.userId;
    
    [self.orderListRequest sendReuqest:^(id result, NSError *error)
     {
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             
             if (code == 0) { //状态值为0 代表请求成功  其他为失败
                 NSDictionary   *dataDic = objDic[@"data"];
                 weakSelf.myOrderInfo = [TYBilliardsOrderInfo objectWithKeyValues:dataDic]; // 返回模型
                 
                 [weakSelf bindData];

             }
             else {
                 NSString *msg = objDic[@"msg"];
                 [ METoast toastWithMessage:msg ? : @"获取订单详情失败"];
                 [HYLoadHubView dismiss];
             }
         }
         else {
             [HYLoadHubView dismiss];
             [METoast toastWithMessage:@"服务器请求异常"];
         }
     }];
}

/**
 * 请求完成后 绑定UI 数据
 */
- (void)bindData{
    
    CGFloat tableRMB = self.myOrderInfo.RateAmount.floatValue;
    CGFloat standRMB = self.myOrderInfo.StandAmount.floatValue;
    CGFloat bentoRMB = self.myOrderInfo.BentoAmount.floatValue;
    CGFloat masterRMB = self.myOrderInfo.MasterFee.floatValue;
    CGFloat drinkRMB = self.myOrderInfo.DrinkAmount.floatValue;
    CGFloat orderRMB = self.myOrderInfo.OrderAmount.floatValue;
    
    CGFloat tableCoupon = self.myOrderInfo.RateTableCoupon.floatValue;
    CGFloat drinkCoupon = self.myOrderInfo.DrinkCoupon.floatValue;
    CGFloat orderCoupon = self.myOrderInfo.OrderCoupon.floatValue;
    
    if (((tableRMB + standRMB + bentoRMB + masterRMB + drinkRMB) != 0 && orderRMB == 0)
        || ((tableCoupon + drinkCoupon) != 0 && orderCoupon == 0)) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"订单信息同步中，请稍后再试"
                                                    delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [av show];
        
        return;
    }
    
    if(self.myOrderInfo.OrderStatus.integerValue == 0){
        [self.orderBut setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xb80000"]] forState:UIControlStateNormal];
        self.orderBut.enabled = YES;
    }
    
    self.goodsList = [self.myOrderInfo.DrinksList mutableCopy]; // 用户购买列表
    
    if (self.goodsList.count > 0) {
        TYBuyModelListInfo *total = [[TYBuyModelListInfo alloc] init]; // 尾部统计模型
        total.GoodsName = @"酒水费用：";
        total.PayAmount = self.myOrderInfo.DrinkAmount; // 酒水总费用
        total.Coupon = self.myOrderInfo.DrinkCoupon;
        [_goodsList addObject:total];
    }
   
    NSString *tmpRate = @"0";

    tmpRate  = [NSString stringWithFormat:@"%@",self.myOrderInfo.RateByHourCoupon];
    
    CGFloat rtCoupon = [self.myOrderInfo.RateTableCoupon floatValue];
    CGFloat rtMoney = [self.myOrderInfo.RateAmount floatValue];
    
    NSString *tableRate = @"0";
    
    if(rtCoupon == 0 && rtMoney != 0){
        
        tableRate  = [NSString stringWithFormat:@"￥%@",self.myOrderInfo.RateAmount];
        
    }else if (rtCoupon != 0 && rtMoney == 0){
        
        tableRate  = [NSString stringWithFormat:@"%@现金券",self.myOrderInfo.RateTableCoupon];
        
    }else if (rtCoupon != 0 && rtMoney != 0){
        tableRate  = [NSString stringWithFormat:@"￥%@ + %@现金券",self.myOrderInfo.RateAmount,self.myOrderInfo.RateTableCoupon];
    }
    
    CGFloat keeperMoney = self.myOrderInfo.MasterFee.floatValue;
    CGFloat standMoney = self.myOrderInfo.StandAmount.floatValue;
    CGFloat bentoMoney = self.myOrderInfo.BentoAmount.floatValue;
    NSString *bentoStr = @"0"; // 外卖费的字段
    if (bentoMoney != 0) {
        bentoStr = [NSString stringWithFormat:@"¥%@",self.myOrderInfo.BentoAmount];
    }
    
    if (keeperMoney == 0 && (standMoney != 0 && bentoMoney != 0)) {
        
        _billiardTitles = @[@"商家名称：",
                            @"台名：",
                            @"开台时间：",
                            @"收台时间：",
                            @"开台时段会员价：",
                            @"看台费用：",
                            @"外卖费用：",
                            @"租台费用："];
        
        _billiardDetails = @[self.myOrderInfo.MerchantName,
                             self.myOrderInfo.TableName,
                             self.myOrderInfo.StartTime,
                             self.myOrderInfo.EndTime,
                             tmpRate,
                             [NSString stringWithFormat:@"￥%@",self.myOrderInfo.StandAmount],
                             bentoStr,
                             tableRate
                             ];
        
    }else if (keeperMoney == 0 && (standMoney == 0 && bentoMoney != 0)){
        
        _billiardTitles = @[@"商家名称：",
                            @"台名：",
                            @"开台时间：",
                            @"收台时间：",
                            @"开台时段会员价：",
                            @"外卖费用：",
                            @"租台费用："];
        
        _billiardDetails = @[self.myOrderInfo.MerchantName,
                             self.myOrderInfo.TableName,
                             self.myOrderInfo.StartTime,
                             self.myOrderInfo.EndTime,
                             tmpRate,
                             bentoStr,
                             tableRate
                             ];
        
    }else if (keeperMoney == 0 && (standMoney != 0 && bentoMoney == 0)){
        
        _billiardTitles = @[@"商家名称：",
                            @"台名：",
                            @"开台时间：",
                            @"收台时间：",
                            @"开台时段会员价：",
                            @"看台费用：",
                            @"租台费用："];
        
        _billiardDetails = @[self.myOrderInfo.MerchantName,
                             self.myOrderInfo.TableName,
                             self.myOrderInfo.StartTime,
                             self.myOrderInfo.EndTime,
                             tmpRate,
                             [NSString stringWithFormat:@"￥%@",self.myOrderInfo.StandAmount],
                             tableRate
                             ];
    
    }else if (keeperMoney == 0 && (standMoney == 0 && bentoMoney == 0)){
        
        _billiardTitles = @[@"商家名称：",
                            @"台名：",
                            @"开台时间：",
                            @"收台时间：",
                            @"开台时段会员价：",
                            @"租台费用："];
        
        _billiardDetails = @[self.myOrderInfo.MerchantName,
                             self.myOrderInfo.TableName,
                             self.myOrderInfo.StartTime,
                             self.myOrderInfo.EndTime,
                             tmpRate,
                             tableRate
                             ];
    
    }else if (keeperMoney != 0 && (standMoney != 0 && bentoMoney != 0)){
        
        _billiardTitles = @[@"商家名称：",
                            @"台名：",
                            @"开台时间：",
                            @"收台时间：",
                            @"开台时段会员价：",
                            @"陪练费用：",
                            @"看台费用：",
                            @"外卖费用：",
                            @"租台费用："];
        
        _billiardDetails = @[self.myOrderInfo.MerchantName,
                             self.myOrderInfo.TableName,
                             self.myOrderInfo.StartTime,
                             self.myOrderInfo.EndTime,
                             tmpRate,
                             [NSString stringWithFormat:@"￥%@",self.myOrderInfo.MasterFee],
                             [NSString stringWithFormat:@"￥%@",self.myOrderInfo.StandAmount],
                             bentoStr,
                             tableRate
                             ];
    
    }else if(keeperMoney != 0 && (standMoney == 0 && bentoMoney != 0)){
        
        _billiardTitles = @[@"商家名称：",
                            @"台名：",
                            @"开台时间：",
                            @"收台时间：",
                            @"开台时段会员价：",
                            @"陪练费用：",
                            @"外卖费用：",
                            @"租台费用："];
        
        _billiardDetails = @[self.myOrderInfo.MerchantName,
                             self.myOrderInfo.TableName,
                             self.myOrderInfo.StartTime,
                             self.myOrderInfo.EndTime,
                             tmpRate,
                             [NSString stringWithFormat:@"￥%@",self.myOrderInfo.MasterFee],
                             bentoStr,
                             tableRate
                             ];
        
    }else if (keeperMoney != 0 && (standMoney == 0 && bentoMoney == 0)){
        
        _billiardTitles = @[@"商家名称：",
                            @"台名：",
                            @"开台时间：",
                            @"收台时间：",
                            @"开台时段会员价：",
                            @"陪练费用：",
                            @"租台费用："];
        
        _billiardDetails = @[self.myOrderInfo.MerchantName,
                             self.myOrderInfo.TableName,
                             self.myOrderInfo.StartTime,
                             self.myOrderInfo.EndTime,
                             tmpRate,
                             [NSString stringWithFormat:@"￥%@",self.myOrderInfo.MasterFee],
                             tableRate
                             ];
    
    }else if (keeperMoney != 0 && (standMoney != 0 && bentoMoney == 0)){
        
        _billiardTitles = @[@"商家名称：",
                            @"台名：",
                            @"开台时间：",
                            @"收台时间：",
                            @"开台时段会员价：",
                            @"陪练费用：",
                            @"看台费用：",
                            @"租台费用："];
        
        _billiardDetails = @[self.myOrderInfo.MerchantName,
                             self.myOrderInfo.TableName,
                             self.myOrderInfo.StartTime,
                             self.myOrderInfo.EndTime,
                             tmpRate,
                             [NSString stringWithFormat:@"￥%@",self.myOrderInfo.MasterFee],
                             [NSString stringWithFormat:@"￥%@",self.myOrderInfo.StandAmount],
                             tableRate
                             ];
        
    }
    else{
        
        _billiardTitles = @[];
    }

    
    if (_goodsList.count == 0) {
        self.headArr = @[@"订单信息",@"球台信息", @"支付类型"];
        self.headImgArr = @[@"order",@"store",@"payment"];
    }else{
        self.headArr = @[@"订单信息",@"球台信息", @"酒水清单", @"支付类型"];
        self.headImgArr = @[@"order",@"store",@"shoppingcart",@"payment"];
    }
    

    
    if (_payType == PayTypeTSH) {
        _bdMoney.text = [NSString stringWithFormat:@"￥%.2lf", [_myOrderInfo.OrderAmount floatValue]];
        _bdCash.text = _myOrderInfo.OrderCoupon;
    }
    else {
        _bdMoney.text = [NSString stringWithFormat:@"￥%.2lf", [_myOrderInfo.OrderAmount floatValue] + [_myOrderInfo.OrderCoupon integerValue]];
        _bdCash.text = @"";
    }
    
    [self.bdPayTableView reloadData];
    
    [HYLoadHubView dismiss];
}

- (void)initPayUikDate
{
    self.title = @"订单结算";
    _opArray  = [[NSMutableArray alloc] initWithCapacity:1];
    
    WS(weakSelf)
    for (int i=0; i<2; i++) {
        HYBilliardsCity *model = [[HYBilliardsCity alloc] init];
        model.orderNum = @"特奢汇价支付:";
        
        if (i==0) {
            model.tabNum = @"choosePriceTypeSeleted";
        }
        else
        {
            model.tabNum = @"choosePriceType";
        }
    
        [_opArray addObject:model];
    }
    
    //初始化订单列表
    _bdPayTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _bdPayTableView.delegate = self;
    _bdPayTableView.dataSource = self;
    _bdPayTableView.sectionFooterHeight = 0;
    [self.view addSubview:_bdPayTableView];
    
    //子控制父视图baoxiao
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"dcdcdc"];
    [self.view addSubview:view];
    
    //消费金额标签
    _bdMoneyLable = [[UILabel alloc] init];
    _bdMoneyLable.font = [UIFont systemFontOfSize:15.0];
    _bdMoneyLable.text = @"金额：";
    [view addSubview:_bdMoneyLable];
    
    //消费金额
    _bdMoney = [[UILabel alloc] init];
    [_bdMoney setTextColor:[UIColor colorWithHexString:@"0xb80000"]];
    _bdMoney.font = [UIFont systemFontOfSize:15.0];
    [view addSubview:_bdMoney];

    //现金券标签
    _bdCashLable = [[UILabel alloc] init];
    _bdCashLable.font = [UIFont systemFontOfSize:15.0];
    _bdCashLable.text = @"现金券：";
    [view addSubview:_bdCashLable];
    
    //现金券
    _bdCash = [[UILabel alloc] init];
    [_bdCash setTextColor:[UIColor colorWithHexString:@"0xb80000"]];
    _bdCash.font = [UIFont systemFontOfSize:15.0];
    [view addSubview:_bdCash];

    //确认支付按钮
    _orderBut = [self buttonTitile:@"确认支付" color:@"bgpay.png" sel:@selector(bdPayClick)];
    [view addSubview:_orderBut];
    

    
#pragma -适配
    
//    //订单列表
    [_bdPayTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 49, 0));
    }];
//
    //子控制父视图
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(49);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
    }];


    
    //消费金额标签
    [_bdMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(10);
        make.centerY.mas_equalTo(view.mas_centerY);

    }];
    
    //消费金额
    [_bdMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bdMoneyLable.mas_right);
        make.centerY.mas_equalTo(_bdMoneyLable.mas_centerY);
    }];
    

    
    //现金券标签
    [_bdCashLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bdMoney.mas_right).offset(10);
        make.centerY.mas_equalTo(_bdMoney.mas_centerY);
    }];
    
    //现金券
    [_bdCash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bdCashLable.mas_right);
        make.centerY.mas_equalTo(_bdCashLable.mas_centerY);
    }];
    
    //确认支付按钮
    [_orderBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width == 320 ? 80 : 120);
        make.height.mas_equalTo(view.mas_height);
        make.centerY.mas_equalTo(_bdCash.mas_centerY);
    }];
    
}

//创建BuyDrinksType按钮
-(UIButton *)buttonTitile:(NSString *)title color:(NSString *)color sel:(SEL)sel
{
    UIButton *bdBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [bdBut setTitle:title forState:UIControlStateNormal];
    bdBut.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [bdBut setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x707070"]] forState:UIControlStateNormal];
    [bdBut setEnabled:NO];
    [bdBut addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bdBut];
    return bdBut;
}

#pragma mark--------UITableView Delegate--------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_goodsList.count == 0) {
        return 3;
    }
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSInteger index = 0;
    if (section == 0)
    {
        index = 1;//
    }
    if (section == 1)
    {
        index = _billiardDetails.count;//
    }
    if (section == 2)
    {
        index = _goodsList.count ? : 2;
    }
    if (section == 3) {
        index = 2;
    }
    
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  333
     */
    
    if (indexPath.section == 0) {
        HYBuyDrinksTableViewCell *bdCell = [HYBuyDrinksTableViewCell initBuyDrinksTableView:tableView];
        
        bdCell.left.text = @"订单号：";
        bdCell.right.text = _myOrderInfo.PcOrderNum;
        
        bdCell.left.textColor = [UIColor blackColor];
        bdCell.right.textColor = bdCell.left.textColor;

        
        return bdCell;
    }
    
    
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 4) {
            
            static NSString *cellId = @"BilliardsRateCell";
            
            BilliardsRateCell   *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell                    = [[BilliardsRateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.costLabel.text = self.billiardDetails[indexPath.row];
            cell.originalLabel.text = [NSString stringWithFormat:@"原价:￥%@/小时",_myOrderInfo.RateCostPrice];
            
            return cell;
        }
        
        HYBuyDrinksTableViewCell *bdCell = [HYBuyDrinksTableViewCell initBuyDrinksTableView:tableView];
        bdCell.left.text = self.billiardTitles[indexPath.row];
        bdCell.right.text = self.billiardDetails[indexPath.row];
       
        if([bdCell.left.text isEqualToString:@"陪练费用："] && self.myOrderInfo.MasterFee.floatValue != 0){
            bdCell.left.textColor = [UIColor colorWithHexString:@"b80000"];
            bdCell.right.textColor = bdCell.left.textColor;
        }else if ([bdCell.left.text isEqualToString:@"看台费用："] && self.myOrderInfo.StandAmount.floatValue != 0){
            bdCell.left.textColor = [UIColor colorWithHexString:@"b80000"];
            bdCell.right.textColor = bdCell.left.textColor;
        }else if ([bdCell.left.text isEqualToString:@"外卖费用："] && self.myOrderInfo.BentoAmount.floatValue != 0){
            bdCell.left.textColor = [UIColor colorWithHexString:@"b80000"];
            bdCell.right.textColor = bdCell.left.textColor;
        }else if (indexPath.row == _billiardTitles.count - 1){
            bdCell.left.textColor = [UIColor colorWithHexString:@"b80000"];
            bdCell.right.textColor = bdCell.left.textColor;
        }else{
            bdCell.left.textColor = [UIColor blackColor];
            bdCell.right.textColor = bdCell.left.textColor;
        }
    
        return bdCell;
    }
    
    else{
            /**
             *  222
             */
            if (_goodsList.count == 0) {

                HYPayTypeTableViewCell *payCell = [HYPayTypeTableViewCell initPayTypeTableView:tableView];
                if (_opArray.count > 0) {
                    HYBilliardsCity *model = [_opArray objectAtIndex:indexPath.row];
                    payCell.billCity = model;
                }

                if (indexPath.row == 0) {
                    _selectImg = payCell.selectImg;
                    payCell.typeLable.text = @"会员价";
                }
                else
                {
                    _noSelectImg = payCell.selectImg;
                    payCell.typeLable.text = @"原价";
                }
                return payCell;
            }
            
            else{
                
                /**
                 *  1111
                 */
                if (indexPath.section == 2) {
                    
                    HYBuyDrinksTableViewCell *bdCell = [HYBuyDrinksTableViewCell initBuyDrinksTableView:tableView];

                    TYBuyModelListInfo *info = (TYBuyModelListInfo *)_goodsList[indexPath.row];
                    if (indexPath.row == _goodsList.count - 1) { // 最后一行统计
                        bdCell.left.text = info.GoodsName;
                        bdCell.right.text = [info.Coupon integerValue] > 0 ? [NSString stringWithFormat:@"￥%.2lf+%@现金券", [info.PayAmount floatValue], info.Coupon] : [NSString stringWithFormat:@"￥%.2lf", [info.PayAmount floatValue]];
                        bdCell.left.textColor = [UIColor colorWithHexString:@"b80000"];
                        bdCell.right.textColor = bdCell.left.textColor;
                    }
                    else {
                        bdCell.left.text = [NSString stringWithFormat:@"%@×%@", info.GoodsName, @(info.Num)];
                        bdCell.right.text = [info.Coupon integerValue] > 0 ? [NSString stringWithFormat:@"￥%.2lf+%@现金券", [info.PayAmount floatValue], info.Coupon] : [NSString stringWithFormat:@"￥%.2lf", [info.PayAmount floatValue]];
                        bdCell.left.textColor = [UIColor blackColor];
                        bdCell.right.textColor = bdCell.left.textColor;
                    }
                    
                    return bdCell;
                }
                
                else{
                    
                    HYPayTypeTableViewCell *payCell = [HYPayTypeTableViewCell initPayTypeTableView:tableView];
                    if (_opArray.count > 0) {
                        HYBilliardsCity *model = [_opArray objectAtIndex:indexPath.row];
                        payCell.billCity = model;
                    }
                    
                    if (indexPath.row == 0) {
                        _selectImg = payCell.selectImg;
                        payCell.typeLable.text = @"会员价";
                    }
                    else
                    {
                        _noSelectImg = payCell.selectImg;
                        payCell.typeLable.text = @"原价";
                    }
                    return payCell;
                }
                /**
                 *  1111
                 */
            
        }
        /**
         *  2222
         */
    
    }
    /**
     *  333
     */
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];///
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:[_headImgArr objectAtIndex:section]];
    [view addSubview:imgView];
    UILabel *lab = [[UILabel alloc] init];
    lab.text = [_headArr objectAtIndex:section];//表头
    lab.font = [UIFont systemFontOfSize:15.0f];
    [view addSubview:lab];

    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).offset(5);
        make.centerY.mas_equalTo(imgView.mas_centerY);
    }];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ((_goodsList.count == 0 && indexPath.section != 2) || (_goodsList.count != 0 && indexPath.section != 3)) {
        return;
    }
    
        if (indexPath.row == 0) {
            _selectImg.image =[UIImage imageNamed:@"choosePriceTypeSeleted"];
            _noSelectImg.image = [UIImage imageNamed:@"choosePriceType"];
            _bdCashLable.hidden = NO;
            _bdCash.hidden = NO;
            _payType = PayTypeTSH;
        }
        else
        {
            _selectImg.image =[UIImage imageNamed:@"choosePriceType"];
            _noSelectImg.image = [UIImage imageNamed:@"choosePriceTypeSeleted"];
            _bdCashLable.hidden = YES;
            _bdCash.hidden = YES;
            _payType = PayTypeOther;
        }
        
        if (_payType == PayTypeTSH) {
            _bdMoney.text = [NSString stringWithFormat:@"￥%@", _myOrderInfo.OrderAmount];
            _bdCash.text = _myOrderInfo.OrderCoupon;
        }
        else {
            _bdMoney.text = [NSString stringWithFormat:@"￥%.2lf", [_myOrderInfo.OrderAmount floatValue] + [_myOrderInfo.OrderCoupon integerValue]];
            _bdCash.text = @"";
        }
    
}

#pragma mark - 按钮点击事件

//确认支付
- (void)bdPayClick
{
    NSString  *money               = [self.bdMoney.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    NSString  *coupon              = self.bdCash.text;

    if(money.floatValue == 0 && coupon.floatValue == 0){
         [METoast toastWithMessage:@"无效支付金额"];
        return;
    }

   
    if(_payType == PayTypeOther){ //如果时原价支付，直接跳转原来的支付流程
        
        [self createPayOrder];
        return;
    }
    
    if(money.floatValue == 0 && coupon != 0){ //纯现金券支付  直接跳转原来的支付流程
        [self createPayOrder];
        return;
    }
    
    /**
     *  其他的支付  需要先判断用户充值卡
     */
    
   // [HYLoadHubView show];
     [PageBaseLoading showLoading];
    HYUserInfo *userInfo                    = [HYUserInfo getUserInfo];
    
    self.checkCardStatusReqeust               = [[CheckCardStatusReqeust alloc] init];
    self.checkCardStatusReqeust.interfaceURL  = [NSString stringWithFormat:@"%@/share/GetCouponCard",BILLIARDS_API_URL];
    self.checkCardStatusReqeust.interfaceType = DotNET2;
    self.checkCardStatusReqeust.postType      = JSON;
    self.checkCardStatusReqeust.httpMethod    = @"POST";

    self.checkCardStatusReqeust.cardNo        = userInfo.number ? : @"";
    self.checkCardStatusReqeust.merId         = self.merID ? : @"";


    self.view.userInteractionEnabled = NO;
    WS(weakSelf);
    [self.checkCardStatusReqeust sendReuqest:^(id result, NSError *error)
     {
      //   [HYLoadHubView dismiss];
         // [PageBaseLoading hide_Load];
         if(result){
             NSDictionary *objDic = [result jsonDic];
             
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功
                 NSDictionary *objKeyValue = objDic[@"data"];
                 weakSelf.isOperationPay  =  YES ;
                 NSString *remindMoney = objKeyValue[@"cardbalance"]; //充值卡余额
                 NSString *remindCoupon = objKeyValue[@"coupon"]; // 会员卡现金券；
                 NSString *cardpay = objKeyValue[@"cardpay"]; //充值本金、赠送余额是否允许支付酒水、陪练、外卖、看台(0:不允许 1：允许)
                 
                 if(remindCoupon.floatValue < coupon.floatValue && remindCoupon.floatValue >= 0){ //现金券不足
                     
                     if (userInfo.userLevel == 0) { //体验用户跳转到体验用户的页面
                         HYExperienceLeakViewController *vc = [[HYExperienceLeakViewController alloc] init];
                         [weakSelf.navigationController pushViewController:vc animated:YES];
                     }
                     else {//正式会员用户跳转到正式会员的页面
                         HYNormalLeakViewController *vc = [[HYNormalLeakViewController alloc] init];
                         [weakSelf.navigationController pushViewController:vc animated:YES];
                     }
                      weakSelf.view.userInteractionEnabled = YES;
                     [PageBaseLoading hide_Load];
                     return ;
                 }
                 
                 if(remindMoney.floatValue >= money.floatValue){//充值卡余额足够
                     
                     if ((cardpay.integerValue == 1) ||
                         (weakSelf.myOrderInfo.MasterFee.integerValue == 0
                          && weakSelf.myOrderInfo.StandAmount.integerValue == 0
                          && weakSelf.myOrderInfo.BentoAmount.integerValue == 0
                          && weakSelf.myOrderInfo.DrinkAmount.integerValue == 0)) { //并且充值卡是允许支付的状态
                         
                         FLCustomAlertView *FLalertView = [[FLCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-100, 151) TheViewType:ThreeButton_NoTM];
                         [FLalertView setIndex0ButtonWithTitle:[NSString stringWithFormat:@"充值卡支付(余额：￥%@)",remindMoney]
                                                    TitleColor:[UIColor colorWithHexColor:@"b80000" alpha:1]
                                               BackgroundColor:[UIColor whiteColor]];
                         
                         [FLalertView setIndex1ButtonWithTitle:@"特奢汇支付"
                                                    TitleColor:[UIColor colorWithHexColor:@"b80000" alpha:1]
                                               BackgroundColor:[UIColor whiteColor]];
                         
                         [FLalertView setIndex2ButtonWithTitle:@"取消返回"
                                                    TitleColor:[UIColor colorWithHexColor:@"343434" alpha:1]
                                               BackgroundColor:[UIColor whiteColor]];
                         
                         [FLalertView buttonClickBlock:^(FLCAlertViewBtnTag tag) {
                             switch (tag) {
                                 case ButtonTag_Index0:
                                 {
                                     // 充值卡支付
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                                                    dispatch_get_main_queue(), ^{
                                                        [weakSelf memberCardPay];
                                                    });
                                 }
                                     break;
                                 case ButtonTag_Index1:
                                 {
                                     // 特奢汇支付
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                                                    dispatch_get_main_queue(), ^{
                                                        [weakSelf createPayOrder];
                                                    });
                                 }
                                     break;
                                     
                                 default:
                                     break;
                             }
                         }];
                         
                         [FLalertView show];
                         
                         
                     } else {  //充值卡是不允许支付的状态
                     
                         [weakSelf createPayOrder]; //直接创建订单进入tsh支付流程
                     }

                     weakSelf.view.userInteractionEnabled = YES;

                 } else { //充值卡余额不足
                     
                    [weakSelf createPayOrder]; //直接创建订单进入tsh支付流程
                 }

             } else {
                 NSString *msg = objDic[@"msg"];
                 [METoast toastWithMessage:msg ? : @"支付方式获取失败"];
             }
         } else {
             [METoast toastWithMessage:@"服务器请求异常"];
         }
         
          weakSelf.view.userInteractionEnabled = YES;
     }];
}

- (void)memberCardPay{
    
    NSString  *money = [self.bdMoney.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    NSString  *coupon              = self.bdCash.text;
    
    if(money.floatValue == 0){
        [METoast toastWithMessage:@"无效支付金额"];
        return;
    }
    
    //[HYLoadHubView show];
   //  [PageBaseLoading showLoading];

    HYUserInfo *userInfo                    = [HYUserInfo getUserInfo];

    self.memberCardPayRequest               = [[MemberCardPayRequest alloc] init];
    self.memberCardPayRequest.interfaceURL  = [NSString stringWithFormat:@"%@/Share/PaySettle",BILLIARDS_API_URL];
    self.memberCardPayRequest.interfaceType = DotNET2;
    self.memberCardPayRequest.postType      = JSON;
    self.memberCardPayRequest.httpMethod    = @"POST";

    self.memberCardPayRequest.payType       = @"0";//默认0
    self.memberCardPayRequest.cardNo        = userInfo.number;
    
    self.memberCardPayRequest.merId         = self.merID ? : @"";
    self.memberCardPayRequest.orId          = self.orderID ? : @"";
    
    self.view.userInteractionEnabled = NO;
    WS(weakSelf);
    [self.memberCardPayRequest sendReuqest:^(id result, NSError *error)
     {
        // [HYLoadHubView dismiss];
         
         if(result){
             NSDictionary *objDic = [result jsonDic];
             
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功
                 
                 //跳转到支付成功的页面
                PaySuccessViewController *tmpCtrl = [[PaySuccessViewController alloc] init];
                

                if (weakSelf.orderInfo) {
                    tmpCtrl.merId = weakSelf.orderInfo.MerchantId;
                    tmpCtrl.storeName                 = weakSelf.orderInfo.MerchantName;
                    tmpCtrl.O2O_OrderNo = weakSelf.orderInfo.OrderNum ? : weakSelf.orderInfo.PcOrderNum;
                }else{
                     tmpCtrl.merId = weakSelf.billiardsTableInfo.MerchantId;
                    tmpCtrl.storeName                 = weakSelf.billiardsTableInfo.MerchantName;
                    tmpCtrl.O2O_OrderNo = weakSelf.billiardsTableInfo.PcOrderNum ? : weakSelf.billiardsTableInfo.PcOrderNum;
                }

                if(money.floatValue != 0){
                    tmpCtrl.money = money;//[NSString stringWithFormat:@"%.2f",money.floatValue];
                }

                if (coupon.floatValue != 0) {
                    tmpCtrl.coupon = coupon;//[NSString stringWithFormat:@"%.0f",coupon.floatValue];
                }

                tmpCtrl.memberPay                = YES;
                tmpCtrl.orderType = @"3";
                tmpCtrl.payType = BilliardsPay;
                [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
                 
                 
             }else{
                  weakSelf.isOperationPay  =  NO ;
                 NSString *msg = objDic[@"msg"];
                 [METoast toastWithMessage:msg ? : @"支付失败"];
             }
         }else{
              weakSelf.isOperationPay  =  NO ;
             [METoast toastWithMessage:@"服务器请求异常"];
         }
         [PageBaseLoading hide_Load];
          weakSelf.view.userInteractionEnabled = YES;
     }];
}

- (void)createPayOrder{
    
    [self.createOrderRequest cancel];
    self.createOrderRequest = nil;
    
    CGFloat money         = [[self.bdMoney.text stringByReplacingOccurrencesOfString:@"￥" withString:@""] floatValue];
    CGFloat coupon        = self.bdCash.text.floatValue;
    
  //   [PageBaseLoading showLoading];
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    self.createOrderRequest               = [[BilliardsCreateOrderRequest alloc] init];
    self.createOrderRequest.interfaceURL  = [NSString stringWithFormat:@"%@/Share/CreateOrder",BILLIARDS_API_URL];
    self.createOrderRequest.interfaceType = DotNET2;
    self.createOrderRequest.postType      = JSON;
    self.createOrderRequest.httpMethod    = @"POST";

    self.createOrderRequest.uId           = userInfo.userId;
    self.createOrderRequest.uName         = userInfo.realName.length == 0 ? userInfo.mobilePhone : userInfo.realName;
    self.createOrderRequest.mobile        = userInfo.mobilePhone;
    self.createOrderRequest.cardNo        = userInfo.number;
    
    self.createOrderRequest.merId        = self.merID ? : @"";
    self.createOrderRequest.orId         = self.orderID ? : @"";
    self.createOrderRequest.isPayCoupon  = (_payType == PayTypeTSH) ?  1 : 0;   //0标示不支付现金券

     self.view.userInteractionEnabled = NO;
    WS(weakSelf);
    [self.createOrderRequest sendReuqest:^(id result, NSError *error)
     {
        
         if(result){
             NSDictionary *objDic = [result jsonDic];
             
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功  
                 NSDictionary *objKeyValue = objDic[@"data"];
                 
                 weakSelf.o2o_trade_no = objKeyValue[@"o2o_trade_no"];
                 weakSelf.c2b_trade_no = objKeyValue[@"c2b_trade_no"];
                 weakSelf.c2b_order_id = objKeyValue[@"c2b_order_id"];

                 if(money == 0 && coupon != 0){  //此时说明用户只用现金券支付 服务器会直接扣除 不需要跳转支付页面
                     
                     //跳转到支付成功的页面
                     
                     PaySuccessViewController *tmpCtrl = [[PaySuccessViewController alloc] init];
                     tmpCtrl.merId = weakSelf.orderInfo.MerchantId;
      
                      if (weakSelf.orderInfo) {
                          tmpCtrl.storeName                 = weakSelf.orderInfo.MerchantName;
                           tmpCtrl.O2O_OrderNo = weakSelf.orderInfo.OrderId;
                      }else{
                          tmpCtrl.storeName                 = weakSelf.billiardsTableInfo.MerchantName;
                           tmpCtrl.O2O_OrderNo = weakSelf.billiardsTableInfo.OrderId;
                      }

                     tmpCtrl.coupon = weakSelf.bdCash.text;
                     tmpCtrl.orderType = @"3"; //桌球商家
                     tmpCtrl.payType = BilliardsPay;
                     [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
                     
                     
                 }else{
                     [weakSelf gotoPay];
                 }
                 
             }else{
                 
                weakSelf.isOperationPay  =  NO ;
                NSString *msg = objDic[@"msg"];
                 if([msg isEqualToString:@"现金券不足"]){
                     /*** 这里进行现金券不足页面跳转 页面由总部那边提供***/
                     
                     if (userInfo.userLevel == 0) { //体验用户跳转到体验用户的页面
                         HYExperienceLeakViewController *vc = [[HYExperienceLeakViewController alloc] init];
                         [weakSelf.navigationController pushViewController:vc animated:YES];
                     }
                     else {//正式会员用户跳转到正式会员的页面
                         HYNormalLeakViewController *vc = [[HYNormalLeakViewController alloc] init];
                         [weakSelf.navigationController pushViewController:vc animated:YES];
                     }
                     
                 }else{
                     
                     [METoast toastWithMessage:msg];
                 }
             }
         }else{
              weakSelf.isOperationPay  =  NO ;
             [METoast toastWithMessage:@"服务器请求异常"];
         }
         
          [PageBaseLoading hide_Load];
          weakSelf.view.userInteractionEnabled = YES;
     }];
}

- (void)gotoPay{

    NSString  *money               = [self.bdMoney.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    NSString  *coupon              = self.bdCash.text;

    HYAlipayOrder *alOrder         = [[HYAlipayOrder alloc] init];
    alOrder.partner                = PartnerID;
    alOrder.seller                 = SellerID;
    alOrder.tradeNO                = self.c2b_trade_no;//订单号 (显示订单号)
    alOrder.productName            = [NSString stringWithFormat:@"【特奢汇】O2O商家订单: %@", self.c2b_trade_no];//商品标题 (显示订单号)
    alOrder.productDescription     = [NSString stringWithFormat:@"【特奢汇】O2O商家订单: %@", self.c2b_trade_no];//商品描述
    alOrder.amount                 = [NSString stringWithFormat:@"%0.2f",money.floatValue];//商品价格

    HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
    payVC.navbarTheme              = self.navbarTheme;
    payVC.alipayOrder              = alOrder;
    payVC.amountMoney              = money;//付款总额
    payVC.point                    = _payType == PayTypeTSH ?  coupon.floatValue : 0.0f ;//  现金券
    payVC.orderID                  = self.c2b_order_id;//用户获取银联支付流水号
    payVC.orderCode                = self.c2b_trade_no;//订单号

    payVC.type                     = Pay_O2O_QRScan;
    payVC.O2OpayType               = BilliardsPay;
    
    WS(weakSelf);
    [payVC setBusinessPaymentSuccess:^(O2OPayType type) {
        [weakSelf pushPaySuccessWithType:type];
    }];
    
    [self.navigationController pushViewController:payVC animated:YES];
    
}

//　回调支付成功
- (void)pushPaySuccessWithType:(O2OPayType)type{
    
    NSString  *money               = [self.bdMoney.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    NSString  *coupon              = self.bdCash.text;
    
    PaySuccessViewController *tmpCtrl = [[PaySuccessViewController alloc] init];
    tmpCtrl.merId = self.merID;
    tmpCtrl.storeName = self.merName;
    tmpCtrl.money = money;
    tmpCtrl.O2O_OrderNo = self.o2o_trade_no;
    tmpCtrl.payType = type;
    tmpCtrl.orderType = @"3";  //3 代表 桌球商家
    if (coupon.floatValue != 0) {
        tmpCtrl.coupon = _payType == PayTypeTSH ?  coupon : @"" ;//  现金券
    }
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

- (void)backToRootViewController:(id)sender{

     WS(weakSelf);
    
    if( _isOperationPay){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationWithBilliardsOrderListChanged object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithBilliardsOrderListChanged object:nil];
    }
    
    if (_backRefresh) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_backRefresh && _isOperationPay ? 0.35 : 0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        return;
    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark --- alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"我知道了"] && _backRefresh) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

- (void)dealloc{
    
    [PageBaseLoading hiddeLoad_anyway];
    
    [_createOrderRequest cancel];
    _createOrderRequest = nil;
    
    [_memberCardPayRequest cancel];
    _memberCardPayRequest = nil;
    
    [_checkCardStatusReqeust cancel];
    _checkCardStatusReqeust = nil;
    
    [_orderListRequest cancel];
    _orderListRequest = nil;

//    [HYLoadHubView dismiss];
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
