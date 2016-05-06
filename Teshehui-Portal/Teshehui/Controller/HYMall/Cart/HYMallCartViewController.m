//
//  HYMallCartViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCartViewController.h"
#import "HYMallCartCell.h"
#import "HYMallCartTableHeader.h"
#import "HYMallCartFooterView.h"
#import "HYMallFullOrderViewController.h"
#import "HYProductDetailViewController.h"
#import "HYNavigationController.h"

#import "HYMallCartService.h"

#import "HYUserInfo.h"
#import "HYNullView.h"
#import "METoast.h"
#import "HYShoppingCarView.h"
#import "HYAppDelegate.h"
#import "HYMallCartModel.h"
#import "HYProductSKUSelectView.h"
#import "HYAlertView.h"
#import "HYMineInfoViewController.h"
#import "HYUmengMobClick.h"

@interface HYMallCartViewController ()
<HYMallCartCellDelegate,
hyMallCartTableHeaderDelegate,
HYMallCartFooterViewDelegate,
HYProductSKUSelectViewDelegate
>
{
    HYMallCartService *_cartService;
    
    BOOL _loading;
    
    UIButton *_editBtn;
    
    HYMallCartModel *_cartModel;
    
    HYMallCartProduct *_editProduct;
    NSInteger _quantityEdited;

    BOOL _navEdit;
}
@property (nonatomic, strong) HYMallCartModel *cartModel;
@property (nonatomic, strong) HYMallCartService *cartService;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYMallCartFooterView *footerView;
@property (nonatomic, strong) UIBarButtonItem *eidtItemBar;
@property (nonatomic, strong) UIBarButtonItem *navEidtItemBar;
@property (nonatomic, strong) NSMutableArray *tempHeaderForSection;
@property (nonatomic, assign) BOOL editing;
//@property (nonatomic, strong) NSMutableDictionary *productList;
//@property (nonatomic, strong) NSArray *storeList;

@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, assign) BOOL loading;

@property (nonatomic, strong) HYProductSKUSelectView *skuSelectView;

/**
 * cell失效图标是否隐藏
 */
@property (nonatomic, assign, getter=isIconHiden) BOOL iconHiden;

@end

@implementation HYMallCartViewController

//取消所有请求并移除加载框
- (void)cancellRequestsAndDismissLoading
{
    [HYLoadHubView dismiss];
    
    [_cartService cancel];
    
    self.loading = NO;
}

-(void)dealloc
{
    [self cancellRequestsAndDismissLoading];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.editing = NO;
        _cartModel = [[HYMallCartModel alloc] init];
        _cartService = [[HYMallCartService alloc] init];
        self.loading = NO;
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
    
    _iconHiden = YES;
    
    frame.size.height -= 44;
    if (self.baseViewController) {
        frame.size.height -= TFScalePoint(kTabBarHeight);
    }
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithRed:240/255.0
                                           green:239/255.0
                                            blue:245/255.0
                                           alpha: 1];
    tableview.delaysContentTouches = NO;
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    //底部栏 ，总金额及结算按钮界面
    HYMallCartFooterView *footerView = [[HYMallCartFooterView alloc] initWithFrame:
                          CGRectMake(0,
                                     CGRectGetHeight(frame),
                                     CGRectGetWidth(frame),
                                     44)];
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.delegate = self;
    footerView.checkBtn.selected = YES;
    [self.view addSubview:footerView];
    self.footerView = footerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"购物车";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    //默认先不显示编辑按钮，数据加载完后再显示
    [self setRightBarItemIsEdit:NO];
    if (isLogin)
    {
        [self.footerView setHidden:NO];
        self.tableView.hidden = NO;
        self.nullView.hidden = YES;
        
        //进入界面时默认清除所有编辑状态
        [_cartModel resetAllEditStats];
        [self reloadCart];
        
        if (_editing)
        {
            [self editItemAction:nil];
        }
        
        if (self.baseViewController)
        {
            [self.baseViewController setTabbarShow:YES];
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO
                                                forKey:kShoppingCarHasNew];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.baseContentView setStatus:NO atIndex:3];
        
        [self.footerView setHidden:YES];
        self.tableView.hidden = YES;
        self.nullView.hidden = NO;
        self.nullView.descInfo = @"您还没有登录，请先登录";
