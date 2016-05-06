//
//  HYSeckillGoodsListViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSeckillGoodsListViewController.h"
#import "HYLimitTimeBuyCell.h"
#import "HYSeckillGoodsListRequest.h"
#import "HYSeckillGoodsListResponse.h"
#import "HYUserInfo.h"
#import "MJRefresh.h"
#import "HYLoadHubView.h"
#import "HYProductDetailViewController.h"
#import "HYSeckillAddRemindReq.h"
#import "HYSeckillCancelRemindReq.h"
#import "MJRefresh.h"
#import "HYSeckillTimeView.h"
#import "Masonry.h"
#import "HYSeckillAddRemindResp.h"
#import "HYSeckillCancelRemindResp.h"
#import "METoast.h"
#import "HYMallFullOrderViewController.h"
#import "HYMallCartShopInfo.h"


#define kHYLimitTimeBuyCellID @"HYLimitTimeBuyCellID"

@interface HYSeckillGoodsListViewController ()
<UITableViewDataSource,UITableViewDelegate,HYLimitTimeBuyCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYSeckillGoodsListRequest *secKillGoodsListReq;
@property (nonatomic, strong) HYSeckillAddRemindReq *secKillAddRemindReq;
@property (nonatomic, strong) HYSeckillCancelRemindReq *secKillCancelRemindReq;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL addRemindIsLoading;
@property (nonatomic, assign) BOOL isRemindReq;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) HYSeckillTimeView *timeView;

@end

@implementation HYSeckillGoodsListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [_secKillGoodsListReq cancel];
    _secKillGoodsListReq = nil;
    
    [_secKillAddRemindReq cancel];
    _secKillAddRemindReq = nil;
    
    [_secKillCancelRemindReq cancel];
    _secKillCancelRemindReq = nil;
}

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    HYSeckillTimeView *timeView = [[HYSeckillTimeView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, TFScalePoint(35))];
    [timeView setHidden:YES];
    [self.view addSubview:timeView];
    self.timeView = timeView;
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(TFScalePoint(35));
    }];
    
    /// tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TFScalePoint(35), rect.size.width, rect.size.height - TFScalePoint(35)) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [tableView registerNib:[UINib nibWithNibName:@"HYLimitTimeBuyCell" bundle:nil] forCellReuseIdentifier:kHYLimitTimeBuyCellID];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(timeView.mas_bottom);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    /// 上拉
//    WS(weakSelf);
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^
//    {
//        if (weakSelf.pullCallback) {
//            weakSelf.pullCallback();
//        }
//    }];
//    tableView.tableFooterView = footer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageNo = 1;
    _pageSize = 20;
    _isLoading = NO;
    _addRemindIsLoading = NO;
    _isRemindReq = NO;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreSeckillGoodsListData)];
    WS(weakSelf);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf reloadData];
    }];
    
    [self getData];
    
    if (self.activity)
    {
        self.timeView.activity = self.activity;
        
        [self.timeView setHidden:NO];
        
        self.timeView.timeEndCallback = self.timeEndCallback;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidRestore) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationDidRestore
{
    /**
     *  只有显示的才刷新，这样会提升一点性能，但是有一个隐藏的bug，即当前没有显示的活动列表
     *  的计时会出现误差。
     */
    if (self.view.window)
    {
        [self reloadData];
    }
}

