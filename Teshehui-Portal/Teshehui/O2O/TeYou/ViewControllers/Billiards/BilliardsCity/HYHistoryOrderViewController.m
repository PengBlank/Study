//
//  HYHistoryOrderViewController.m
//  Teshehui
//
//  Created by macmini7 on 15/11/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//  历史订单

#import "HYHistoryOrderViewController.h"
#import "HYBuyDrinksTableViewCell.h"
#import "Masonry.h"
#import "HYBilliardsCity.h"
#import "goodsInfo.h"

#import "SVPullToRefresh.h"
#import "DefineConfig.h"
#import "UITableView+Common.h"
#import "UIView+Common.h"
#import "HYUserInfo.h"
#import "MJExtension.h"
#import "DefineConfig.h"
//#import "TravelQRView.h"
#import "NSString+Addition.h"
#import "METoast.h"
#import "TYBilliardsOrderInfo.h"
#import "BuyDrinksRequest.h"
#import "TYBuyModelListInfo.h"
#import "UIColor+expanded.h"
#import "UIColor+hexColor.h"
#import "BilliardsRateCell.h"
@interface HYHistoryOrderViewController () <UITableViewDataSource,UITableViewDelegate>

/**购买酒水*/
@property (nonatomic,strong ) UITableView          *hsTableView;
/**历史酒水数据源*/
@property (nonatomic,strong ) NSMutableArray       *hsArray;
/**历史酒水表头数组*/
@property (nonatomic,strong ) NSArray              *headArr;
/**历史酒水表头图标数组*/
@property (nonatomic,strong ) NSArray              *headImgArr;//表头图标
@property (nonatomic, strong) NSArray              *billiardTitles;
@property (nonatomic, strong) NSArray              *billiardDetails;
@property (nonatomic ,strong) NSMutableArray       *dataSource;
@property (nonatomic, strong) TYBilliardsOrderInfo *myOrderInfo;
@property (nonatomic,strong ) BuyDrinksRequest     *orderListRequest;
@property (nonatomic, strong) NSMutableArray       *goodsList;

@end

@implementation HYHistoryOrderViewController

//- (NSArray *)billiardTitles
//{
//    if (!_billiardTitles) {
//        _billiardTitles = @[@"台名：", @"开台时间：", @"收台时间：", @"开台时段会员价：", @"陪练费用：", @"看台费用：", @"外卖费用：", @"租台费用："];
//    }
//    
//    return _billiardTitles;
//}

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
    
    self.orderListRequest.merId = _billiardsOrderInfo.MerchantId;//  商户id
    self.orderListRequest.orId = _billiardsOrderInfo.OrderId;
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
                 [ METoast toastWithMessage:msg];
                 [HYLoadHubView dismiss];
             }
         }
         else {
             [HYLoadHubView dismiss];
             [METoast toastWithMessage:@"无法连接服务器"];
         }
     }];
}

/**
 * 请求完成后 绑定UI 数据
 */
- (void)bindData{
    
    self.goodsList = [self.myOrderInfo.DrinksList mutableCopy]; // 用户购买列表
    
    if (self.goodsList.count > 0) {
        TYBuyModelListInfo *total = [[TYBuyModelListInfo alloc] init]; // 尾部统计模型
        total.GoodsName = @"酒水费用：";
        total.PayAmount = self.myOrderInfo.DrinkAmount; // 酒水总费用
        total.Coupon = self.myOrderInfo.DrinkCoupon;
        [_goodsList addObject:total];
    }
    
//    CGFloat rCoupon = [self.myOrderInfo.RateCoupon floatValue];
//    CGFloat rMoney = [self.myOrderInfo.RateByHour floatValue];
//
    NSString *tmpRate = @"0";
//
//    if(rCoupon == 0 && rMoney != 0){
//
//        tmpRate  = [NSString stringWithFormat:@"￥%@/小时",self.myOrderInfo.RateByHour];
//
//    }else if (rCoupon != 0 && rMoney == 0){
//
//        tmpRate  = [NSString stringWithFormat:@"%@现金券/小时",self.myOrderInfo.RateCoupon];
//
//    }else if (rCoupon != 0 && rMoney != 0){
//        tmpRate  = [NSString stringWithFormat:@"￥%@ + %@现金券/小时",self.myOrderInfo.RateByHour,self.myOrderInfo.RateCoupon];
//    }
    
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

    
    self.headArr = @[@"订单信息",@"球台信息",@"酒水清单"];
    self.headImgArr = @[@"order",@"store",@"shoppingcart"];
    [self.hsTableView reloadData];
    [HYLoadHubView dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    [self initUikDate];
}

- (void)initUikDate
{
    self.title = @"历史订单详情";
    
    WS(weakSelf)
    _hsArray  = [[NSMutableArray alloc] initWithCapacity:1];
    _hsTableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _hsTableView.delegate = self;
    _hsTableView.dataSource = self;
    _hsTableView.sectionFooterHeight = 0;
    _hsTableView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [self.view addSubview:_hsTableView];

    [_hsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.top.mas_equalTo(weakSelf.view.mas_top);
    }];
}

//创建BuyDrinksType按钮
-(UIButton *)button:(NSString *)title color:(UIColor *)color sel:(SEL)sel
{
    UIButton *bdBut = [[UIButton alloc] init];
    [bdBut setTitle:title forState:UIControlStateNormal];
    bdBut.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    bdBut.backgroundColor = color;
    [bdBut addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bdBut];
    return bdBut;
}


