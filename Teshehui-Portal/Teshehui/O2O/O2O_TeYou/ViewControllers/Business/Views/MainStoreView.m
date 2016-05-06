//
//  MainStoreView.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/8.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#define SegmentHeight       35

#import "MainStoreView.h"
#import "BusinessDetailViewController.h"
#import "SelectCityViewController.h"
#import "QRCodeEncoderViewController.h"
//#import "BusinessMapViewController.h"
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

#import "DownMenuView.h"
#import "BusinesslistCell.h"

#import "UIImage+Addition.h"
#import "UIView+Common.h"
#import "UIColor+expanded.h"
#import "UISearchBar+Common.h"
#import "UIView+Frame.h"
#import "UIImage+Common.h"
#import "LocalCityManager.h"
#import "UITableView+Common.h"
#import "UIButton+Common.h"
#import "MJRefresh.h"
#import "LoadNullView.h"
#import "PageBaseLoading.h"
@interface MainStoreView ()
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

    
    SearchMerchantRequest   *_mercantListRequest;
    CategoryRequest         *_categoryRequest;
    CategoryRequest         *_cityRequest;
    
    DownMenuView            *_categoryView;
    DownMenuView            *_cityView;
    DownMenuView            *_sortView;
    DownMenuView            *_tmpDownView;
    
    BOOL                    _isCateFresh;
    BOOL                    _isCityFresh;
    BOOL                    _isSortFresh;
    BOOL                    _animationFlag;
    
    dispatch_queue_t _serialQueue;
}

@property (strong, nonatomic) XTSegmentControl  *mySegmentControl;
@property (nonatomic, assign) NSInteger         categoryId;
@property (nonatomic, assign) NSInteger         areaId;
@property (nonatomic, assign) BOOL              isNext;
@property (nonatomic, strong) UITableView       *baseTableView;
@property (nonatomic, strong) NSMutableArray    *dataSource;
@property (nonatomic, strong) NSMutableArray    *cityDataSource;
@property (nonatomic, strong) NSMutableArray    *businessListArray;

@property (nonatomic, strong) LoadNullView      *nullView;
@end

@implementation MainStoreView

- (instancetype)initWithFrame:(CGRect)frame city:(NSString *)city location:(CLLocationCoordinate2D)coor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cityName = city;
        self.coor = coor;
        _pageNumber = 1;
        [self setup];
    }
    return self;
}

- (UITableView *)baseTableView{
    if (!_baseTableView) {
        _baseTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.backgroundColor = UIColorFromRGB(245, 245, 245);
            tableView;
        });
    }
    return _baseTableView;
}

- (LoadNullView *)nullView{
    if (!_nullView) {
        _nullView = [[LoadNullView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)
                                              imageName:@"shouyeshitidian_picture" text:@"暂无商家信息，请小主耐心等待" secondText:nil offsetY:-35];
    }
    
    return _nullView;
}

- (NSMutableArray *)businessListArray{

    if (!_businessListArray) {
         _businessListArray = [[NSMutableArray alloc] init];
    }
    
    return _businessListArray;
}

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}

- (NSMutableArray *)cityDataSource{
    
    if (!_cityDataSource) {
        _cityDataSource = [[NSMutableArray alloc] init];
    }
    
    return _cityDataSource;
}

- (LoadNullView *)loadNullView:(NSString *)text secondText:(NSString *)secondText{
    [_nullView removeFromSuperview];
    _nullView = nil;
    if (!_nullView) {
        _nullView = [[LoadNullView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)
                                              imageName:@"shouyemeishi_picture" text:text secondText:secondText offsetY:-35];
    }
    
    return _nullView;
}

- (void)setup{
   
    [self addSubview:self.baseTableView];
    WS(weakSelf);
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(SegmentHeight, 0, 0, 0));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(selectCity:)
                                                 name:kNotificationWithSelecteCityBlock object:nil];
    
    
    [self.baseTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    [self.baseTableView setShowsInfiniteScrolling:NO];
    
    self.baseTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    
    [self createMyQRCode];
    [self loadData];
}

