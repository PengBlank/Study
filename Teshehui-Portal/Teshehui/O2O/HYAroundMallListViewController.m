//
//  HYAroundMallListViewController.m
//  Teshehui
//
//  Created by HYZB on 14-7-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAroundMallListViewController.h"
#import "HYAllCategoryView.h"
#import "HYAllCategoryViewDataSource.h"
#import "HYHotelPriceConditionView.h"
#import "HYAroundShopListCell.h"
#import "HYAppDelegate.h"
#import "UIImage+Addition.h"

#import "HYQRCodeGetCityListRequest.h"
#import "HYQRCodeGetShopListRequest.h"
#import "HYQRCodeGetShopCategoryRequest.h"
#import "HYQRCodeEncoderViewController.h"

#import "HYAroundMallListView.h"
#import "HYNullView.h"

//city
#import "HYAroundCitySelectViewController.h"
#import "HYAroundMallListTableDataSource.h"

//detail
#import "HYAroundMallDetailViewController.h"

//locate
#import "HYLocationManager.h"

#import "HYMerchantCategoryCell.h"
#import "HYO2OFilterView.h"

typedef enum {
    FromAround = 0,
    FromCity
} MallListType;


@interface HYAroundMallListViewController ()
<CLLocationManagerDelegate>
{
    HYQRCodeGetShopListRequest *_shopeRequest;
    HYQRCodeGetShopCategoryRequest *_shopCategoryRequest;
    NSInteger _pageNumber;
    
    //UIView *_cityView;
    
    HYAroundMallListView *_view;
    HYAllCategoryView *_allCategoryView;
    HYAllCategoryView *_smartSortView;
    
    UITableView *_categorySubTable;
    UITableView *_smartSortTableView;
    UITableView *_categoryMainTable;

    BOOL _firstDisplay;
    
    //控制加载情况
    BOOL _hasMore;
    BOOL _isLoading;
    
    //只能排序
//    BOOL _intelligent;
//    BOOL _latestPosts;
    NSInteger _sort;
    
    CLLocationCoordinate2D _coor;
}

//当前城市
@property (nonatomic, strong) HYCityForQRCode *currCity;
@property (nonatomic, assign) int filterType;

@property (nonatomic, strong) HYAroundMallListTableDataSource *datasource;
@property (nonatomic, strong) HYAllCategoryViewDataSource *categoryDatasource;
@property (nonatomic, assign) NSInteger categoryIdx;
@property (nonatomic, strong) HYO2OFilterView *filterView;
@property (nonatomic, strong) HYQRCodeGetShopCategory *shopcate;

@property (nonatomic, assign) MallListType mallListType;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) UIButton *cityBtn;

@property (nonatomic,strong) NSMutableArray *selectedShopList;

@end

@implementation HYAroundMallListViewController