//        [self setRightBarItemIsEdit:NO];
    }
    
    self.baseViewController.navigationItem.leftBarButtonItem = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self cancellRequestsAndDismissLoading];
}

#pragma mark setter/getter
-(NSMutableArray *)tempHeaderForSection
{
    if (!_tempHeaderForSection)
    {
        _tempHeaderForSection = [NSMutableArray array];
    }
    return _tempHeaderForSection;
}

- (UIBarButtonItem *)eidtItemBar
{
    if (!_eidtItemBar)
    {
        UIButton* editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(0, 0,48,30);
        [editBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [editBtn setTitle:[NSString stringWithFormat:@"编辑"]
                 forState:UIControlStateNormal];
        [editBtn setTitle:@"完成" forState:UIControlStateSelected];
        [editBtn setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
        [editBtn addTarget:self
                    action:@selector(editItemAction:)
          forControlEvents:UIControlEventTouchUpInside];
        _editBtn = editBtn;
        _editBtn.selected = _editing;
        _eidtItemBar = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    }
    
    return _eidtItemBar;
}

- (void)editItemAction:(UIButton *)item
{
    WS(weakSelf);
    
    _editing = !_editing;
    _editBtn.selected = _editing;

    _iconHiden = !_iconHiden;
    _navEdit = _editing;
    [_tableView reloadData];
    
   /*
    [_cartModel setAllProductIsSelect:_editing];
    [self updatePriceInfo];
    [_footerView setCheckBtnSelected:_editing];
    */
    
    /*
    [self clearTempHeader];
    //reload可能是异步执行的
    [self.tableView reloadData];
    //等待刷新完成后再回调下面的代码
    [self.tableView layoutIfNeeded];
     */
     
    
    //点击全选编辑的展示状态
//    for (HYMallCartTableHeader *obj in self.tempHeaderForSection)
//    {
//        [self navDidClickEditButton:obj];
//    }

    //把单个编辑按钮隐藏
//    [self.tempHeaderForSection makeObjectsPerformSelector:@selector(setEditBtnHidden:)
//                                               withObject:[NSNumber numberWithBool:_editing]];
    [_footerView showNewFooter:_editing];
    
    //添加收藏
    _footerView.footer.firstBlock = ^{
        
        [HYUmengMobClick homePageBuyCarMoveToCollectionClicked];
        //取出选中的商品
        NSArray *selected = [weakSelf.cartModel getSelectedShopListToOrder];
        if (selected.count > 0)
        {
           [weakSelf addToFavorites:selected];
        }
        else
        {
            [METoast toastWithMessage:@"您还没有选择宝贝!"];
        }
    };
    
    //批量删除
    _footerView.footer.secBlock = ^{
        
        [HYUmengMobClick homePageBuyCarDeleteClicked];
        NSArray *selected = [weakSelf.cartModel getSelectedShopListToOrder];
        if (selected.count > 0)
        {
            [weakSelf setupGroupDeleteListAlertView];
        }
        else
        {
            [METoast toastWithMessage:@"您还没有选择宝贝!"];
        }
    };
    
    //用是否有选中的商品数量来判断收藏和删除按钮的可用状态

    //先留着，防止以后改回来
    /*
    CGRect frame = self.tableView.frame;
    frame.size.height += CGRectGetHeight(self.footerView.frame) * off;
    self.tableView.frame = frame;
    
    frame = self.footerView.frame;
    frame.origin.y += CGRectGetHeight(self.footerView.frame) * off;
    [UIView animateWithDuration:.2 animations:^
    {
        self.footerView.frame = frame;
    }];
     */
}

#pragma mark private methods
- (void)setupGroupDeleteListAlertView
{
    WS(weakSelf);
    HYAlertView *alert = [HYAlertView instanceView];
    alert.mainTitle.text = [NSString
                            stringWithFormat:@"确定要删除这%lu个宝贝吗?",(unsigned long)_cartModel.getSelectedProductList.count];
   
    alert.secondBlock = ^{
        //取出选中的商品
        NSArray *selected = [_cartModel getSelectedShopListToOrder];
        
        //取出所有的productSKUId
        NSMutableArray *productIDArr = [NSMutableArray array];
        for (NSInteger i = 0; i < selected.count; i++) {
            HYMallCartShopInfo *model = selected[i];
            NSArray *goodsArr = model.goods;
            for (NSInteger j = 0; j < goodsArr.count; j++) {
                HYMallCartProduct *model = goodsArr[j];
                [productIDArr addObject:model.productSKUId];
            }
        }
        [weakSelf dropProduct:productIDArr];
    };
    [alert show];
}

/**
 *  @brief 编辑数量
 *  当前逻辑是，如果成功，那么刷新购物车列表
 *
 *  @param product  商品
 *  @param quantity 目标数量
 */
- (void)updateProduct:(HYMallCartProduct *)product buyQuantity:(NSInteger)quantity
{
    //商品数量+、-
    [MobClick event:@"v430_shangcheng_gouwuche_shangpinshuliangjiajian_jishu"];
    
    if (!_loading)
    {
        [HYLoadHubView show];
        __weak typeof(self) b_self = self;
        _loading = YES;
        [_cartService updateProduct:product
                       withQuantity:quantity newSKU:nil callback:^(BOOL succ, NSString *error)
         {
             b_self.loading = NO;
             [HYLoadHubView dismiss];
             
             ///    toast显示错误信息
             if (error)
             {
                 [METoast toastWithMessage:error];
             }
             [b_self reloadCartWithAlertShow:YES];
         }];
    }
}

-(void)dropProduct:(NSArray *)goods
{
    //删除
    [MobClick event:@"v430_shangcheng_gouwuche_shanchushangpin_jishu"];
    
    if (!_loading)
    {
        _loading = YES;
        [HYLoadHubView show];
        __weak typeof(self) b_self = self;
        [_cartService dropProduct:goods callback:^(BOOL succ, NSString *err)
         {
             b_self.loading = NO;
             [HYLoadHubView dismiss];
             /*
             if (succ)
             {
                 [METoast toastWithMessage:@"删除成功!"];
             }
             else
             {
                 [METoast toastWithMessage:@"删除失败"];
             }
              */
             [b_self reloadCart];
         }];
    }
}

- (void)addToFavorites:(NSArray *)products
{
    if (!_loading)
    {
        [HYLoadHubView show];
        __weak typeof(self) b_self = self;
        _loading = YES;
        [_cartService addProductToFavorites:products callback:^(BOOL succ, NSString *error,NSString *message) {
            b_self.loading = NO;
            [HYLoadHubView dismiss];
            if (succ)
            {
                [METoast toastWithMessage:message];
                [b_self reloadCart];
            }
            else
            {
                [METoast toastWithMessage:error];
            }
        }];
       
    }
}

- (void)updatePriceInfo
{
    _footerView.checkBtn.selected = _cartModel.isSelect;
    
    CGFloat money = 0.0;
    NSInteger points = 0;
    NSInteger spare = 0;
    [_cartModel getPrice:&money point:&points spare:&spare];
    
    [self.footerView.buyBtn setEnabled:(money>0)];
//    [self.footerView.footer setUserInteractionEnabled:(money>0)];
    [self.footerView setPrice:[NSString stringWithFormat:@"%.2f", money]
                       points:[NSString stringWithFormat:@"%ld", (long)points]
                        spare:[NSString stringWithFormat:@"%ld", (long)spare]];
}

- (void)clearTempHeader
{
    [self.tempHeaderForSection removeAllObjects];
}
//加载商品列表
-(void)reloadCart
{
    [self reloadCartWithAlertShow:YES];
}

/// 刷新购物车，确定是否弹框显示错误信息
- (void)reloadCartWithAlertShow:(BOOL)show
{
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_cartService getProductList:^(NSArray *array, NSString *error)
     {
         [HYLoadHubView dismiss];
         if (error && show)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:error
                                                            delegate:nil
                                                   cancelButtonTitle:@"刷新库存"
                                                   otherButtonTitles:nil];
             [alert show];
         }
         [b_self updateViewWithData:array error:error];
     }];
}

