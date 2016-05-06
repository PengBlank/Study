//
//  HYProductDetailViewController.m
//  Teshehui
//
//  Created by HYZB on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


#import "HYMallProductDetailWithFilterController.h"
#import "HYAdsScrollView.h"
#import "HYProductComparePriceView.h"

#import "HYMallProductManager.h"
#import "HYMallGoodsDetail.h"
#import "HYAdsScrollView.h"
#import "HYTableViewFooterView.h"

#import "HYProductDetailContentView.h"
#import "HYProductImageInfo.h"
#import "HYProductSummaryCell.h"
#import "HYProductParamInfoCell.h"
#import "HYMallMainProductListCell.h"
#import "HYProductWebView.h"
#import "HYCommentsViewController.h"
#import "HYMallCartViewController.h"
#import "HYMallSectionView.h"
#import "HYMallProductListViewController.h"
#import "HYProductServiceViewController.h"
#import "HYMallFullOrderViewController.h"
#import "HYTheMoreTheCheaperViewController.h"
#import "HYUpdateToOfficialUserViewController.h"
#import "HYMallCartShopInfo.h"

#import "HYUserInfo.h"
#import "HYMallStoreInfo.h"
#import "HYMallHomeItemsInfo.h"

#import "HYMallGoodDetailRequest.h"
#import "HYMallAddShoppingCarReq.h"
#import "HYMallAddFavoriteRequest.h"
#import "HYComparePriceRequest.h"
#import "HYComparePriceResponse.h"
#import "HYShareInfoReq.h"
#import "HYCommentsViewController.h"
#import "HYMediaPlayViewController.h"

#import "HYAppDelegate.h"
#import "UMSocial.h"
#import "METoast.h"
#import "SDWebImageManager.h"
#import "HYHYMallOrderListFilterView.h"
#import "HYProductSKUSelectView.h"
#import "HYMallSearchGoodResponse.h"
#import "HYPromoteSellingRequest.h"
#import "HYPromoteSellingResponse.h"
#import "HYProductSpareAmount.h"
#import "HYProductPraiseAnimation.h"
#import "UIImageView+WebCache.h"
#import "HYAnalyticsManager.h"
#import "HYVisitObjectReq.h"
#import "HYUpgradeAlertView.h"
#import "HYUserService.h"
#import "HYPaymentViewController.h"
#import "HYSiRedPacketsViewController.h"
#import "NSObject+cc_introspect.h"

#import "HYProductComparePriceViewModel.h"
#import "HYProductComparePriceDataController.h"
#import "HYProductDetailAdsScrollView.h"

#import "HYProductDetailGuessYouLikeReq.h"
#import "HYProductDetailGuessYouLikeResponse.h"

#import "HYMallGuessYouLikeCell.h"
#import "HYProductQrcodeView.h"

#import "HYMallBrandCellBtn.h"
#import "HYQueryUserBadgeDataService.h"
#import "HYProductDetailSBCell2.h"

/// 环信
#import "HYChatManager.h"

CGFloat const kTableViewHeaderHeight = 300.0;

@interface HYMallProductDetailWithFilterController ()
<
HYProductDetailAdsScrollViewDataSource,
HYProductDetailAdsScrollViewDelegate,
HYMallProductListCellDelegate,
UIAlertViewDelegate,
UIWebViewDelegate,
HYProductSummaryCellDelegate,
HYProductSKUSelectViewDelegate,
HYProductDetailToolViewDelegate,
UMSocialUIDelegate
>
{
    HYMallGoodDetailRequest *_getGoodDetailReq;
    HYMallAddShoppingCarReq *_addShopCarReq;
    HYPromoteSellingRequest *_promoteReq;
    
    HYMallAddFavoriteRequest *_addFavoriteReq;
    HYComparePriceRequest *_comparePriceReq;
    HYShareInfoReq *_getShareInfoReq;
    
    HYProductDetailGuessYouLikeReq *_guessYouLikeReq;
    
    BOOL _isSelectedSKU;
    BOOL _willHidden;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYProductDetailAdsScrollView *tableHeaderView;
@property (nonatomic, strong) HYProductSKUSelectView *skuSelectView;
@property (nonatomic, strong) UIButton *cartBtn;

@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIWebView *detailWeb;

@property (nonatomic, strong) UIButton *scrollToTopBtn;  //滑动到顶部

@property (nonatomic, strong) HYMallProductManager *productManager;
@property (nonatomic, strong) HYMallGoodsDetail *goodsDetail;
@property (nonatomic, strong) HYComparePriceModel *comparePriceModel;

@property (nonatomic, strong) NSArray *skuImages;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, assign) BOOL isShare;

@property (nonatomic, strong) HYUserService *userService;

@property (nonatomic, strong) HYProductComparePriceDataController *productComparePriceDataController;
@property (nonatomic, strong) HYProductComparePriceViewModel *comparePriceViewModel;
@property (nonatomic, strong) HYQueryUserBadgeDataService *service;

@property (nonatomic, copy) NSArray *guessYouLikeList;

@end

@implementation HYMallProductDetailWithFilterController

- (HYUserService *)userService
{
    if (!_userService) {
        _userService = [[HYUserService alloc] init];
    }
    return _userService;
}

