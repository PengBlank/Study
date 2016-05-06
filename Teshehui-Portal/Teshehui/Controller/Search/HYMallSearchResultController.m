//
//  HYMallSearchResultController.m
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallSearchResultController.h"
#import "HYTheMoreTheCheaperViewController.h"
#import "HYMallSearchField.h"

#import "HYMallProductListCell.h"
#import "HYProductFilterViewController.h"
#import "HYNullView.h"
#import "HYMallSearchResultHeaderView.h"
#import "HYTabbarViewController.h"
#import "HYTableViewFooterView.h"
#import "HYMallMoreGoodsRequest.h"
#import "HYSearchSuggestRequest.h"
#import "HYSearchSuggestController.h"
#import "HYProductDetailViewController.h"
#import "HYSearchHistoryStore.h"
#import "HYMallSearchGoodsRequest.h"
#import "HYMallSearchGoodResponse.h"
#import "HYMallHomeItem.h"
#import "HYProductFilterDataManeger.h"
#import "HYKeyboardHandler.h"
#import "HYProductSortView.h"
#import "HYAnalyticsManager.h"
#import "HYUserInfo.h"
#import "HYMakeWishPoolViewController.h"
#import "HYAppDelegate.h"
#import "HYMallSearchView.h"

@interface HYMallSearchResultController ()
<UITableViewDataSource,
UITableViewDelegate,
HYMallProductListCellDelegate,
HYProductFilterViewControllerDelegate,
HYMallSearchResultHeaderViewDelegate,
HYMallProductListCellDelegate,
HYSearchSuggestDelegate,
HYKeyboardHandlerDelegate,
HYProductSortViewDelegate,
HYMallSearchViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, strong) HYMallSearchResultHeaderView *headView;
@property (nonatomic, strong) UIBarButtonItem *filtItem;
@property (nonatomic, strong) HYMallSearchGoodsRequest *request;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL willCorrect;     //会纠错
@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, strong) NSMutableArray *goodsList;

//筛选
@property (nonatomic, strong) HYProductFilterViewController *filterViewController;
@property (nonatomic, strong) HYProductFilterDataManeger *filterData;

//更多
@property (nonatomic, assign) BOOL isSearchMore;    //是否显示更多精品
@property (nonatomic, strong) HYMallMoreGoodsRequest *moreRequest;

//联想
//点击搜索框时进入搜索功能
@property (nonatomic, strong) HYSearchSuggestRequest *suggestRequest;
@property (nonatomic, strong) HYSearchSuggestController *suggestController;
@property (nonatomic, strong) HYKeyboardHandler *handler;   //键盘事件监听
@property (nonatomic, assign) BOOL isSearching; //标志现在是否在搜索状态下

/**
 *  排序功能
 */
@property (nonatomic, strong) HYProductSortView *sortView;
@property (nonatomic, copy) NSString *orderby;
@property (nonatomic, copy) NSString *order;

//省banner
@property (nonatomic, strong) UIView *sheng;


@property (nonatomic, strong) HYMallSearchView *searchView;


@end

@implementation HYMallSearchResultController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _isLoading = NO;
        _hasMore = YES;
        _willCorrect = YES;
        _pageNumber = 1;
        _isSearchMore = NO;
        _isSearching = NO;
        self.goodsList = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [_request cancel];
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect frame = ScreenRect;
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
                                           alpha:1.0];
    
    
    _sortView = [[HYProductSortView alloc] initWithFrame:TFRectMake(0, 0, 320, 34)];
    _sortView.delegate = self;
    [self.view addSubview:_sortView];
    
    //添加一个省的bannner
    UIView *sheng = [UIView new];
    sheng.frame = TFRectMake(0, 34, 320, 34);
    sheng.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.97 alpha:1.0f];
    
    UILabel *banner = [UILabel new];
    banner.text = @"越买越省，同款价更低!";
    banner.textColor = [UIColor colorWithRed:0.60f green:0.0f blue:0.0f alpha:1.0f];
    banner.textAlignment = NSTextAlignmentCenter;
    banner.font = [UIFont systemFontOfSize:14];
    banner.frame = TFRectMake(60, 6, 200, 20);
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
    [self.view addSubview:sheng];
    self.sheng = sheng;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:
                              CGRectMake(0, TFScalePoint(68), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-TFScalePoint(34.0))
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 48)];
    tableView.tableFooterView = v;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    HYMallSearchResultHeaderView *headView = [[HYMallSearchResultHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0)];
    headView.delegate = self;
    self.headView = headView;
    
    self.navigationItem.titleView = [self searchView];