- (void)setRightBarItemIsEdit:(BOOL)yes
{
    UIBarButtonItem *item = yes ? [self eidtItemBar] : nil;
    
    if (!self.baseViewController)
    {
        self.navigationItem.rightBarButtonItem = item;
    }
    else
    {
        self.baseViewController.navigationItem.rightBarButtonItem = item;
    }
}

- (void)getSpareInfos
{
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_cartService getSpareInfoWithProductList:_cartModel
                                     callback:^(BOOL succ, NSString *err)
     {
         [HYLoadHubView dismiss];
         [b_self.tableView reloadData];
         [b_self updatePriceInfo];
     }];
}

//商品列表加载完成
- (void)updateViewWithData:(NSArray *)array error:(NSString *)error
{
    if (array > 0)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:kShoppingCarHasNew];
        [[NSUserDefaults standardUserDefaults] synchronize];
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.baseContentView setStatus:YES
                                       atIndex:3];
        
        [self setRightBarItemIsEdit:YES];
        
        self.nullView.hidden = YES;
        self.tableView.hidden = NO;
        _footerView.hidden = NO;
        
        [_cartModel updateWithNewShopList:array];
        self.footerView.checkBtn.selected = [_cartModel allProductIsSelect];
        [self.tableView reloadData];
        //更新界面的价格信息
        [self updatePriceInfo];
        [self getSpareInfos];
    }
    else
    {
        [self setRightBarItemIsEdit:NO];
        _tableView.hidden = YES;
        _footerView.hidden = YES;
        self.nullView.hidden = NO;
        
        if (error)
        {
            self.nullView.descInfo = @"购物车查询失败，请稍后再试";
        }
        else
        {
            self.nullView.descInfo = @"购物车中没有添加任何商品";
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:NO
                                                forKey:kShoppingCarHasNew];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.baseContentView setStatus:NO atIndex:3];
    }
}