- (void)dealloc
{
    [_guessYouLikeReq cancel];
    _guessYouLikeReq = nil;
    
    [_comparePriceReq cancel];
    _comparePriceReq = nil;
    
    [_getGoodDetailReq cancel];
    _getGoodDetailReq = nil;
    
    [_addShopCarReq cancel];
    _addShopCarReq = nil;
    
    [_addFavoriteReq cancel];
    _addFavoriteReq = nil;
    
    [_promoteReq cancel];
    _promoteReq = nil;
    
    [_getShareInfoReq cancel];
    _getShareInfoReq = nil;
    
    _tableHeaderView.delegate = nil;
    _tableHeaderView.dataSource = nil;
    _tableHeaderView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isLoading = NO;
        _isSelectedSKU = NO;
        _isShare = NO;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
                                           alpha:1.0];
    self.view = view;
    
    frame.size.height -= 44.0;
    frame.size.height -= 64.0;
    
    //tableview
    _tableView = [[UITableView alloc] initWithFrame:frame
                                              style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.contentInset = UIEdgeInsetsMake(frame.size.width, 0, 0, 0);
    _tableView.sectionHeaderHeight = 0;
    _tableView.bouncesZoom = YES;
    
    self.tableHeaderView = [[HYProductDetailAdsScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         -frame.size.width,
                                                                         frame.size.width,
                                                                         frame.size.width)];
    _tableHeaderView.delegate = self;
    _tableHeaderView.dataSource = self;
    [_tableView addSubview:_tableHeaderView];
    [self.view addSubview:_tableView];
    
    UILabel *drag = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 40)];
    drag.backgroundColor = [UIColor clearColor];
    drag.textColor = [UIColor grayColor];
    drag.font = [UIFont systemFontOfSize:14.0];
    drag.textAlignment = NSTextAlignmentCenter;
    drag.text = @"继续拖动，查看图文详情";
    _tableView.tableFooterView = drag;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
//    [self.navigationController.navigationBar setAlpha:0];
    
    if (!self.goodsDetail)
    {
        [self getGoodsDetailInfo];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateBadge];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //重新加载
    HYProductSummaryCell *cell = (HYProductSummaryCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                          inSection:0]];
    if (cell)
    {
        [cell setPlayAnimations:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)backToRootViewController:(id)sender
{
    if (self.loadFromPayResult)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  @brief 滑动返回时，去除分享界面。by:成才
 */
- (BOOL)canDragBack
{
    if (_isShare) {
        return NO;
    }
    return YES;
}

#pragma mark setter/getter
- (void)setGoodsDetail:(HYMallGoodsDetail *)goodsDetail
{
    if (goodsDetail != _goodsDetail)
    {
        _goodsDetail = goodsDetail;
        
        [self.tableView reloadData];
//        [self.tableHeaderView reloadData];
        
        //统计
        [[HYAnalyticsManager sharedManager] sendProductDetailVisit:goodsDetail
                                                             stgId:self.stgId];
        
        //加载详情
        [self.detailWeb loadHTMLString:goodsDetail.productDescription
                               baseURL:nil];
    }
}

- (UIButton *)scrollToTopBtn
{
    if (!_scrollToTopBtn)
    {
        _scrollToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scrollToTopBtn.frame = CGRectMake(CGRectGetMaxX(self.view.frame)-58,
                                           CGRectGetHeight(self.view.frame)-104,
                                           50,
                                           50);
        [_scrollToTopBtn setImage:[UIImage imageNamed:@"icon_returnUp"]
                         forState:UIControlStateNormal];
        [_scrollToTopBtn addTarget:self
                            action:@selector(scrollViewToTopEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_scrollToTopBtn];
    }
    
    return _scrollToTopBtn;
}

- (UIView *)tableFooterView
{
    if (!_tableFooterView)
    {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.frame))];
        _tableFooterView.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                                           green:237.0/255.0
                                                            blue:237.0/255.0
                                                           alpha:1.0];;
        
        UILabel *drag = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  12,
                                                                  self.view.frame.size.width,
                                                                  20)];
        drag.backgroundColor = [UIColor clearColor];
        drag.textColor = [UIColor grayColor];
        drag.font = [UIFont systemFontOfSize:14.0];
        drag.textAlignment = NSTextAlignmentCenter;
        drag.text = @"下拉，返回商品简介";
        [_tableFooterView addSubview:drag];
        
        _detailWeb = [[UIWebView alloc] initWithFrame:
                      CGRectMake(0,
                                 44,
                                 CGRectGetWidth(_tableFooterView.frame),
                                 CGRectGetHeight(_tableFooterView.frame)-44)];
        _detailWeb.backgroundColor = [UIColor whiteColor];
        _detailWeb.delegate = self;
        _detailWeb.scalesPageToFit = YES;
        _detailWeb.scrollView.delegate = self;
        _detailWeb.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _detailWeb.backgroundColor = [UIColor clearColor];
        [_tableFooterView addSubview:_detailWeb];

    }
    return _tableFooterView;
}

- (HYMallProductManager *)productManager
{
    if (!_productManager)
    {
        _productManager = [[HYMallProductManager alloc] init];
    }
    
    return _productManager;
}

- (HYProductSKUSelectView *)skuSelectView
{
    if (!_skuSelectView)
    {
        _skuSelectView = [[HYProductSKUSelectView alloc] initWithFrame:CGRectZero];
        _skuSelectView.delegate = self;
    }
    
    return _skuSelectView;
}

