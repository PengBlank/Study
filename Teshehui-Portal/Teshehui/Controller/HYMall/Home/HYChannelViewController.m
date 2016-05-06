//
//  HYChannelViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/6.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChannelViewController.h"
#import "HYMallHomeHeaderView.h"

//UI
#import "HYChannelHotCell.h"
#import "HYChannelTitleCell.h"
#import "HYChannelTopicCell.h"
#import "HYChannelSpecialCell.h"
#import "HYChannelBrandCell.h"
#import "HYChannelCategoryCell.h"
#import "HYChannelMoreCell.h"
#import "METoast.h"

//MODELS
#import "HYMallChannelBoard.h"
#import "HYMallChannelItem.h"

//REQUESTS
#import "HYChannelPageRequest.h"
#import "HYChannelGoodsRequest.h"

//Direct
#import "PTHttpManager.h"
#import "HYUserInfo.h"
#import "HYMallSearchGoodsRequest.h"
#import "HYMallProductListViewController.h"
#import "HYFlowerSubListViewController.h"
#import "HYProductDetailViewController.h"
#import "HYFlowerDetailViewController.h"
#import "HYActivityProductListViewController.h"
#import "HYLuckyHomeViewController.h"
#import "HYMallChannelGoods.h"
#import "HYTableViewFooterView.h"
#import "HYMallWebViewController.h"
#import "HYShowHandViewController.h"
#import "HYAnalyticsManager.h"

@interface HYChannelViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
HYMallProductListCellDelegate,
HYMallHomeCellDelegate
>
{
    
    NSInteger _sectionMapping[50];
    NSInteger _sectionCount;
    
//    CGFloat _titleOffset;
    
    //界面控制
    CGFloat _prevContentOffsetY;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HYMallHomeHeaderView *tableHeader;
@property (nonatomic, strong) HYTableViewFooterView *tableFooter;
@property (nonatomic, strong) UIButton *scrollToTopBtn;  //滑动到顶部
@property (nonatomic, strong) HYChannelCategoryCell *cateHead;

@property (nonatomic, strong) HYChannelPageRequest *pageRequest;
@property (nonatomic, strong) HYChannelGoodsRequest *goodsRequest;

//data
@property (nonatomic, strong) HYMallChannelBoard *bannerBoard;
@property (nonatomic, strong) HYMallChannelBoard *hotBoard;
@property (nonatomic, strong) HYMallChannelBoard *ntsBoard;
@property (nonatomic, strong) HYMallChannelBoard *timeLimitBoard;
@property (nonatomic, strong) HYMallChannelBoard *themeBoard;
@property (nonatomic, strong) HYMallChannelBoard *specialBoard;
@property (nonatomic, strong) HYMallChannelBoard *brandBoard;

//
@property (nonatomic, strong) NSArray<HYChannelCategory*> *cateArray;
@property (nonatomic, strong) NSMutableArray<HYMallChannelGoods*> *goodsList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) HYChannelCategory *currentCate;


@end

@implementation HYChannelViewController

