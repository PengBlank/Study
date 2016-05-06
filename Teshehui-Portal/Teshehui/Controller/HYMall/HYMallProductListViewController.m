//
//  HYMallProductLIstViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallProductListViewController.h"

#import "HYMallCartViewController.h"
#import "HYMallProductManager.h"
#import "HYMallSearchGoodResponse.h"
#import "HYLoadHubView.h"
#import "UMSocial.h"
#import "HYTableViewFooterView.h"
#import "HYNullView.h"
#import "HYProductSortView.h"
#import "HYProductDetailViewController.h"
#import "HYProductFilterViewController.h"
#import "UIColor+hexColor.h"
#import "HYProductFilterDataManeger.h"
#import "HYTheMoreTheCheaperViewController.h"
#import "HYMallProductListRowCell.h"
#import "HYMediaPlayViewController.h"
#import "HYUserInfo.h"
#import "HYAnalyticsManager.h"

#import "HYMallProductListTableViewHeaderView.h"
#import "HYMallBrandStory.h"
#import "UINavigationBar+Awesome.h"

@interface HYMallProductListViewController ()
<
HYProductSortViewDelegate,
HYProductFilterViewControllerDelegate,
UMSocialUIDelegate,
HYMallProductListTableViewHeaderViewDelegate
>
{
    BOOL _isLoading;
    BOOL _hasMore;
//    NSInteger _pageNumber;
    
    HYProductSortView *_sortView;
    
    UIButton *_shaiXuanBtn;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *sheng;
@property (nonatomic, strong) HYProductFilterViewController *filterViewController;
@property (nonatomic, strong) HYMallProductManager *productManager;
@property (nonatomic, strong) HYMallBrandStory *brandBo;
@property (nonatomic, strong) NSMutableArray *productList;

@property (nonatomic, strong) HYMallProductListTableViewHeaderView *headerContentView;
@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, strong) HYProductFilterDataManeger *filterData;

@property (nonatomic, copy) NSString *orderby;
@property (nonatomic, copy) NSString *order;

@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, assign) BOOL hasBrandStory;
@property (nonatomic, assign) BOOL showBanner;

@end

@implementation HYMallProductListViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [self.getSearchDataReq cancel];
    self.getSearchDataReq = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _pageNumber = 1;
        _hasMore = NO;
        _isShare = NO;
        _showBanner = YES;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    frame.origin.y += 64;
    frame.size.height = self.view.frame.size.height - 64;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionFooterHeight = 10;
    tableview.backgroundColor = [UIColor colorWithWhite:.96 alpha:1.0];
    tableview.backgroundView = nil;
    
    switch (self.style)
    {
        case ProductListStyleFlush:
            [tableview registerClass:[HYMallProductListCell class] forCellReuseIdentifier:@"cell"];
            break;
        case ProductListStyleRowCell:
            [tableview registerClass:[HYMallProductListRowCell class] forCellReuseIdentifier:@"cell"];
            break;
        default:
            break;
    }
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar lt_setAlpha:0];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self reloadData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_hasBrandStory)
    {
        [self updateNavgationbarAlpha];
    }

    //加载更多
    float scrollOffset = scrollView.contentOffset.y;
    float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (scrollOffset >= maximumOffset && !_isLoading && _hasMore)
    {
        [self reloadMoreData];
    }
}

#pragma mark HYMallProductListTableViewHeaderViewDelegate
-(void)contentHeightHasChange
{
    UIView *container = _tableView.tableHeaderView;
    CGRect old = container.frame;
    old.size.height = self.headerContentView.contentHeight-64;
    container.frame = old;
    
    _tableView.tableHeaderView = container;
    [_tableView reloadData];
}

#pragma mark private methods
- (void)layoutViewWithBrandInfo
{
    UIView *headerContainer = [[UIView alloc]init];
    
    if (!self.headerContentView)
    {
        self.headerContentView = [HYMallProductListTableViewHeaderView instanceView];
        self.headerContentView.delegate = self;
    }
    
    [self.headerContentView setData:self.brandBo];
    self.headerContentView.frame = CGRectMake(0,
                                    -64,
                                    TFScalePoint(320),
                                    self.headerContentView.contentHeight);
    [headerContainer setFrame:CGRectMake(0,
                                         0,
                                         TFScalePoint(320),
                                         self.headerContentView.frame.size.height-64)];
    headerContainer.clipsToBounds = NO;
    [headerContainer addSubview:self.headerContentView];
    
    _tableView.tableHeaderView = headerContainer;
    _tableView.clipsToBounds = NO;
    
    [self updateNavgationbarAlpha];
//    self.navigationController.navigationBar.alpha = 0;
//    [self viewDidLayoutSubviews];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self
                action:@selector(backToBeforeController)
      forControlEvents:UIControlEventTouchDown];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"mall_NavBackBtn"]
                       forState:UIControlStateNormal];
    backBtn.frame = TFRectMake(10, 25, 20, 20);
    [self.view addSubview:backBtn];
}

