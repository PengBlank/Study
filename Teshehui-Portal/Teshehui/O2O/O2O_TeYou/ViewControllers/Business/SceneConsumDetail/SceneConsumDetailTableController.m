//
//  SceneConsumDetailTableController.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "SceneConsumDetailTableController.h"
#import "SceneConsumDetailTableViewCell.h"
#import "HYHotelMapViewController.h"

#import "TopAdvertisingView.h"
#import "MWPhotoBrowser.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "METoast.h"
#import "UIUtils.h"
#import "NSTimer+Common.h"

#define CSS_ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString *_tableCellIdentifier = @"SceneConsumDetailTableViewCell";

@interface SceneConsumDetailTableController ()<UIWebViewDelegate,UIScrollViewDelegate,TopAdvertisingViewDelegate,MWPhotoBrowserDelegate>
{
    UIWebView      * _webView;
    UIWebView      * _webViewDetail;
    CGFloat        _fCellHeight;
    CGFloat        _fSectionHeight;
    CGRect         _rctViewHeader;
    CGRect         _rctMapButton;
    UIButton       * _btnSelectedSection;
    BOOL           _isSectionSelected;

    NSMutableArray * _photos;
}

@property (nonatomic, strong  ) NSMutableArray  *muarrAdverImages;

@property (strong, nonatomic) IBOutlet UIView *headerView;  // tableHeaderView


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeaderSubTop;
@property (weak, nonatomic) IBOutlet UIView *headerSubView; // 修改y坐标的view
@property (weak, nonatomic) IBOutlet TopAdvertisingView *viewAdvertising;// 图片滚动的view
@property (weak, nonatomic) IBOutlet UILabel *lblAdverPaged; // 轮播图片右下角显示页码
@property (weak, nonatomic) IBOutlet UIView *viewAdverPagedBack;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTitleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeaderHeight;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblConsum;// 收费情况
@property (weak, nonatomic) IBOutlet UILabel *lblName;  // 名称
@property (weak, nonatomic) IBOutlet UILabel *lblAdress;//　地址

@property (strong, nonatomic) IBOutlet UIView *sectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnReson;    // 推荐理由
@property (weak, nonatomic) IBOutlet UIButton *btnDetail;   // 套餐详情
@property (weak, nonatomic) IBOutlet UIView *viewPage;      // 分页图片
@property (weak, nonatomic) IBOutlet UIButton *btnMapPlaceholder;//　这个是代替地址按钮点击的　因为地址按钮走出了bounds无法触发点击事件
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutPageImageLeft;


@end

@implementation SceneConsumDetailTableController