- (void)dealloc
{
    [_pageRequest cancel];
    [HYLoadHubView dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.channelName)
    {
        self.title = self.channelName;
    }
    self.navigationController.navigationBar.hidden = NO;
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    [tableview registerClass:[HYChannelHotCell class] forCellReuseIdentifier:@"hotCell"];
    [tableview registerClass:[HYChannelTitleCell class] forCellReuseIdentifier:@"titleCell"];
    [tableview registerClass:[HYChannelTopicCell class] forCellReuseIdentifier:@"topicCell"];
    [tableview registerClass:[HYChannelSpecialCell class] forCellReuseIdentifier:@"specialCell"];
    [tableview registerClass:[HYChannelBrandCell class] forCellReuseIdentifier:@"brandCell"];
    [tableview registerClass:[HYChannelCategoryCell class] forCellReuseIdentifier:@"categoryCell"];
    [tableview registerClass:[HYChannelMoreCell class] forCellReuseIdentifier:@"moreCell"];
    self.tableView = tableview;
    [self.view addSubview:tableview];
    
    HYTableViewFooterView *footer = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
    self.tableFooter = footer;
    
    [self loadPageData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)scrollToTopBtn
{
    if (!_scrollToTopBtn)
    {
        _scrollToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scrollToTopBtn.frame = CGRectMake(CGRectGetMaxX(self.view.frame)-50,
                                           CGRectGetHeight(self.view.frame)-90,
                                           TFScalePoint(30),
                                           TFScalePoint(30));
        [_scrollToTopBtn setImage:[UIImage imageNamed:@"icon_returnUp"]
                         forState:UIControlStateNormal];
        [_scrollToTopBtn addTarget:self
                            action:@selector(scrollViewToTopEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_scrollToTopBtn];
        [self.view bringSubviewToFront:_scrollToTopBtn];
    }
    
    return _scrollToTopBtn;
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    NSInteger mappedSection = _sectionMapping[section];
    switch (mappedSection)
    {
        case ChannelBoardBanner:
            count = 1;
            break;
        case ChannelBoardHot:
            count = 1;
            break;
        case ChannelBoardTheme:
            count=  2;
            break;
        case ChannelBoardSpecial:
            count = 2;
            break;
        case ChannelBoardBrand:
        {
            NSInteger line = 0;
            NSInteger itemcount = self.brandBoard.channelBannerList.count;
            if (itemcount < 4) {
                line = 1;
            }
            else if (itemcount < 7) {
                line = 2;
            }
            else if (itemcount > 0) {
                line = 3;
            }
            count = line + 1;
        }
            break;
        case ChannelBoardGoods:
            count = (self.goodsList.count+1)/2;
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    CGFloat width = self.view.frame.size.width;
    HYMallChannelBoardType section = [self mappedSection:indexPath.section];
    if (section == ChannelBoardBanner)
    {
        //处理banner可能没有
        //11月19日陈文涛确认改为 1242x524
        height = width * 0.4219;
    }
    else if (section == ChannelBoardHot)
    {
        height =  width * 0.29;
    }
    else if (section == ChannelBoardTheme)
    {
        if (indexPath.row == 0)
        {
            height = width * 0.08;
        }
        else
        {
            height = width * 0.54;
        }
    }
    else if (section == ChannelBoardSpecial)
    {
        if (indexPath.row == 0)
        {
            height = width * 0.08;
        }
        else
        {
            height = width * 0.34;
        }
    }
    else if (section == ChannelBoardBrand)
    {
        if (indexPath.row == 0)
        {
            height = width * 0.08;
        }
        else
        {
            height = width * 0.15;
        }
    }
    else if (section == ChannelBoardGoods)
    {
        height = width * 0.74;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    HYMallChannelBoardType mapsection = [self mappedSection:section];
    if (mapsection == ChannelBoardGoods) {
        return self.view.frame.size.width * 0.11;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 8;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HYMallChannelBoardType mapsection = [self mappedSection:section];
    if (mapsection == ChannelBoardGoods)
    {
        if (!self.cateHead) {
            self.cateHead = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
            self.cateHead.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*0.11);
        }
        _cateHead.items = self.cateArray;
        _cateHead.selectedIdx = [_cateArray indexOfObject:_currentCate];
        __weak typeof(self) weakSelf = self;
        _cateHead.cateCallback = ^(NSInteger idx)
        {
            if (idx < weakSelf.cateArray.count)
            {
                [weakSelf reloadGoodsDataWithCateIndex:idx];
            }
        };
        return _cateHead;
    }
    return nil;
}

 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 8)];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMallChannelBoardType section = [self mappedSection:indexPath.section];
    if (section == ChannelBoardBanner)
    {
        HYBaseLineCell *banner = [tableView dequeueReusableCellWithIdentifier:@"banner"];
        if (!banner)
        {
            banner = [[HYBaseLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"banner"];
            HYMallHomeHeaderView *header = [[HYMallHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 0.4219)];
            header.delegate = self;
            [header setChannelBoard:self.bannerBoard];
            banner.separatorLeftInset = 0;
            [banner.contentView addSubview:header];
        }
        return banner;
    }
    else if (section == ChannelBoardHot)
    {
        HYChannelHotCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
        NSArray *items = [NSArray array];
        if (self.hotBoard.channelBannerList.count > 0)
        {
            items = [items arrayByAddingObject:self.hotBoard.channelBannerList[0]];
            hotCell.channelBoard = self.hotBoard;
        }
        if (self.ntsBoard.channelBannerList.count > 0)
        {
            items = [items arrayByAddingObject:self.ntsBoard.channelBannerList[0]];
            hotCell.channelBoard = self.ntsBoard;
        }
        if (self.timeLimitBoard.channelBannerList.count > 0)
        {
            items = [items arrayByAddingObject:self.timeLimitBoard.channelBannerList[0]];
            hotCell.channelBoard = self.timeLimitBoard;
        }
        hotCell.items = items;
        hotCell.delegate = self;
        return hotCell;
    }
    else if (section == ChannelBoardTheme)
    {
        if (indexPath.row == 0)
        {
            HYChannelTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            titleCell.textLabel.text = self.themeBoard.channelBoardName;
            return titleCell;
        }
        else
        {
            HYChannelTopicCell *topicCell = [tableView dequeueReusableCellWithIdentifier:@"topicCell"];
            topicCell.channelBoard = self.themeBoard;
            topicCell.delegate = self;
            return topicCell;
        }
    }
    else if (section == ChannelBoardSpecial)
    {
        if (indexPath.row == 0)
        {
            HYChannelTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            titleCell.textLabel.text = self.specialBoard.channelBoardName;
            return titleCell;
        }
        else
        {
            HYChannelSpecialCell *specialCell = [tableView dequeueReusableCellWithIdentifier:@"specialCell"];
            CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            specialCell.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
//            NSString *strs[] = {@"44",@"44",@"44",@"44",@"44",@"44",@"44"};
            //specialCell.items = [NSArray arrayWithObjects:strs count:7];
            specialCell.channelBoard = self.specialBoard;
            specialCell.delegate = self;
            return specialCell;
        }
    }
    else if (section == ChannelBoardBrand)
    {
        if (indexPath.row == 0)
        {
            HYChannelTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            titleCell.textLabel.text = self.brandBoard.channelBoardName;
            return titleCell;
        }
        else
        {
            HYChannelBrandCell *brandCell = [tableView dequeueReusableCellWithIdentifier:@"brandCell"];
            NSInteger index = indexPath.row - 1;
            if (index == 0) {
                NSInteger len = self.brandBoard.channelBannerList.count > 3 ? 3 : self.brandBoard.channelBannerList.count;
                NSArray *items = [self.brandBoard.channelBannerList subarrayWithRange:NSMakeRange(0, len)];
                brandCell.items = items;
            }
            else if (index == 1) {
                NSInteger len = self.brandBoard.channelBannerList.count > 6 ? 3 : self.brandBoard.channelBannerList.count-3;
                NSArray *items = [self.brandBoard.channelBannerList subarrayWithRange:NSMakeRange(3, len)];
                brandCell.items = items;
            }
            else if (index == 2) {
                NSInteger len = self.brandBoard.channelBannerList.count > 9 ? 3 : self.brandBoard.channelBannerList.count-6;
                NSArray *items = [self.brandBoard.channelBannerList subarrayWithRange:NSMakeRange(6, len)];
                brandCell.items = items;
            }
            brandCell.delegate = self;
            brandCell.channelBoard = self.brandBoard;
            return brandCell;
        }
    }
    else if (section == ChannelBoardGoods)
    {
        HYChannelMoreCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"moreCell"];
        NSInteger idx = indexPath.row;
        if (idx < (self.goodsList.count+1)/2)
        {
            HYMallChannelGoods *left = [self.goodsList objectAtIndex:idx*2];
            HYMallChannelGoods *right = nil;
            if (self.goodsList.count > 2*idx+1)
            {
                right = [self.goodsList objectAtIndex:2*idx+1];
            }
            moreCell.leftView.item = left;
            moreCell.rightView.item = right;
            moreCell.delegate = self;
        }
        return moreCell;
    }
    //default
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //加载更多
    float scrollOffset = scrollView.contentOffset.y;
    float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (scrollOffset >= maximumOffset && !_isLoading && _hasMore)
    {
        [self loadMoreGoodsData];
    }
    
//    if (scrollOffset > [self calculateTitleOffset] && _titleOffset != 0)
//    {
//        self.title = self.currentCate.categoryName;
//    }
//    else
//    {
//        self.title = self.channelName;
//    }
    
    if (scrollView.dragging)
    {
        float deltaY = scrollView.contentOffset.y-_prevContentOffsetY;
        _prevContentOffsetY = MAX(scrollView.contentOffset.y, -scrollView.contentInset.top);
        
        if (deltaY < 0)
        {
            [self.scrollToTopBtn setHidden:YES];
        }
    }
    else
    {
        if (scrollView.contentOffset.y > self.view.frame.size.height*3)
        {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [_scrollToTopBtn setHidden:YES];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _prevContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    //    [self.baseViewController setToolBarIsShow:YES];
    if (scrollView.contentOffset.y > self.view.frame.size.height*3)
    {
        [self.scrollToTopBtn setHidden:NO];
    }
    else
    {
        [_scrollToTopBtn setHidden:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        if (scrollView.contentOffset.y > self.view.frame.size.height*3)
        {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [_scrollToTopBtn setHidden:YES];
        }
    }
}

- (void)scrollViewToTopEvent:(id)sender
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - requests
- (void)loadPageData
{
    if (!_pageRequest)
    {
        _pageRequest = [[HYChannelPageRequest alloc] init];
    }
    _pageRequest.channelCode = self.channelCode;
    __weak typeof(self) weakSelf = self;
    [HYLoadHubView show];
    [_pageRequest sendReuqest:^(id result, NSError *error)
    {
        HYChannelPageResponse *response = nil;
        if ([result isKindOfClass:[HYChannelPageResponse class]])
        {
            response = (HYChannelPageResponse *)result;
        }
        [weakSelf updateWithResponse:result error:error];
    }];
}

- (void)updateWithResponse:(HYChannelPageResponse *)response error:(NSError *)err
{
    [HYLoadHubView dismiss];
    if (!err)
    {
        for (HYMallChannelBoard *board in response.boardList)
        {
            switch (board.boardType)
            {
                case ChannelBoardBanner:
                    self.bannerBoard = board;
                    break;
                case ChannelBoardHot:
                    self.hotBoard = board;
                    break;
                case ChannelBoardNew:
                    self.ntsBoard = board;
                    break;
                case ChannelBoardTimeLimit:
                    self.timeLimitBoard = board;
                    break;
                case ChannelBoardTheme:
                    self.themeBoard = board;
                    break;
                case ChannelBoardSpecial:
                    self.specialBoard = board;
                    break;
                case ChannelBoardBrand:
                    self.brandBoard = board;
                    break;
                default:
                    break;
            }
        }
        self.cateArray = response.cateList;
        [self calculateUIElementMapping];
        [self.tableView reloadData];
        
        if (self.cateArray.count > 0)
        {
            self.tableView.tableFooterView = self.tableFooter;
            [self.tableFooter startLoadMore];
            [self reloadGoodsDataWithCateIndex:0];
        }
        else
        {
            self.tableView.tableFooterView = nil;
        }
        
        self.title = response.channelTitle;
    }
    else
    {
        [METoast toastWithMessage:err.domain];
    }
}

/**
 *  计算各版块显示与否及显示的顺序
 *
 */
- (void)calculateUIElementMapping
{
    NSInteger count = 0;
    if (self.bannerBoard.channelBannerList.count > 0)
    {
        _sectionMapping[count] = ChannelBoardBanner;
        count += 1;
    }
    if (self.hotBoard.channelBannerList.count > 0 &&
        self.ntsBoard.channelBannerList.count > 0 &&
        self.timeLimitBoard.channelBannerList.count > 0)
    {
        _sectionMapping[count] = ChannelBoardHot;
        count += 1;
    }
    if (self.themeBoard.channelBannerList.count > 0)    //主题活动
    {
        _sectionMapping[count] = ChannelBoardTheme;
        count += 1;
    }
    if (self.specialBoard.channelBannerList.count > 2)  //专题活动, 只有大于三个才显示
    {
        _sectionMapping[count] = ChannelBoardSpecial;
        count += 1;
    }
    if (self.brandBoard.channelBannerList.count > 0)
    {
        _sectionMapping[count] = ChannelBoardBrand;
        count += 1;
    }
    if (self.cateArray.count > 0)
    {
        _sectionMapping[count] = ChannelBoardGoods;
        count += 1;
    }
    _sectionCount = count;
}

//- (CGFloat)calculateTitleOffset
//{
//    if (_sectionCount > 0 && _sectionMapping[_sectionCount-1] == ChannelBoardGoods)
//    {
//        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:_sectionCount-1];
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
//        if (cell)
//        {
//            _titleOffset = CGRectGetMaxY(cell.frame);
//        }
//    }
//    return _titleOffset;
//}

- (HYMallChannelBoardType)mappedSection:(NSInteger)section
{
    if (section < _sectionCount)
    {
        return _sectionMapping[section];
    }
    return ChannelBoardUnknown;
}

#pragma mark - More data
- (void)reloadGoodsDataWithCateIndex:(NSInteger)idx
{
    if (idx < _cateArray.count)
    {
        HYChannelCategory *cate = [_cateArray objectAtIndex:idx];
        self.currentCate = cate;
        _page = 1;
        _hasMore = YES;
        _isLoading = NO;
        self.goodsList = [NSMutableArray array];
        [self loadGoodsData];
    }
}

- (void)loadMoreGoodsData
{
    _page += 1;
    [self loadGoodsData];
}

- (void)loadGoodsData
{
    if (!_goodsRequest)
    {
        _goodsRequest = [[HYChannelGoodsRequest alloc] init];
        _goodsRequest.pageSize = 20;
    }
    _goodsRequest.page = _page;
    _goodsRequest.cateCode = _currentCate.categoryCode;
    self.isLoading = YES;
    [self.tableFooter startLoadMore];
    [HYLoadHubView show];
    __weak typeof(self) weakSelf = self;
    [_goodsRequest sendReuqest:^(id result, NSError *error)
    {
        [weakSelf updateWithGoodsResponse:result error:error];
    }];
}

- (void)updateWithGoodsResponse:(HYChannelGoodsResponse *)response error:(NSError *)err
{
    self.isLoading = NO;
    [HYLoadHubView dismiss];
    [self.tableFooter stopLoadMore];
    
    if (err)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err.domain delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        _hasMore = NO;
    }
    else if (response.status == 200)
    {
        _hasMore = response.goodsList.count > 0;
        [self.goodsList addObjectsFromArray:response.goodsList];
        [self.tableView reloadData];
    }
}

#pragma mark - 各种界面跳转
#pragma mark - HYMallProductListCellDelegate
- (void)didClickWithBoardType:(NSInteger)boardType itemAtIndex:(NSInteger)idx
{
    if (idx < [self.bannerBoard.channelBannerList count])
    {
        HYMallChannelItem *item = self.bannerBoard.channelBannerList[idx];
        [self checkBannerItem:item
                    withBoard:self.bannerBoard];
    }
}

- (void)checkBannerItem:(id)product withBoard:(id)board
{
    if ([product isKindOfClass:[HYMallChannelItem class]] &&
        [board isKindOfClass:[HYMallChannelBoard class]])
    {
        HYMallChannelItem *item = (HYMallChannelItem *)product;
        HYMallChannelBoard *channelBoard = (HYMallChannelBoard *)board;
        
        [[HYAnalyticsManager sharedManager] hotStaticsWithB:channelBoard.channelBoardCode
                                                         b2:item.bannerCode
                                                          t:item.bannerType
                                                       from:2];
        
        //特殊处理执销排行, 新品推荐这两个栏目,没有bannerType, 直接使用boardCode进行跳转
        if (item.boardType == ChannelBoardHot || item.boardType == ChannelBoardNew)
        {
            HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithParamStr:item.url];
            HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
            vc.title = item.boardType == ChannelBoardHot ? @"热销排行": @"新品推荐";
            vc.getSearchDataReq = req;
            vc.showRecommendGoods = YES;
            
            [self.navigationController pushViewController:vc
                                                 animated:YES];
            
            [HYAnalyticsManager sendProductListVisitFromChannelWithItem:item
                                                                  board:board
                                                                  stgid:self.stgId];
            [[HYAnalyticsManager sharedManager]beginProductDetailFromChannelWithItem:item
                                                                               board:board];
        }
        else
        {
            switch (item.itemType)
            {
                case MallHomeItemWeb:  //url
                {
                    PTHttpManager *mg = [PTHttpManager getInstantane];
                    NSString *user_id = [NSString stringWithFormat:@"user_id=%@",[[HYUserInfo getUserInfo] userId]];
                    NSString *appkey = [NSString stringWithFormat:@"app_key=%@", [mg appKey]];
                    NSString *token = [NSString stringWithFormat:@"token=%@", [HYUserInfo getUserInfo].token];
                    
                    NSString *timestamp = [mg timestamp];
                    NSString *signature = [mg getSigantureWittTimestpamp:timestamp];
                    signature = [NSString stringWithFormat:@"signature=%@", signature];
                    timestamp = [NSString stringWithFormat:@"timestamp=%@", timestamp];
                    
                    NSMutableString *str = [NSMutableString string];
                    if ([appkey length] > 0 && [timestamp length] > 0 && [signature length] > 0 && [token length] > 0)
                    {
                        [str appendString:appkey];
                        [str appendString:[NSString stringWithFormat:@"&%@", timestamp]];
                        [str appendString:[NSString stringWithFormat:@"&%@", signature]];
                        [str appendString:@"&app_from=IOS"];
                        [str appendString:[NSString stringWithFormat:@"&%@", user_id]];
                        [str appendString:[NSString stringWithFormat:@"&%@", token]];
                        
                        NSURL* parsedURL = [NSURL URLWithString:item.url];
                        NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
                        
                        NSString *url = [NSString stringWithFormat:@"%@%@%@", item.url, queryPrefix, str];
                        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                        
                        HYMallWebViewController *goodWeb = [[HYMallWebViewController alloc]init];
                        goodWeb.linkUrl = url;
                        goodWeb.title = item.bannerName;
                        [self.navigationController pushViewController:goodWeb animated:YES];
                        
                        [HYAnalyticsManager sendWebVisitReqWithURL:item.url];
                    }
                }
                    break;
                case MallHomeItemStore:
                case MallHomeItemSearch:
                case MallHomeItemBrand:
                {
                    HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
                    vc.title = item.bannerName;
                    
                    //request init
                    HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithParamStr:item.url];
                    if (item.itemType == MallHomeItemStore)
                    {
                        req.searchType = @"10";
                    }
                    else if (item.itemType == MallHomeItemSearch)
                    {
                        req.searchType = @"10";
                    }
                    else
                    {
                        req.searchType = @"30";
                    }
                    
                    vc.getSearchDataReq = req;
                    
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                    
                    [HYAnalyticsManager sendProductListVisitFromChannelWithItem:item
                                                                          board:board
                                                                          stgid:self.stgId];
                    [[HYAnalyticsManager sharedManager]beginProductDetailFromChannelWithItem:item
                                                                                       board:board];
                }
                    break;
                case MallHomeItemCategory:
                {
                    if ([item.businessType isEqualToString:BusinessType_Mall])
                    {
                        HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithParamStr:item.url];
                        req.searchType = @"20";
                        
                        HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
                        vc.title = item.bannerName;
                        vc.getSearchDataReq = req;
                        
                        [self.navigationController pushViewController:vc
                                                             animated:YES];
                        
                        [HYAnalyticsManager sendProductListVisitFromChannelWithItem:item
                                                                              board:board
                                                                              stgid:self.stgId];
                        [[HYAnalyticsManager sharedManager]beginProductDetailFromChannelWithItem:item
                                                                                           board:board];
                    }
                    else
                    {
                        HYFlowerSubListViewController* vc = [[HYFlowerSubListViewController alloc]init];
                        vc.categoryID = item.productId;
                        vc.categoryName = item.bannerName;
                        [self.navigationController pushViewController:vc
                                                             animated:YES];
                    }
                }
                    break;
                case MallHomeItemGoods: //商品详情
                {
                    if ([item.businessType isEqualToString:BusinessType_Mall])
                    {
                        HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
                        vc.goodsId =  item.productId;
                        [self.navigationController pushViewController:vc
                                                             animated:YES];
                        
                        [[HYAnalyticsManager sharedManager] beginProductDetailFromChannelWithItem:item board:board];
                        
                    }
                    else if ([item.businessType isEqualToString:BusinessType_Flower])
                    {
                        
                        HYFlowerDetailViewController* vc = [[HYFlowerDetailViewController alloc]init];
                        vc.produceID = item.productId;
                        vc.title = item.bannerName;
                        vc.headImgUrl = item.image;
                        [self.navigationController pushViewController:vc
                                                             animated:YES];
                        
                    }
                }
                    break;
                case MallHomeItemActive: //活动商品列表
                {
                    if ([item.businessType isEqualToString:BusinessType_Mall])
                    {
                        
                        HYActivityGoodsRequest *req = [[HYActivityGoodsRequest alloc] initReqWithParamStr:item.url];
                        
                        HYActivityProductListViewController *list = [[HYActivityProductListViewController alloc] init];
                        list.getDataReq = req;
                        list.title = item.bannerName;
                        [self.navigationController pushViewController:list animated:YES];
                        
                        [HYAnalyticsManager sendProductListVisitFromChannelWithItem:item
                                                                              board:board
                                                                              stgid:self.stgId];
                        [[HYAnalyticsManager sharedManager]beginProductDetailFromChannelWithItem:item
                                                                                           board:board];
                    }
                    else if ([item.businessType isEqualToString:BusinessType_Flower])
                    {
                        
                        HYActivityGoodsRequest *req = [[HYActivityGoodsRequest alloc] initReqWithParamStr:item.url];
                        
                        HYFlowerSubListViewController* vc = [[HYFlowerSubListViewController alloc]init];
                        vc.getActiveDataReq = req;
                        vc.title = item.bannerName;
                        [self.navigationController pushViewController:vc
                                                             animated:YES];
                    }
                    
                    break;
                }
                case MallHomeItemNew:
                case MallHomeItemHot:
                {
                    HYActivityGoodsRequest *req = [[HYActivityGoodsRequest alloc] initReqWithParamStr:item.url];
                    
                    HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
                    vc.title = item.bannerName;
                    vc.showRecommendGoods = YES;
                    vc.getActiveDataReq = req;
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                    
                    [HYAnalyticsManager sendProductListVisitFromChannelWithItem:item
                                                                          board:board
                                                                          stgid:self.stgId];
                    [[HYAnalyticsManager sharedManager]beginProductDetailFromChannelWithItem:item
                                                                                       board:board];
                }
                    break;
                case MallHomeItemShowHands:
                {
                    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
                    if (isLogin)
                    {
                        PTHttpManager *mg = [PTHttpManager getInstantane];
                        NSString *user_id = [NSString stringWithFormat:@"user_id=%@",[[HYUserInfo getUserInfo] userId]];
                        NSString *appkey = [NSString stringWithFormat:@"app_key=%@", [mg appKey]];
                        NSString *token = [NSString stringWithFormat:@"token=%@", [HYUserInfo getUserInfo].token];
                        
                        NSString *timestamp = [mg timestamp];
                        NSString *signature = [mg getSigantureWittTimestpamp:timestamp];
                        signature = [NSString stringWithFormat:@"signature=%@", signature];
                        timestamp = [NSString stringWithFormat:@"timestamp=%@", timestamp];
                        
                        NSMutableString *str = [NSMutableString string];
                        if ([appkey length] > 0 && [timestamp length] > 0 && [signature length] > 0 && [token length] > 0)
                        {
                            [str appendString:appkey];
                            [str appendString:[NSString stringWithFormat:@"&%@", timestamp]];
                            [str appendString:[NSString stringWithFormat:@"&%@", signature]];
                            [str appendString:@"&app_from=IOS"];
                            [str appendString:[NSString stringWithFormat:@"&%@", user_id]];
                            [str appendString:[NSString stringWithFormat:@"&%@", token]];
                            
                            NSURL* parsedURL = [NSURL URLWithString:item.url];
                            NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
                            
                            NSString *url = [NSString stringWithFormat:@"%@%@%@", item.url, queryPrefix, str];
                            url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                            
                            HYShowHandViewController *vc = [[HYShowHandViewController alloc] init];
                            vc.title = item.bannerName;
                            vc.linkUrl = url;
                            [self.navigationController pushViewController:vc
                                                                 animated:YES];
                        }
                        
                        //统计
                        [HYAnalyticsManager sendWebVisitReqWithURL:item.url];
                    }
                }
                    break;
                case MallHomeItemChannel:
                {
                    HYChannelViewController *vc = [[HYChannelViewController alloc] init];
                    vc.channelCode = item.bannerCode;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    [HYAnalyticsManager sendProductListVisitFromChannelWithItem:item
                                                                          board:board
                                                                          stgid:self.stgId];
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    else if ([product isKindOfClass:[HYMallChannelGoods class]])
    {
        HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
        vc.goodsId = [(HYMallChannelGoods *)product productCode];
        [self.navigationController pushViewController:vc animated:YES];
        
        [[HYAnalyticsManager sharedManager]beginDetailFromChannelWithProduct:product withCate:_currentCate];
    }
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