#pragma mark - private methods
- (void)fetchPrefrenceData
{
    if (!_guessYouLikeReq)
    {
        _guessYouLikeReq = [[HYProductDetailGuessYouLikeReq alloc]init];
    }
    [_guessYouLikeReq cancel];
//    _guessYouLikeReq.brandCode = self.goodsDetail.brandId;
//    _guessYouLikeReq.categoryCode = self.goodsDetail.categoryId;
    _guessYouLikeReq.productCode = self.goodsDetail.productId;
    _guessYouLikeReq.recType = @"3";
    
    WS(weakSelf);
    [_guessYouLikeReq sendReuqest:^(HYProductDetailGuessYouLikeResponse *result, NSError *error) {
        if (result.dataList.count > 0)
        {
            weakSelf.guessYouLikeList = [result.dataList copy];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)fetchComparePriceData
{
    self.productComparePriceDataController = [[HYProductComparePriceDataController alloc]init];
    self.productComparePriceDataController.productId = self.goodsDetail.productId;
    
    WS(weakSelf);
    [self.productComparePriceDataController fetchComparePriceDataWithBlock:^(HYComparePriceModel *data) {
        if (data)
        {
            [weakSelf bindCompareDataWithModel:data];
            weakSelf.tableHeaderView.hasComparePriceData = YES;
        }
        
        [weakSelf.tableHeaderView setGoodDetail:weakSelf.goodsDetail];
        [weakSelf.tableView reloadData];
    }];
}

- (void)bindCompareDataWithModel:(HYComparePriceModel *)data
{
    HYProductComparePriceViewModel *viewModel = [[HYProductComparePriceViewModel alloc]init];
    viewModel.priceModel = data;
    viewModel.detailModel = self.goodsDetail;
    
    self.comparePriceViewModel = viewModel;
}

/*
- (void)updateNavgationbarAlpha
{
    if (!_willHidden)
    {
        if (self.tableView.contentOffset.y + self.view.frame.size.width > 0)
        {
            self.navigationController.navigationBar.alpha = (self.tableView.contentOffset.y + self.view.frame.size.width)/64.0;
        }
        else
        {
            self.navigationController.navigationBar.alpha = 0;
        }
    }
}
 */

- (void)calculatePriceWithQunatityCallBack:(void(^)(BOOL finished))callBack
{
    NSMutableArray *skuInfos = [NSMutableArray array];

    if (self.goodsDetail.currentsSUK.productSKUId && self.goodsDetail.currentsSUK.quantity)
    {
        [skuInfos addObject:@{@"productSKUId": self.goodsDetail.currentsSUK.productSKUId,
                              @"quantity": [NSNumber numberWithInteger:self.goodsDetail.currentsSUK.quantity]}];
    }
    
    [HYLoadHubView show];
    
    _promoteReq = [[HYPromoteSellingRequest alloc] init];
    _promoteReq.productSKUInfos = skuInfos;
    _promoteReq.settleType = HYSettleTypeProductDetail;
    __weak typeof(self) bself = self;
    [_promoteReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        
        //callback
        callBack(YES);
        
        if (!error && [result isKindOfClass:[HYPromoteSellingResponse class]])
        {
            HYPromoteSellingResponse *response = (HYPromoteSellingResponse *)result;
            
            [bself updateWithResponse:response];
        }
        else
        {
            [METoast toastWithMessage:error.domain];
        }
    }];
}

- (void)updateWithResponse:(HYPromoteSellingResponse *)response
{
    HYSpareItem *item = [response.spareAmount.productSKUArray lastObject];
    self.goodsDetail.currentsSUK.points = item.spareAmount;
    self.goodsDetail.currentsSUK.price = item.amount;
    self.goodsDetail.currentsSUK.discountRate = item.discountRate;
    self.goodsDetail.currentsSUK.totalPrice = response.spareAmount.totalAmount;
    self.goodsDetail.currentsSUK.totalPoint = response.spareAmount.totalSpareAmount;
    
    //update
    [self.skuSelectView updatePriceInfo];
    [self.tableView reloadData];
}

- (void)scrollViewToTopEvent:(id)sender
{
    [self.tableView setContentOffset:CGPointMake(0, -self.view.frame.size.width)
                            animated:YES];
    
    if (self.tableView.frame.origin.y < 0)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kRestoreNavTitleView"
                                                           object:nil];
        
        [UIView animateWithDuration:.3 animations:^{
            _tableView.frame = CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height);
            _tableFooterView.frame = CGRectMake(0, _tableView.frame.size.height, _tableFooterView.frame.size.width, _tableFooterView.frame.size.height);
        }];
    }
    
    [self.scrollToTopBtn setHidden:YES];
}

