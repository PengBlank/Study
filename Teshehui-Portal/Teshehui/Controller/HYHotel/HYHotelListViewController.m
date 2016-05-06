//
//  HYHotelListViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelListViewController.h"
#import "HYHotelDetailViewController.h"
#import "HYHotelListCell.h"
#import "CQSegmentItem.h"
#import "CQSegmentControl.h"
#import "HYHotelFilterViewController.h"
#import "HYTableViewFooterView.h"

#import "HYHotelSearchReuqest.h"
#import "HYHotelSearchResponse.h"

#import "HYLoadHubView.h"
#import "HYHotelLoadView.h"
#import "CQPopoverView.h"
#import "HYNullView.h"
#import "HYHotelPriceConditionView.h"
#import "HYConditionSettingViewController.h"
#import "HYHotelSortView.h"

@interface HYHotelListViewController ()
<
CQPopoverViewDelegate,
HYHotelFilterViewControllerDelegate,
HYHotelConditionChangeDelegate,
HYConditionSettingDelegate,
HYHotelSortDelegate
>
{
    CQSegmentControl *_segControl;
    
    HYHotelSearchReuqest *_searchRequset;
    
    BOOL _isLoading;
    BOOL _hasMore;
    HotelOrderType _orderType;
    HYHotelLoadView *_loadView;
    
    CGFloat _prevContentOffsetY;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CQPopoverView *orderSettingView;
@property (nonatomic, strong) NSMutableArray *hotelList;
@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, strong) HYNullView *nullView;

- (void)sendHoletSearchRequest;
- (void)loadDataSource;

@end

@implementation HYHotelListViewController

- (void)dealloc
{
    [_searchRequset cancel];
    _searchRequset = nil;
    
    [HYLoadHubView dismiss];
    
    //    if (_loadView)
    //    {
    //        [_loadView stopLoadAnimation];
    //        _loadView = nil;
    //    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.pageNumber = 1;
        _orderType = DEFAULT;
    }
    
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
    
    // bottom bar
    if (!_segControl)
    {
        //综合筛选
        CQSegmentItem *filter = [[CQSegmentItem alloc] init];
        filter.dicection = Vertical;
        filter.title = NSLocalizedString(@"filter", nil);
        filter.normalImage = [UIImage imageNamed:@"icon_filter"];
        filter.hightlightImage = [UIImage imageNamed:@"icon_filter"];
        
        CQSegmentItem *price = [[CQSegmentItem alloc] init];
        price.normalImage = [UIImage imageNamed:@"icon_price"];
        price.hightlightImage = [UIImage imageNamed:@"icon_price"];
        price.dicection = Vertical;
        price.title = @"价格/星级";
        
        //排序
        CQSegmentItem *sort = [[CQSegmentItem alloc] init];
        sort.dicection = Vertical;
        sort.title = NSLocalizedString(@"sort", nil);
        sort.normalImage = [UIImage imageNamed:@"icon_rank"];
        sort.hightlightImage = [UIImage imageNamed:@"icon_rank"];
        
        NSArray *items = [NSArray arrayWithObjects:filter,price, sort, nil];
        frame.origin.y = (frame.origin.y+frame.size.height-48);
        frame.size.height = 48;
        _segControl = [[CQSegmentControl alloc] initWithFrame:frame items:items];
        _segControl.showSelectStatus = NO;
        _segControl.textColor = [UIColor lightGrayColor];
//        _segControl.bgImage = [[UIImage imageNamed:@"hotel_bg_tabV2"] stretchableImageWithLeftCapWidth:1
//                                                                                        topCapHeight:2];
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 1.0)];
        line.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                     topCapHeight:0];
        [_segControl addSubview:line];
        _segControl.backgroundColor = [UIColor whiteColor];
        [_segControl addEventforSelectChangeTarget:self
                                            action:@selector(didchangeSelectValue:)];
        [self.view addSubview:_segControl];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"hotel_list", nil);
    
    [self loadDataSource];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (!self.view.window)
    {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
        
        [_segControl removeFromSuperview];
        _segControl = nil;
        
        _nullView = nil;
        
        self.view = nil;
    }
}