//    self.searchField = (UITextField *)self.navigationItem.titleView;
//    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _searchField.returnKeyType = UIReturnKeySearch;
//    _searchField.text = self.searchKey;
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:238/255.0 blue:243/255.0 alpha:1];
    
    [self loadSearchData];
    
    //添加联想
    self.suggestController = [[HYSearchSuggestController alloc] initWithNibName:@"HYSearchSuggestController" bundle:nil];
    [self.view addSubview:_suggestController.view];
    _suggestController.delegate = self;
    _suggestController.view.hidden = YES;
    
    self.handler = [[HYKeyboardHandler alloc] initWithDelegate:self view:self.view];
    _handler.tapToDismiss = NO;
}

//- (UIView*)searchView
//{
//    UITextField *search = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-80, 30)];
//    search.layer.borderWidth = 0.5;
//    search.layer.borderColor = [UIColor colorWithWhite:.83 alpha:0.6].CGColor;
//    search.layer.cornerRadius = 4.0;
//    search.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
//    UIImage *img = [UIImage imageNamed:@"i_search"];
//    UIImageView *searchv = [[UIImageView alloc] initWithImage:img];
//    searchv.contentMode = UIViewContentModeCenter;
//    searchv.frame = CGRectMake(0, 0, 30, 30);
//    search.leftView = searchv;
//    search.leftViewMode = UITextFieldViewModeAlways;
//    [search addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
//    [search addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
//    [search addTarget:self action:@selector(textFieldBeginEdit:) forControlEvents:UIControlEventEditingDidBegin];
//    [search addTarget:self action:@selector(textFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
//    search.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    return search;
//}
- (HYMallSearchView *)searchView
{
    if (!_searchView)
    {
        _searchView = [[HYMallSearchView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, 30)];
        _searchView.search.placeholder = self.searchKeyWord;
        _searchView.search.text = self.searchKey;
        _searchView.delegate = self;
    }
    [_searchView.search resignFirstResponder];
    return _searchView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_handler startListen];
    _suggestController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-216);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_handler stopListen];
}

#pragma mark private methods

- (void)backToRootViewController:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//筛选按钮事件
- (void)filtBtnAction:(UIButton *)btn
{
    [_searchField resignFirstResponder];
    
    //筛选
    [MobClick event:@"v430_shangcheng_sousuoshangpinliebiao_shaixuan_jishu"];
    
    self.filterViewController.filterData = self.filterData;
    [self.filterViewController.menuTableView reloadData];
    [self.filterViewController showHideSidebar];
}

//搜索统一入口点
- (void)searchWithKey:(NSString *)key
{
    [[HYSearchHistoryStore sharedStore] addSearchRecord:key];
    
    self.searchKey = key;
    self.filterData = nil;
    self.willCorrect = YES;
    self.isSearchMore = NO;
    [self reloadData];
}

//刷新搜索数据，不改变搜索条件
- (void)reloadData
{
    _pageNumber = 1;
    _hasMore = YES;
    [_goodsList removeAllObjects];
    [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self loadSearchData];
}