//- (void)navDidClickEditButton:(HYMallCartTableHeader *)header
//{
//    NSInteger section = header.section;
//    BOOL edit = header.shopInfo.isNavEdit;
//    header.shopInfo.isNavEdit = !edit;
//    _navEdit = !edit;
//    [_tableView reloadData];
//}

#pragma mark - Table View Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_cartModel storeCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cartModel rowForStoreAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cartCell";
    HYMallCartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[HYMallCartCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:identifier];
        cell.frame = CGRectMake(0, 0, ScreenRect.size.width, 44);
    }
    
    cell.edit = [[_cartModel shopForIndex:indexPath.section] isEdit];
    cell.iconHiden = self.iconHiden;
    HYMallCartProduct *good = [_cartModel productForIndexPath:indexPath];
    [cell setProduct:good];
    if ((!cell.edit && _navEdit)
        || (cell.edit && _navEdit))
    {
       [cell setNavEdit:_navEdit animated:NO];
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_editing)
    {
        HYMallCartProduct *goods = [_cartModel productForIndexPath:indexPath];
        HYProductDetailViewController *detail = [[HYProductDetailViewController alloc] init];
        detail.goodsId = goods.productId;
        detail.title = @"商品详情";
        if (self.baseViewController)
        {
            [self.baseViewController setTabbarShow:NO];
        }
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HYMallCartTableHeader *header = [[HYMallCartTableHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    header.delegate = self;
    header.section = section;
    header.shopInfo = [_cartModel shopForIndex:section];
    if ((!header.shopInfo.isEdit && _navEdit)
        || (header.shopInfo.isEdit && _navEdit))
    {
       [header setEditBtnHidden:[NSNumber numberWithInt:_navEdit]];
    }


    /*
    if (_navEdit)
    {
        [header setEditBtnHidden:[NSNumber numberWithInt:_navEdit]];
    }
    else
    {
        header.edit = header.shopInfo.isEdit;
    }
     */
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMallCartProduct *good = [_cartModel productForIndexPath:indexPath];
    return [HYMallCartCell heightForGoods:good withWidth:self.view.frame.size.width];
}

#pragma mark - cell delegate
- (void)cartCellDidClickDeleteButton:(HYMallCartCell *)cell
{
    HYAlertView *alert = [HYAlertView instanceView];
    
    WS(weakSelf);
    alert.secondBlock = ^{
        [weakSelf dropProduct:@[cell.product.productSKUId]];
    };
    [alert show];
}

- (void)cartCellDidClickCheckButton:(HYMallCartCell *)cell
{
    BOOL select = [[_cartModel productForIndexPath:cell.indexPath] isSelect];
    [_cartModel setGoodsAtPath:cell.indexPath isSelect:!select];
    [self.tableView reloadData];
    [self updatePriceInfo];
    //计算省价
    [self getSpareInfos];
}

- (void)cartCell:(HYMallCartCell *)cell didEditQuantity:(NSInteger)quantity
{
    if (!_loading)
    {
        if (quantity < 1)
        {
            
        }
        else
        {
            [self updateProduct:cell.product buyQuantity:quantity];
        }
    }
}

- (void)cartCellDidClickEditButton:(HYMallCartCell *)cell
{
    if (!_skuSelectView)
    {
        _skuSelectView = [[HYProductSKUSelectView alloc] initWithFrame:CGRectZero
                                                              showDone:YES];
        _skuSelectView.delegate = self;
    }
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_cartService getProductDetailCartProduct:cell.product callback:^(HYMallGoodsDetail *detail, NSString *err)
    {
        if (detail)
        {
            [detail setCurrentSKUWithSKUId:cell.product.productSKUId];
            detail.currentsSUK.quantity = cell.product.quantity.integerValue;
            b_self.skuSelectView.goodsDetail = detail;
            [b_self.skuSelectView showWithAnimation:YES];
            _editProduct = cell.product;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    
}

#pragma mark - Header delegate
- (void)cartHeaderDidClickCheckButton:(HYMallCartTableHeader *)header
{
    [_cartModel setShopAtIndex:header.section isSelect:!header.shopInfo.isSelect];
    [self.tableView reloadData];
    [self updatePriceInfo];
    //计算省价
    [self getSpareInfos];
}

- (void)cartHeaderDidClickEditButton:(HYMallCartTableHeader *)header
{
    NSInteger section = header.section;
    BOOL edit = header.shopInfo.isEdit;
    header.shopInfo.isEdit = !edit;
    for (int i = 0; i < [_cartModel rowForStoreAtIndex:section]; i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:section];
        HYMallCartCell *cell = (HYMallCartCell *)[self.tableView cellForRowAtIndexPath:path];
        if (cell)
        {
            [cell setEdit:!edit animated:YES];
        }
    }
//    [self.tableView reloadData];
}
#pragma mark - Footer delegate
- (void)footerViewDidClickCheckButton:(BOOL)check
{
    //底部-全选
    [MobClick event:@"v430_shangcheng_gouwuche_dibu_quanxuan_jishu"];
    
    [_cartModel setAllProductIsSelect:check];
    [self.tableView reloadData];
    
    [self updatePriceInfo];
    //计算省价
    [self getSpareInfos];
}

- (void)footerViewDidClickBuyButton
{
    //取出选中的商品
    NSArray *selected = [_cartModel getSelectedShopListToOrder];
    
    //底部-去结算
    NSMutableArray *productIDArr = [NSMutableArray array];
    NSArray *goodsArr = nil;
    for (NSInteger i = 0; i < selected.count; i++)
    {
        HYMallCartShopInfo *model = selected[i];
        goodsArr = model.goods;
        for (NSInteger j = 0; j < goodsArr.count; j++)
        {
            HYMallCartProduct *model = goodsArr[j];
            [productIDArr addObject:model.productId];
        }
    }
    NSDictionary *dict = @{@"ProudctID":productIDArr};
    [MobClick event:@"v430_shangcheng_gouwuche_dibu_qujiesuan_jishu" attributes:dict];
    
    //检查库存
    WS(weakSelf);
    [_cartService checkBatchProducts:goodsArr callback:^(BOOL succ, NSString *message, NSArray *list) {
        //有库存不足的
        if (list.count > 0)
        {
            for (HYProductStockCheck *stockCheck in list)
            {
                HYMallCartProduct *find = [weakSelf.cartModel findProductAccordingToProductCode:stockCheck.productSKUCode];
                find.isOverStock = stockCheck.stock;
                if (stockCheck.stock == 0) {
                    find.quantity = @"0";
                    find.isSelect = NO;
                }
            }
            [weakSelf.cartModel updateCartCheckStatus];
            [weakSelf getSpareInfos];
            [weakSelf.tableView reloadData];
        }
        else
        {
            if ([selected count] > 0)
            {
                HYMallFullOrderViewController *vc = [[HYMallFullOrderViewController alloc] init];
                vc.storeList = selected;
                vc.amountAfterSpare = self.cartModel.amountAfterSpare;
                vc.pointAfterSpare = self.cartModel.pointAfterSpare;
                vc.spareAmount = self.cartModel.spareAmount;
                if (self.baseViewController)
                {
                    [weakSelf.baseViewController setTabbarShow:NO];
                }
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请选择要结算的商品"
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        }
        
    }];
    
    

}

#pragma mark - skuselect delegate

//如果判断skuid相同，则只编辑数量
//如果不同，则编辑sku
- (void)didFinishedSelectSKUToAddShoppingCar:(BOOL)addCar
{
    if (!_loading)
    {
        if ([self.skuSelectView.goodsDetail.currentsSUK.productSKUId
             isEqualToString:_editProduct.productSKUId])
        {
            [self updateProduct:_editProduct buyQuantity:self.skuSelectView.goodsDetail.currentsSUK.quantity];
        }
        else
        {
            _loading = YES;
            [HYLoadHubView show];
            __weak typeof(self) b_self = self;
            [_cartService updateProduct:_editProduct
                           withQuantity:self.skuSelectView.goodsDetail.currentsSUK.quantity
                                 newSKU:self.skuSelectView.goodsDetail.currentsSUK.productSKUId
                               callback:^(BOOL succ, NSString *error)
             {
                 b_self.loading = NO;
                 [HYLoadHubView dismiss];
                 [b_self reloadCart];
             }];
        }
    }
}

- (void)quantityChange:(NSUInteger)qunatity callBack:(void(^)(BOOL finished))callBack
{
    if (!_loading)
    {
        _loading = YES;
        [HYLoadHubView show];
        __weak typeof(self) b_self = self;
        [_cartService getPromotionInfoWithSKU:self.skuSelectView.goodsDetail.currentsSUK.productSKUId
                                     quantity:qunatity
                                     callback:^(HYProductSpareAmount *spare)
         {
             b_self.loading = NO;
             [HYLoadHubView dismiss];
             if (spare)
             {
                 b_self.skuSelectView.goodsDetail.currentsSUK.quantity = qunatity;
                 b_self.skuSelectView.goodsDetail.currentsSUK.totalPoint = spare.totalPoints;
                 b_self.skuSelectView.goodsDetail.currentsSUK.totalPrice = spare.totalAmount;
                 [b_self.skuSelectView updatePriceInfo];
                 callBack(YES);
             }
         }];
    }
}

#pragma mark - nullview
- (HYNullView *)nullView
{
    if (!_nullView)
    {
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        HYNullView *v = [[HYNullView alloc] initWithFrame:rect];
        v.descInfo = @"购物车中没有添加任何商品";
        v.hidden = YES;
        [self.view addSubview:v];
        _nullView = v;
        _nullView.needTouch = YES;
        [self nullViewAddButton];
    }
    return _nullView;
}

- (void)nullViewAddButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = TFRectMake(110, 280, 100, 40);
    [btn setTitle:@"去逛逛" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[[UIImage imageNamed:@"mall_afterSaleType"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:TFScalePoint(13)];
    [_nullView addSubview:btn];
}

#pragma mark HYMallNullView delegate
- (void)goToHome
{
    HYMineInfoViewController *vc = (HYMineInfoViewController*)self.navigationController.viewControllers[0];
    [vc.baseViewController setCurrentSelectIndex:0];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