-(void)backToRootViewController:(id)sender
{
    [_condition clearLocationInfos];
    [super backToRootViewController:sender];
}

#pragma mark setter
- (CQPopoverView *)orderSettingView
{
    
    if (!_orderSettingView)
    {
        NSString *defsort = NSLocalizedString(@"def_sort", nil);
        CQPopoverItem *defItem = [[CQPopoverItem alloc] initWithFrame:CGRectMake(0, 0, 100, 40)
                                                                title:defsort
                                                          normalImage:nil
                                                          selectImage:nil];
        defItem.tag = DEFAULT;
        
        NSString *price = NSLocalizedString(@"price", nil);
        UIImage *ascNormal = [UIImage imageNamed:@"hotel_icon_arrows_downs"];
        UIImage *ascSelect = [UIImage imageNamed:@"hotel_icon_arrows_down"];
        CQPopoverItem *ascItem = [[CQPopoverItem alloc] initWithFrame:CGRectMake(0, 0, 100, 40)
                                                                title:price
                                                          normalImage:ascNormal
                                                          selectImage:ascSelect];
        ascItem.tag = Price_DESC;
        
        UIImage *descNormal = [UIImage imageNamed:@"hotel_icon_arrows_top"];
        UIImage *descSelect = [UIImage imageNamed:@"hotel_icon_arrows_tops"];
        CQPopoverItem *descItem = [[CQPopoverItem alloc] initWithFrame:CGRectMake(0, 0, 100, 40)
                                                                 title:price
                                                           normalImage:descNormal
                                                           selectImage:descSelect];
        descItem.tag = Price_ASC;
        
        CQPopoverItem *nameItem = [[CQPopoverItem alloc] initWithFrame:CGRectMake(0, 0, 100, 40) title:@"按名称" normalImage:nil selectImage:nil];
        nameItem.tag = Name;
        
        NSArray *items = [NSArray arrayWithObjects:defItem, ascItem, descItem, nameItem, nil];;
        CGFloat spece = 144;
        if (self.searchNear)
        {
            CQPopoverItem *disItem = [[CQPopoverItem alloc] initWithFrame:CGRectMake(0, 0, 100, 40)
                                                                    title:@"由近到远"
                                                              normalImage:nil
                                                              selectImage:nil];
            disItem.tag = Distance_ASC;
            
            items = [NSArray arrayWithObjects:defItem, ascItem, descItem, disItem, nameItem, nil];
            spece += 40;
        }
        
        UIImage *selectImage = [[UIImage imageNamed:@"hotel_bg_blue_d1.png"] stretchableImageWithLeftCapWidth:5
                                                                                                 topCapHeight:0];
        UIImage *bgImage = [[UIImage imageNamed:@"hotel_bg_white_d1.png"] stretchableImageWithLeftCapWidth:0
                                                                                              topCapHeight:5];
        
        CGPoint point = CGPointMake(TFScalePoint(220), self.view.frame.size.height-spece);
        _orderSettingView = [[CQPopoverView alloc] initWithPoint:point
                                                         bgImage:bgImage
                                                     popoverItem:items];
        _orderSettingView.selectImage = selectImage;
        _orderSettingView.delegate = self;
        [_orderSettingView setCurrentSelectItem:DEFAULT];
    }
    
    return _orderSettingView;
}

- (HYNullView *)nullView
{
    if (!_nullView) {
        CGRect frame = self.view.bounds;
        frame.size.height -= 48;
        _nullView = [[HYNullView alloc] initWithFrame:frame];
        [_nullView addTarget:self
                      action:@selector(loadDataSource)
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nullView];
    }
    return _nullView;
}

