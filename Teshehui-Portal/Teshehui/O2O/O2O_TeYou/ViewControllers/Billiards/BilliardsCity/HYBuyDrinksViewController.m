//
//  HYBuyDrinksViewController.m
//  Teshehui
//
//  Created by macmini7 on 15/11/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//  购买酒水&结单

//#define WIDTH self.view.frame.size.width/2

#import "HYBuyDrinksViewController.h"
#import "HYOrderPayViewController.h"
#import "HYBuyDrinksTableViewCell.h"

#import "DrinksListViewController.h"
#import "HYHistoryOrderViewController.h"
#import "DrinksListViewController.h"
#import "HYOrderPayViewController.h"
#import "CallServiceRequest.h"


#import "Masonry.h"
#import "HYBilliardsCity.h"
#import "goodsInfo.h"
#import "TYBilliardsOrderInfo.h"
#import "TYBuyModelListInfo.h"
#import "BuyDrinksRequest.h"
#import "BuyGoodsRequest.h"
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
#import "BilliardsRateCell.h"
#import "CloseTableRequest.h"
#import "HYHistoryOrderViewController.h"
#import "UIUtils.h"

#import "FLCustomAlertView.h"   // 提示框
#import "UIColor+hexColor.h"

@interface HYBuyDrinksViewController () <UITableViewDataSource,UITableViewDelegate>

/**购买酒水*/
@property (nonatomic, strong) UITableView          *bdTableView;
/**酒水数据源*/
@property (nonatomic, strong) NSMutableArray       *bdArray;
/**收台待结*/
@property (nonatomic, strong) UIButton             *waitBut;
/**收台结算*/
@property (nonatomic, strong) UIButton             *startBut;
/**收台结算*/
@property (nonatomic, strong) UIButton             *callBtn;
/**表头名称数组*/
@property (nonatomic, strong) NSArray              *headArr;
/**表头图标数组*/
@property (nonatomic, strong) NSArray              *headImgArr;

@property (nonatomic, strong) NSArray              *billiardTitles;
@property (nonatomic, strong) NSMutableArray       *goodsList;
@property (nonatomic, assign) CGFloat              totalCash;
@property (nonatomic, assign) NSInteger            totalCoupon;
@property (nonatomic ,strong) NSMutableArray       *dataSource;

@property (nonatomic,strong ) BuyDrinksRequest     *orderListRequest;
@property (nonatomic, strong) TYBilliardsOrderInfo *myOrderInfo;
@property (nonatomic,strong ) CloseTableRequest    *closeTableRequest;
@property (nonatomic,strong ) CallServiceRequest    *callServiceRequest;


@property (nonatomic, strong) NSString             *merID;
@property (nonatomic, strong) NSString             *btId;
@property (nonatomic, strong) NSString             *tableID;
@property (nonatomic, strong) NSString             *orderID;

@property (nonatomic,assign ) BOOL                 isGoPay;

@end

@implementation HYBuyDrinksViewController

- (NSArray *)billiardTitles
{
    if (!_billiardTitles) {
        _billiardTitles = @[@"商家名称：",@"台名：", @"开台时间：", @"租台单价："];
    }
    
    return _billiardTitles;
}

- (NSMutableArray *)goodsList
{
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    
    return _goodsList;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_orderInfo == nil) {
    //    self.tableID = _billiardsTableInfo.TableId;
        self.merID = _billiardsTableInfo.MerchantId;
        self.btId = _billiardsTableInfo.TableId;
        self.orderID = _billiardsTableInfo.OrderId;
    }else{
     //   self.tableID = _orderInfo.TableNo;
        self.merID = _orderInfo.MerchantId;
        self.btId = _orderInfo.BallTableId;
        self.orderID = _orderInfo.OrderId;
    }
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUikDate];
}

- (void)initUikDate
{
    self.title = @"购买&结算";
    
    WS(weakSelf)
    _bdArray  = [[NSMutableArray alloc] initWithCapacity:1];
    _bdTableView  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _bdTableView.backgroundColor = [UIColor whiteColor];
    _bdTableView.delegate = self;
    _bdTableView.dataSource = self;
    _bdTableView.sectionFooterHeight = 0;
    [self.view addSubview:_bdTableView];
    
    [_bdTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-72);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.top.mas_equalTo(weakSelf.view.mas_top);
    }];
    
    // 酒水
