//
//  BusinessRootCtrl.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BusinessRootCtrl.h"
#import "BusinessDetailViewController.h"
#import "SelectCityViewController.h"
#import "QRCodeEncoderViewController.h"
#import "BusinessMapViewController.h"
#import "HYLoginViewController.h"

#import "XTSegmentControl.h"
#import "SVPullToRefresh.h"

#import "HYLocationManager.h"
#import "HYAppDelegate.h"
#import "DefineConfig.h"

#import "BusinessListRequest.h"
#import "CategoryRequest.h"
#import "SearchMerchantRequest.h"

#import "categoryInfo.h"
#import "BusinessListInfo.h"

#import "MJExtension.h"
#import "HYNullView.h"
#import "METoast.h"
#import "Masonry.h"

#import "BusinesslistCell.h"

#import "UIImage+Addition.h"
#import "UIView+Common.h"
#import "UIColor+expanded.h"
#import "UISearchBar+Common.h"
#import "UIView+Frame.h"
#import "UIImage+Common.h"
#import "LocalCityManager.h"
#import "UITableView+Common.h"

#define SegmentHeight       44
/**fasdgidsg**/
@interface BusinessRootCtrl ()
<DownMenuViewDelegate,
UITableViewDelegate,
UITableViewDataSource
,UISearchBarDelegate,
UISearchDisplayDelegate,
UITextFieldDelegate,
UIScrollViewDelegate,
UIAlertViewDelegate>{
    
    NSInteger               _segmentIndex;
    NSInteger               _pageNumber;
    NSInteger               _sort;
    CGFloat                 _lastPosition;
    
    NSMutableArray          *_businessListArray;
    
    SearchMerchantRequest   *_mercantListRequest;
    CategoryRequest         *_categoryRequest;
    CategoryRequest         *_cityRequest;
    SearchMerchantRequest   *_searchMerchantRequest;

    DownMenuView            *_categoryView;
    DownMenuView            *_cityView;
    DownMenuView            *_sortView;
    DownMenuView            *_tmpDownView;
    
    BOOL                    _isCateFresh;
    BOOL                    _isCityFresh;
    BOOL                    _isSortFresh;
    BOOL                    _animationFlag;
    CLLocationCoordinate2D  _coor;

}

@property (strong, nonatomic) XTSegmentControl  *mySegmentControl;
@property (nonatomic, assign) NSInteger         categoryId;
@property (nonatomic, assign) NSInteger         areaId;
@property (nonatomic, assign) BOOL              isNext;
@property (nonatomic, assign) BOOL              isSearch;
@property (nonatomic, assign) BOOL              isLocationSuccess;
@property (nonatomic, strong) NSString          *cityName;
@property (nonatomic, strong) NSString          *tmpCityName;
@property (nonatomic, strong) NSString          *searchText;
@property (nonatomic, strong) UIButton          *cityBtn;
@property (nonatomic, strong) UITableView       *baseTableView;
@property (nonatomic, strong) NSMutableArray    *dataSource;
@property (nonatomic, strong) NSMutableArray    *cityDataSource;
@property (nonatomic, strong) NSMutableArray    *searchResultData;
@property (nonatomic, strong) UIImageView       *myQRCode;

@end

/***哈哈***/
@implementation BusinessRootCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.leftItemType = BackItemBar;
        _pageNumber = 1;
        self.searchResultData = [NSMutableArray array];
    }
    return self;
}

- (IBAction)backToRootViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    [HYLoadHubView dismiss];
     DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _mySearchBar.hidden = NO;
    if (!_isLocationSuccess) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"自动获取城市失败，请手动选择城市或者打开定位服务重试"
                                                    delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"手动选择城市",nil];
        [av show];
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setNavBar];//创建导航按钮
}