#pragma mark - private methods
- (void)loadDataSource
{
    self.pageNumber = 1;
    [self.hotelList removeAllObjects];
    [self.tableView reloadData];
    
    [self sendHoletSearchRequest];
}

- (void)sendHoletSearchRequest
{
    _isLoading = YES;
    
    [HYLoadHubView show];
    
    HYTableViewFooterView *loadFooter = (HYTableViewFooterView *)self.tableView.tableFooterView;
    [loadFooter startLoadMore];
    
    _nullView.hidden = YES;
    
    [_searchRequset cancel];
    _searchRequset = nil;
    
    _searchRequset = [[HYHotelSearchReuqest alloc] init];
    _searchRequset.businessType = @"03";
    
    //入住和离店时间
    _searchRequset.startDate = self.searchCheckInDate;
    _searchRequset.endDate = self.searchCheckOutDate;
    
    //查询条件
    self.condition.searchNear = self.searchNear;
    _searchRequset.condition = self.condition;
    
    _searchRequset.pageNo = self.pageNumber;
    
    //排序
    _searchRequset.orderType = _orderType;
    
    __weak typeof(self) b_self = self;
    [_searchRequset sendReuqest:^(id result, NSError *error)
    {
        NSArray *array = nil;
        
        if (!error && [result isKindOfClass:[HYHotelSearchResponse class]])
        {
            HYHotelSearchResponse *response = (HYHotelSearchResponse *)result;
            array = response.hotelList;
        }
        
        [b_self searchResultUpdate:array error:error];
    }];
}

- (void)searchResultUpdate:(NSArray *)hotels error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (!_hotelList)
    {
        _hotelList = [[NSMutableArray alloc] init];
    }
    
    if (_isLoading)
    {
        _isLoading = NO;
        [_loadView stopLoadAnimation];
        [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    }
    
    _hasMore = ([hotels count] > 0);
    
    if (_hasMore)
    {
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        [_hotelList addObjectsFromArray:hotels];
        [self.tableView reloadData];
    }
    else if ([_hotelList count] <= 0)
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
                str = @"暂无酒店数据，请稍后再试";
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

//筛选或者排序
- (void)didchangeSelectValue:(id)sender
{
    if ([sender isKindOfClass:[CQSegmentControl class]])
    {
        CQSegmentControl *seg = (CQSegmentControl *)sender;
        NSInteger index = seg.currentIndex;
        
        switch (index)
        {
            case 0:  //条件筛选
            {
                /*
                HYHotelFilterViewController *vc = [[HYHotelFilterViewController alloc] init];
                vc.delegate = self;
                vc.condition = self.condition;
                [self.navigationController pushViewController:vc
                                                     animated:YES];
                 */
                HYConditionSettingViewController *vc = [[HYConditionSettingViewController alloc] init];
                vc.condition = self.condition;
                vc.delegate = self;
                [self.navigationController pushViewController:vc
                                                     animated:YES];
                
            }
                break;
            case 1:
            {
                HYHotelPriceConditionView *conditionView = [[HYHotelPriceConditionView alloc] initWithFrame:CGRectMake(0, 0, 320, 330)];
                conditionView.condition = self.condition;
                conditionView.delegate = self;
                [conditionView showWithAnimation:YES];
            }
                break;
            case 2:  //排序
            {
                HYHotelSortView *sortView = [[HYHotelSortView alloc] initWithSize:CGSizeMake(self.view.frame.size.width, 35*4)];
                NSInteger idx = 0;
                if (_orderType == DEFAULT) {
                    idx = 0;
                }
                else if (_orderType == Price_ASC) {
                    idx = 1;
                }
                else if (_orderType == Price_DESC) {
                    idx = 2;
                }
                else if (_orderType == Name) {
                    idx = 3;
                }
                sortView.selectedIdx = idx;
                sortView.delegate = self;
                [sortView showWithAnimation:YES];
//                [self.orderSettingView showWithAnimation:YES];
                break;
            }
            default:
                break;
        }
        
        //取消掉选中状态
        [seg cancelSelcteStatus];
    }
}

- (void)setToolBarIsShow:(BOOL)show
{
    if (show)
    {
        CGRect rect = _segControl.frame;
        rect.origin.y = [[UIScreen mainScreen] bounds].size.height-rect.size.height-64;
        [UIView animateWithDuration:0.3
                         animations:^{
                             _segControl.frame = rect;
                         }];
        
        
        UIEdgeInsets insets = self.tableView.scrollIndicatorInsets;
        insets.bottom = self.view.frame.size.height-rect.origin.y;
        self.tableView.scrollIndicatorInsets = insets;
    }
    else
    {
        CGRect rect = _segControl.frame;
        rect.origin.y = [[UIScreen mainScreen] bounds].size.height-rect.size.height;
        [UIView animateWithDuration:0.3
                         animations:^{
                             _segControl.frame = rect;
                         }];
        
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }
}

#pragma mark - HYHotelPriceConditionDelegate
- (void)hotelConditionChanged:(HYHotelCondition *)condition
{
    [self loadDataSource];
}

#pragma mark - HYHotelFilterViewControllerDelegate
- (void)searchConditionDidChange
{
    [self loadDataSource];
}

#pragma mark - HYConditionSettingDelegate
- (void)didSelectCondition:(HYHotelCondition *)condition type:(ConditionType)viewType
{
    [self loadDataSource];
}

#pragma mark - CQPopoverViewDelegate
- (void)popoverDidSelectItem:(id)item
{
    if ([item isKindOfClass:[CQPopoverItem class]])
    {
        CQPopoverItem *popItem = (CQPopoverItem *)item;
        _orderType = (int)popItem.tag;
        [self loadDataSource];
    }
}

- (void)hotelSortViewDidSelectIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            _orderType = DEFAULT;
            break;
        case 1:
            _orderType = Price_ASC;
            break;
        case 2:
            _orderType = Price_DESC;
            break;
        case 3:
            _orderType = Name;
            break;
        default:
            break;
    }
    [self loadDataSource];
}