- (void)dealloc{

    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _viewAdvertising.delegate = nil;
    [_viewAdvertising.animationTimer invalidate];
    _viewAdvertising.animationTimer = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_viewAdvertising.imagesArray.count != 0) {
            _viewAdvertising.delegate = self;
         // [_viewAdvertising.animationTimer resumeTimerAfterTimeInterval:5.0f];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 基本布局数据
    _navigationbarHeight   -= 1.0f;
    _fCellHeight           = 150.0f;
    _fSectionHeight        = 40.0f + _navigationbarHeight;
    
    CGRect rctHeader      = _headerSubView.frame;
    rctHeader.size.width  = CGRectGetWidth([UIScreen mainScreen].bounds);
    _rctViewHeader        = rctHeader;
    rctHeader.size.height -= _navigationbarHeight;
    _headerView.frame     = rctHeader;
    _rctMapButton         = _btnMapPlaceholder.frame;
    
    CGRect rctSection      = _sectionView.frame;
    rctSection.size.height = _fSectionHeight;
    _sectionView.frame     = rctSection;

    // "推荐理由“默认选中
    _btnReson.selected           = YES;
    _btnSelectedSection          = _btnReson;
    _headerSubView.clipsToBounds = YES;
    _sectionView.clipsToBounds   = YES;
    [_sectionView sendSubviewToBack:_btnMapPlaceholder];
    
//    self.tableView.tableHeaderView = _headerView;
    [self.tableView registerNib:[UINib nibWithNibName:_tableCellIdentifier bundle:nil] forCellReuseIdentifier:_tableCellIdentifier];
    
    // 轮动图片
    [_viewAdvertising setImageType:aliyun];
    [_viewAdvertising setDelegate:self];
    [_viewAdvertising bringSubviewToFront:_viewAdverPagedBack];
    [_viewAdvertising bringSubviewToFront: _lblAdverPaged];
    _muarrAdverImages = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// setter
- (void) setDetailInfo:(SceneDeatilInfo *)detailInfo {

    // 标签文字设置text
    _detailInfo         = detailInfo;
    self.lblTitle.text  = _detailInfo.packageName;
    self.lblName.text   = _detailInfo.merchantName;
    self.lblAdress.text = _detailInfo.merchantAddress;
    [self setConsumLabelAttributedText];
    [self setTitleLabelHeight];
    self.lblTitle.adjustsFontSizeToFitWidth = NO;
    
    // 图片滚动
    [self.muarrAdverImages removeAllObjects];
    for (imageUrl *url in _detailInfo.merUrlList) {
        if (url.merUrl.length > 0 ) {
            [self.muarrAdverImages addObject:url.merUrl];
        }
    }
    if (_muarrAdverImages.count == 0) {
        self.lblAdverPaged.hidden = YES;
    }else{
        [self.lblAdverPaged setText:[NSString stringWithFormat:@"1/%@",@(self.muarrAdverImages.count)]];
        [self.viewAdvertising setImagesArray:_muarrAdverImages];
        [self.viewAdvertising setAnimationDuration:5.0f];
        [self.viewAdvertising.animationTimer resumeTimerAfterTimeInterval:5.0f];
    }
}
// label自动适应高度
- (void) setTitleLabelHeight {
    NSDictionary *attribute = @{NSFontAttributeName: _lblTitle.font};
    CGFloat width = _lblTitle.frame.size.width;
    CGFloat height = [_lblTitle.text boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
    // 如果字多了　就修改约束为最新的高度
    if (height > _layoutTitleHeight.constant) {
        height += 5.0f;
        CGRect rctHeader = _headerView.frame;
        rctHeader.size.height += height - _layoutTitleHeight.constant;
        self.headerView.frame = rctHeader;
        _rctViewHeader        = rctHeader;
        CGFloat headerHeight = _layoutHeaderHeight.constant + height - _layoutTitleHeight.constant;
        
        self.layoutTitleHeight.constant = height;
        self.layoutHeaderHeight.constant = headerHeight;
        [self.lblTitle setNeedsUpdateConstraints];
        [self.lblTitle layoutIfNeeded];
        [self.headerSubView setNeedsUpdateConstraints];
        [self.headerSubView layoutIfNeeded];
    }
    self.tableView.tableHeaderView = _headerView;
}
#pragma mark - 按钮点击事件
// 地址点击
- (IBAction)btnMapClick:(id)sender {
    if (_detailInfo.latitude == 0 && _detailInfo.longitude == 0)
    {
        [METoast toastWithMessage:@"该商户没有录入地理信息，无法定位"];
        return;
    }
    else
    {
        HYHotelMapViewController *map   = [[HYHotelMapViewController alloc] init];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(_detailInfo.latitude, _detailInfo.longitude);
        map.annotationTitle             = _detailInfo.merchantName;
        map.showAroundShops             = NO;
        map.location                    = location;
        map.coorType                    = HYCoorBaidu;
        [self.parentViewController.navigationController pushViewController:map animated:YES];
    }
}

// 推荐理由\套餐详情点击
// tag 101 102
- (IBAction)btnSectionClick:(UIButton *)sender {
    
    NSString *url = @"";
    UIWebView *webview;
    if (sender.tag == 101) {
        url                   = _detailInfo.recommendReason;
        webview               = _webView;
        _webView.hidden       = NO;
        _webViewDetail.hidden = YES;
    }else{
        url                   = _detailInfo.details;
        webview               = _webViewDetail;
        _webViewDetail.hidden = NO;
        _webView.hidden       = YES;
    }
    if (url.length > 0) {
        [self resetWebViewFrame:webview];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [webview loadRequest:request];
    }
    if (![sender isEqual:_btnSelectedSection]) {
        _isSectionSelected = YES;
    }
    _btnSelectedSection.selected = NO;
    sender.selected              = YES;
    _btnSelectedSection          = sender;
    [self movePageView:sender];
}

#pragma mark banner视图代理
- (void)topAdvertisingViewCallBack:(TopAdvertisingView *)TopAdvertisingView didScrollImageView:(NSUInteger)paramIndex{
    
    if (_muarrAdverImages.count == 0) {
        return;
    }
    [self.lblAdverPaged setText:[NSString stringWithFormat:@"%lu/%lu",(unsigned long)paramIndex,(unsigned long)_muarrAdverImages.count]];
}

- (void)topAdvertisingViewCallBack:(TopAdvertisingView *)TopAdvertisingView didSelectImageView:(NSUInteger)paramIndex{
    
    if (_muarrAdverImages.count == 0) {
        [METoast toastWithMessage:@"该商家还没有添加展示图片"];
        return;
    }
    
    BOOL displayActionButton     = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows        = NO;
    BOOL enableGrid              = NO;
    BOOL startOnGrid             = NO;
    
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    [_photos removeAllObjects];
    for (NSString *p in _muarrAdverImages)
    {
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:p]]];
    }
    
    MWPhotoBrowser *browser         = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton     = displayActionButton;
    browser.displayNavArrows        = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls      = displaySelectionButtons;
    browser.wantsFullScreenLayout   = YES;
    browser.zoomPhotosToFill        = YES;
    browser.enableGrid              = enableGrid;
    browser.startOnGrid             = startOnGrid;
    [browser setCurrentPhotoIndex:paramIndex - 1];
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark 照片浏览器代理
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    DebugNSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