- (void)viewDidLoad {
    

    
    
    [super viewDidLoad];
    [self.baseViewController setTabbarShow:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self cityItem]; //创建导航按钮item
    [self getLocalBusinessList]; //请求定位地址
    
    _isLocationSuccess = YES;
    
    WS(weakSelf);
    _businessListArray = [[NSMutableArray alloc] init];
    _baseTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = UIColorFromRGB(245, 245, 245);
        [self.view addSubview:tableView];
        tableView;
    });
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(44, 0, 0, 0));//g_fitFloat(@[@48,@56.25,@62.10])
    }];
    
    [self createMyQRCode];
    
    [self.baseTableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.isNext = YES;
        [weakSelf sendRequest];
    }];
    [self.baseTableView setShowsInfiniteScrolling:NO];
    
    _mySearchBar = [[UISearchBar alloc] init];
    [_mySearchBar setFrame:CGRectMake(40,22, kScreen_Width - 118 , 40)];
    [_mySearchBar setDelegate:self];
    [_mySearchBar setPlaceholder:@"搜索"];
    [_mySearchBar setBarStyle:UIBarStyleDefault];
    [_mySearchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _mySearchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    [_mySearchBar setTranslucent:YES];

    NSArray  *subViews = nil;
    subViews = IOS7 ? [_mySearchBar.subviews[0] subviews] : [_mySearchBar subviews];
    
    for (UIView *subview in subViews){
        
            if ( [subview isKindOfClass:[UITextField class]] ){
                
                UITextField *temTextFD = (UITextField *)subview;
                [temTextFD setTintColor:[UIColor colorWithHexString:@"0xb80000"]];
                [temTextFD setFont:[UIFont systemFontOfSize:13]];
                [temTextFD setValue:[UIColor colorWithHexString:@"0x999999"] forKeyPath:@"_placeholderLabel.textColor"];
                [temTextFD setTextColor:[UIColor colorWithHexString:@"0x404040"]];
                [temTextFD  setBackgroundColor:[UIColor colorWithHexString:@"0xf6f6f6"]];
                [[temTextFD  layer] setCornerRadius:5];
                [[temTextFD  layer] setMasksToBounds:YES];
                [[temTextFD layer] setBorderWidth:0.5];
                [[temTextFD layer] setBorderColor:[UIColor colorWithHexString:@"0xe0e0e0"].CGColor];
                UIImage *image = [UIImage imageNamed: @"search"];
                UIImageView *iView = [[UIImageView alloc] initWithImage:image];
                iView.frame = CGRectMake(0, 0, 17 , 17);
                [temTextFD setLeftView:iView];
                return;
            }
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self cancelRequest];
    [_tmpDownView dismiss];
    _mySearchBar.hidden = YES;
    [self.baseViewController setTabbarShow:NO];
    [self.mySearchBar setShowsCancelButton:NO animated:YES];
    [self.mySearchBar resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)
{
 
    if (searchText.length == 0) {
        
        [searchBar performSelector: @selector(resignFirstResponder)
                           withObject: nil
                           afterDelay: 0.1];
        if (_isSearch) {
            _isSearch = NO;
            [self.baseTableView setShowsInfiniteScrolling:_businessListArray.count < kDefaultPageSize ? NO : YES];
            [self.baseTableView configBlankPage:EaseBlankPageTypeNoData hasData:_businessListArray.count > 0 hasError:nil
                              reloadButtonBlock:nil];
            [self.baseTableView reloadData];
        }
      
    }
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0);{

    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _isSearch = YES;
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    _searchText = searchBar.text;
    [self searchMerchant:searchBar.text];
}

#pragma mark -- 商家列表数据请求
- (void)searchMerchant:(NSString *)merchantName;
{

    [HYLoadHubView show];
    _searchMerchantRequest               = [[SearchMerchantRequest alloc] init];
    _searchMerchantRequest.interfaceURL  = [NSString stringWithFormat:@"%@/v3/Merchants/GetMerchantsByName",BASEURL];
    _searchMerchantRequest.httpMethod    = @"POST";
    _searchMerchantRequest.postType      = JSON;
    _searchMerchantRequest.interfaceType = DotNET2;

    _searchMerchantRequest.MerchantName  = merchantName;
    _searchMerchantRequest.City          = self.cityName ? :@"";

    _searchMerchantRequest.AreaId        = _areaId;
    _searchMerchantRequest.CategoryId    = _categoryId;
    
    _searchMerchantRequest.Latitude      = _coor.latitude;
    _searchMerchantRequest.Longitude     = _coor.longitude;
    
    _searchMerchantRequest.SortType               = _sort;
    _searchMerchantRequest.PageIndex              = kDefaultPageIndexStart;
    _searchMerchantRequest.PageSize               = 100;
    
    WS(weakSelf);
    [_searchMerchantRequest sendReuqest:^(id result, NSError *error)
     {
         NSArray  *objArray = nil;
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             NSString *msg = objDic[@"msg"];
             if (code == 0) { //状态值为0 代表请求成功
                 NSArray *DateArray = objDic[@"data"];
                 objArray  = [BusinessListInfo objectArrayWithKeyValuesArray:DateArray];
             }else{
                weakSelf.isSearch = NO;
                [METoast toastWithMessage:msg ? : @"获取商家信息失败"];
             }
         }else{
            weakSelf.isSearch = NO;
            [METoast toastWithMessage:@"获取商家信息失败"];
         }
         [weakSelf updateSearchData:objArray error:error];
     }];
}