- (void)reloadMoreData
{
    if (!_isLoading && _hasMore)
    {
        [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
        self.pageNumber++;
        [self sendHoletSearchRequest];
    }
}

/*
 - (void)popoverDidHidden
 {
 
 }
 */

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.hotelList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *searchnearID = @"searchnearID";
    HYHotelListCell *cell = [tableView dequeueReusableCellWithIdentifier:searchnearID];
    if (cell == nil)
    {
        cell = [[HYHotelListCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:searchnearID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.separatorLeftInset = 0;
    }
    
    if (indexPath.row < [self.hotelList count])
    {
        HYHotelListSummary *hSummary = [self.hotelList objectAtIndex:indexPath.row];
        cell.hotleSummary = hSummary;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [self.hotelList count])
    {
        HYHotelListSummary *hSummary = [self.hotelList objectAtIndex:indexPath.row];
        HYHotelDetailViewController *vc = [[HYHotelDetailViewController alloc] init];
        vc.hotleSummary = hSummary;
        vc.hotleCity = self.condition.cityInfo;
        vc.checkInDate = self.searchCheckInDate;
        vc.checkOutDate = self.searchCheckOutDate;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _prevContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging)
    {
        CGFloat deltaY = scrollView.contentOffset.y-_prevContentOffsetY;
        _prevContentOffsetY = MAX(scrollView.contentOffset.y, -scrollView.contentInset.top);
        
        if (deltaY > 0)
        {
            [self setToolBarIsShow:NO];
        }
    }
    
    float scrollOffset = scrollView.contentOffset.y;
    float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (scrollOffset >= maximumOffset)
    {
        [self reloadMoreData];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self setToolBarIsShow:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setToolBarIsShow:YES];
}
@end
