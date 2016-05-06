//
//  SceneConsumDetailController.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//


/**
 *  //这个页面主要是继承“中心”的滑动返回和自定义导航栏
 *  //加载数据
 *  //其他数据绑定及操作等功能都在子控制器中
 */

#import "SceneConsumDetailController.h"

#import "SceneConsumDetailTableController.h"
#import "SceneConsumDetailTabButtonsController.h"

#import "Masonry.h"

#import "DefineConfig.h"
#import "SceneConsumDetailRequest.h"
#import "SceneConsumGiveFavorite.h"
#import "MJExtension.h"
#import "SceneDeatilInfo.h"
#import "HYUserInfo.h"
#import "METoast.h"
#import "UIUtils.h"
#import "TYAnalyticsManager.h"
#define CSS_ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString *_tableIdentifier      = @"SceneConsumDetailTableController";
static NSString *_tabButtonsIdentifier = @"SceneConsumDetailTabButtonsController";

@interface SceneConsumDetailController ()<SceneConsumDetailTableControllerDelegae,SceneConsumDetailTabButtonsControllerDelegae>{
    CGFloat _contentOffset_Y;
    BOOL    _willHidden;
    BOOL _isLoaderror;
    SceneConsumDetailRequest *_detailRequest;
    SceneConsumGiveFavorite *_giveFavoriteRequest;
}

@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, strong) SceneConsumDetailTableController *tableController;
@property (nonatomic, strong) SceneConsumDetailTabButtonsController *tabButtonsController;
@end

@implementation SceneConsumDetailController

