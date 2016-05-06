//
//  DrinksListViewController.m
//  zuoqiu
//
//  Created by wujianming on 15/11/5.
//  Copyright © 2015年 teshehui. All rights reserved.
//  酒水列表

#define kTabBarH 49

#import "DrinksListViewController.h"
#import "DrinksListView.h"
#import "DrinksListCell.h"
#import "DrinksListHeaderView.h"
#import "UITableView+Common.h"
#import "UIImage+Common.h"
#import "Masonry.h"
#import "PKYStepper.h"
#import "goodsInfo.h"
#import "MJRefresh.h"

#import "TYBilliardsOrderInfo.h"
#import "DrinksListRequest.h"
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
#import "TYDrinksListInfo.h"
#import "BuyGoodsRequest.h"

@interface DrinksListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DrinksListHeaderView *myHeaderView;
@property (nonatomic, assign) CGFloat              cash;
@property (nonatomic, assign) NSInteger            coupon;
@property (nonatomic, strong) DrinksListView       *drinks;
@property (nonatomic, strong) NSMutableArray       *dataSourceRequest;
@property (nonatomic, strong) NSMutableArray       *dataSource;
@property (nonatomic, assign) NSInteger            index;

@property (nonatomic, strong) UIButton            *buyBtn;

// 回传数据数组
@property (nonatomic, strong) NSMutableArray       *goodsInfos;

@property (nonatomic, strong) DrinksListRequest    *orderListRequest;
@property (nonatomic,strong ) BuyGoodsRequest      *buyGoodsListRequest;

@end

@implementation DrinksListViewController

- (NSMutableArray *)goodsInfos
{
    if (!_goodsInfos) {
        _goodsInfos = [NSMutableArray array];
    }
    
    return _goodsInfos;
}

- (NSMutableArray *)dataSource // 网络数据
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSMutableArray *)dataSourceRequest
{
    if (!_dataSourceRequest) {
        _dataSourceRequest = [NSMutableArray array];
    }
    
    return _dataSourceRequest;
}

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    
    _index = kDefaultPageIndexStart;
    
    [self loadData];
    [self setupController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [HYLoadHubView dismiss];
    [_orderListRequest cancel];
    _orderListRequest = nil;
    
    [_buyGoodsListRequest cancel];
    _buyGoodsListRequest = nil;
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)loadData
{
    [HYLoadHubView show];
    WS(weakSelf);
    
    self.orderListRequest               = [[DrinksListRequest alloc] init];
    self.orderListRequest.interfaceURL  = [NSString stringWithFormat:@"%@/Share/GetGoodsList",BILLIARDS_API_URL];
    self.orderListRequest.interfaceType = DotNET2;
    self.orderListRequest.postType      = JSON;
    self.orderListRequest.httpMethod    = @"POST";
    
    self.orderListRequest.merId         = _merId;
    self.orderListRequest.pageIndex     = _index;
    self.orderListRequest.pageSize      = kDefaultPageSize;
    
    [self.orderListRequest sendReuqest:^(id result, NSError *error)
     {
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             
             if (code == 0) { //状态值为0 代表请求成功  其他为失败
                 weakSelf.index++;
                 NSArray *listArray = objDic[@"data"];
                 
                 if (listArray.count == 0) {
                     [METoast toastWithMessage:@"已显示全部商品"];
                 }
                 else {
                     
                     for (TYDrinksListInfo *info in [TYDrinksListInfo objectArrayWithKeyValuesArray:listArray]) {
                         [weakSelf.dataSourceRequest addObject:info];
                    }
                     
                     weakSelf.dataSource = [NSMutableArray array];
                     for (int i = 0; i < weakSelf.dataSourceRequest.count; i++) {
                         
                         TYDrinksListInfo *info = (TYDrinksListInfo *)weakSelf.dataSourceRequest[i];
                         goodsInfo *gInfo = [[goodsInfo alloc] init];
                         gInfo.productName = info.Name;
                         gInfo.salePrice = info.SalePrice;
                         gInfo.productCash = info.Rmb;
                         gInfo.productCoupon = info.TeBi;
                         gInfo.gid = info.Gid;
                         [weakSelf.dataSource addObject:gInfo];
                     }
                 }
                 
                 [weakSelf.drinks reloadData];
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
     }];
}

- (void)buyGoodsList
{
    
    if(_goodsInfos.count == 0){
        [METoast toastWithMessage:@"请选择需要购买的商品"];
        return;
    }
    
    self.view.userInteractionEnabled  = NO;
    
    [self.buyGoodsListRequest cancel];
    self.buyGoodsListRequest = nil;
    
    [HYLoadHubView show];
    
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    self.buyGoodsListRequest               = [[BuyGoodsRequest alloc] init];
    self.buyGoodsListRequest.interfaceURL  = [NSString stringWithFormat:@"%@/Share/BuyGoods",BILLIARDS_API_URL];
    self.buyGoodsListRequest.interfaceType = DotNET2;
    self.buyGoodsListRequest.postType      = JSON;
    self.buyGoodsListRequest.httpMethod    = @"POST";
    
    self.buyGoodsListRequest.merId = _merId;
    self.buyGoodsListRequest.orderId = _orderId;
    self.buyGoodsListRequest.uId = userInfo.userId;
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:_goodsInfos.count];
    for (int i = 0; i < _goodsInfos.count; i++) {
        goodsInfo *gInfo = _goodsInfos[i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:gInfo.gid forKey:@"goId"];
        [dic setObject:@(gInfo.buyAmount) forKey:@"num"];
        [temp addObject:[dic copy]];
    }
    self.buyGoodsListRequest.buyList = [temp copy];
    WS(weakSelf);
    [self.buyGoodsListRequest sendReuqest:^(id result, NSError *error)
     {
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             
             if (code == 0) { //状态值为0 代表请求成功  其他为失败
                 // 确认按钮事件处理
                 
                 [HYLoadHubView dismiss];
                 [METoast toastWithMessage:@"购买商品成功"];
                 
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [weakSelf.navigationController popViewControllerAnimated:YES];
                 });
   
             }
             else {
                 NSString *msg = objDic[@"msg"];
                  [METoast toastWithMessage:msg ? : @"购买商品失败"];
                 [HYLoadHubView dismiss];
             }
            
         }else{
             [HYLoadHubView dismiss];
             [METoast toastWithMessage:@"服务器请求异常"];
            
         }
         
         self.view.userInteractionEnabled = YES;
     }];
}