- (void)backToBeforeController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateNavgationbarAlpha
{
    CGFloat alpha = self.tableView.contentOffset.y/64.0;
    [self.navigationController.navigationBar lt_setAlpha:alpha];
    self.navigationController.navigationBar.alpha = alpha;
}

- (void)bannerClick
{
    HYTheMoreTheCheaperViewController *vc = [[HYTheMoreTheCheaperViewController alloc]initWithNibName:@"HYTheMoreTheCheaperViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)closeSheng:(UIButton *)sender
{
    [_sheng removeFromSuperview];
    
    if (_sheng && self.showBanner)
    {
        self.showBanner = NO;
        self.sheng = nil;
        
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)filterProduct:(id)sender
{
    //筛选
    [MobClick event:@"v430_shangcheng_fenleishangpinliebiao_shaixuan_jishu"];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                              inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:NO];
    
    self.filterViewController.filterData = self.filterData;
    [self.filterViewController showHideSidebar];
}

- (void)didClickUpdateEvent:(id)sender
{
    [self.nullView setHidden:YES];
    [self reloadData];
}

- (void)reloadMoreData
{
    _pageNumber++;
    [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
    [self loadProductData];
}

- (void)shareProduct:(id)sender
{
    if (!_isShare)
    {
        _isShare = YES;
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;  //使用app类型的时候分享到会话无法跳转
        [UMSocialData defaultData].extConfig.title = @"我发现了一款超赞的应用《特奢汇》";
        [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.hy.teshehui&g_f=991653";
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.hy.teshehui&g_f=991653";
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:uMengAppKey
                                          shareText:kUMengShareContent
                                         shareImage:[UIImage imageNamed:@"share_icon"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,nil]
                                           delegate:self];
    }
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    _isShare = NO;
}

/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    _isShare = NO;
}

- (void)reloadData
{
    _pageNumber = 1;
    _hasMore = YES;
    self.productList = nil;
    [self loadProductData];
}

- (void)loadProductData
{
    if (!_isLoading)
    {
        _isLoading = YES;
        
        [HYLoadHubView show];
        
        if (self.getSearchDataReq)
        {
            self.getSearchDataReq.pageNo = _pageNumber;
            self.getSearchDataReq.order = self.order;
            self.getSearchDataReq.orderBy = self.orderby;
            
            __weak typeof(self) bself = self;
            [self.getSearchDataReq sendReuqest:^(id result, NSError *error) {
                
                NSArray *array = nil;
                if (!error && [result isKindOfClass:[HYMallSearchGoodResponse class]])
                {
                    HYMallSearchGoodResponse *response = (HYMallSearchGoodResponse *)result;
                    array = [response searchGoodArray];
                    
                    //因为后台返回时最后一页的category没有数据，这里非第一页的category都不做处理
                    if (bself.pageNumber == 1)
                    {
                        [bself updateNavgationBarWithData:result];
                        //同时存在品牌故事和banner才显示
                        if (response.brandBo.brandStory.length > 0
                            && response.brandBo.bannerImage.length > 0)
                        {
                            bself.brandBo = response.brandBo;
                            bself.hasBrandStory = YES;
                            [bself layoutViewWithBrandInfo];
                        }
                    }
                }
                
                [bself updateViewWithData:array error:error];
                
                //分类商品列表
                NSMutableArray *productIdArr = [NSMutableArray array];
                for (NSInteger i = 0; i < array.count; i++) {
                    HYProductListSummary *model = array[i];
                    [productIdArr addObject:model.productId];
                }
                NSString *userID = [HYUserInfo getUserInfo].userId;
                if (userID) {
                    NSDictionary *dict = @{@"ProudctID":productIdArr,@"UserID":userID};
                    [MobClick event:@"v430_shangcheng_fenleishangpinliebiao_jishu" attributes:dict];
                }
            }];
        }
        else if (self.getActiveDataReq)
        {
            self.getActiveDataReq.pageNo = _pageNumber;
            
            __weak typeof(self) bself = self;
            [self.getActiveDataReq sendReuqest:^(id result, NSError *error){
                
                NSArray *array = nil;
                
                if ([result isKindOfClass:[HYActivityGoodsResponse class]])
                {
                    array = [(HYActivityGoodsResponse *)result goodsArray];
                }
                
                [bself updateViewWithData:array
                                    error:error];
            }];
        }
        else if (self.getMoreGoodsReq)
        {
            self.getMoreGoodsReq.pageNo = _pageNumber;
            
            __weak typeof(self) bself = self;
            [self.getMoreGoodsReq sendReuqest:^(id result, NSError *error){
                
                NSArray *array = nil;
                
                if ([result isKindOfClass:[HYMallMoreGoodsResponse class]])
                {
                    array = [(HYMallMoreGoodsResponse *)result products];
                }
                
                [bself updateViewWithData:array
                                    error:error];
            }];
        }
    }
}

- (void)updateViewWithData:(NSArray *)array error:(NSError *)error
{
    _isLoading = NO;
    
    [HYLoadHubView dismiss];
    
    _hasMore = ([array count]>0);
    if (!self.productList)
    {
        self.productList = [NSMutableArray array];
    }
    
    if (_hasMore)
    {
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        [self.productList addObjectsFromArray:array];
        
        [self.tableView reloadData];
    }
    else if (self.productList.count == 0)
    {
        _hasMore = YES;
        _pageNumber = 1;
        
        [self.tableView setHidden:YES];
        [self.nullView setHidden:NO];
        
        if ([error.domain isEqualToString:@"网络请求出现异常"])
        {
            [self.nullView setNeedTouch:YES];
            self.nullView.descInfo = @"由于网络原因加载失败，请点击重新加载";
        }
        else
        {
            [self.nullView setNeedTouch:NO];
            NSString *str = error.domain;
            if ([str length] <= 0)
            {
                str = @"暂无数据，敬请期待";
            }
            self.nullView.descInfo = str;
        }
    }
    else
    {
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    }
}

- (void)updateNavgationBarWithData:(HYMallSearchGoodResponse *)result
{
    //显示推荐的时候筛选按钮和非推荐类商品列表的时候显示规则不一致，位置也不一致
    if (!self.showRecommendGoods)
    {
        //添加筛选条件
        if (!self.filterData)
        {
            self.filterData = [[HYProductFilterDataManeger alloc] init];
            self.filterData.subCategroyList = result.subCategroy;
            self.filterData.brandInfo = result.brandInfo;
            self.filterData.selectedCategory = result.curCategroy;
            self.filterData.parentCategory = result.parentCategroy;
            self.filterData.priceRangDesc = result.priceRangDesc;
        }
        else
        {
            //更新数据
            self.filterData.subCategroyList = result.subCategroy;
            self.filterData.brandInfo = result.brandInfo;
            self.filterData.selectedCategory = result.curCategroy;
            self.filterData.parentCategory = result.parentCategroy;
            self.filterData.priceRangDesc = result.priceRangDesc;
            
            if ([self.filterViewController isShow])
            {
                [self.filterViewController.menuTableView reloadData];
            }
        }
        
        if (!self->_shaiXuanBtn)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1]
                      forState:UIControlStateNormal];
            [btn setTitle:@"筛选" forState:UIControlStateNormal];
            [btn addTarget:self
                    action:@selector(filterProduct:)
          forControlEvents:UIControlEventTouchUpInside];
            
            _sortView.shaiXuanBtn = btn;
            self->_shaiXuanBtn = btn;
        }
        
        _sortView.shaiXuanBtn = self->_shaiXuanBtn;
    }
    else
    {
        if (!self.filterData)
        {
            if (result.subCategroy.count+result.brandInfo.productAttibuteArray.count > 0)
            {
                self.filterData = [[HYProductFilterDataManeger alloc] init];
                self.filterData.subCategroyList = result.subCategroy;
                self.filterData.brandInfo = result.brandInfo;
                self.filterData.selectedCategory = result.curCategroy;
                self.filterData.parentCategory = result.parentCategroy;
                self.filterData.priceRangDesc = result.priceRangDesc;
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0, 0, 80, 30);
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [btn setTitleColor:[UIColor colorWithHexColor:@"545454"
                                                        alpha:1.0]
                          forState:UIControlStateNormal];
                [btn setTitle:@"筛选" forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"i_sx"]
                     forState:UIControlStateNormal];
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
                [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
                [btn addTarget:self
                        action:@selector(filterProduct:)
              forControlEvents:UIControlEventTouchUpInside];
                
                UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
                self.navigationItem.rightBarButtonItem = shareButtonItem;
            }
            else
            {
                self.navigationItem.rightBarButtonItem = nil;
            }
        }
        else
        {
            //更新数据
            self.filterData.subCategroyList = result.subCategroy;
            self.filterData.brandInfo = result.brandInfo;
            self.filterData.selectedCategory = result.curCategroy;
            self.filterData.parentCategory = result.parentCategroy;
            self.filterData.priceRangDesc = result.priceRangDesc;
            
            if ([self.filterViewController isShow])
            {
                [self.filterViewController.menuTableView reloadData];
            }
        }
    }
}