//        _waitBut = [self button:@"" color:@"buy" sel:@selector(bdPendingClick)];
     _waitBut = [self button:@"" image:@"checkbg" hilightImage:@"checkbg-click" sel:@selector(bdPendingClick)];
    
        [_waitBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.view.mas_left);
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
            make.width.mas_equalTo(weakSelf.view.frame.size.width/2);
            make.height.mas_equalTo(49);
        }];
    
    
       // _startBut = [self button:@"" color:@"pay" sel:@selector(bdCheckOutClick)];
        _startBut = [self button:@"" image:@"snacksbuybg" hilightImage:@"snacksbuybg-click" sel:@selector(bdCheckOutClick)];

        [_startBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.waitBut.mas_right).offset(-1);
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
            make.top.mas_equalTo(weakSelf.waitBut.mas_top);
            make.right.mas_equalTo(weakSelf.view.mas_right);
        }];
    
     //   _callBtn = [self button:@"" color:@"callservice" sel:@selector(callBtnClick)];
     _callBtn = [self button:@"" image:@"helpbtn" hilightImage:@"helpbtn-click" sel:@selector(callBtnClick)];
    
        [_callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
          //  make.size.mas_equalTo(CGSizeMake(116, 72));
        }];
    

}

- (void)loadData
{
    self.view.userInteractionEnabled = NO;
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
                 
                 weakSelf.myOrderInfo = (TYBilliardsOrderInfo *)[TYBilliardsOrderInfo objectWithKeyValues:dataDic]; // 返回模型
                 weakSelf.headArr = @[@"订单信息",@"球台信息", @"酒水清单"];
                 weakSelf.headImgArr = @[@"order",@"store",@"shoppingcart"];
                 weakSelf.goodsList = [weakSelf.myOrderInfo.DrinksList mutableCopy]; // 用户购买列表
                 
                 if (weakSelf.goodsList.count > 0) {
                     TYBuyModelListInfo *total = [[TYBuyModelListInfo alloc] init]; // 尾部统计模型
                     total.GoodsName = @"酒水费用：";
                     total.PayAmount = weakSelf.myOrderInfo.DrinkAmount;
                     total.Coupon = weakSelf.myOrderInfo.DrinkCoupon;
                     [weakSelf.goodsList addObject:total];
                 }
                 
                 [weakSelf.bdTableView reloadData];
                 [HYLoadHubView dismiss];
             }
             else {
                 NSString *msg = objDic[@"msg"];
                 [ METoast toastWithMessage:msg];
                 [HYLoadHubView dismiss];
             }
         }else{
             [HYLoadHubView dismiss];
             [METoast toastWithMessage:@"服务器请求异常"];
         }
         
          weakSelf.view.userInteractionEnabled = YES;
     }];
}