#pragma mark -- 创建我的二维码
- (void)createMyQRCode{
    
    _myQRCode = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QRImage"]];
    _myQRCode.frame = CGRectMake(self.width - 75,
                                 self.height - g_fitFloat(@[@75,@85,@95]),
                                 65,
                                 65);
    _myQRCode.userInteractionEnabled = YES;
    [self addSubview:_myQRCode];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(myCode)];
    [_myQRCode addGestureRecognizer:tap];
}

- (void)myCode{
    
    if (_delegate && [_delegate respondsToSelector:@selector(QRcodeClickWithMainStoreView)]) {
        [_delegate QRcodeClickWithMainStoreView];
    }
}

- (void)loadData{
    
    [PageBaseLoading showLoading];
//    WS(weakSelf);
//    dispatch_queue_t queue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    dispatch_group_t group = dispatch_group_create(); //
//    
//    dispatch_async(queue, ^{ //创建串行队列 目的是让下列网络请求去按顺序执行
//        DebugNSLog(@"进入 串行队列");
//        
//        dispatch_group_async(group, queue, ^{  //创建第一条group任务
//            DebugNSLog(@"aaaaaa");
//            [self loadCategoryData];
//        });
//        
//        dispatch_group_async(group, queue, ^{  //创建第二条group任务
//            DebugNSLog(@"bbbbbbb");
//            [weakSelf loadCityAreaData];
//        });
//        
//        dispatch_group_async(group, queue, ^{  //创建第三条group任务
//            DebugNSLog(@"ccccc");
//            [weakSelf sendRequest];
//        });
//        
//        dispatch_group_notify(group, mainQueue, ^{ //队列全部执行完开始构建UI
//            DebugNSLog(@"group 全部执行完成");
//            [weakSelf setcategorySearchView];
//            
//        });
//    });
    
    [self loadCategoryData];
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
         
         DebugNSLog(@"bbbbbbb");
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
         DebugNSLog(@"ccccc");
     }];
    
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
    [self addSubview:self.mySegmentControl];
    
    
    
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

#pragma mark -- 商家列表数据请求
- (void)sendRequest
{
    if (_areaId != 0 || _categoryId != 0 || _sort != 0) {
        [PageBaseLoading showLoading];
    }
    
    [_mercantListRequest cancel];
    _mercantListRequest = nil;
    _mercantListRequest = [[SearchMerchantRequest alloc] init];
    _mercantListRequest.interfaceURL     = [NSString stringWithFormat:@"%@/v3/Merchants/GetMerchantsByName",BASEURL];
    _mercantListRequest.httpMethod       = @"POST";
    _mercantListRequest.postType         = JSON;
    _mercantListRequest.interfaceType    = DotNET2;
    
     {
        _mercantListRequest.MerchantName        = @"";
        _mercantListRequest.City                = self.cityName;
        _mercantListRequest.AreaId              = _areaId;
        _mercantListRequest.CategoryId          = _categoryId;
        _mercantListRequest.Latitude        =  _coor.latitude;
        _mercantListRequest.Longitude       =  _coor.longitude;
        _mercantListRequest.SortType            = _sort;
        _mercantListRequest.PageIndex           = _pageNumber;
        _mercantListRequest.PageSize            = kDefaultPageSize;
    }
    
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
             [METoast toastWithMessage:@"服务器请求异常"];
         }
         
         if (_areaId != 0 || _categoryId != 0 || _sort != 0) {
             [PageBaseLoading hide_Load];
         }
         [weakSelf updateBusinessListData:objArray error:error];
     }];

}

- (void)loadMoreData{
    _isNext = YES;
    _pageNumber += 1;
    [self sendRequest];
}

- (void)refreshData{
    
    /**检查网络状态**/
    if (kNetworkNotReachability) {
        [METoast toastWithMessage:@"网络出错，请稍后重试"];
        [self.baseTableView.header endRefreshing];
        return;
    }
    
    _isNext = NO;
    _pageNumber = 1;
    [self sendRequest];
}