- (void)loadSearchData
{
    if (!_isLoading)
    {
        [HYLoadHubView show];
        _request = [[HYMallSearchGoodsRequest alloc] init];
        _request.keyword = _searchKey;
        _request.searchType = @"10";
        
        if (_filterData.selectedCategory.cate_id)
        {
            _request.categoryId = _filterData.selectedCategory.cate_id;
        }
        else if (_filterData.parentCategory.cate_id)
        {
            _request.categoryId = _filterData.parentCategory.cate_id;
        }
        
        if (_filterData.selectedBrand)
        {
            _request.brandIds = @[_filterData.selectedBrand.code];
        }
        
        _request.lowPrice = _filterData.minPrice;
        _request.highPrice = _filterData.maxPrice;
        
        _request.pageNo = _pageNumber;
        _request.keywordParseType = _willCorrect ? @"1" : @"0";
        _request.order = self.order;
        _request.orderBy = self.orderby;
        __weak typeof(self) b_self = self;
        _isLoading = YES;
        [_request sendReuqest:^(HYMallSearchGoodResponse* result, NSError *error)
         {
             [b_self updateViewWithData:result];
         }];
    }
}

- (void)updateViewWithData:(HYMallSearchGoodResponse *)result
{
    //统计
    HYAnalyticsManager *ay = [[HYAnalyticsManager alloc] init];
    [ay searchEventWith:self.searchKey
                 result:([result.searchGoodArray count]>0)];
    
    _isLoading = NO;
    
    [HYLoadHubView dismiss];
    [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    
    _hasMore = ([result.searchGoodArray count]>0);
    
    //添加筛选条件
    if (!self.filterData)
    {
        if (result.subCategroy.count+result.brandInfo.productAttibuteArray.count > 0)
        {
            self.filterData = [[HYProductFilterDataManeger alloc] init];
            self.filterData.subCategroyList = result.subCategroy;
            self.filterData.brandInfo = result.brandInfo;
            self.filterData.selectedCategory = result.curCategroy;
            self.filterData.parentCategory = result.parentCategroy;
            
            self.navigationItem.rightBarButtonItem = self.filtItem;
        }
        else
        {
            self.navigationItem.rightBarButtonItem = [self emptyRightItem];
        }
    }
    else
    {
        //更新数据
        self.filterData.subCategroyList = result.subCategroy;
        self.filterData.brandInfo = result.brandInfo;
        self.filterData.selectedCategory = result.curCategroy;
        self.filterData.parentCategory = result.parentCategroy;
        
        if ([self.filterViewController isShow])
        {
            [self.filterViewController.menuTableView reloadData];
        }
    }
    
    if (_hasMore)
    {
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        [self setSortViewHidden:NO];
        
        [self.goodsList addObjectsFromArray:result.searchGoodArray];
        _hasMore = self.goodsList.count < result.totalCount;
        
        //在顶部显示搜索条件
        //显示搜索条件需要放在网络操作回调中，避免出现还没有加载完就显示分类标识的情况
        [self showSearchConditionInHeadview];
        
        
        //搜索商品列表
        NSString *userID = [HYUserInfo getUserInfo].userId;
        NSMutableArray *ProudctIDArr = [NSMutableArray array];
        for (NSInteger i = 0; i < self.goodsList.count; i++) {
            HYProductListSummary *model = self.goodsList[i];
            [ProudctIDArr addObject:model.productId];
        }
        if (userID) {
            NSDictionary *dict = @{@"ProudctID":ProudctIDArr, @"UserID":userID};
            [MobClick event:@"v430_shangcheng_sousuoshangpinliebiao_jishu" attributes:dict];
        }
        
        
        [self.tableView reloadData];
    }
    else if (self.goodsList.count == 0)
    {
        _hasMore = YES;
        _pageNumber = 1;
        
        if (!result)
        {
            [self.tableView setHidden:YES];
            [self.nullView setHidden:NO];
            [self.nullView setNeedTouch:YES];
            self.nullView.descInfo = @"由于网络原因加载失败，请点击重新加载";
        }
        else
        {
            _nullView.hidden = YES;
            [self setSortViewHidden:YES];
            [self.headView setNull];
            _pageNumber = 1;
            [self loadMoreGoods];
        }
        [self.tableView reloadData];
    }
    else
    {
        [self setSortViewHidden:NO];
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
    }
}

/**
 *  在顶部显示搜索条件
 */
- (void)showSearchConditionInHeadview
{
    //显示搜索条件需要放在网络操作回调中，避免出现还没有加载完就显示分类标识的情况
//    NSArray *conditions = [self.filterData conditionsDisplay];
//    if (conditions.count > 0)
//    {
//        [_headView setConditions:conditions];
//    }
//    else
//    {
//        [_headView setHide];
//    }
    
    [_headView setHide];
}

- (void)loadMoreGoods
{
    self.pageNumber = 1;
    [self.headView setNull];
    _isSearchMore = YES;
    [_goodsList removeAllObjects];
    [self loadMoredGoodsDatas];
}

- (void)loadMoredGoodsDatas
{
    if (!_isLoading)
    {
        _isLoading = YES;
        [HYLoadHubView show];
        _moreRequest = [[HYMallMoreGoodsRequest alloc] init];
        _moreRequest.pageNo = _pageNumber;
        [_moreRequest sendReuqest:^(HYMallMoreGoodsResponse* result, NSError *error)
        {
            [self updateWithMoreResponse:result];
        }];
    }
}

- (void)updateWithMoreResponse:(HYMallMoreGoodsResponse *)result
{
    _isLoading = NO;
    
    [HYLoadHubView dismiss];
    
    _hasMore = ([result.products count]>0);
    
    if (_hasMore)
    {
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        [self.goodsList addObjectsFromArray:result.products];
        
        [self.tableView reloadData];
    }
    else if (self.goodsList.count == 0)
    {
        _hasMore = YES;
        _pageNumber = 1;
        
        if (!result)
        {
            [self.tableView setHidden:YES];
            [self.nullView setHidden:NO];
            [self.nullView setNeedTouch:YES];
            self.nullView.descInfo = @"由于网络原因加载失败，请点击重新加载";
        }
        else
        {
            [self.tableView setHidden:YES];
            [self.nullView setHidden:NO];
            [self.nullView setNeedTouch:NO];
            self.nullView.descInfo = @"暂无数据，敬请期待";
        }
    }
    else
    {
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _goodsList.count == 0 ? 0 : (_goodsList.count - 1) / 2 + 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mallProductListCellId = @"mallProductListCellId";
    HYMallProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:mallProductListCellId];
    if (cell == nil)
    {
        cell = [[HYMallProductListCell alloc]initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:mallProductListCellId];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorLeftInset = 0;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    HYProductListSummary *litem = nil;
    if (_goodsList.count > indexPath.row*2)
    {
        litem = [_goodsList objectAtIndex:indexPath.row*2];
    }
    HYProductListSummary *ritem = nil;
    if (_goodsList.count > indexPath.row*2 + 1)
    {
        ritem = [_goodsList objectAtIndex:indexPath.row*2 + 1];
    }
    
    [cell setLeftItem:litem rightItem:ritem];
    
    return cell;
    //test
    //return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = TFScalePoint(242.0f);
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _headView.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headView;
}

#pragma mark - scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.searchField resignFirstResponder];
    [_searchView.search resignFirstResponder];
    //[self.view endEditing:YES];
    
    //加载更多
    float scrollOffset = scrollView.contentOffset.y;
    float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (scrollOffset >= maximumOffset && maximumOffset > 0)
    {
        if (_hasMore && !_isLoading)
        {
            _pageNumber++;
            [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
            if (_isSearchMore) {
                [self loadMoredGoodsDatas];
            }
            else
            {
                [self loadSearchData];
            }
        }
    }
}

#pragma mark - HYMallProductListCellDelegate
- (void)checkProductDetail:(id)product
{
    if ([product isKindOfClass:[HYProductListSummary class]])
    {
        HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
        vc.goodsId = [product productId];
        [self.navigationController pushViewController:vc
                                             animated:YES];
        
        /// 搜索结果进详情页，插码
        [[HYAnalyticsManager sharedManager] beginDetailVisitFromSearch:product
                                                               withKey:self.searchKey];
    }
    else if ([product isKindOfClass:[HYMallHomeItem class]])
    {
        HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
        vc.goodsId = [product productId];
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

#pragma mark - HYProductFilterViewControllerDelegate
- (void)didFilterSettingFinished:(HYProductFilterDataManeger *)filterData
{
    [self.filterViewController showHideSidebar];
    [self reloadData];
}

- (void)didUpdateFilterCondition:(HYProductFilterDataManeger *)filterData
{
    [self reloadData];
}

#pragma mark - HYProductSortView
- (void)setSortViewHidden:(BOOL)hidden
{
    if (hidden)
    {
        _sortView.hidden = YES;
        if (self.sheng)
        {
            self.sheng.frame = CGRectMake(0, 0, self.view.frame.size.width, TFScalePoint(34));
        }
        self.tableView.frame = CGRectMake(0,
                                          CGRectGetMaxY(_sheng.frame),
                                          CGRectGetWidth(self.view.frame),
                                          CGRectGetHeight(self.view.frame)-CGRectGetHeight(_sheng.frame));
    }
    else
    {
        _sortView.hidden = NO;
        if (self.sheng)
        {
            self.sheng.frame = CGRectMake(0, TFScalePoint(34), self.view.frame.size.width, TFScalePoint(34));
            self.tableView.frame = CGRectMake(0,
                                              CGRectGetMaxY(_sheng.frame),
                                              CGRectGetWidth(self.view.frame),
                                              CGRectGetHeight(self.view.frame)-CGRectGetHeight(_sheng.frame)*2);
        }
        else
        {
            self.tableView.frame = CGRectMake(0,
                                              CGRectGetMaxY(_sortView.frame),
                                              CGRectGetWidth(self.view.frame),
                                              CGRectGetHeight(self.view.frame)-CGRectGetHeight(_sheng.frame)*2);
        }
        
    }
}

- (void)didSortWithType:(ProductSortType)sortType ascend:(BOOL)ascend
{
    switch (sortType)
    {
        case SortWithPrice:
            self.orderby = @"11";
            //排序-价格
            [MobClick event:@"v430_shangcheng_sousuoshangpinliebiao_jiagepaixu_jishu"];
            break;
        case SortWithSales:
            self.orderby = @"10";
            //排序-销量
            [MobClick event:@"v430_shangcheng_sousuoshangpinliebiao_xiaoliangpaixu_jishu"];
            break;
        case SortWithCreateTime:
            self.orderby = @"12";
            //排序-上架时间
            [MobClick event:@"v430_shangcheng_sousuoshangpinliebiao_shangjiapaixu_jishu"];
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
        [self.view addSubview:_nullView];
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
        [self.view addSubview:_filterViewController.view];
    }
    
    return _filterViewController;
}

- (UIBarButtonItem *)filtItem
{
    if (!_filtItem) {
        UIButton *filtBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
        [filtBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [filtBtn setTitleColor:[UIColor colorWithWhite:.2 alpha:1]
                      forState:UIControlStateNormal];
        filtBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [filtBtn addTarget:self
                    action:@selector(filtBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:filtBtn];
        //self.navigationItem.rightBarButtonItem = item;
        _filtItem = item;
    }
    return _filtItem;
}

- (UIBarButtonItem *)emptyRightItem
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIBarButtonItem *empty = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return empty;
}

#pragma mark - head view delegate

//清除搜索分类
- (void)clearConditionAtIndex:(NSInteger)idx
{
    [_filterData clearConditionAtIndex:idx];
    [self reloadData];
}

//纠错，在返回提示可以纠错的时候点
- (void)reloadWithCorrect
{
    self.willCorrect = NO;
    [self reloadData];
}

// 搜索到没有该商品，去许愿
- (void)goToMakeWish
{
    NSString *useId = [HYUserInfo getUserInfo].userId;
    if (useId)
    {
        HYMakeWishPoolViewController *makeWishVC = [[HYMakeWishPoolViewController alloc] init];
        makeWishVC.goodsName = self.searchKey;
        [self.navigationController pushViewController:makeWishVC animated:YES];
    }
    else
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
}

#pragma mark - 联想
//- (void)textFieldEndEdit:(UITextField *)text
//{
//    self.suggestController.view.hidden = YES;
//    _isSearching = NO;
//}

- (void)hiddenSuggestview
{
    self.suggestController.view.hidden = YES;
    _isSearching = NO;
}

//- (void)textFieldReturn:(UITextField *)text
//{
//    [text resignFirstResponder];
//    
//    NSString *key = text.text;
//    key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (key.length > 0)
//    {
//        [self searchWithKey:key];
//    }
//}

//- (void)textFieldBeginEdit:(UITextField *)field
//{
//    //_suggestController.view.hidden = NO;
//    if ([self.filterViewController isShow]) {
//        [self.filterViewController showHideSidebar];
//    }
//    _isSearching = YES;
//}
- (void)filterViewControllerIsShow
{
    //_suggestController.view.hidden = NO;
    if ([self.filterViewController isShow]) {
        [self.filterViewController showHideSidebar];
    }
    _isSearching = YES;
}

//- (IBAction)textFieldValueChanged:(UITextField *)field
//{
//    NSString *result = field.text;
//    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (result.length > 0)
//    {
//        if (_isSearching)
//        {
//            _suggestController.view.hidden = NO;
//            [self getSuggestWithString:result];
//        }
//    }
//    else
//    {
//        _suggestController.view.hidden = YES;
//        _suggestController.suggests = nil;
//    }
//}
- (void)getSuggestWithString:(NSString *)str
{
    if (_isSearching)
    {
        _suggestController.view.hidden = NO;
        
        if (_suggestRequest) {
            [_suggestRequest cancel];
            _suggestRequest = nil;
        }
        _suggestRequest = [[HYSearchSuggestRequest alloc] init];
        _suggestRequest.key = str;
        _suggestRequest.businessType = @"01";
        __weak typeof(self) b_self = self;
        [_suggestRequest sendReuqest:^(HYSearchSuggestResponse* result, NSError *error)
         {
             if (result && result.status == 200)
             {
                 b_self.suggestController.suggests = result.result;
             }
         }];
    }
}

- (void)hiddenSuggestController
{
    _suggestController.view.hidden = YES;
    _suggestController.suggests = nil;
}

- (void)suggestControllerDidSelectItem:(HYSearchSuggestItem *)item
{
    _isSearching = NO;
    [self.searchField resignFirstResponder];
    self.searchField.text = item.display;
    [self searchWithKey:item.display];
}

#pragma mark - private methods

//- (void)searchBtnAction:(UIButton *)btn
//{
////    UITextField *textField = (UITextField *)self.navigationItem.titleView;
//    UITextField *textField = _searchView.search;
//    [textField resignFirstResponder];
//    NSString *key = textField.text;
//    key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (key.length > 0)
//    {
//        [self searchWithKey:key];
//    }
//}

- (void)didClickUpdateEvent:(id)sender
{
    [self.nullView setHidden:YES];
    [self reloadData];
}

- (void)bannerClick
{
    HYTheMoreTheCheaperViewController *vc = [[HYTheMoreTheCheaperViewController alloc]initWithNibName:@"HYTheMoreTheCheaperViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)closeSheng:(UIButton *)sender
{
    [_sheng removeFromSuperview];
    
    if (_sheng)
    {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:.5f animations:^{
            CGRect frame = _tableView.frame;
            frame.origin.y -= TFScalePoint(34);
            frame.size.height += TFScalePoint(34);
            _tableView.frame = frame;
        }
        completion:^(BOOL finished){
            weakSelf.sheng = nil;
                         }];
    }
}

#pragma mark - 
- (void)keyboardChangeFrame:(CGRect)kFrame
{
    _suggestController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kFrame.size.height);
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