- (void)updateSearchData:(NSArray *)objArray error:(NSError *)error{
    WS(weakSelf);
    [self.baseTableView setShowsInfiniteScrolling:NO];
    [self.searchResultData removeAllObjects];
    [self.searchResultData addObjectsFromArray:objArray];
    [self.baseTableView configBlankPage:EaseBlankPageTypeNoData hasData:objArray.count > 0 hasError:error
                      reloadButtonBlock:^(id sender) {
                          [weakSelf searchMerchant:weakSelf.searchText];
                      }];
    [self.baseTableView reloadData];
     [HYLoadHubView dismiss];
}


#pragma mark -- 初始导航栏
- (void)setNavBar{
    self.navigationItem.leftBarButtonItem = [self backItemBar];
    self.navigationItem.rightBarButtonItem = [self cityItem];
    [self.navigationController.view addSubview:_mySearchBar];
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

#pragma mark -- 我的二维码
- (void)createMyQRCode{
    //我的二维码
    CGRect frame = [[UIScreen mainScreen] bounds];
    _myQRCode = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QRImage"]];
    _myQRCode.frame = CGRectMake(frame.size.width - 75,
                                frame.size.height - g_fitFloat(@[@125,@135,@145]),
                                65,
                                65);
    _myQRCode.userInteractionEnabled = YES;
    [self.view addSubview:_myQRCode];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(myCode)];
    [_myQRCode addGestureRecognizer:tap];

}

#pragma mark private methods
- (void)loginEvent
{
    HYLoginViewController *vc = [[HYLoginViewController alloc] init];
    HYNavigationController *nav = [[HYNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];

}

- (void)myCode
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (!isLogin) {
        [self loginEvent];
    }else{
        QRCodeEncoderViewController *vc = [[QRCodeEncoderViewController alloc]init];
        [self.baseViewController setTabbarShow:NO];
        vc.showBottom = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- 初始化分类搜索视图
- (void)setcategorySearchView{
    
    if (self.mySegmentControl) {
        return;
    }
    
    WS(weakSelf);
    

        self.mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, SegmentHeight)
                                                                  Items:@[@"全部分类", @"全城", @"智能排序"]
                                                               withIcon:YES
                                                          selectedBlock:^(NSInteger index) {
                                                              [weakSelf openList:index];
                                                          }];
    
        _segmentIndex = 99999;
        [self.view addSubview:self.mySegmentControl];
  
    

        _categoryView = [[DownMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0) hiddenBlock:^{
            [weakSelf.mySegmentControl selectIndex:-1];
        }];
        
        _categoryView.delegate = self;
        _categoryView.backgroundColor = [UIColor clearColor];
        _categoryView.tag = 9898;
        
         [_categoryView initCategoryTable];
   
        _cityView = [[DownMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0) hiddenBlock:^{
            [weakSelf.mySegmentControl selectIndex:-1];
        }];
        _cityView.delegate = self;
        _cityView.backgroundColor = [UIColor clearColor];
        _cityView.tag = 9899;
        
         [_cityView initCategoryTable];

        _sortView = [[DownMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0) hiddenBlock:^{
            [weakSelf.mySegmentControl selectIndex:-1];
        }];
        _sortView.delegate = self;
        _sortView.backgroundColor = [UIColor clearColor];
        _sortView.tag = 9900;
        
         [_sortView initSortTable];
 
}