- (void)dealloc
{
    [self cancelRequest];
    [HYLoadHubView dismiss];
    
    [[HYLocationManager sharedManager] stopLocate];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"合作商户";
        self.leftItemType = NoneItemBar;
        _pageNumber = 1;
        _hasMore = YES;
        _isLoading = NO;
        _mallListType = FromAround;
        _firstDisplay = YES;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    HYAroundMallListView *view = [[HYAroundMallListView alloc] initWithFrame:frame];
    _view = view;
    self.view = view;
    
    _filterView = [[HYO2OFilterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, TFScalePoint(34))];
    _filterView.conditions = @[@"全部分类", @"智能排序"];
    _filterView.userInteractionEnabled = YES;
    [_filterView addTarget:self
                    action:@selector(filterOrder:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_filterView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.datasource = [[HYAroundMallListTableDataSource alloc] init];
    HYAroundMallListView *view = (HYAroundMallListView *)self.view;
    view.tableView.delegate = self;
    view.tableView.dataSource = self.datasource;

    
    self.categoryDatasource = [[HYAllCategoryViewDataSource alloc]init];
    _allCategoryView = [[HYAllCategoryView alloc]init];
    _categoryMainTable = _allCategoryView.allCategorySelectTableView;
    _categoryMainTable.delegate = self;
    _categoryMainTable.dataSource = self.categoryDatasource;
    self.categoryDatasource.allCategorySelectTableView = _categoryMainTable;
    
    _categorySubTable = _allCategoryView.allCategoryTableView;
    _categorySubTable.delegate = self;
    _categorySubTable.dataSource = self.categoryDatasource;
    
    _smartSortView = [[HYAllCategoryView alloc]init];
    _smartSortTableView = _smartSortView.smartSortTableView;
    _smartSortTableView.delegate = self;
    _smartSortTableView.dataSource = self.categoryDatasource;
    
    
    [view.nullView addTarget:self
                      action:@selector(nullViewAction:)
            forControlEvents:UIControlEventTouchUpInside];
    [[HYLocationManager sharedManager] addTarget:self action:@selector(updateLocationInfo:) state:HYLocateSuccess];
    [[HYLocationManager sharedManager] addTarget:self action:@selector(locationFailed:) state:HYLocateFailed];
    
    //我的二维码
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIImageView *myQRCode = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aroundMall_ewm"]];
    myQRCode.frame = CGRectMake(frame.size.width - 50,
                                frame.size.height - 170,
                                40,
                                40);
    myQRCode.userInteractionEnabled = YES;
    [view addSubview:myQRCode];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(myCode)];
    [myQRCode addGestureRecognizer:tap];
    
    UILabel *qrCode = [[UILabel alloc]init];
    qrCode.frame = CGRectMake(CGRectGetMinX(myQRCode.frame) - 70, frame.size.height - 170, 70, 40);
    qrCode.font = [UIFont systemFontOfSize:11];
    [qrCode setTextColor:[UIColor orangeColor]];
    [view addSubview:qrCode];
    
//    [self sendRequest];
    
    if (_mallListType == FromAround)
    {
        [self cityItem];
        [self getAroundShopList];
    }
    else
    {
        [self getCityShopList];
    }
}

- (void)updateFilterView
{
    NSString *cate = @"全部分类";
    if (self.shopcate)
    {
        cate = self.shopcate.category_name;
    }
    NSString *sort = nil;
    NSArray *sortsNames = @[@"智能排序", @"最新发布", @"离我最近",];
    sort = [sortsNames objectAtIndex:_sort];
    self.filterView.conditions = @[cate, sort];
}

- (UIBarButtonItem *)cityItem
{
    if (!_cityBtn)
    {
        UIImage *btnImg = [[UIImage imageNamed:@"sp_btn_normal"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(10, 7, 6, 6)];
        UIButton *cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 68, 32)];
        [cityBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
        [cityBtn setTitle:@"选择城市" forState:UIControlStateNormal];
        cityBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [cityBtn addTarget:self
                    action:@selector(cityBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];
        self.cityBtn = cityBtn;
    }
    
    UIBarButtonItem *cityItem = [[UIBarButtonItem alloc] initWithCustomView:_cityBtn];
    return cityItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.baseViewController setTabbarShow:YES];
    self.baseViewController.navigationItem.leftBarButtonItem = nil;
    if (self.baseViewController)
    {
        self.baseViewController.navigationItem.rightBarButtonItem = [self cityItem];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [self cityItem];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //这里必须加哦〜〜〜〜!!!!!!
    [HYLoadHubView dismiss];
    [[HYLocationManager sharedManager] stopLocate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (self.view.window == nil)
    {
        self.view = nil;
    }
}


- (void)getAroundShopList
{
    if (_isLoading)
    {
        [self cancelRequest];
    }
    
//    [HYLoadHubView show];
    
    __weak typeof(self) b_self = self;
    [[HYLocationManager sharedManager] getCacheAddressInfo:^(HYLocateState state, HYLocateResultInfo *result)
    {
        [HYLoadHubView dismiss];
        if (state == HYLocateSuccess)
        {
            b_self.cityName = result.city;
            [b_self.cityBtn setTitle:result.city forState:UIControlStateNormal];
            _coor.latitude = result.lat;
            _coor.longitude = result.lon;
            
            b_self.mallListType = FromAround;
            [b_self reloadData];
        }
        else
        {
            [HYLoadHubView dismiss];
            NSString *info = @"获取定位信息失败，您可以选择一个城市，"
            "或者打开定位服务后点击重试";
            b_self.mallListType = FromAround;
            [(HYAroundMallListView *)b_self.view showNullViewWithInfo:info needTouch:YES];
        }
    }];
}

#pragma mark - private methods
- (void)filterOrder:(id)sender
{
    if ([sender isKindOfClass:[HYO2OFilterView class]])
    {
        HYO2OFilterView *filter = (HYO2OFilterView *)sender;
        
        switch (filter.currentIndex)
        {
            case 0: //全部分类
            {
                _categoryDatasource.filterType = filter.currentIndex;
                [_smartSortView dismissWithAnimation:YES];
                [_allCategoryView showWithAnimation:YES andFrame:_filterView.frame];
                [self sendCateRequest];
            }
                break;
            case 1: //智能排序
            {
                _categoryDatasource.filterType = filter.currentIndex;
                [_allCategoryView dismissWithAnimation:YES];
                [_smartSortView showWithAnimation:YES andFrame:_filterView.frame];
                [_smartSortTableView reloadData];
                @try
                {
                    [_smartSortTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_sort inSection:0]
                                                     animated:YES
                                               scrollPosition:UITableViewScrollPositionNone];
                }
                @catch (NSException *exception)
                {
                    [_smartSortTableView reloadData];
                }
                
            }
                break;
            default:
                break;
        }
    }
}

- (void)myCode
{
    HYQRCodeEncoderViewController *vc = [[HYQRCodeEncoderViewController alloc]init];
//    [self.baseViewController setTabbarShow:NO];
//    vc.showBottom = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 选择城市

- (void)cityBtnAction:(id)sender
{
    __block HYAroundMallListViewController *w_self = self;
    HYAroundCitySelectBlock callback = ^(HYCityForQRCode *city)
    {
        
        [w_self setWithCity:city];
    };
    HYAroundCitySelectViewController *city = [[HYAroundCitySelectViewController alloc] init];
    city.callback = callback;
    
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:city animated:YES];
}

- (void)setWithCity:(HYCityForQRCode *)city
{
    if (city)
    {
        //清除数据
        self.shopcate = nil;
        _sort = 0;
        [self updateFilterView];
        self.categoryDatasource.secondLevelItems = nil;
        [_categorySubTable reloadData];
        _categoryIdx = 0;
        [_smartSortTableView reloadData];
        
        //加载城市数据
        self.currCity = city;
        self.cityName = city.region_use;
        [self getCityShopList];
        [self.cityBtn setTitle:city.region_use forState:UIControlStateNormal];
    }
}

//获取城市商户
- (void)getCityShopList
{
    if (_isLoading)
    {
        [self cancelRequest];
    }
    _mallListType = FromCity;
    [self reloadData];
}

- (void)nullViewAction:(id)sender
{
    if ([sender isKindOfClass:[HYNullView class]])
    {
        if (_mallListType == FromAround)
        {
            [self getAroundShopList];
        } else {
            [self getCityShopList];
        }
    }
}

- (void)reloadData
{
    if ([HYLocationManager sharedManager].locateState != HYLocateSuccess
        && _mallListType == FromAround)
    {
        NSString *warning = @"定位仍未成功，请选择城市";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:warning delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    _pageNumber = 1;
    _hasMore = YES;
    [self.datasource cleanData];
    [self sendRequest];
}

- (void)reloadMoreData
{
    if (!_isLoading)
    {
        _pageNumber++;
        [self sendRequest];
    }
}

//取消正在进行的商户请求
- (void)cancelRequest
{
    [_shopeRequest cancel];
    _shopeRequest = nil;
    
    [_shopCategoryRequest cancel];
    _shopeRequest = nil;
    
    _hasMore = YES;
    _isLoading = NO;
}

- (void)sendCateRequest
{
     [HYLoadHubView show];
    
    _shopCategoryRequest = [[HYQRCodeGetShopCategoryRequest alloc] init];
    _shopCategoryRequest.cityName = self.cityName;
    
    __weak typeof(self) b_self = self;
    [_shopCategoryRequest sendReuqest:^(id result, NSError *error)
     {
         HYAroundMallListViewController *s_self = b_self;
         s_self->_isLoading = NO;
         [HYLoadHubView dismiss];
         NSArray *data = nil;
         if (!error && [result isKindOfClass:[HYQRCodeGetShopCategoryResponse class]])
         {
             HYQRCodeGetShopCategoryResponse *response = (HYQRCodeGetShopCategoryResponse *)result;
             if (200 == response.status)
             {
                 data = response.shopCateList;
             }
         }
         [b_self updateWithCateData:data error:error];
     }];
}

- (void)sendRequest
{
    _isLoading = YES;
    
    [HYLoadHubView show];
    
    _shopeRequest = [[HYQRCodeGetShopListRequest alloc] init];
    _shopeRequest.cityName = self.cityName;
    
    //if (_mallListType == FromAround)
    {
        _shopeRequest.latitude = [NSString stringWithFormat:@"%f", _coor.latitude];
        _shopeRequest.lontitude = [NSString stringWithFormat:@"%f", _coor.longitude];
    }
    _shopeRequest.sort = _sort;
    
    if (_shopcate)
    {
        _shopeRequest.merchant_cate_id = _shopcate.cate_id;
    }
    _shopeRequest.pageNumber = _pageNumber;
    
    __weak typeof(self) b_self = self;
    [_shopeRequest sendReuqest:^(id result, NSError *error)
     {
         HYAroundMallListViewController *s_self = b_self;
         s_self->_isLoading = NO;
         
         NSArray *data = nil;
         if (!error && [result isKindOfClass:[HYQRCodeGetShopListResponse class]])
         {
             HYQRCodeGetShopListResponse *response = (HYQRCodeGetShopListResponse *)result;
             if (response.status == -1)
             {
                 [b_self showLoginError];
             } else if (response.status == 200) {
                 data = response.shopList;
             }
         }
         [b_self updateWithData:data error:error];
     }];
}

- (void)updateWithCateData:(NSArray *)array error:(NSError *)error
{
    [HYLoadHubView dismiss];
    [self.categoryDatasource.categoryItems removeAllObjects];
    [self.categoryDatasource.categoryItems  addObjectsFromArray:array];
    [_categoryMainTable reloadData];
    if (self.categoryDatasource.categoryItems.count > _categoryIdx)
    {
        [_categoryMainTable selectRowAtIndexPath:[NSIndexPath
                                                  indexPathForItem:_categoryIdx inSection:0]
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)updateWithData:(NSArray *)array error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    _hasMore = ([array count] > 0);
    _isLoading = NO;
    
    if (_hasMore)
    {
        [self.datasource.items addObjectsFromArray:array];
        [(HYAroundMallListView *)self.view showTable];
    }
    else if (self.datasource.items.count == 0)
    {
        _hasMore = YES;
        _pageNumber = 1;
        
        if (error)
        {
            [(HYAroundMallListView *)self.view showNullViewWithInfo:@"由于网络原因加载失败，请点击重新加载"
                                                          needTouch:YES];
        }
        else
        {
            NSString *str = error.domain;
            if ([str length] <= 0)
            {
                str = @"暂无数据，敬请期待";
            }
            [(HYAroundMallListView *)self.view showNullViewWithInfo:str needTouch:NO];
        }
    }
    else
    {
        
        [(HYAroundMallListView *)self.view showTable];
        [(HYAroundMallListView *)self.view setLoadMore:NO];
    }
}
//#pragma mark - allCategoryTableView DataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}

#pragma mark - TableView delegate
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _view.tableView)
    {
        NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
        if(indexPath.row == totalRow -1)
        {
            HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
            lineCell.separatorLeftInset = 0.0f;
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _categorySubTable || tableView == _smartSortTableView
        || tableView == _categoryMainTable)
    {
        return TFScalePoint(40);
    }else return TFScalePoint(110);
}

// Customize the appearance of table view cells.

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _view.tableView)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        HYAroundMallDetailViewController *detail = [[HYAroundMallDetailViewController alloc] init];
        HYQRCodeShop *shop = [self.datasource itemAtIndexPath:indexPath];
        detail.shop = shop;
        [self.baseViewController setTabbarShow:NO];
        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        if (tableView == _categoryMainTable)
        {
            if (indexPath.row == 0)
            {
                self.shopcate = nil;
                _filterView.clickSelected = NO;
                [_allCategoryView dismissWithAnimation:YES];
                self.categoryDatasource.secondLevelItems = nil;
                self.categoryIdx = 0;
                [_categorySubTable reloadData];
                [self updateFilterView];
            }
            else if (indexPath.row < self.categoryDatasource.categoryItems.count+1)
            {
                HYQRCodeGetShopCategory *mainCategory = [self.categoryDatasource.categoryItems
                                                         objectAtIndex:(indexPath.row-1)];
                NSArray *secondItems = [NSArray arrayWithObject:mainCategory];
                secondItems = [secondItems arrayByAddingObjectsFromArray:[mainCategory items]];
                self.categoryDatasource.secondLevelItems = (id)secondItems;
                self.categoryIdx = indexPath.row;
                [_categorySubTable reloadData];
                return;
            }
        }
        else if (tableView == _categorySubTable)
        {
            if (indexPath.row == 0)
            {
                //子分类全部，只显示加载
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }
            else
            {
                HYQRCodeGetShopCategory *cate = self.categoryDatasource.secondLevelItems[indexPath.row];
                self.shopcate = cate;
                _filterView.clickSelected = NO;
                [_allCategoryView dismissWithAnimation:YES];
                [self updateFilterView];
            }
        }
        else
        {
            _sort = indexPath.row;
            [self updateFilterView];
           _filterView.clickSelected = NO;
          [_smartSortView dismissWithAnimation:YES];
        }
        [self reloadData];
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _view.tableView)
    {
        //加载更多
        float scrollOffset = scrollView.contentOffset.y;
        float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (scrollOffset >= maximumOffset && !_isLoading && _hasMore)
        {
            [self reloadMoreData];
        }
    }
}

#pragma mark - LOGIN
- (void)showLoginError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                    message:@"用户未登录或登录信息不完整，请重新登录"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"重新登录", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication]
                                                       delegate];
        [appDelegate loadLoginView];
    }
}

#pragma mark getter and setter
-(NSMutableArray *)selectedShopList
{
    if (!_selectedShopList)
    {
        _selectedShopList = [NSMutableArray array];
    }
    return _selectedShopList;
}
@end