#pragma mark - getData
- (void)getData
{
    _isLoading = YES;
    
    [HYLoadHubView show];
    if (!_secKillGoodsListReq) {
        _secKillGoodsListReq = [[HYSeckillGoodsListRequest alloc] init];
    }
    NSString *userId = [HYUserInfo getUserInfo].userId;
    _secKillGoodsListReq.userId = userId;
    _secKillGoodsListReq.pageNo = [NSString stringWithFormat:@"%ld", self.pageNo];
    _secKillGoodsListReq.pageSize = [NSString stringWithFormat:@"%ld", self.pageSize];
    _secKillGoodsListReq.activityId = self.activity.activityId;
    
    // 假数据
   // _secKillGoodsListReq.activityId = @"3";
    
    __weak typeof(self) weakSelf = self;
    [_secKillGoodsListReq sendReuqest:^(id result, NSError *error){
        HYSeckillGoodsListResponse *secKillGoodsListResponse = (HYSeckillGoodsListResponse *)result;
        
        [weakSelf.dataArr addObjectsFromArray:secKillGoodsListResponse.dataList];
        [weakSelf.tableView reloadData];
        if (secKillGoodsListResponse.dataList.count == 0) {
            
            weakSelf.tableView.footer.hidden = YES;
        } else {
            
            weakSelf.tableView.footer.hidden = NO;
        }
        [weakSelf.tableView.footer endRefreshing];
        weakSelf.isLoading = NO;
        [HYLoadHubView dismiss];
        [weakSelf.tableView.header endRefreshing];
        
        if (weakSelf.pageNo == 1 && secKillGoodsListResponse.status == 200)
        {
            [weakSelf refreshActivity:secKillGoodsListResponse.activity];
        }
    }];
}

/**
 *  @brief 更新活动时间信息
 */
- (void)refreshActivity:(HYSeckillActivityModel *)activity
{
    self.activity = activity;
    self.timeView.activity = activity;
    if (self.pulldownCallback)
    {
        self.pulldownCallback(activity);
    }
}

/// 这里有隐藏bug，在正在加载时上拉，会发生页码与数据不一致的情况
- (void)getMoreSeckillGoodsListData
{
    
    if (_isLoading == NO) {
        _pageNo++;
        [self getData];
    }
}