- (void)selectCity:(NSNotification *)notif{
    
    NSString *city = [notif object];
    self.cityName = city;
    _isNext = NO;
    _pageNumber = 1;
    _isCityFresh = NO;
    _isCateFresh = NO;
    _sort = 0;
    _categoryId = 0;
    _areaId = 0;
   
    if (_segmentIndex == 0) {
        [self.mySegmentControl setTitle:@"全部分类" withIndex:_segmentIndex];
        [self.mySegmentControl selectIndex:-1];
    }else if (_segmentIndex == 1){
        [self.mySegmentControl setTitle:@"全城" withIndex:_segmentIndex];
        [self.mySegmentControl selectIndex:-1];
    }else if (_segmentIndex == 2){
        [self.mySegmentControl setTitle:@"智能排序" withIndex:_segmentIndex];
        [self.mySegmentControl selectIndex:-1];
    }
    _segmentIndex = 99999;
    [self loadData];
}

- (void)reset{
    [self.baseTableView setShowsInfiniteScrolling:YES];
}

//商家列表数据绑定
- (void)updateBusinessListData:(NSArray *)objArray error:(NSError *)error{
    
    if (!_isNext) {
        
        [self.baseTableView.header endRefreshing];
        [self.businessListArray removeAllObjects];
        
        
        if(objArray.count <= 0){

//            if (_segmentIndex == 0) {
//                [self.baseTableView addSubview:[self loadNullView:@"您所选分类还没有商家" secondText:@"我们正在为此日夜奔波，请小主耐心等候"]];
//            }else if (_segmentIndex == 1){
//                [self.baseTableView addSubview:[self loadNullView:@"您所选区域还没有商家" secondText:@"我们正在为此日夜奔波，请小主耐心等候"]];
//            }else{
//                if (_segmentIndex != 2) {
                   [self.baseTableView addSubview:self.nullView];
//                }
//            }
           [self.baseTableView setShowsInfiniteScrolling:NO];
            self.myQRCode.hidden = YES;
            
        }else{
            if (_nullView) {
                [_nullView removeFromSuperview];
                _nullView = nil;
            }
            self.myQRCode.hidden = NO;
            [self reset];
        }
        
    }else{
        
        [self.baseTableView.infiniteScrollingView stopAnimating];
        if (objArray.count <= 0) {
            [self.baseTableView setShowsInfiniteScrolling:NO];
             [METoast toastWithMessage:@"没有更多数据"];

        }else{
            [self.baseTableView setShowsInfiniteScrolling:YES];
        }

    }
    
    [self.businessListArray addObjectsFromArray:objArray];
    [self.baseTableView reloadData];
    [PageBaseLoading hide_Load];

}


#pragma mark -- tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.businessListArray.count;
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
    bInfo = [self.businessListArray objectAtIndex:indexPath.row];

    [cell setWithShop:bInfo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"didSelectRowAtIndexPath");
    BusinessListInfo *bInfo = [self.businessListArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithMainTableViewClick object:bInfo];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0 hasSectionLine:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

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
    [UIView setAnimationDuration:0.4];
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
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    _myQRCode.frame = CGRectMake(_myQRCode.x, _myQRCode.y + 100, _myQRCode.width, _myQRCode.height);
    [UIView setAnimationDidStopSelector:@selector(scareAnimation)];
    [UIView commitAnimations];
    _animationFlag = YES;
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
            if (self.dataSource.count == 0) {
                [METoast toastWithMessage:@"分类信息加载失败,请稍后重试"];
                return;
            }
            
            [_cityView hidenView];
            [_sortView hidenView];
            
            if (!_isCateFresh) {
                [_categoryView bindData:self.dataSource index:index];
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
            if (self.cityDataSource.count == 0) {
                [METoast toastWithMessage:@"暂无商圈信息"];
                return;
            }
            
            [_categoryView hidenView];
            [_sortView hidenView];
            
            if (!_isCityFresh) {
                [_cityView bindData:self.cityDataSource index:index];
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
    
}

@end