#pragma mark -- 获取分类信息
- (void)loadDate{
    _dataSource = [[NSMutableArray alloc] init];
    _cityDataSource = [[NSMutableArray alloc] init];
    [self loadCategoryData];
}


#pragma mark -- 获取定位信息
- (void)getLocalBusinessList
{

    WS(weakSelf);
    if (kNetworkNotReachability) {

        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络异常，请检查网络状态"
                                                    delegate:weakSelf cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
        [av show];

        return;
    }
    
    [self cancelRequest];
     [HYLoadHubView show];

   [[HYLocationManager sharedManager] getCacheAddressInfo:^(HYLocateState state, HYLocateResultInfo *result)
     {
         if (state == HYLocateSuccess)
         {
             weakSelf.isLocationSuccess = YES;
             NSString *city = result.city;

             weakSelf.tmpCityName = [LocalCityManager sharedManager].city;
             weakSelf.cityName = weakSelf.tmpCityName ? : city;
             
             [weakSelf.cityBtn setTitle: weakSelf.cityName forState:UIControlStateNormal];
             _coor.latitude = result.lat;
             _coor.longitude = result.lon;
             [weakSelf loadDate];
         }
         else
         {
             weakSelf.isLocationSuccess = NO;
             
             [HYLoadHubView dismiss];
            [weakSelf.baseTableView setShowsInfiniteScrolling:NO];

             UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"自动获取城市失败，请手动选择城市"
                                                         delegate:weakSelf cancelButtonTitle:nil otherButtonTitles:@"取消",@"手动选择城市",nil];
             [av show];
         }
     }];
}

#pragma mark -- tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        if (_isSearch) {
            return _searchResultData.count;
        }
        return _businessListArray.count;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScaleHEIGHT(94);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"BusinesslistCell";
    BusinesslistCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BusinesslistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    BusinessListInfo *bInfo = nil;
    if (_isSearch) {
        bInfo = [_searchResultData objectAtIndex:indexPath.row];
    }else{
        bInfo = [_businessListArray objectAtIndex:indexPath.row];
    }
    
    [cell setWithShop:bInfo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BusinessListInfo *bInfo = nil;
    if (_isSearch) {
        bInfo = [_searchResultData objectAtIndex:indexPath.row];
    }else{
        bInfo = [_businessListArray objectAtIndex:indexPath.row];
    }
    
    BusinessDetailViewController *tmpCtrl = [[BusinessDetailViewController alloc] init];
    tmpCtrl.businessInfo = bInfo;
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:tmpCtrl animated:YES];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.mySearchBar isFirstResponder]) {
        [self.mySearchBar resignFirstResponder];
    }

    CGFloat currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 10 && !_animationFlag) {
        
        [self positionAnimationWithUp];
    }
    else if (_lastPosition - currentPostion > 2 && _animationFlag)
    {
        [self positionAnimationWithDown];
    }
    _lastPosition = currentPostion;
}