// 创建BuyDrinksType按钮
-(UIButton *)button:(NSString *)title image:(NSString *)image hilightImage:(NSString *)hilightImage sel:(SEL)sel
{
    UIButton *bdBut = [[UIButton alloc] init];
    [bdBut setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [bdBut setBackgroundImage:[UIImage imageNamed:hilightImage] forState:UIControlStateHighlighted];
    [bdBut addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bdBut];
    
    return bdBut;
}

#pragma mark -- UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (_goodsList.count == 0) {
//        return 2;
//    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger index = 0;
    if (section == 0)
    {
        index = 1;
    }
    if (section == 1)
    {
        index = 4;
    }
    if (section == 2)
    {
        index = _goodsList.count;
    }
    
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYBuyDrinksTableViewCell *bdCell = [HYBuyDrinksTableViewCell initBuyDrinksTableView:tableView];

    switch (indexPath.section) {
        case 0:
        {
            bdCell.left.text = @"订单号:";
            bdCell.right.text = _myOrderInfo.PcOrderNum;
            
            bdCell.left.textColor = [UIColor blackColor];
            bdCell.right.textColor = bdCell.left.textColor;
        }
            break;
        case 1:
        {
            bdCell.left.text = self.billiardTitles[indexPath.row];
            if (0 == indexPath.row) {
                bdCell.right.text = _myOrderInfo.MerchantName;
            }
            else if (1 == indexPath.row) {
                bdCell.right.text = _myOrderInfo.TableName;
            }else if (indexPath.row == 2){
                bdCell.right.text = _myOrderInfo.StartTime;
            }
            else {
                
                static NSString *cellId = @"BilliardsRateCell";
                
                BilliardsRateCell   *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell                    = [[BilliardsRateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cell.originalLabel.text = [NSString stringWithFormat:@"原价:￥%@/小时",_myOrderInfo.RateCostPrice];

                cell.costLabel.text  = [NSString stringWithFormat:@"%@",self.myOrderInfo.RateByHourCoupon];
                
                 return cell;
            }
        
            bdCell.left.textColor = [UIColor blackColor];
            bdCell.right.textColor = bdCell.left.textColor;
        }
            break;
            
        case 2:
        {
            if (_goodsList.count > 0) {
                TYBuyModelListInfo *info = (TYBuyModelListInfo *)_goodsList[indexPath.row];
                
                if (indexPath.row == _goodsList.count - 1) { // 最后一行统计
                    bdCell.left.text = info.GoodsName;
                    bdCell.right.text = [info.Coupon integerValue] > 0 ? [NSString stringWithFormat:@"￥%.2lf+%@现金券", [info.PayAmount floatValue], info.Coupon] : [NSString stringWithFormat:@"￥%.2lf", [info.PayAmount floatValue]];
                    bdCell.left.textColor = [UIColor colorWithRed:219/255.0 green:31/255.0 blue:25/255.0 alpha:1];
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
            break;
            
        default:
            break;
    }
    
    return bdCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:[_headImgArr objectAtIndex:section]];
    [view addSubview:imgView];
    UILabel *lab = [[UILabel alloc] init];
    lab.text = [_headArr objectAtIndex:section]; // 表头
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
    
    if(section == 2 && _goodsList.count == 0)
    {
        [UIUtils addLineInView:view top:NO color:@"e5e5e5" leftMargin:0 rightMargin:0];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

#pragma mark - 购买酒水按钮

//购买酒水
- (void)bdPendingClick
{
    DrinksListViewController *drinks = [[DrinksListViewController alloc] init];
    drinks.merId = self.merID;
    drinks.orderId = self.orderID;
    [self.navigationController pushViewController:drinks animated:YES];
}

#pragma mark ---  关灯买单
- (void)bdCheckOutClick
{
    
//#warning  我自己写的提示框
    WS(weakSelf);
    FLCustomAlertView *alertView = [[FLCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-94, 150) TheViewType:TwoButton_TitleMessage];
    [alertView setTitle:@"关灯买单" TitleColor:[UIColor colorWithHexColor:@"b80000" alpha:1] andMessage:@"确认后将停止计费并关灯\n随后将进入支付页面" MessageColor:[UIColor colorWithHexColor:@"343434" alpha:1]];
    [alertView setOkButtonWithTitle:@"确定" TitleColor:[UIColor colorWithHexColor:@"ffffff" alpha:1] BackgroundColor:[UIColor colorWithHexColor:@"b80000" alpha:1]];
    [alertView setCancelButtonWithTitle:@"取消" TitleColor:[UIColor colorWithHexColor:@"ffffff" alpha:1] BackgroundColor:[UIColor colorWithHexColor:@"707070" alpha:1]];
   
    // 按钮点击回调事件
    [alertView buttonClickBlock:^(FLCAlertViewBtnTag tag) {
        switch (tag) {
            case ButtonTag_OkBtn:
            {
                // 确认按钮
                weakSelf.isGoPay = YES;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^{
                    [weakSelf confirmCloseTable];
                });
            }
                break;
            case ButtonTag_CancelBtn:
            {
                // 取消按钮
            }
                break;
                
            default:
                break;
        }
    }];
    
    [alertView show];
}

#pragma mark ---  呼叫按钮
- (void)callBtnClick
{
    
    [HYLoadHubView show];
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    WS(weakSelf);
    self.callServiceRequest             = [[CallServiceRequest alloc] init];
    self.callServiceRequest.interfaceURL  = [NSString stringWithFormat:@"%@/Share/CallService",BILLIARDS_API_URL];
    self.callServiceRequest.interfaceType = DotNET2;
    self.callServiceRequest.postType      = JSON;
    self.callServiceRequest.httpMethod    = @"POST";
    
    self.callServiceRequest.merId = self.merID;//  商户id
    self.callServiceRequest.btId = self.btId;
    self.callServiceRequest.uName = userInfo.realName ? : @"";
    self.callServiceRequest.mobile = userInfo.mobilePhone ? : @"";
    
    self.view.userInteractionEnabled = NO; //点击按钮的时候锁定当前的view 操作互斥
    [self.callServiceRequest sendReuqest:^(id result, NSError *error)
     {
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             
             if (code == 0) { //状态值为0 代表请求成功  其他为失败
                
                [HYLoadHubView dismiss];
                 
                 FLCustomAlertView *alertView = [[FLCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-94, 134) TheViewType:OneButton_TitleMessage];
                
                 [alertView setTitle:@"呼叫成功" TitleColor:[UIColor colorWithHexColor:@"b80000" alpha:1] subTitle:@"正在为您安排，请稍等" AndSubTitleColor:[UIColor colorWithHexColor:@"343434" alpha:1] andMessage:nil MessageColor:nil];
                 
                 [alertView setOkButtonWithTitle:@"我知道了" TitleColor:[UIColor colorWithHexColor:@"343434" alpha:1] BackgroundColor:[UIColor whiteColor]];
                 
                 [alertView buttonClickBlock:^(FLCAlertViewBtnTag tag) {
                     switch (tag) {
                         case ButtonTag_OkBtn:
                         {
                             // 点击按钮回调事件
                         }
                             break;
                             
                         default:
                             break;
                     }
                 }];
                 
                 
                 [alertView show];

             }
             else {
                 NSString *msg = objDic[@"msg"];
                 [ METoast toastWithMessage:msg];
                 [HYLoadHubView dismiss];
             }
         }else{
             [HYLoadHubView dismiss];
             [METoast toastWithMessage:@"服务器请求异常"];
         }
         
          weakSelf.view.userInteractionEnabled = YES;
     }];
}

#pragma mark -- 关灯买单点击确定后的收台操作
- (void)confirmCloseTable{
    [HYLoadHubView show];
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    self.closeTableRequest               = [[CloseTableRequest alloc] init];
    self.closeTableRequest.interfaceURL  = [NSString stringWithFormat:@"%@/Share/CloseBallTable",BILLIARDS_API_URL];
    self.closeTableRequest.interfaceType = DotNET2;
    self.closeTableRequest.postType      = JSON;
    self.closeTableRequest.httpMethod    = @"POST";
    
    self.closeTableRequest.uId   = userInfo.userId ? : @"";//  用户id
    self.closeTableRequest.merId = self.merID ? : @"";
    self.closeTableRequest.btId  = self.btId ? : @"";
    self.closeTableRequest.orId  = self.orderID ? : @"";
    
     self.view.userInteractionEnabled = NO; //点击按钮的时候锁定当前的view 操作互斥
    WS(weakSelf);
    [self.closeTableRequest sendReuqest:^(id result, NSError *error)
     {
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功  其他为失败

                     HYOrderPayViewController *orderPay = [[HYOrderPayViewController alloc] init];
                     orderPay.goodsList = weakSelf.goodsList;
                    
                     if (weakSelf.orderInfo) {
                          orderPay.orderInfo  = weakSelf.orderInfo;
                          weakSelf.orderInfo.EndTime = objDic[@"data"];
                     }else{
                          orderPay.billiardsTableInfo  = weakSelf.billiardsTableInfo;
                     }
                     orderPay.backRefresh = weakSelf.backRefresh;
                     
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithBilliardsCloseTable object:nil];

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                            dispatch_get_main_queue(), ^{
                                [weakSelf.navigationController pushViewController:orderPay animated:YES];
                    });
                 
 
             }else{
                 NSString *msg = objDic[@"msg"];
                 [METoast toastWithMessage:msg ? : @"收台失败,请稍后重试"];
             }
         }else{
             [METoast toastWithMessage:@"服务器请求异常"];
         }
         
         [HYLoadHubView dismiss];
        weakSelf.view.userInteractionEnabled = YES; //点击按钮的时候锁定当前的view 操作互斥
     }];
}

- (void)backToRootViewController:(id)sender{
    
    if (_backRefresh) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{// 如果时扫码进来的 则跳到root
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)dealloc{
    [HYLoadHubView dismiss];
    
    [_orderListRequest cancel];
    _orderListRequest = nil;
    
    [_closeTableRequest cancel];
    _closeTableRequest = nil;
    
    [self.callServiceRequest cancel];
    self.callServiceRequest  = nil;
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