#pragma mark -- UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_goodsList.count == 0){
        return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger index = 0;
    if (section == 0) {
        index = 3;//
    }
    if (section == 1)
    {
        index = _billiardDetails.count;//
    }
    if (section == 2)
    {
        index = _goodsList.count;//
    }
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYBuyDrinksTableViewCell *bdCell = [HYBuyDrinksTableViewCell initBuyDrinksTableView:tableView];
    switch (indexPath.section) {
        case 0:
        {
            
            if (indexPath.row == 0) {
                bdCell.left.text = @"订单号：";
                bdCell.right.text = _myOrderInfo.PcOrderNum;
                bdCell.left.textColor = [UIColor blackColor];
                bdCell.right.textColor = bdCell.left.textColor;
                
            }else if (indexPath.row == 1){
                
                bdCell.left.text = @"支付方式：";
                bdCell.right.text = _myOrderInfo.PayType;
                bdCell.left.textColor = [UIColor blackColor];
                bdCell.right.textColor = bdCell.left.textColor;
                

            }
            else {

                bdCell.left.text = @"订单总额：";
                CGFloat rCoupon = [self.myOrderInfo.OrderCoupon floatValue];
                CGFloat rMoney = [self.myOrderInfo.OrderAmount floatValue];
                
                if(rCoupon == 0 && rMoney != 0){
                    
                    bdCell.right.text  = [NSString stringWithFormat:@"￥%@",self.myOrderInfo.OrderAmount];
                    
                }else if (rCoupon != 0 && rMoney == 0){
                    
                    bdCell.right.text  = [NSString stringWithFormat:@"%@现金券",self.myOrderInfo.OrderCoupon];
                    
                }else if (rCoupon != 0 && rMoney != 0){
                    bdCell.right.text  = [NSString stringWithFormat:@"￥%@ + %@现金券",self.myOrderInfo.OrderAmount,self.myOrderInfo.OrderCoupon];
                }
                
                bdCell.left.textColor = [UIColor colorWithHexString:@"b80000"];
                bdCell.right.textColor = bdCell.left.textColor;
            }
        }
            break;
            
        case 1:
        {
            
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
                
            }else{
                
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
                
//                if (indexPath.row == _billiardTitles.count - 1) {
//                    bdCell.left.textColor = [UIColor colorWithHexString:@"0xb80000"];//[UIColor colorWithRed:219/255.0 green:31/255.0 blue:25/255.0 alpha:1];
//                    bdCell.right.textColor = bdCell.left.textColor;
//                } else {
//                    bdCell.left.textColor = [UIColor blackColor];
//                    bdCell.right.textColor = bdCell.left.textColor;
//                }
            }
            

        }
            break;
            
        case 2:
        {
            if (_goodsList.count > 0) {
                TYBuyModelListInfo *info = (TYBuyModelListInfo *)_goodsList[indexPath.row];
                if (indexPath.row == _goodsList.count - 1) { // 最后一行统计
                    bdCell.left.text = info.GoodsName;
                    bdCell.right.text = [info.Coupon integerValue] > 0 ? [NSString stringWithFormat:@"￥%.2lf+%@现金券", [info.PayAmount floatValue], info.Coupon] : [NSString stringWithFormat:@"￥%.2lf", [info.PayAmount floatValue]];
                    bdCell.left.textColor =[UIColor colorWithHexString:@"0xb80000"];// [UIColor colorWithRed:219/255.0 green:31/255.0 blue:25/255.0 alpha:1];
                    bdCell.right.textColor = bdCell.left.textColor;
                }
                else {
                    bdCell.left.text = [NSString stringWithFormat:@"%@×%ld", info.GoodsName, info.Num];
                    bdCell.right.text = [info.Coupon integerValue] > 0 ? [NSString stringWithFormat:@"￥%.2lf+%@现金券", [info.PayAmount floatValue], info.Coupon] : [NSString stringWithFormat:@"￥%.2lf", [info.PayAmount floatValue]];
                    bdCell.left.textColor = [UIColor blackColor];
                    bdCell.right.textColor = bdCell.left.textColor;
                }
            }

        }
            default:
            break;
    }
    
    return bdCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];///
    view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:[_headImgArr objectAtIndex:section]];
    [view addSubview:imgView];
    UILabel *leftLab = [[UILabel alloc] init];
    leftLab.text = [_headArr objectAtIndex:section];//表头
    leftLab.font = [UIFont systemFontOfSize:15.0f];
    [view addSubview:leftLab];

    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    
    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).offset(5);
        make.centerY.mas_equalTo(imgView.mas_centerY);
    }];
    
//    if (section == 0) {
//        UILabel *rightLab = [[UILabel alloc] init];
//        rightLab.text = @"已付款";//表头
//        rightLab.font = [UIFont systemFontOfSize:15.0f];
//        rightLab.textColor = [UIColor colorWithHexString:@"0xb80000"];
//        [view addSubview:rightLab];
//        
//        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(rightLab.superview.mas_right).offset(-10);
//            make.centerY.mas_equalTo(view.mas_centerY);
//        }];
//    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (void)dealloc{
    [HYLoadHubView dismiss];
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