- (void)shareProduct:(id)sender
{
    // 朋友分享
    [MobClick event:@"v430_shangcheng_shangpinxiangqing_pengyoufenxiang_jishu"];
    
    NSString *userid = [HYUserInfo getUserInfo].userId;
    if (userid.length == 0)
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
    else
    {
        if (!self.isShare)
        {
            //统计
            HYFeedbackItemInfo *item = [[HYFeedbackItemInfo alloc] init];
            item.item_code = self.goodsDetail.productId;
            item.category_code = self.goodsDetail.categoryId;
            item.brand_code = self.goodsDetail.brandId;
            item.tsh_price = self.goodsDetail.currentsSUK.price;
            [[[HYAnalyticsManager alloc] init] feedbackEventWith:[NSArray arrayWithObject:item]
                                                            type:@"3"
                                                           stgid:self.stgId];
            
            _getShareInfoReq = [[HYShareInfoReq alloc] init];
            _getShareInfoReq.user_id = [[HYUserInfo getUserInfo] userId];
            _getShareInfoReq.type = @"2";
            _getShareInfoReq.price = self.goodsDetail.currentsSUK.points;
            
            self.isShare = YES;
            __weak typeof(self) b_self = self;
            [_getShareInfoReq sendReuqest:^(HYShareInfoResp *res, NSError *error)
             {
                 [HYLoadHubView dismiss];
                 
                 if (res.status == 200)
                 {
                     NSData *imgData = nil;
                     if (res.imgurl)
                     {
                         imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:res.imgurl]];
                     }
                     else
                     {
                         imgData = UIImageJPEGRepresentation([UIImage imageNamed:@"share_icon"], 1);
                     }
                     
                     [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;  //使用app类型的时候分享到会话无法跳转
                     [UMSocialData defaultData].extConfig.title = res.title;
                     [UMSocialData defaultData].extConfig.wechatSessionData.url = res.url;
                     [UMSocialData defaultData].extConfig.wechatTimelineData.url = res.url;
                     [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
                     [UMSocialData defaultData].extConfig.qqData.url = res.url;
                     [UMSocialData defaultData].extConfig.qzoneData.title = res.title;
                     [UMSocialData defaultData].extConfig.qzoneData.url = res.url;
                     [UMSocialData defaultData].extConfig.qqData.title = res.title;
                     
                     [UMSocialSnsService presentSnsIconSheetView:self
                                                          appKey:uMengAppKey
                                                       shareText:[NSString stringWithFormat:@"%@%@", res.msg, res.url]
                                                      shareImage:imgData
                                                 shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,nil]
                                                        delegate:self];
                 }
                 else
                 {
                     b_self.isShare = NO;
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:res.rspDesc
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                     [alert show];
                 }
             }];
        }
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
    //朋友分享-分享成功
    [MobClick event:@"v430_shangcheng_shangpinxiangqing_pengyoufenxiang_fenxiangchenggong_jishu"];
    
    _isShare = NO;
}


/**
 *  获取商品详情
 */
- (void)getGoodsDetailInfo
{
    [HYLoadHubView show];
    
    _getGoodDetailReq = [[HYMallGoodDetailRequest alloc] init];
    _getGoodDetailReq.productId = self.goodsId;
    _getGoodDetailReq.userId = [[HYUserInfo getUserInfo] userId];
    
    __weak typeof(self) b_self = self;
    [_getGoodDetailReq sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        
        if (!error && [result isKindOfClass:[HYMallGoodDetailResponse class]])
        {
            HYMallGoodDetailResponse *response = (HYMallGoodDetailResponse *)result;
            b_self.goodsDetail = response.goodDetailInfo;
            
            [b_self fetchComparePriceData];
            [b_self.tableHeaderView setDataSource:b_self];

            [b_self fetchPrefrenceData];
            [b_self updateBadge];
        }
        else
        {
            [METoast toastWithMessage:@"获取商品详情失败"];
        }
    }];
}

/**
 *  选择sku
 */
- (void)selectSKU
{
    //颜色尺码选择栏
    [MobClick event:@"v430_shangcheng_shangpinxiangqing_yansechimaxuanzelan_jishu"];
    
    _isSelectedSKU = YES;
    [self.skuSelectView setGoodsDetail:self.goodsDetail];
    [self.skuSelectView showWithAnimation:YES];
}

- (void)updateFavoriteResult:(BOOL)result error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (error)
    {
        [METoast toastWithMessage:error.domain];
    }
    else if (result)
    {
        [_toolView setIsCollect:result];
        [METoast toastWithMessage:@"收藏成功"];
        
        //本地点赞+1
        self.goodsDetail.favorCount = [NSString stringWithFormat:@"%d",
                                        (int)(_goodsDetail.favorCount.integerValue+1)];
        [self.tableView reloadData];
    }
    else
    {
        [METoast toastWithMessage:@"收藏失败"];
    }
}

- (void)updateAddShopCarResult:(BOOL)result error:(NSError *)error
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    
    if (!error && result)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:kShoppingCarHasNew];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [METoast toastWithMessage:@"商品已成功加入购物车"];
        
        if (self.skuImages.count > 0)
        {
            CGRect from = self.toolView.addBtn.frame;
            from = [self.toolView convertRect:from toView:self.view];
            CGRect to = self.cartBtn.frame;
            
            UIImageView *product = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            product.frame = CGRectMake(CGRectGetMidX(from)-25, CGRectGetMidY(from)-25, 70, 70);
            [product sd_setImageWithURL:[NSURL URLWithString:self.skuImages[0]] placeholderImage:[UIImage imageNamed:@"loading"]];
            [self.view addSubview:product];
            [UIView animateWithDuration:1 animations:^{
                product.frame = to;
                product.transform = CGAffineTransformMakeScale(0.4, 0.4);
                
            } completion:^(BOOL finished) {
                [product removeFromSuperview];
            }];
            
            CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rotation.duration = 1.0;
            rotation.repeatCount = CGFLOAT_MAX;
            rotation.fromValue = @(0);
            rotation.toValue = @(M_PI*2);
            [product.layer addAnimation:rotation forKey:@"rotation"];
        }
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:error.domain
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - HYProductSummaryCellDelegate
- (void)beginRighting
{
    HYProductServiceViewController *vc = [[HYProductServiceViewController alloc]init];
    vc.title = @"维权";
    vc.webUrl = @"http://m.teshehui.com/index.php?app=users&act=rights";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)qrcodeAction
{
    //二维码
    [MobClick event:@"v430_shangcheng_shangpinxiangqing_erweima_jishu"];
    
    HYProductQrcodeView *view = [HYProductQrcodeView instanceView];
    view.productId = self.goodsDetail.productId;
    [view show];
}

