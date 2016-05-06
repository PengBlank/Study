//
//  MainTableView.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "MainTableView.h"
#import "MainCarouselView.h"
#import "DefineConfig.h"
#import "BusinessMainCell.h"
#import "MainHeaderView.h"
#import "iCarousel.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "SVPullToRefresh.h"
#import "SceneListRequest.h"
#import "METoast.h"
#import "MJExtension.h"
#import "SceneCategoryInfo.h"
#import "SceneListInfo.h"
#import "UIView+Common.h"
#import "LoadNullView.h"
#import "PageBaseLoading.h"
@interface MainTableView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger _currentPageIndex;
    CGFloat   _lastPosition;
    BOOL      _isNext;
    BOOL      _animationFlag;
    BOOL      _showLoding;
}
@property (strong, nonatomic) iCarousel                 *myCarousel;
@property (assign, nonatomic) NSInteger                 oldSelectedIndex;
@property (strong, nonatomic) SceneListRequest          *sceneListRequest;
@property (assign, nonatomic) NSInteger                 type;
@property (nonatomic, strong) LoadNullView      *nullView;
@property (nonatomic,strong) NSMutableArray *dataArray;



@property (nonatomic,strong) NSMutableArray *modelArray;
@property (nonatomic,strong) NSString       *cityName;
@end

@implementation MainTableView
- (instancetype)initWithFrame:(CGRect)frame  type:(NSInteger)type models:(NSMutableArray *)models city:(NSString *)city
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.modelArray = models;
        self.cityName = city;
        _currentPageIndex = 1;
        

        [self setup];
    }
    return self;
}


- (void)setup{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCity:)
                                                 name:kNotificationWithSelecteCityBlock object:nil];
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(245, 245, 245);
        [self addSubview:_tableView];
    }
    
    [self addRefresh];
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
    if (_delegate && [_delegate respondsToSelector:@selector(QRcodeClickWithMainTableView)]) {
        [_delegate QRcodeClickWithMainTableView];
    }
}

- (LoadNullView *)nullView{
    if (!_nullView) {
        _nullView = [[LoadNullView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)
                                              imageName:@"shouyemeishi_picture" text:@"努力覆盖中，请小主耐心等待" secondText:nil offsetY:00];
    }
    
    return _nullView;
}

- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc] init];
    }
    
    return _modelArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}


- (void)addRefresh{
    
    WS(weakSelf);
//     MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
//                                                                 refreshingAction:@selector(loadMoreData)];
   // self.tableView.footer.automaticallyHidden = YES;
//    self.tableView.footer.automaticallyChangeAlpha = YES;
//    MJRefreshFooter *footer = self.tableView.footer;
//    [footer setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
    
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    [self.tableView setShowsInfiniteScrolling:NO];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
}

- (void)loadData{
    WS(weakSelf);
    
    if (!_showLoding) {
        [PageBaseLoading showLoading];
    }

    [_sceneListRequest cancel];
    _sceneListRequest = nil;
    SceneCategoryInfo *info = [self.modelArray objectAtIndex:self.type];
    
    _sceneListRequest               = [[SceneListRequest alloc] init];
    _sceneListRequest.interfaceURL  = [NSString stringWithFormat:@"%@/v4/Scene/GetPackageList",BASEURL];
    _sceneListRequest.httpMethod    = @"POST";
    _sceneListRequest.postType      = JSON;
    _sceneListRequest.interfaceType = DotNET2;
    
    _sceneListRequest.cityName      = self.cityName;
    _sceneListRequest.calId         = info.calId;
    _sceneListRequest.pageIndex     = _currentPageIndex;
    _sceneListRequest.pageSize      = kDefaultPageSize;
    
    [_sceneListRequest sendReuqest:^(id result, NSError *error)
     {
         
         NSArray *objArray = nil;
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             NSString *msg = objDic[@"msg"];
             if (code == 0) { //状态值为0 代表请求成功
                 NSArray *DateArray = objDic[@"data"];
                 objArray  = [SceneListInfo objectArrayWithKeyValuesArray:DateArray];
        
             }else{
                 [METoast toastWithMessage:msg ? : @"搜索商家信息失败"];
             }
         }else{
             [METoast toastWithMessage:@"搜索商家信息失败"];
         }
         
         [weakSelf updateListData:objArray error:error];
     }];
}

//商家列表数据绑定
- (void)updateListData:(NSArray *)objArray error:(NSError *)error{
    
    if (!_isNext) {
        
        [self.tableView.header endRefreshing];
        [self.dataArray removeAllObjects];
        
        
        if (objArray.count <= 0) {
            [self.tableView addSubview:self.nullView];
            self.myQRCode.hidden = YES;
            [self.tableView setShowsInfiniteScrolling:NO];
        }else{
            if (_nullView) {
                [_nullView removeFromSuperview];
                _nullView = nil;
            }
            self.myQRCode.hidden = NO;
            [self reset];
        }

    }else{

        [self.tableView.infiniteScrollingView stopAnimating];

        if (objArray.count <= 0) {
            [METoast toastWithMessage:@"没有更多数据"];
            [self.tableView setShowsInfiniteScrolling:NO];
        }else{
            [self.tableView setShowsInfiniteScrolling:YES];
        }
        
    }
    
    [self.dataArray addObjectsFromArray:objArray];
    [self.tableView reloadData];
    [PageBaseLoading hide_Load];
}

- (void)refreshData{
    
    /**检查网络状态**/
    if (kNetworkNotReachability) {
        [METoast toastWithMessage:@"网络出错，请稍后重试"];
        [self.tableView.header endRefreshing];
        return;
    }
    
    _showLoding = YES;
    _isNext = NO;
   _currentPageIndex = 1;
    [self loadData];

}

- (void)loadMoreData{
    _isNext = YES;
    _showLoding = YES;
    _currentPageIndex += 1;
    [self loadData];
}

- (void)reset{
  [self.tableView setShowsInfiniteScrolling:YES];
}

- (void)selectCity:(NSNotification *)notify{
    
    _cityName = [notify object];
    _isNext = NO;
    _showLoding = NO;
    _currentPageIndex = 1;
    [self loadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ScaleHEIGHT(250);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
//    if (section == 0) {
//        return 100 ;
//    }
//    
    return 0.000001;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section != 0) {
//        return nil;
//    }
//    MainHeaderView *view = [[MainHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
//    view.topicArray = @[@"全部",@"下午茶",@"聚餐",@"约会",@"庆生"].mutableCopy;
//    return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"BusinessMainCell";
    BusinessMainCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BusinessMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell bindData:self.dataArray[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SceneListInfo *model = self.dataArray[indexPath.section];
    NSLog(@"didSelectRowAtIndexPath");
    model.infoIndentifier = self.type;

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithMainTableViewClick object:model];

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

//- (void)share:(SceneListInfo *)sInfo{
//   
//}


@end