- (void)reloadData
{
    _pageNo = 1;
    [self.dataArr removeAllObjects];
    [self getData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYLimitTimeBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:kHYLimitTimeBuyCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (indexPath.row < self.dataArr.count)
    {
        HYSeckillGoodsListModel *model = self.dataArr[indexPath.row];
        [cell setCellInfoWithModel:model andActivityStatus:self.activity.activityStatus];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HYProductDetailViewController *productVC = [[HYProductDetailViewController alloc] init];
    if (indexPath.row < self.dataArr.count) {
        
        HYSeckillGoodsListModel *model = self.dataArr[indexPath.row];
        productVC.goodsId = model.productCode;
        [self.navigationController pushViewController:productVC animated:YES];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark - HYLimitTimeBuyCellDelegate
- (void)addRemindWithBtn:(UIButton *)btn
{
    
    if (_addRemindIsLoading == NO)
    {
        
        _addRemindIsLoading = YES;
        [HYLoadHubView show];
        HYLimitTimeBuyCell *cell = (HYLimitTimeBuyCell *)btn.superview;
        
        if ([self.tableView indexPathForCell:cell])
        {
            NSIndexPath *path = [self.tableView indexPathForCell:cell];
            if (path.row < self.dataArr.count)
            {
                
                HYSeckillGoodsListModel *model = self.dataArr[path.row];
                if (!_secKillAddRemindReq)
                {
                    _secKillAddRemindReq = [[HYSeckillAddRemindReq alloc] init];
                }
                _secKillAddRemindReq.activityId = self.activity.activityId;
                _secKillAddRemindReq.productCode = model.productCode;
                
                __weak typeof(self) weakSelf = self;
                [_secKillAddRemindReq sendReuqest:^(id result, NSError *error)
                {
                    if ([result isKindOfClass:[HYSeckillAddRemindResp class]])
                    {
                        HYSeckillAddRemindResp *resp = (HYSeckillAddRemindResp *)result;
                        if (resp.status == 200)
                        {
                            model.isHaveReminded = 1;
                            NSInteger num = [model.totalRemindNum integerValue];
                            num++;
                            model.totalRemindNum = [NSString stringWithFormat:@"%ld", num];
                            model.remindId = resp.data.integerValue;
                            [weakSelf.tableView reloadData];
                        }
                    }
                    weakSelf.addRemindIsLoading = NO;
                    [HYLoadHubView dismiss];
                    weakSelf.isRemindReq = YES;
                }];
            }
        }
    }
}

- (void)cancelRemindWithBtn:(UIButton *)btn
{
    
    if (_addRemindIsLoading == NO) {
        
        _addRemindIsLoading = YES;
        [HYLoadHubView show];
        HYLimitTimeBuyCell *cell = (HYLimitTimeBuyCell *)btn.superview;
        
        if ([self.tableView indexPathForCell:cell]) {
            
            NSIndexPath *path = [self.tableView indexPathForCell:cell];
            if (path.row < self.dataArr.count)
            {
                HYSeckillGoodsListModel *model = self.dataArr[path.row];
                if (!_secKillCancelRemindReq)
                {
                    _secKillCancelRemindReq = [[HYSeckillCancelRemindReq alloc] init];
                }
                _secKillCancelRemindReq.remindId = [NSString stringWithFormat:@"%ld", (long)model.remindId];
                
                __weak typeof(self) weakSelf = self;
                [_secKillCancelRemindReq sendReuqest:^(id result, NSError *error)
                {
                    if ([result isKindOfClass:[HYSeckillCancelRemindResp class]])
                    {
                        HYSeckillCancelRemindResp *resp = (HYSeckillCancelRemindResp *)result;
                        if (resp.status == 200)
                        {
                            model.isHaveReminded = 0;
                            NSInteger num = [model.totalRemindNum integerValue];
                            num--;
                            model.totalRemindNum = [NSString stringWithFormat:@"%ld", num];
                            model.remindId = 0;
                            [weakSelf.tableView reloadData];
                        }
                    }
                    weakSelf.addRemindIsLoading = NO;
                    [HYLoadHubView dismiss];
                    weakSelf.isRemindReq = YES;
                }];
            }
            
        }
        
    }
}

/**
 * 界面跳转
 */
- (void)actionWithModel:(HYSeckillGoodsListModel *)model
{
    if (model.stock > 0)
    {
        HYMallFullOrderViewController *vc = [[HYMallFullOrderViewController alloc] init];
        HYMallCartShopInfo *store = [[HYMallCartShopInfo alloc] init];
        store.supplierType = model.supplierType;
        store.store_id = [NSString stringWithFormat:@"%ld", model.storeId];
        store.store_name = model.storeName;
        store.isSelect = YES;
        store.quantity = @"1";
        HYUserInfo *user = [HYUserInfo getUserInfo];
        HYMallCartProduct *product = [[HYMallCartProduct alloc] init];
        product.supplierType = model.supplierType;
        product.userId = user.userId;
        product.businessType = @"01";
        product.productId = model.productCode;
        product.productName = model.productName;
        
        HYImageInfo *image = model.productImage;
        product.productSKUPicUrl = [image defaultURL];
        product.productSKUImage = image;
        product.productSKUId = model.productSkuCode;
        //    product.productSKUSpecification = [self.goodsDetail skuDesc];颜色: 红色 尺码: L
            product.salePoints = [NSString stringWithFormat:@"%ld", model.point];
            product.salePrice = model.seckillPrice;
        product.quantity = @"1";
        product.subTotalPoints = [NSString stringWithFormat:@"%ld", model.point];
        product.subTotal = model.seckillPrice;
        product.isSelect = YES;
        //    product.attributeValue1 = _goodsDetail.currentsSUK.attributeValue1;
        //    product.attributeValue2 = _goodsDetail.currentsSUK.attributeValue2;
        //    product.brandId = _goodsDetail.brandId;
        store.goods = [NSArray arrayWithObject:product];
        vc.storeList = [NSArray arrayWithObject:store];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        HYProductDetailViewController *productVC = [[HYProductDetailViewController alloc] init];
        productVC.goodsId = model.productCode;
        [self.navigationController pushViewController:productVC animated:YES];
    }
}

//- (void)actionWithBtn:(UIButton *)btn
//{
//
//    HYProductDetailViewController *productVC = [[HYProductDetailViewController alloc] init];
//    HYLimitTimeBuyCell *cell = (HYLimitTimeBuyCell *)btn.superview;
//
//    if ([self.tableView indexPathForCell:cell])
//    {
//
//        NSIndexPath *path = [self.tableView indexPathForCell:cell];
//        
//        if (path.row < self.dataArr.count)
//        {
//            
//            HYSeckillGoodsListModel *model = self.dataArr[path.row];
//            productVC.goodsId = model.productCode;
//            [self.navigationController pushViewController:productVC animated:YES];
//        }
//    }
//}

@end