- (void)playVideoWithUrl
{
    NSString *trimmedString = [self.goodsDetail.productVideoUrl stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:trimmedString];
    HYMediaPlayViewController *vc = [[HYMediaPlayViewController alloc] initWithContentURL:url];
//    vc.mediaUrl = url;
    [self presentMoviePlayerViewControllerAnimated:vc];
    /*
    [self.navigationController presentViewController:vc
                                            animated:YES
                                          completion:nil];
     */
}

- (void)shareProduct
{
    [self shareProduct:nil];
}

- (void)memberUpgrad
{
    HYUpgradeAlertView *alert = [[HYUpgradeAlertView alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
    [alert showWithAnimation:YES];
    alert.handler = ^(NSInteger buttonIndex)
    {
        if (buttonIndex == 0)
        {
            [HYLoadHubView show];
            WS(weakSelf);
            [self.userService upgradeWithNoPolicy:^(HYUserUpgradeResponse *response)
             {
                 [HYLoadHubView dismiss];
                 if (response.status == 200)
                 {
                     HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
                     payVC.navbarTheme = weakSelf.navbarTheme;
                     payVC.amountMoney = response.orderAmount;
                     payVC.orderID = response.orderId;
                     payVC.orderCode = response.orderNumber;
                     payVC.type = Pay_Upgrad;
                     payVC.productDesc = [NSString stringWithFormat:@"【特奢汇】在线购卡: %@", response.orderNumber]; //商品描述
                     
                     [weakSelf.navigationController pushViewController:payVC animated:YES];
                     
                     payVC.paymentCallback = ^(HYPaymentViewController *payvc, id data)
                     {
                         [payvc.navigationController popViewControllerAnimated:YES];
                         
                         HYSiRedPacketsViewController *vc = [[HYSiRedPacketsViewController alloc]initWithNibName:@"HYSiRedPacketsViewController" bundle:nil];
                         vc.cashCard = @"1000";
                         [weakSelf presentViewController:vc animated:YES completion:nil];
                     };
                 }
             }];
        }
        else if (buttonIndex == 1)
        {
            //升级会员
            HYUpdateToOfficialUserViewController *vc = [HYUpdateToOfficialUserViewController new];
            //            HYMemberUpgradeViewController *vc = [[HYMemberUpgradeViewController alloc] init];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
    };
    
//    HYUpdateToOfficialUserViewController *vc = [HYUpdateToOfficialUserViewController new];
//    [self.navigationController pushViewController:vc
//                                         animated:YES];
}

- (void)quantityChange:(NSUInteger)quantity callBack:(void(^)(BOOL finished))callBack
{
    
    self.goodsDetail.currentsSUK.quantity = quantity;
    
    //重新计算价格
    [self calculatePriceWithQunatityCallBack:callBack];
}

- (void)checkServiceDesc
{
    //商品服务说明栏
    [MobClick event:@"v430_shangcheng_shouye_feileitubiao_jishu"];
    
    HYProductServiceViewController *vc = [[HYProductServiceViewController alloc]init];
    vc.webUrl = @"http://m.teshehui.com/index.php?app=users&act=service";
    vc.title = @"商品服务";
    [self.navigationController pushViewController:vc animated:YES];
    
    /*
    HYTheMoreTheCheaperViewController *vc = [[HYTheMoreTheCheaperViewController alloc]initWithNibName:@"HYTheMoreTheCheaperViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
     */
}

- (void)comparePrice
{
    //我要比价
    
    if (self.goodsDetail.productId)
    {
        NSDictionary *dict = @{@"ProudctID":self.goodsDetail.productId};
        [MobClick event:@"v430_shangcheng_shangpinxiangqing_woyaobijia_jishu"
             attributes:dict];
    }
    
    HYProductComparePriceView *view = [HYProductComparePriceView instanceView];
    view.delegate = self;
    [view setData:self.comparePriceViewModel];
    [view show];
}

#pragma mark -HYProductDetailToolViewDelegate
/**
 *  环信
 */
- (void)setupHuanXin
{
    //检查登录
    [[HYChatManager sharedManager] chatLogin];
    
    // 对象
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    [muDic setObject:@"order"
              forKey:@"type"];
    if (self.goodsDetail.productName)
    {
        [muDic setObject:self.goodsDetail.productName
                  forKey:@"title"];
    }
    
    if ([self.goodsDetail skuDesc])
    {
        [muDic setObject:[self.goodsDetail skuDesc]
                  forKey:@"desc"];
    }
    
    if (self.goodsDetail.currentsSUK.price)
    {
        [muDic setObject:self.goodsDetail.currentsSUK.price
                  forKey:@"price"];
    }
    
    if ([self.skuImages count])
    {
        [muDic setObject:self.skuImages[0]
                  forKey:@"img_url"];
    }
    if (self.goodsDetail.productOrderUrl)
    {
        [muDic setObject:self.goodsDetail.productOrderUrl
                  forKey:@"item_url"];
    }
    
    ChatViewController *vc = [[ChatViewController alloc] initWithChatter:kCustomerHXId
                                                                    type:eAfterSaleType];
    vc.commodityInfo = [muDic copy];
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

/**
 *  添加到购物车
 */
- (void)addToShoppingCar
{
    if (!_isSelectedSKU)
    {
        [self selectSKU];
    }
    else
    {
        
        BOOL _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
        if (!_isLogin)
        {
            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loadLoginView];
        }
        else
        {
            if (!_isLoading)
            {
                //底部-加入购物车
                if (self.goodsId)
                {
                    NSDictionary *dict = @{@"ProudctID":self.goodsId};
                    [MobClick event:@"v430_shangcheng_shangpinxiangqing_dibu_jiarugouwuche_jishu"
                         attributes:dict];
                }
                
                if ([self.goodsDetail.currentsSUK.productSKUId length] > 0)
                {
                    if (self.goodsDetail.currentsSUK.stock.integerValue < self.goodsDetail.currentsSUK.quantity)
                    {
                        [METoast toastWithMessage:[NSString stringWithFormat:@"您最多只能购买%ld件",(long)self.goodsDetail.currentsSUK.stock.integerValue ]];
                    }
                    else
                    {
                        _isLoading = YES;
                        
                        [HYLoadHubView show];
                        
                        HYUserInfo *user = [HYUserInfo getUserInfo];
                        
                        _addShopCarReq = [[HYMallAddShoppingCarReq alloc] init];
                        _addShopCarReq.productSKUId = self.goodsDetail.currentsSUK.productSKUId;
                        _addShopCarReq.userId = user.userId;
                        _addShopCarReq.quantity = self.goodsDetail.currentsSUK.quantity;
                        
                        __weak typeof(self) b_self = self;
                        [_addShopCarReq sendReuqest:^(id result, NSError *error) {
                            BOOL succ = NO;
                            if (!error && [result isKindOfClass:[HYMallAddOrdersResponse class]])
                            {
                                HYMallAddOrdersResponse *response = (HYMallAddOrdersResponse *)result;
                                if (response.status == 200)
                                {
                                    succ = YES;
                                    [b_self updateBadge];
                                }
                            }
                            
                            [b_self updateAddShopCarResult:succ error:error];
                        }];
                        
                        //统计
                        HYFeedbackItemInfo *item = [[HYFeedbackItemInfo alloc] init];
                        item.item_code = self.goodsDetail.productId;
                        item.category_code = self.goodsDetail.categoryId;
                        item.brand_code = self.goodsDetail.brandId;
                        item.tsh_price = self.goodsDetail.currentsSUK.price;
                        
                        [[[HYAnalyticsManager alloc] init] feedbackEventWith:[NSArray arrayWithObject:item]
                                                                        type:@"2"
                                                                       stgid:self.stgId];
                    }
                }
                else
                {
                    [self selectSKU];
                }
            }
        }
    }
}

- (void)updateBadge
{
    HYQueryUserBadgeDataService __strong *service =  [[HYQueryUserBadgeDataService alloc]init];
    self.service = service;
    [service queryUserInfoViewBadgeWithType:ShoppingCartBadge callback:^(NSArray *countInfo, NSError *err) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"cartBadge" object:countInfo];
    }];
}

- (void)checkMoreProductWithStore
{
    HYMallStoreInfo  *store = [[HYMallStoreInfo alloc] init];

    if (self.goodsId && self.goodsDetail.storeId)
    {
        //进入店铺
        NSDictionary *dict = @{@"ProudctID":self.goodsId, @"ShopID":self.goodsDetail.storeId};
        [MobClick event:@"v430_shangcheng_shangpinxiangqing_jinrudianpu_jishu" attributes:dict];
        
        //底部-进店
        NSDictionary *dictBottom = @{@"ProudctID":self.goodsId, @"ShopID":self.goodsDetail.storeId};
        [MobClick event:@"v430_shangcheng_shangpinxiangqing_dibu_jindian_jishu" attributes:dictBottom];
    }
    
    store.store_id = self.goodsDetail.storeId;
    store.store_name = self.goodsDetail.storeName;
    
    HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithStoreId:self.goodsDetail.storeId];
    req.searchType = @"10";
    
    HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
    vc.title = self.goodsDetail.storeName;
    vc.getSearchDataReq = req;
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
}

