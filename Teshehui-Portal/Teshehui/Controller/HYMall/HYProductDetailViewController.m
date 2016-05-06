//
//  HYMallProductDetailWithFilterController.m
//  Teshehui
//
//  Created by Kris on 16/3/28.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallProductDetailWithFilterController.h"
#import "HYProductDetailViewController.h"
#import "HYMallProductNewDetailViewController.h"
#import "HYProductDetailNavigationTitleView.h"
#import "HYAppDelegate.h"
#import "HYMallCartViewController.h"
#import "UIPageViewController+GWPrivateProperty.h"
#import "HYProductDetailMoreNavView.h"
#import "Masonry.h"
#import "HYImageButton.h"

@interface HYProductDetailViewController ()
<
HYProductDetailNavigationTitleViewDelegate
>
{
    HYProductDetailMoreNavView *_moreView;
    
    HYImageButton *_cartBtn;
}

@property (nonatomic, strong) HYProductDetailToolView *toolView;
@property (nonatomic, strong) HYProductDetailNavigationTitleView *navTitleView;
@property (nonatomic, strong) HYMallProductNewDetailViewController *detail;
@property (nonatomic, strong) HYMallProductDetailWithFilterController *product;
@property (nonatomic, strong) NSMutableDictionary *observedItems;

@end

@implementation HYProductDetailViewController

- (void)dealloc
{
    //clear the view above the window
    [_moreView removeFromSuperview];
    _moreView = nil;
    
    //clear obsever
    [self.observedItems enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj removeObserver:self forKeyPath:key];
    }];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    /// 组装子视图
    self.pageContent = CGRectMake(0, 0, rect.size.width, rect.size.height);
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:self.product];
    [controllers addObject:self.detail];
    [self.product addObserver:self forKeyPath:@"goodsDetail" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.product addObserver:self forKeyPath:@"tableHeaderView" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.observedItems setObject:self.product forKey:@"goodsDetail"];
    [self.observedItems setObject:self.product forKey:@"tableHeaderView"];
    self.contentControllers = controllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navTitleView = [[HYProductDetailNavigationTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 35)];
    self.navTitleView.delegate = self;
    self.navigationItem.titleView = self.navTitleView;
    [self loadRightItemBar];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(changeNavTitleView)
                                                name:@"kChangeNavTitleView"
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(restoreNavTitleView)
                                                name:@"kRestoreNavTitleView"
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(refreshBadge:)
                                                name:@"cartBadge"
                                              object:nil];
    
    if (!_toolView)
    {
        CGRect rect = self.pageContent;
        rect.origin.y = CGRectGetMaxY(self.pageContent)-44;
        rect.size.height = 44;
        _toolView = [[HYProductDetailToolView alloc] initWithFrame:rect];
        _toolView.delegate = self.product;
        self.product.toolView = _toolView;
        [self.pageController.view addSubview:_toolView];
    }
}

#pragma mark private methods
- (void)loadRightItemBar
{
    HYImageButton *carBtn = [HYImageButton buttonWithType:UIButtonTypeCustom];
    carBtn.frame = CGRectMake(0, 5, 30, 40);
    [carBtn setImage:[UIImage imageNamed:@"shopping_car_navbar"]
            forState:UIControlStateNormal];
    [carBtn addTarget:self
               action:@selector(gotoShoppingCar:)
     forControlEvents:UIControlEventTouchUpInside];
    _cartBtn = carBtn;
    [self.product setValue:carBtn forKey:@"cartBtn"];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"productDetail_more"]
            forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    moreBtn.frame = CGRectMake(0, 5, 30, 40);
    [moreBtn addTarget:self
                action:@selector(showMore:)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:carBtn];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    
    self.navigationItem.rightBarButtonItems = @[item2,item1];
}

- (void)showMore:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (![self moreView].superview)
    {
        [[self moreView] performShowAboveView:self.view];
    }
    else
    {
        [[self moreView]removeFromSuperview];
    }
}

- (void)refreshBadge:(id)sender
{
    if ([sender isKindOfClass:[NSNotification class]])
    {
        NSNotification *sb = sender;
        [_cartBtn setLabelCount:[sb.object[0] integerValue]];
    }
}

- (void)filterAction
{
    self.currentIdx = self.navTitleView.filter.currentIndex;
}

- (void)didShowControllerAtIndex:(NSInteger)idx
{
    self.navTitleView.filter.currentIndex = self.currentIdx;
}

- (void)changeNavTitleView
{
    [self.navTitleView changeTitle];
    //disable scroll action
    self.pageController.scrollable = NO;
//    self.pageController.bounce = NO;
}

- (void)restoreNavTitleView
{
    [self.navTitleView restoreTitle];
    //enable scroll action
    self.pageController.scrollable = YES;
//    self.pageController.bounce = YES;
}

#pragma mark setter & getter
- (HYProductDetailMoreNavView *)moreView
{
    if (!_moreView)
    {
        _moreView = [HYProductDetailMoreNavView instanceView];
        _moreView.delegate = self;
    }
    return _moreView;
}

-(void)setGoodsId:(NSString *)goodsId
{
    _goodsId = goodsId;
    
    self.product.goodsId = _goodsId;
}

-(void)setLoadFromPayResult:(BOOL)loadFromPayResult
{
    self.product.loadFromPayResult = loadFromPayResult;
}

-(HYMallProductDetailWithFilterController *)product
{
    if (!_product)
    {
        _product = [[HYMallProductDetailWithFilterController alloc] init];
    }
    return _product;
}

-(HYMallProductNewDetailViewController *)detail
{
    if (!_detail)
    {
        _detail = [[HYMallProductNewDetailViewController alloc] init];
    }
    return _detail;
}

-(NSMutableDictionary *)observedItems
{
    if (!_observedItems)
    {
        _observedItems = [NSMutableDictionary dictionary];
    }
    return _observedItems;
}


- (void)gotoShoppingCar:(id)sender
{
    //购物车图标
    [MobClick event:@"v430_shangcheng_shangpinxiangqing_gouwuchetubiao_jishu"];
    
    BOOL _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (!_isLogin)
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
    else
    {
        HYMallCartViewController *vc = [[HYMallCartViewController alloc] init];
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

#pragma mark rightButtonItem delegate
- (void)shareAction
{
    if ([self.product respondsToSelector:@selector(shareProduct)])
    {
        [self.product performSelector:@selector(shareProduct)];
    }
}

- (void)qRAction
{
    if ([self.product respondsToSelector:@selector(qrcodeAction)])
    {
        [self.product performSelector:@selector(qrcodeAction)];
    }
}

#pragma mark obsever
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //when the data comes
    if ([object isKindOfClass:[self.product class]])
    {
        id data = [self.product valueForKey:keyPath];
        //when tableHeader has been initilized
        if ([data isKindOfClass:[UIView class]])
        {
            [data addObserver:self forKeyPath:@"deltaX"
                      options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                      context:nil];
            [self.observedItems setObject:data forKey:@"deltaX"];
        }
        else
        {
            self.navTitleView.filter.enabled = !(data == nil);
            [self.detail setGoodsDetail:data];
        }
    }
    //handle scrollView of product
    else if ([object isKindOfClass:[UIView class]])
    {
        self.currentIdx = 1;
        [self didShowControllerAtIndex:self.currentIdx];
    }
}
@end