#pragma mark - webview delegate
//- (void)webViewDidStartLoad:(UIWebView *)webView {
////    NSLog(@"webViewDidStartLoad %@",webView);
//}
//
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    NSLog(@"didFailLoadWithError");
}
- (void) resetWebViewFrame:(UIWebView *)webView {
    // 切换url后　重新给webview设置frame 不然会保持上一次的大小
    CGRect frame       = webView.frame;
    frame.size.height  = 1;
    webView.frame      = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size         = fittingSize;
    webView.frame      = frame;
    
    // 解决webview　宽度显示不全的问题
    UIScrollView *scroll = [webView scrollView];
    CGFloat zoom         = webView.bounds.size.width / scroll.contentSize.width;
    [scroll setZoomScale:zoom animated:YES];
    scroll.scrollEnabled = NO;
    scroll.bounces       = NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    CGFloat webHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight;"]floatValue];
    
    CGRect frame         = webView.frame;
    UIScrollView *scroll = [webView scrollView];
    
    // 重新设置frame
//    _fCellHeight         = scroll.contentSize.height+10;
    _fCellHeight         = webHeight + 10;
    frame.size.height    = _fCellHeight;
    webView.frame        = frame;
    scroll.frame         = frame;
    
    //        [self.tableView beginUpdates];
    //        [self.tableView endUpdates];
    
    [self.tableView reloadData];
    
    if (_isSectionSelected) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        //            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    if ([_btnSelectedSection isEqual:_btnDetail]) {
        self.layoutPageImageLeft.constant = self.view.frame.size.width * .5f;
    }else{
        self.layoutPageImageLeft.constant = 0;
    }
    [self.viewPage setNeedsUpdateConstraints];

}