/**
 *  收藏商品
 */
- (void)collectProduct
{
    //底部-收藏
    if (self.goodsId)
    {
        NSDictionary *dict = @{@"ProudctID":self.goodsId};
        [MobClick event:@"v430_shangcheng_shangpinxiangqing_dibu_shoucang_jishu"
             attributes:dict];
    }
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    if (user.userId)
    {
        [HYLoadHubView show];
        _addFavoriteReq = [[HYMallAddFavoriteRequest alloc] init];
        _addFavoriteReq.goodsId = self.goodsId;
        _addFavoriteReq.userid = user.userId;
        
        __weak typeof(self) b_self = self;
        [_addFavoriteReq sendReuqest:^(id result, NSError *error) {
            BOOL succ = NO;
            if (!error && [result isKindOfClass:[HYMallAddFavoriteResponse class]])
            {
                HYMallAddFavoriteResponse *response = (HYMallAddFavoriteResponse *)result;
                succ = response.status == 200;
            }
            
            [b_self updateFavoriteResult:succ error:error];
        }];
        
        //统计
        HYFeedbackItemInfo *item = [[HYFeedbackItemInfo alloc] init];
        item.item_code = self.goodsDetail.productId;
        item.category_code = self.goodsDetail.categoryId;
        item.brand_code = self.goodsDetail.brandId;
        item.tsh_price = self.goodsDetail.currentsSUK.price;
        
        [[[HYAnalyticsManager alloc] init] feedbackEventWith:[NSArray arrayWithObject:item]
                                                        type:@"1"
                                                       stgid:self.stgId];
    }
    else
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
}