- (void)positionAnimationWithDown //位移动画
{
    [UIView beginAnimations:@"PositionAnition" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    _myQRCode.frame = CGRectMake(_myQRCode.x, _myQRCode.y - 100, _myQRCode.width, _myQRCode.height);
    [UIView setAnimationDidStopSelector:@selector(scareAnimation:)];
    [UIView commitAnimations];
   _animationFlag = NO;
}

- (void)positionAnimationWithUp //向上动画
{
    [UIView beginAnimations:@"PositionAnition" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    _myQRCode.frame = CGRectMake(_myQRCode.x, _myQRCode.y + 100, _myQRCode.width, _myQRCode.height);
    [UIView setAnimationDidStopSelector:@selector(scareAnimation)];
    [UIView commitAnimations];
    _animationFlag = YES;
}


#pragma mark -- 商家列表数据请求
- (void)sendRequest
{

    [_mercantListRequest cancel];
    _mercantListRequest = nil;
    _mercantListRequest = [[SearchMerchantRequest alloc] init];
    _mercantListRequest.interfaceURL     = [NSString stringWithFormat:@"%@/v3/Merchants/GetMerchantsByName",BASEURL];
    _mercantListRequest.httpMethod       = @"POST";
    _mercantListRequest.postType         = JSON;
    _mercantListRequest.interfaceType    = DotNET2;
    
    _mercantListRequest.MerchantName        = @"";
    _mercantListRequest.City                = self.cityName;
    _mercantListRequest.AreaId              = _areaId;
    _mercantListRequest.CategoryId          = _categoryId;
    
    {
        _mercantListRequest.Latitude        =  _coor.latitude;
        _mercantListRequest.Longitude       =  _coor.longitude;
    }
    
    _mercantListRequest.SortType            = _sort;
    _mercantListRequest.PageIndex           = _pageNumber;
    _mercantListRequest.PageSize            = kDefaultPageSize;
    
    WS(weakSelf);
    [_mercantListRequest sendReuqest:^(id result, NSError *error)
     {
         NSArray  *objArray = nil;
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为1 代表请求成功
                 NSArray *DateArray = objDic[@"data"];
                 objArray  = [BusinessListInfo objectArrayWithKeyValuesArray:DateArray];
             }else{
                 [METoast toastWithMessage:@"获取商家信息失败"];
             }
         }else{
             [METoast toastWithMessage:@"无法连接服务器"];
         }
         [weakSelf updateBusinessListData:objArray error:error];
         
     }];
}

//商家列表数据绑定
- (void)updateBusinessListData:(NSArray *)objArray error:(NSError *)error{
    
  
    [self.baseTableView.infiniteScrollingView stopAnimating];
    
    if (!_isNext) {
        [_businessListArray removeAllObjects];
    }
    [_businessListArray addObjectsFromArray:objArray];
    _pageNumber += 1;
   
    if (objArray.count < kDefaultPageSize) {
       [self.baseTableView setShowsInfiniteScrolling:NO];
        
    }else{
          [self.baseTableView setShowsInfiniteScrolling:YES];
    }
    
     WS(weakSelf);
    if (!_isNext) {
        [HYLoadHubView dismiss];
        [weakSelf.baseTableView configBlankPage:EaseBlankPageTypeNoData hasData:objArray.count > 0 hasError:error
                              reloadButtonBlock:^(id sender) {
            [weakSelf sendRequest];
        }];
    }
     [weakSelf.baseTableView reloadData];

}

#pragma mark -- 获取生活分类信息
- (void)loadCategoryData{
   
    [_categoryRequest cancel];
    _categoryRequest = nil;
    
    _categoryRequest = [[CategoryRequest alloc] init];
    _categoryRequest.interfaceURL = [NSString stringWithFormat:@"%@/Merchants/GetCategorys",BASEURL];
    _categoryRequest.httpMethod = @"GET";
    _categoryRequest.cityName = self.cityName;
    
    WS(weakSelf);
    [_categoryRequest sendReuqest:^(id result, NSError *error)
     {

         if(result){
             
             NSDictionary *objDic = [result jsonDic];
             NSArray *objArray = nil;
             int code = [objDic[@"Result"] intValue];
             if (code == 1) {
                 NSArray *DateArray = objDic[@"Data"];
                 
                 [categoryInfo setupObjectClassInArray:^NSDictionary *{
                     return @{@"SubCategorys" : @"categoryInfo"};
                 }];
                 
                 objArray  = [categoryInfo objectArrayWithKeyValuesArray:DateArray];
                 weakSelf.dataSource = objArray.mutableCopy;
             }else{
                 [METoast toastWithMessage:@"获取分类信息失败"];
             }
         }
         else{
             [METoast toastWithMessage:@"获取分类信息失败"];
         }
         
         [weakSelf loadCityAreaData];
     }];
}