#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    //    设置本页面的图片效果
    
    CGRect rctHeader   = _rctViewHeader;
    CGRect rctImage = _viewAdvertising.frame;
    CGRect rctMapButton = _rctMapButton;
    
    if (contentOffsetY > 0) {
        rctHeader.origin.y = contentOffsetY * .5f ;
        rctHeader.size.height -= contentOffsetY * .5f;
        rctMapButton.origin.y += contentOffsetY * .5f;
    }else{
//        rctHeader.origin.y = contentOffsetY;
//        rctHeader.size.height += -contentOffsetY;
//        rctImage.size.height += -contentOffsetY;
    }
    
    [_headerSubView setFrame:rctHeader];
//    [_headerImageView setFrame:rctImage];
    _btnMapPlaceholder.frame = rctMapButton;
    self.layoutHeaderSubTop.constant = rctHeader.origin.y;
    [self.headerSubView setNeedsUpdateConstraints];
//    [_headerSubView setNeedsLayout];
    [_headerSubView layoutIfNeeded];
    
//    父页面回调
    [self.scrollDelegate SceneConsumDetailTableControllerDidScroll:scrollView.contentOffset.y];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _fCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _fSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SceneConsumDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_tableCellIdentifier forIndexPath:indexPath];
    if (!_webView) {
        _webView             = cell.webView;
        UIScrollView *scroll = [_webView scrollView];
        scroll.scrollEnabled = NO;
        scroll.bounces       = NO;
        [_webView setDelegate:self];
        [self btnSectionClick:_btnSelectedSection];
    }
    if (!_webViewDetail) {
        _webViewDetail        = cell.webViewDetail;
        UIScrollView *scroll  = [_webViewDetail scrollView];
        scroll.scrollEnabled  = NO;
        scroll.bounces        = NO;
        _webViewDetail.hidden = YES;
        [_webViewDetail setDelegate:self];
    }
    return cell;
}

#pragma mark - 内部方法

// 费用标签化字体
- (void) setConsumLabelAttributedText{
    NSMutableAttributedString *attConsum;
    
    // 红色
    NSString *consum = [NSString stringWithFormat:@"￥%@/%@",_detailInfo.thsPrice?:@" ",@"份"];
    attConsum = [[NSMutableAttributedString alloc]initWithString:consum
                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f],NSForegroundColorAttributeName:CSS_ColorFromRGB(0xb80000)}];
    // 灰色
    NSString *point = [NSString stringWithFormat:@"   已抵扣%@现金券    ",_detailInfo.coupon?:@" "];
    NSAttributedString *attPoint = [[NSAttributedString alloc] initWithString:point attributes:@{
                                                                                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:CSS_ColorFromRGB(0x606060)}];
    
    // 加删除线
    NSString *originalPrice = [NSString stringWithFormat:@"￥%@/%@",_detailInfo.originalPrice?:@" ",@"份"];
    NSAttributedString *attOrigina =
    [[NSAttributedString alloc]initWithString:originalPrice
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
       NSForegroundColorAttributeName:CSS_ColorFromRGB(0x606060),
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:CSS_ColorFromRGB(0x606060)}];
    
    [attConsum appendAttributedString:attPoint];
    [attConsum appendAttributedString:attOrigina];
    _lblConsum.attributedText = attConsum;
    _lblConsum.adjustsFontSizeToFitWidth = YES;
}

- (void) movePageView:(UIButton *)btn {
    // 动画 移动 分页图片
    WS(weakSelf);
    [UIView animateWithDuration:.4f     //动画持续的时间
                          delay:.0      //延迟
                        options:UIViewAnimationOptionAllowAnimatedContent //设置动画类型
                     animations:^{
                         //开始动画
                         weakSelf.viewPage.center = CGPointMake(btn.center.x, _viewPage.center.y);
                     }
                     completion:^(BOOL finished){
                         // 动画结束时的处理
                         //                         _isTopButtonClick = NO;
                     }];
}

@end