- (void)buyNow
{
    if (!_isSelectedSKU)
    {
        [self selectSKU];
    }
    else
    {
        HYUserInfo *user = [HYUserInfo getUserInfo];
        if (user.userId)
        {
            if (self.goodsDetail.currentsSUK)  //有sku
            {
                //底部-立即购买
                if (self.goodsId)
                {
                    NSDictionary *dict = @{@"ProudctID":self.goodsId};
                    [MobClick event:@"v430_shangcheng_shangpinxiangqing_dibu_lijigoumai_jishu"
                         attributes:dict];
                }
                
                if (self.goodsDetail.currentsSUK.stock.integerValue < self.goodsDetail.currentsSUK.quantity)
                {
                    [METoast toastWithMessage:[NSString stringWithFormat:@"您最多只能购买%ld件",(long)self.goodsDetail.currentsSUK.stock.integerValue ]];
                }
                else
                {
                    HYMallCartShopInfo *store = [[HYMallCartShopInfo alloc] init];
                    store.supplierType = self.goodsDetail.supplierType;
                    store.store_id = self.goodsDetail.storeId;
                    store.store_name = self.goodsDetail.storeName;
                    store.isSelect = YES;
                    store.quantity = [NSString stringWithFormat:@"%d", (int)self.goodsDetail.currentsSUK.quantity];
                    
                    HYMallCartProduct *product = [[HYMallCartProduct alloc] init];
                    product.userId = user.userId;
                    product.businessType = self.goodsDetail.businessType;
                    product.productId = self.goodsDetail.productId;
                    product.productName = self.goodsDetail.productName;
                    product.supplierType = self.goodsDetail.supplierType;
                    
                    HYImageInfo *image = [self.goodsDetail.currentsSUK.productSKUImagArray objectAtIndex:0];
                    product.productSKUPicUrl = [image defaultURL];
                    product.productSKUImage = image;
                    product.productSKUId = self.goodsDetail.currentsSUK.productSKUId;
                    product.productSKUSpecification = [self.goodsDetail skuDesc];
                    product.salePoints = self.goodsDetail.currentsSUK.points;
                    product.salePrice = self.goodsDetail.currentsSUK.price;
                    product.quantity = [NSString stringWithFormat:@"%d", (int)self.goodsDetail.currentsSUK.quantity];
                    product.subTotalPoints = self.goodsDetail.currentsSUK.totalPoint;
                    product.subTotal = self.goodsDetail.currentsSUK.totalPrice;
                    product.isSelect = YES;
                    product.attributeValue1 = _goodsDetail.currentsSUK.attributeValue1;
                    product.attributeValue2 = _goodsDetail.currentsSUK.attributeValue2;
                    product.brandId = _goodsDetail.brandId;
                    
                    store.goods = [NSArray arrayWithObject:product];
                    
                    HYMallFullOrderViewController *vc = [[HYMallFullOrderViewController alloc] init];
                    vc.storeList = [NSArray arrayWithObject:store];
                
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                }
            }
            else  //去选择sku
            {
                [self selectSKU];
            }
        }
        else
        {
            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loadLoginView];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        HYMallCartViewController *vc = [[HYMallCartViewController alloc] init];
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

#pragma mark - HYAdsScrollViewDataSource
- (NSArray *)adsContents
{
    if (![self.skuImages count])
    {
        NSMutableArray *tempBigArr = [[NSMutableArray alloc] init];
        
        for (HYImageInfo *image in self.goodsDetail.currentsSUK.productSKUImagArray)
        {
            NSString *bigUrl = [NSString stringWithFormat:@"%@_%@", image.imageUrl, ImageSizeBig];
            [tempBigArr addObject:bigUrl];
       
        }
        
        self.skuImages = [tempBigArr copy];
    }
    
    return self.skuImages;
}

#pragma mark - HYAdsScrollViewDelegate
- (void)didClickAdsIndex:(NSInteger)index
{
    // 商品主图
    [MobClick event:@"v430_shangcheng_shangpinxiangqing_shangpinzhutu_jishu"];
    
    HYProductWebView *webView = [[HYProductWebView alloc] initWithFrame:_tableHeaderView.bounds];
    webView.htmlStr = self.goodsDetail.productDescription;
    [webView showWithAnimation:YES];
}

#pragma mark - HYProductSKUSelectViewDelegate
- (void)didDismiss
{
    [self.tableView reloadData];
}

- (void)didFinished
{
    self.skuImages = nil;
    [_tableHeaderView reloadData];
    [self.tableView reloadData];
    [self.toolView setIsCanBuy:([self.goodsDetail.currentsSUK.stock intValue] > 0)];
}

- (void)didFinishedSelectSKUToAddShoppingCar:(BOOL)addCar
{
    self.skuImages = nil;
    [_tableHeaderView reloadData];
    [self.tableView reloadData];
    [self.toolView setIsCanBuy:([self.goodsDetail.currentsSUK.stock intValue] > 0)];
    
    if (addCar)
    {
        [self addToShoppingCar];
    }
    else
    {
        [self buyNow];
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView)
    {
        return self.guessYouLikeList.count > 0 ? 4 : 3;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView)
    {
        return 1;
    }
    else
    {
        return [self.productManager section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 5;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView)
    {
        CGFloat height = 44;
        if (indexPath.section==0)
        {
            return TFScalePoint(100)+120;
        }
        if (indexPath.section == 3)
        {
            return TFScalePoint(90)+80;
        }
        return height;
    }
    else
    {
        return TFScalePoint(246);
    }
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow-1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)  //摘要
    {
        static NSString *summaryCellId = @"summaryCellId";
        HYProductSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:summaryCellId];
        if (!cell)
        {
            cell = [[HYProductSummaryCell alloc]initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:summaryCellId];
            cell.delegate = self;
            cell.separatorLeftInset = 0.0f;
            cell.hiddenLine = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //wap 的唯一标示 stg_id
        cell.stgId = self.stgId;
        [cell setGoodsDetail:self.goodsDetail];
        return cell;
    }
    else if (1 == indexPath.section)
    {
        static NSString *pSKUtParmaInfoCellId = @"pSKUtParmaInfoCellId";
        HYProductDetailSBCell2 *cell = [tableView dequeueReusableCellWithIdentifier:pSKUtParmaInfoCellId];
        if (!cell)
        {
            cell = [[HYProductDetailSBCell2 alloc]initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:pSKUtParmaInfoCellId];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor darkGrayColor];
        }
        NSString *skuInfo = [self.goodsDetail skuDesc];;
        if (skuInfo && _isSelectedSKU)
        {
            cell.textLabel.text = skuInfo;
        }
        else
        {
            if (self.goodsDetail.attributeName1)
            {
                skuInfo = [NSString stringWithFormat:@"请选择 %@", self.goodsDetail.attributeName1];
            }
            
            if (self.goodsDetail.attributeName2)
            {
                if (skuInfo)
                {
                    skuInfo = [NSString stringWithFormat:@"%@、%@", skuInfo,
                               self.goodsDetail.attributeName2];
                }
                else
                {
                    skuInfo = [NSString stringWithFormat:@"请选择 %@", self.goodsDetail.attributeName2];
                }
            }
            
            cell.textLabel.text = skuInfo;
        }
        return cell;
    }
    else if (2 == indexPath.section)
    {
        static NSString *storeInfoCellId = @"storeInfoCellId";
        HYProductDetailSBCell2 *cell = [tableView dequeueReusableCellWithIdentifier:storeInfoCellId];
        if (!cell)
        {
            cell = [[HYProductDetailSBCell2 alloc]initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:storeInfoCellId];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"进入店铺";
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        
        return cell;
    }
    else if (3 == indexPath.section)
    {
        static NSString *guessInfoCellId = @"guessInfoCellId";
        HYMallGuessYouLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:guessInfoCellId];
        if (!cell)
        {
            cell = [[HYMallGuessYouLikeCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:guessInfoCellId];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        [cell setData:self.guessYouLikeList];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (1 == indexPath.section)
    {
        [self selectSKU];
    }
    else if (2 == indexPath.section)
    {
        [self checkMoreProductWithStore];
    }
}

- (void)cellBtnClick:(HYMallBrandCellBtn *)sender
{
    HYMallGuessYouLikeModel *model = sender.data;
    if (model)
    {
        [self checkProductDetail:model];
    }

}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat yOffset  = scrollView.contentOffset.y;
        if (yOffset < - self.view.frame.size.width)
        {
            CGRect f = _tableHeaderView.frame;
            f.origin.y = yOffset;
            f.size.height =  -yOffset;
            _tableHeaderView.frame = f;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableView)
    {
        CGFloat offset = TFScalePoint(70);
        if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height + offset)
        {
            [self.scrollToTopBtn setHidden:NO];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kChangeNavTitleView"
                                                               object:nil];
            
            [UIView animateWithDuration:.3 animations:^{
                _tableView.frame = CGRectMake(0, -_tableView.frame.size.height, _tableView.frame.size.width, _tableView.frame.size.height);
                
            }];
            UIView *footview = self.tableFooterView;
            if (!footview.superview)
            {
                footview.frame = CGRectMake(0, _tableView.frame.size.height-64, _tableView.frame.size.width, _tableView.frame.size.height);
                [self.view insertSubview:footview
                            belowSubview:self.scrollToTopBtn];
                //加载详情
                [self.detailWeb loadHTMLString:_goodsDetail.productDescription
                                       baseURL:nil];
            }
            [UIView animateWithDuration:.3 animations:^{
                footview.frame = CGRectMake(0, 0, footview.frame.size.width, footview.frame.size.height);
            }];
        }
    }
    
    if (scrollView == _detailWeb.scrollView)
    {
        CGFloat offset = TFScalePoint(50);
        if (scrollView.contentOffset.y < -offset)
        {
            [self.scrollToTopBtn setHidden:YES];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kRestoreNavTitleView"
                                                               object:nil];
            
            [UIView animateWithDuration:.3 animations:^{
                _tableView.frame = CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height);
            }];
            [UIView animateWithDuration:.3 animations:^{
                _tableFooterView.frame = CGRectMake(0, _tableView.frame.size.height, _tableFooterView.frame.size.width, _tableFooterView.frame.size.height);
            }];
        }
    }
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
    }
    else if ([product isKindOfClass:[HYMallGuessYouLikeModel class]])
    {
        HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
        vc.goodsId = [(HYMallGuessYouLikeModel *)product itemCode];
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}
@end