#pragma mark - 控制器初始化
- (void)setupController
{
    self.title = @"酒水列表";
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    [self addDrinksListView];
    [self addBottomView];
}

- (void)addDrinksListView
{
    DrinksListView *drinksV = [[DrinksListView alloc] initWithFrame:CGRectMake(0, 0,kScreen_Width, [UIScreen mainScreen].bounds.size.height - (IOS7 ? 64 : 44) - kTabBarH) style:UITableViewStylePlain];
    drinksV.dataSource = self;
    drinksV.delegate = self;
    drinksV.showsVerticalScrollIndicator = NO;
    drinksV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:drinksV];
    _drinks = drinksV;
    [self setRefresh];
}

- (void)setRefresh
{
    WS(weakSelf);
    self.drinks.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
        [weakSelf.drinks.footer endRefreshing];
    }];
}

- (void)addBottomView
{
    _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:177/255.0 green:26/255.0 blue:34/255.0 alpha:1.0]] forState:UIControlStateNormal];
    [self.view addSubview:_buyBtn];
    [_buyBtn setTitle:@"确 认" forState:UIControlStateNormal];
    _buyBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    
    [_buyBtn addTarget:self action:@selector(confirmButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self) weakSelf = self;
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(kTabBarH);
        make.right.mas_equalTo(weakSelf.view.mas_right);
    }];
}

- (void)confirmButtonDidClick
{
    [self buyGoodsList];
}

#pragma mark - UITabbleView dataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    DrinksListCell *cell = [DrinksListCell cellWithTableView:tableView];

    [cell binddata:indexPath goodsInfo:_dataSource[indexPath.row]];

    [cell setSteperClick:^(NSIndexPath *indexpath1, float value) {
        NSLog(@"%li %.lf",indexpath1.row, value);
        goodsInfo *info = (goodsInfo *)[weakSelf.dataSource objectAtIndex:indexpath1.row];
        info.buyAmount = value;
        
        weakSelf.cash = 0.00; // 每次点击清空上次记录总数
        weakSelf.coupon = 0;
        
        for (goodsInfo *info in weakSelf.dataSource) {
//            weakSelf.cash += [info.productCash floatValue] * info.buyAmount; // 计算当前所选商品总金额
            weakSelf.coupon += [info.productCoupon integerValue] * info.buyAmount;
            
            weakSelf.cash += [info.salePrice floatValue] * info.buyAmount; // 计算当前所选商品总金额
            
            // 存储单个商品信息
            if ((info.buyAmount > 0 && ![weakSelf.goodsInfos containsObject:info]) || info.buyAmount > 1) {
                if (info.buyAmount > 1) {
                    NSInteger index = [weakSelf.goodsInfos indexOfObject:info];
                    [weakSelf.goodsInfos replaceObjectAtIndex:index withObject:info];
                }
                else {
                    [weakSelf.goodsInfos addObject:info];
                }
            }
            
            if (info.buyAmount == 0 && [weakSelf.goodsInfos containsObject:info]) {
                [weakSelf.goodsInfos removeObject:info];
            }
        }
        
        weakSelf.myHeaderView.totalPrice.text = [NSString stringWithFormat:@"￥%.2lf", weakSelf.cash];//[NSString stringWithFormat:@"￥%.2lf+%li", weakSelf.cash, weakSelf.coupon];
        NSLog(@"%@", weakSelf.goodsInfos);
    }];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DrinksListHeaderView *headerV = [[DrinksListHeaderView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,94}];
    _myHeaderView = headerV;
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
}

@end