/******************仿中心代码***********************/
- (void)updateNavgationbarAlpha
{
    if (!_willHidden)
    {
        //            if (_contentOffset_Y + self.view.frame.size.width > 0)
        if (_contentOffset_Y  > 0)
        {
            self.navigationController.navigationBar.alpha = _contentOffset_Y * 0.01;
        }
        else
        {
            self.navigationController.navigationBar.alpha = 0;
        }
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _willHidden = NO;
    [self updateNavgationbarAlpha];
    

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CGRect rctView = self.view.frame;
    if (rctView.origin.y != 0) {
        rctView.size.height += rctView.origin.y;
        rctView.origin.y = 0;
        self.view.frame = rctView;
    }
    _willHidden = NO;
    if (!_isLoaderror) {
        [self updateNavgationbarAlpha];
    }
    
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _willHidden = YES;
    [self.navigationController.navigationBar setAlpha:1];
    [HYLoadHubView dismiss];
}
/**
 *  @brief 滑动返回时，去除分享界面。by:成才
 */
- (BOOL)canDragBack
{
    if (_tabButtonsController.isShare) {
        return NO;
    }
    return YES;
}

- (void)backToRootViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/******************仿中心代码*完**********************/


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //统计
    if (self.pageType == 0) {
        [[TYAnalyticsManager sharedManager] sendAnalyseForSceneDetailPage:FoodPackageDetailPage packId:self.packId
                                                           pageIdentifier:@"BusinessMainViewController" toPageIdentifier:NSStringFromClass([self class])];
        
    }else{
        [[TYAnalyticsManager sharedManager] sendAnalyseForSceneDetailPage:EntertainmentPackageDetailPage packId:self.packId
                                                           pageIdentifier:@"BusinessMainViewController" toPageIdentifier:NSStringFromClass([self class])];
    }
    
    [self loadData];
    self.title = @"套餐详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setAlpha:0];


}
- (void) addTwoChildViewController:(SceneDeatilInfo *)sInfo {
    
    CGRect rctView            = self.view.frame;
    CGFloat fNavbarHeight     = CGRectGetHeight(self.navigationController.navigationBar.frame) + 20.0f;
    CGFloat fFooterViewHeight = 50.0f;
    CGFloat fTableViewHeight  = CGRectGetHeight([UIScreen mainScreen].bounds) - fFooterViewHeight;
    
    // 添加tableview
    _tableController = [[SceneConsumDetailTableController alloc]initWithNibName:_tableIdentifier bundle:nil];
    _tableController.navigationbarHeight = fNavbarHeight;
    _tableController.view.frame          = CGRectMake(0, 0, CGRectGetWidth(rctView), CGRectGetMaxY(rctView) - fFooterViewHeight);
    _tableController.view.translatesAutoresizingMaskIntoConstraints = NO; //要实现自动布局，必须把该属性设置为NO
    _tableController.scrollDelegate      = self;
    [self addChildViewController:_tableController];
    [self.view addSubview:_tableController.view];
    [_tableController didMoveToParentViewController:self];
    
    //    // 添加底部的button
    _tabButtonsController                = [[SceneConsumDetailTabButtonsController alloc]initWithNibName:_tabButtonsIdentifier bundle:nil];
    _tabButtonsController.buttonDelegate = self;
    _tabButtonsController.cityName       = _cityName;
    _tabButtonsController.shareImage     = _shareImage;
    _tabButtonsController.view.frame     = CGRectMake(0, CGRectGetMaxY(rctView) - fFooterViewHeight, CGRectGetWidth(rctView), fFooterViewHeight);
    _tabButtonsController.view.translatesAutoresizingMaskIntoConstraints = NO; //要实现自动布局，必须把该属性设置为NO
    [self addChildViewController:_tabButtonsController];
    [self.view addSubview:_tabButtonsController.view];
    [_tabButtonsController didMoveToParentViewController:self];
    
    // 添加约束
    WS(weakSelf);
    [_tabButtonsController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(0);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(0);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(fFooterViewHeight);
    }];
    
    [_tableController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(0);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(0);
        make.bottom.mas_equalTo(_tabButtonsController.view.mas_top);
        make.height.mas_equalTo(fTableViewHeight);
    }];
    
    /******************仿中心代码***********************/
    // 添加左上角返回按钮
    UIImage *back_n      = [UIImage imageNamed:@"btn_back"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame     = CGRectMake(1, 22, 40, 40);
    [backButton setImage:back_n forState:UIControlStateNormal];
    [backButton setAdjustsImageWhenHighlighted:NO];
    [backButton addTarget:self action:@selector(backToRootViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    /******************仿中心代码*完**********************/
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_tableController.view.mas_left).with.offset(1);
        make.top.mas_equalTo(_tableController.view.mas_top).with.offset(22);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    weakSelf.tableController.detailInfo = sInfo;
    weakSelf.tabButtonsController.detailInfo = sInfo;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark private methods
- (void)loadData{
    
    [HYLoadHubView show];
    _detailRequest              = [[SceneConsumDetailRequest alloc] init];
    _detailRequest.interfaceURL = [NSString stringWithFormat:@"%@/v4/Scene/GetPackageDetail",BASEURL];
    _detailRequest.httpMethod   = @"POST";
    _detailRequest.postType     = JSON;
    _detailRequest.packId       = _packId;
    _detailRequest.interfaceType = DotNET2;
    
    WS(weakSelf);
    [_detailRequest sendReuqest:^(id result, NSError *error)
     {
         if(result){
             
             NSDictionary *objDic = [result jsonDic];
             
             int code = [objDic[@"code"] intValue];
    
             
             if (code == 0) {  //这种接口将成功定义为 0
                 
                 NSDictionary *dic = objDic[@"data"];
                 
                 [SceneDeatilInfo setupObjectClassInArray:^NSDictionary *{
                     return @{@"merUrlList" :@"imageUrl"};
                 }];
                 
                 [HYLoadHubView dismiss];
                 [weakSelf addTwoChildViewController:[SceneDeatilInfo objectWithKeyValues:dic]];
                 
             }else{
                 [weakSelf addNetworkErrorView:@""];
//                 [METoast toastWithMessage:msg ? msg : @"获取商家信息失败"];
                 [HYLoadHubView dismiss];
                 [weakSelf addNetworkErrorView:@"该套餐太火爆，半路被打劫了！"];
                 return ;
             }
             
         }else{
             
//             [METoast toastWithMessage:@"获取服务器数据失败"];
             [HYLoadHubView dismiss];
             [weakSelf addNetworkErrorView:@"该套餐太火爆，半路被打劫了！"];
         }
     }];
}

// 点赞网络请求
- (void) networkGiveFavorite {
    
    [HYLoadHubView show];
    _giveFavoriteRequest              = [[SceneConsumGiveFavorite alloc] init];
    _giveFavoriteRequest.interfaceURL = [NSString stringWithFormat:@"%@/v4/Scene/GiveFavorite",BASEURL];
    _giveFavoriteRequest.httpMethod   = @"POST";
    _giveFavoriteRequest.postType     = JSON;
    _giveFavoriteRequest.interfaceType = DotNET2;
    
    _giveFavoriteRequest.packId       = _packId;
    _giveFavoriteRequest.userId       = [HYUserInfo getUserInfo].userId ?: @"";
    
    WS(weakSelf);
    [_giveFavoriteRequest sendReuqest:^(id result, NSError *error)
     {
         if(result){
             
             NSDictionary *objDic = [result jsonDic];
             
             int code = [objDic[@"code"] intValue];
             NSString *msg = objDic[@"msg"];
             
             if (code == 0) {  //这种接口将成功定义为 0
                 
                 NSDictionary *dic = objDic[@"data"];
                 
                 NSString *praiseCount = dic[@"FavoriteCount"];
                 weakSelf.tabButtonsController.FavoriteCount = praiseCount;
                 [HYLoadHubView dismiss];
                 
             }else{
                 
                 [METoast toastWithMessage:msg ? msg : @"点赞失败"];
                 [HYLoadHubView dismiss];
                 return ;
             }
             
         }else{
             
             [METoast toastWithMessage:@"网络出错，请稍后重试"];
             [HYLoadHubView dismiss];
         }
     }];
}
// 添加错误显示页面
- (void) addNetworkErrorView:(NSString *)error {

    _isLoaderror = YES;
    [self.navigationController.navigationBar setAlpha:1];

    CGRect rctView            = self.view.frame;
    rctView.origin.y          = CGRectGetHeight(self.navigationController.navigationBar.frame) + 20.0f;
    UIView *viewError         = [[UIView alloc]initWithFrame:rctView];
    viewError.backgroundColor = [UIColor whiteColor];
    
    UIImageView *errImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 170.0f, rctView.size.width, 120.0f)];
    errImage.image = [UIImage imageNamed:@"ico_nosearch"];
    errImage.contentMode = UIViewContentModeCenter;
    [viewError addSubview:errImage];
    
    UILabel *lblError  = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(errImage.frame)+25.0f, rctView.size.width, 30.0f)];
    lblError.text      = error;
    lblError.font      = [UIFont systemFontOfSize:15];
    lblError.textColor = CSS_ColorFromRGB(0x606060);
    lblError.textAlignment = NSTextAlignmentCenter;
    [viewError addSubview:lblError];
    [self.view addSubview:viewError];
}
#pragma makr - subview delegate
// tableview滚动后　设置导航栏alpha
- (void) SceneConsumDetailTableControllerDidScroll:(CGFloat)contentOffset_Y {
    _contentOffset_Y = contentOffset_Y;
    [self updateNavgationbarAlpha];
}
// 点赞
- (void)SceneConsumDetailTabButtonsControllerLikeButtonClick {
    [self networkGiveFavorite];
}

- (void)dealloc{
    
    [_detailRequest cancel];
    _detailRequest = nil;
    [_giveFavoriteRequest cancel];
    _giveFavoriteRequest = nil;
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
@end