#pragma mark -- 获取区域分类信息
- (void)loadCityAreaData{
    
    [_cityRequest cancel];
    _cityRequest = nil;
    
    _cityRequest = [[CategoryRequest alloc] init];
    _cityRequest.interfaceURL = [NSString stringWithFormat:@"%@/Merchants/GetAreasByCity?City=%@",BASEURL,self.cityName];
    _cityRequest.httpMethod = @"GET";
    
    WS(weakSelf);
    [_cityRequest sendReuqest:^(id result, NSError *error)
     {

         if(result){
             
             NSDictionary *objDic = [result jsonDic];
             NSArray *objArray = nil;
             int code = [objDic[@"Result"] intValue];
             if (code == 1) {
                 NSArray *DateArray = objDic[@"Data"];
                 
                 [cityInfo setupObjectClassInArray:^NSDictionary *{
                     return @{@"SubAdress" : @"cityInfo"};
                 }];
                 
                 objArray  = [cityInfo objectArrayWithKeyValuesArray:DateArray];
                 cityInfo *cInfo = [objArray firstObject];
                 weakSelf.cityDataSource = cInfo.SubAdress;
                 
             }else{
                 [METoast toastWithMessage:@"获取信息失败"];
             }
         }
         else{
             [METoast toastWithMessage:@"获取城市信息失败"];
         }
         
         
        [weakSelf setcategorySearchView];
        [weakSelf sendRequest];
     }];

}


#pragma mark -- 选择城市
- (void)cityBtnAction:(id)sender
{
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:@"这个是UIAlertController的默认样式" preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
//        textField.placeholder = @"登录";
//    }];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"密码";
//        textField.secureTextEntry = YES;
//    }];
//    
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        
//        UITextField *login = alertController.textFields.firstObject;
//        UITextField *password = alertController.textFields.lastObject;
//         [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
//        
//        NSLog(@"%@",login.text);
//        NSLog(@"%@",password.text);
//
//    }];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
//    [self presentViewController:alertController animated:YES completion:nil];
//    
//    return;
    

    WS(weakSelf)
    citySelectBlock callback = ^(NSString *city)
    {
        weakSelf.isLocationSuccess = YES;

        if (weakSelf.mySearchBar.text != nil) {
            weakSelf.mySearchBar.text = nil;
        }
        [LocalCityManager sharedManager].city = city;

        [weakSelf.baseTableView setShowsInfiniteScrolling:YES];
        [weakSelf setWithCity:city];
    };
    SelectCityViewController *city = [[SelectCityViewController alloc] init];
    city.callback = callback;
    city.currentCity = self.cityName;
    
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:city animated:YES];
}


- (void)setWithCity:(NSString *)city
{
    if (city)
    {
        
        if (_segmentIndex == 0) {
            [self.mySegmentControl setTitle:@"全部分类" withIndex:_segmentIndex];
             [self.mySegmentControl selectIndex:-1];
        }else if (_segmentIndex == 1){
            [self.mySegmentControl setTitle:@"全城" withIndex:_segmentIndex];
            [self.mySegmentControl selectIndex:-1];
        }
        
        //清除数据
        _sort = 0;
        _categoryId = 0;
        _areaId = 0;
        _isNext = NO;
        _pageNumber = 1;
        //加载城市数据
        self.cityName = city;
        [self.cityBtn setTitle:city forState:UIControlStateNormal];
        _isCityFresh = NO;
        _isSearch = NO;
        [HYLoadHubView show];
        [self loadDate];
    }
}