#pragma mark - HYBuyCarViewDelegate
- (void)didCheckBuyCarList
{
    HYMallCartViewController *vc = [[HYMallCartViewController alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - HYProductSortViewDelegate
- (void)didSortWithType:(ProductSortType)sortType ascend:(BOOL)ascend
{
    switch (sortType)
    {
        case SortWithPrice:
            self.orderby = @"11";
            //排序-价格
            [MobClick event:@"v430_shangcheng_fenleishangpinliebiao_jiagepaixu_jishu"];
            break;
        case SortWithSales:
            self.orderby = @"10";
            //排序-销量
            [MobClick event:@"v430_shangcheng_fenleishangpinliebiao_xiaoliangpaixu_jishu"];
            break;
        case SortWithCreateTime:
            self.orderby = @"12";
            //排序-上架时间
            [MobClick event:@"v430_shangcheng_fenleishangpinliebiao_shangjiapaixu_jishu"];
            break;
        default:
            break;
    }
    
    if (ascend)
    {
        self.order = @"1";
    }
    else
    {
        self.order = @"0";
    }

    [self reloadData];
}

#pragma mark - HYMallProductListCellDelegate
- (void)checkProductDetail:(id)product
{
    if ([product isKindOfClass:[HYProductListSummary class]])
    {
        HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
        vc.goodsId = [(HYProductListSummary *)product productId];
        [self.navigationController pushViewController:vc
                                             animated:YES];
        
        [[HYAnalyticsManager sharedManager] continueVisitAtListWithSummary:product];
    }
    else if ([product isKindOfClass:[HYMallHomeItem class]])
    {
        HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
        vc.goodsId = [(HYMallHomeItem *)product productId];
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

#pragma mark - HYProductFilterViewControllerDelegate
- (void)didFilterSettingFinished:(HYProductFilterDataManeger *)filterData
{
    [self.filterViewController showHideSidebar];
    if (!_isLoading)
    {
        //这里需要重置掉brandids,否则会让请求参数重复,
        //这里只清空掉成员变量的brandIds,对于从首页传过的brandIds,应该不会有影响
        self.getSearchDataReq.brandIds = nil;
        if (filterData.selectedBrand.code)
        {
            self.getSearchDataReq.brandIds = @[filterData.selectedBrand.code];
        }
        else if (self.curSearchBrandId)
        {
            self.getSearchDataReq.brandIds = @[self.curSearchBrandId];
        }
        
        if (filterData.selectedCategory)
        {
            self.getSearchDataReq.categoryId = filterData.selectedCategory.cate_id;
        }
        else if (filterData.parentCategory)
        {
            self.getSearchDataReq.categoryId = filterData.parentCategory.cate_id;
        }
        
        //加入加格参数
        if (filterData.minPrice)
        {
            self.getSearchDataReq.lowPrice = filterData.minPrice;
            if (filterData.maxPrice)
            {
                self.getSearchDataReq.highPrice = filterData.maxPrice;
            }
            else
            {
                self.getSearchDataReq.highPrice = nil;
            }
        }
        else
        {
            self.getSearchDataReq.lowPrice = nil;
        }
        
        [self reloadData];
    }
}

- (void)didUpdateFilterCondition:(HYProductFilterDataManeger *)filterData
{
    if (!_isLoading)
    {
        if (filterData.selectedBrand.code)
        {
            self.getSearchDataReq.brandIds = @[filterData.selectedBrand.code];
        }
        else if (self.curSearchBrandId)
        {
            self.getSearchDataReq.brandIds = @[self.curSearchBrandId];
        }
        
        if (filterData.selectedCategory)
        {
            self.getSearchDataReq.categoryId = filterData.selectedCategory.cate_id;
        }
        else if (filterData.parentCategory)
        {
            self.getSearchDataReq.categoryId = filterData.parentCategory.cate_id;
        }
        else
        {
            //取出缓存的搜索分类
            self.getSearchDataReq.categoryId = self.curSearchCategoryId;
        }
        
        //加入加格参数
        self.getSearchDataReq.highPrice = filterData.minPrice;
        self.getSearchDataReq.lowPrice = filterData.maxPrice;
        
        [self reloadData];
    }
}

- (void)didSelectCategory:(HYMallCategoryInfo *)category
{
    if (!_isLoading)
    {
        if (category)
        {
            HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithCategoryId:category.cate_id];
            req.searchType = @"20";
            
            HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
            vc.getSearchDataReq = req;
            vc.title = category.cate_name;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *containHeaderView = [[UIView alloc]init];
    
    switch (self.style) {
        case ProductListStyleFlush:
        {
            if (!self.showRecommendGoods)
            {
                if (!_sortView)
                {
                    _sortView = [[HYProductSortView alloc] initWithFrame:TFRectMake(0, 0, 320, 34)];
                    _sortView.delegate = self;
                    _sortView.needRelayout = self.hasBrandStory;
                    _sortView.showTopLine = YES;
                    if (self->_shaiXuanBtn)
                    {
                        _sortView.shaiXuanBtn = self->_shaiXuanBtn;
                    }
                }
                
                [containHeaderView addSubview:_sortView];
                containHeaderView.frame = TFRectMake(0, 0, 320, 34);
            }
            
            if (self.showBanner)
            {
                //添加一个省的bannner
                UIView *sheng = [UIView new];
                sheng.frame = TFRectMake(0, 34*(!self.showRecommendGoods), 320, 34);
                sheng.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.97 alpha:1.0f];
                
                UILabel *banner = [UILabel new];
                banner.text = @"越买越省，同款价更低!";
                banner.textColor = [UIColor colorWithRed:0.60f green:0.0f blue:0.0f alpha:1.0f];
                banner.textAlignment = NSTextAlignmentCenter;
                banner.font = [UIFont systemFontOfSize:14];
                banner.frame = TFRectMake(60, 5, 200, 20);
                [sheng addSubview:banner];
                
                UIButton *bannerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                bannerBtn.frame = TFRectMake(0, 0, 280, 20);
                [sheng addSubview:bannerBtn];
                [bannerBtn addTarget:self action:@selector(bannerClick) forControlEvents:UIControlEventTouchDown];
                
                UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
                [close setImage:[UIImage imageNamed:@"sheng_close"] forState:UIControlStateNormal];
                [close addTarget:self action:@selector(closeSheng:) forControlEvents:UIControlEventTouchUpInside];
                close.frame = TFRectMake(280, 2, 30, 30);
                [sheng addSubview:close];
                [containHeaderView addSubview:sheng];
                self.sheng = sheng;
            }
            
            containHeaderView.frame = TFRectMake(0,
                                                 0,
                                                 320,
                                                 (34*(self.showBanner+!self.showRecommendGoods)));
        }
            break;
        case ProductListStyleRowCell:
        {
            if (self.showBanner)
            {
                //添加一个省的bannner
                UIView *sheng = [UIView new];
                sheng.frame = TFRectMake(0, 0, 320, 34);
                containHeaderView.frame = TFRectMake(0, 0, 320, 34);
                
                sheng.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.97 alpha:1.0f];
                
                UILabel *banner = [UILabel new];
                banner.text = @"越买越省，同款价更低!";
                banner.textColor = [UIColor colorWithRed:0.60f green:0.0f blue:0.0f alpha:1.0f];
                banner.textAlignment = NSTextAlignmentCenter;
                banner.font = [UIFont systemFontOfSize:14];
                banner.frame = TFRectMake(60, 5, 200, 20);
                [sheng addSubview:banner];
                
                UIButton *bannerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                bannerBtn.frame = TFRectMake(0, 0, 280, 20);
                [sheng addSubview:bannerBtn];
                [bannerBtn addTarget:self
                              action:@selector(bannerClick)
                    forControlEvents:UIControlEventTouchDown];
                
                UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
                [close setImage:[UIImage imageNamed:@"sheng_close"] forState:UIControlStateNormal];
                [close addTarget:self action:@selector(closeSheng:) forControlEvents:UIControlEventTouchUpInside];
                close.frame = TFRectMake(280, 2, 30, 30);
                [sheng addSubview:close];
                [containHeaderView addSubview:sheng];
                self.sheng = sheng;
            }
        }
            break;
        default:
            break;
    }
    return containHeaderView;

}

-(CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    if(self.style == ProductListStyleFlush)
    {
        return TFScalePoint(34*(self.showBanner+!self.showRecommendGoods));
    }
    else
    {
        return TFScalePoint(34*self.showBanner);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.style)
    {
        case ProductListStyleFlush:
            if (self.productList)
            {
                return (self.productList.count+1)/2;
            }
            break;
        case ProductListStyleRowCell:
            if (self.productList)
            {
                return self.productList.count;
            }
            break;
        default:
            return 0;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (self.style)
    {
        case ProductListStyleFlush:
            height = TFScalePoint(242.0f);
            break;
        case ProductListStyleRowCell:
            height = 96;
        default:
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mallProductListCellId = @"cell";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:mallProductListCellId];
    switch (self.style) {
        case ProductListStyleFlush:
        {
            HYMallProductListCell *listCell = (HYMallProductListCell *)cell;
            listCell.delegate = self;
            HYProductListSummary *left = nil;
            HYProductListSummary *right = nil;
            if (indexPath.row * 2 < self.productList.count)
            {
                left = [self.productList objectAtIndex:indexPath.row*2];
            }
            if (indexPath.row*2+1 < self.productList.count)
            {
                right = [self.productList objectAtIndex:indexPath.row*2+1];
            }
            [listCell setLeftItem:left rightItem:right];
        }
            break;
        case ProductListStyleRowCell:
        {
            HYMallProductListRowCell *rowCell = (HYMallProductListRowCell *)cell;
            rowCell.delegate = self;
            if (self.productList.count > indexPath.row)
            {
                rowCell.item = [self.productList objectAtIndex:indexPath.row];
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.style == ProductListStyleRowCell)
    {
        if (self.productList.count > indexPath.row)
        {
            HYProductListSummary *sum = [self.productList objectAtIndex:indexPath.row];
            [self checkProductDetail:sum];
        }
    }
}

#pragma mark setter/getter
- (HYNullView *)nullView
{
    if (!_nullView)
    {
        CGRect frame = self.view.frame;
        frame.origin = CGPointZero;
        
        _nullView = [[HYNullView alloc] initWithFrame:frame];
        _nullView.needTouch = YES;
        [_nullView addTarget:self
                      action:@selector(didClickUpdateEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        if (_filterViewController)
        {
            [self.view insertSubview:_nullView
                        belowSubview:_filterViewController.view];
        }
        else
        {
            [self.view addSubview:_nullView];
        }
        
    }
    
    return _nullView;
}

- (HYProductFilterViewController *)filterViewController
{
    if (!_filterViewController)
    {
        _filterViewController = [[HYProductFilterViewController alloc] init];
        _filterViewController.bgColor = [UIColor blackColor];
        _filterViewController.delegate = self;
        _filterViewController.layoutOffset = YES;
        [self.view addSubview:_filterViewController.view];
    }
    
    return _filterViewController;
}

- (void)checkVideoWithURL:(NSString *)url
{
    if (url) {
        NSURL *urlS = [NSURL URLWithString:url];
        HYMediaPlayViewController *vc = [[HYMediaPlayViewController alloc] initWithContentURL:urlS];
        //    vc.mediaUrl = url;
        [self presentMoviePlayerViewControllerAnimated:vc];
    }
}

//- (void)sideDidShow
//{
//    if ([self.navigationController isKindOfClass:[HYNavigationController class]]) {
//        HYNavigationController *nav = (HYNavigationController *)self.navigationController;
//        nav.canDragBack = NO;
//    }
//}
//
//- (void)sideDidHide
//{
//    if ([self.navigationController isKindOfClass:[HYNavigationController class]]) {
//        HYNavigationController *nav = (HYNavigationController *)self.navigationController;
//        nav.canDragBack = YES;
//    }
//}

@end