#pragma mark -- 分类tab点击触发事件
- (void)openList:(NSInteger)index{

    if(self.cityName == nil){
        [METoast toastWithMessage:@"请选择城市"];
        return;
    }
    switch (index) {
        case 0:
        {
            _tmpDownView = _categoryView;
            if (_dataSource.count == 0) {
                [METoast toastWithMessage:@"分类信息加载失败,请稍后重试"];
                return;
            }
            
            [_cityView hidenView];
            [_sortView hidenView];
            
            if (!_isCateFresh) {
                 [_categoryView bindData:_dataSource index:index];
                _isCateFresh = YES;
            }
            
    
            if (!_categoryView.isShow) {
                [_categoryView showInView:KEY_WINDOW index:index];
            }else{
                [_categoryView dismiss];
            }
        }
            break;
        case 1:
        {
              _tmpDownView = _cityView;
            if (_cityDataSource.count == 0) {
                [METoast toastWithMessage:@"城市信息加载失败,请稍后重试"];
                return;
            }

            [_categoryView hidenView];
            [_sortView hidenView];
            
            if (!_isCityFresh) {
                [_cityView bindData:_cityDataSource index:index];
                _isCityFresh = YES;
            }
            
            
            if (!_cityView.isShow) {
                [_cityView showInView:KEY_WINDOW index:index];
            }else{
                [_cityView dismiss];
            }

        }
            break;
        case 2:
        {
            _tmpDownView = _sortView;
            [_cityView hidenView];
            [_categoryView hidenView];
            
            if (!_sortView.isShow) {
                [_sortView showInView:KEY_WINDOW index:index];
            }else{
                [_sortView dismiss];
            }

        }
            break;
            
        default:
            break;
    }
     _segmentIndex = index;
}


#pragma mark -- 分类tab选择代理
- (void)selectedRowWithItem:(NSString *)objString{
    if (_segmentIndex == 0) {
        [_categoryView hidenView];
    }else if (_segmentIndex == 1){
        [_cityView hidenView];
    }else{
        [_sortView hidenView];
    }

    [self.mySegmentControl setTitle:objString withIndex:_segmentIndex];
    
    if ([objString isEqualToString:@"离我最近"]) {
        _sort = 0;
    }else{
        _sort = 1;
    }
    
    _pageNumber = 1;
     _isNext = NO;
    [self sendRequest];
}

- (void)selectedRowWithObj:(NSObject *)obj{
    
    if (_segmentIndex == 0) {
        [_categoryView hidenView];
        
        categoryInfo *info = (categoryInfo *)obj;
        _pageNumber = 1;
         _isNext = NO;
        _categoryId = info.CaId;
        [self sendRequest];
         [self.mySegmentControl setTitle:info.Name withIndex:_segmentIndex];
        
    }else if (_segmentIndex == 1){
        [_cityView hidenView];
        cityInfo *info = (cityInfo *)obj;
        _pageNumber = 1;
        _isNext = NO;
        _areaId = info.OrzId;
        [self sendRequest];
        [self.mySegmentControl setTitle:info.Name withIndex:_segmentIndex];

    }else{
        [_sortView hidenView];
    }
}

- (void)selectedRowWithIndx:(NSInteger)index{
    if (_segmentIndex == 0) {
        [_categoryView hidenView];
        _categoryId = index;
        [self.mySegmentControl setTitle:@"全部分类" withIndex:_segmentIndex];
    }else if (_segmentIndex == 1){
        [_cityView hidenView];
        _areaId = index;
         [self.mySegmentControl setTitle:@"全城" withIndex:_segmentIndex];
    }
     _pageNumber = 1;
     _isNext = NO;
    [self sendRequest];
}

- (void)selectedRowWithObj:(NSObject *)Obj isAll:(BOOL)isAll{
    
    if (_segmentIndex == 0) {
        [_categoryView hidenView];
        categoryInfo *info = (categoryInfo *)Obj;
        _categoryId = info.CaId;
        [self.mySegmentControl setTitle:info.Name withIndex:_segmentIndex];
    }else if (_segmentIndex == 1){
        [_cityView hidenView];
        cityInfo *info = (cityInfo *)Obj;
        _areaId = info.OrzId;
        [self.mySegmentControl setTitle:info.Name withIndex:_segmentIndex];
    }
    _pageNumber = 1;
    _isNext = NO;
    [self sendRequest];

}

#pragma mark -- 取消正在进行的商户请求
- (void)cancelRequest
{
    [_mercantListRequest cancel];
    _mercantListRequest = nil;
    
    [_categoryRequest cancel];
    _categoryRequest = nil;
    
    [_cityRequest cancel];
    _cityRequest = nil;
    
    [_searchMerchantRequest cancel];
    _searchMerchantRequest = nil;

}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self backToRootViewController:nil];
    }else{
        [self cityBtnAction:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
