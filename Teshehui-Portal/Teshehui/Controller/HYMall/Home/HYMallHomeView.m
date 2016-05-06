//
//  HYMallHomeView.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallHomeView.h"
#import "HYMallHomeModalAdsView.h"
#import "HYMallHomeLayout.h"
#import "HYMallHomeHeaderCell.h"
#import "HYTableViewFooterView.h"
#import "HYMallHomeTitleCell.h"
#import "HYMallHomeTileCollectionCell.h"
#import "HYMallHomeProductCollectionCell.h"
#import "HYMallHomeFashionScrollCell.h"
#import "HYMallHomeFashionTileCell.h"
#import "HYMallHomeLifeCell.h"
#import "HYMallHomeCategoryCollectionCell.h"
#import "HYMallHomeBrandBoostCell.h"
#import "HYMallHomeBrandTileCell.h"
#import "HYMallHomeBrandAdsCell.h"
#import "HYMallHomeMoreTimeCell.h"
#import "HYMallHomeLoadMoreView.h"
#import "HYTableViewFooterView.h"
#import "HYMallHomeRecommendHeader.h"
#import "HYMallHomeTextAdsCell.h"
#import "HYMallHomeBaseLineHeader.h"
#import "HYMallHomeInterestCell.h"
#import "HYMallHomeBrandMoreCell.h"
#import "HYMallHomeShoppingPlaceCell.h"
#import "HYNullView.h"
#import "HYHomeMoreView.h"
#import "UIColor+hexColor.h"

#import "HYMallHomeViewModel.h"
#import "PTDateFormatrer.h"
#import "NSDate+Addition.h"

#import "HYUmengMobClick.h"
#import "HYMallHomeCellDelegate.h"

#define NAVBAR_CHANGE_POINT 50

@interface HYMallHomeView ()
<UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
HYMallHomeCellDelegate,
HYMallHomeBrandBoostDelegate
>
{
    NSInteger _pageNumber;
    
    NSInteger _recmPageNumber;
    
    HYMallHomeLayout *_collectionLayout;
    
    //界面控制
    CGFloat _prevContentOffsetY;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HYMallHomeHeaderView *headerView;
@property (nonatomic, strong) HYTableViewFooterView *loadMoreView;
@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIButton *scrollToTopBtn;  //滑动到顶部

@property (nonatomic, strong) HYMallHomeViewModel *viewModel;

@end

@implementation HYMallHomeView

- (void)setupWithModel:(HYMallHomeViewModel *)viewmodel
{
    self.viewModel = viewmodel;
    if (self.viewModel.moreBoard.programPOList.count > 0) {
        _collectionLayout.moreSection = viewmodel.totalSection-1;
    }
    [_collectionLayout invalidateLayout];
    [self.collectionView reloadData];
    
    WS(weakSelf);
    viewmodel.dataDidUpdate = ^{
        [weakSelf.collectionView reloadData];
    };
}

- (UIButton *)scrollToTopBtn
{
    if (!_scrollToTopBtn)
    {
        _scrollToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scrollToTopBtn.frame = CGRectMake(CGRectGetMaxX(self.frame)-50,
                                           CGRectGetHeight(self.frame)-90,
                                           TFScalePoint(30),
                                           TFScalePoint(30));
        [_scrollToTopBtn setImage:[UIImage imageNamed:@"icon_returnUp"]
                         forState:UIControlStateNormal];
        [_scrollToTopBtn addTarget:self
                            action:@selector(scrollViewToTopEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_scrollToTopBtn];
        [self bringSubviewToFront:_scrollToTopBtn];
    }
    
    return _scrollToTopBtn;
}

- (HYNullView *)nullView
{
    if (!_nullView)
    {
        CGRect frame = self.frame;
        frame.origin = CGPointZero;
        
        _nullView = [[HYNullView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _nullView.needTouch = YES;
        [_nullView addTarget:self
                      action:@selector(didClickUpdateEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nullView];
    }
    return _nullView;
}

//重新加载数据
//在点击nullView的时候调用
- (void)didClickUpdateEvent:(id)sender
{
    [self.nullView setHidden:YES];
    [self.delegate reloadAllData];
}

- (void)scrollViewToTopEvent:(id)sender
{
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexColor:@"f9f9f9" alpha:1];
        
        HYMallHomeLayout *layout = [[HYMallHomeLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.footerReferenceSize = CGSizeMake(frame.size.width, 8);
        _collectionLayout = layout;
        layout.minimumInteritemSpacing = 4;
        layout.sectionInset = UIEdgeInsetsMake(2, 8, 2, 8);
        
        //collection
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        collection.delegate = self;
        collection.dataSource = self;
        collection.backgroundColor = [UIColor colorWithHexColor:@"f9f9f9" alpha:1];
        collection.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        //register!
        [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"default"];
        [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"default"];
        [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"default"];
        [collection registerClass:[HYMallHomeHeaderCell class] forCellWithReuseIdentifier:@"header"];
        [collection registerNib:[UINib nibWithNibName:@"HYMallHomeTitleCell" bundle:nil]forCellWithReuseIdentifier:@"title"];
        [collection registerClass:[HYMallHomeTileCollectionCell class] forCellWithReuseIdentifier:@"tileCell"];
        [collection registerClass:[HYMallHomeProductCollectionCell class] forCellWithReuseIdentifier:@"recomend"];
        [collection registerClass:[HYMallHomeFashionScrollCell class] forCellWithReuseIdentifier:@"fashionScroll"];
        [collection registerClass:[HYMallHomeFashionTileCell class] forCellWithReuseIdentifier:@"fashionTile"];
        [collection registerClass:[HYMallHomeLifeCell class] forCellWithReuseIdentifier:@"life"];
        [collection registerClass:[HYMallHomeCategoryCollectionCell class] forCellWithReuseIdentifier:@"category"];
        [collection registerClass:[HYMallHomeBrandBoostCell class] forCellWithReuseIdentifier:@"brand"];
        [collection registerClass:[HYMallHomeBrandTileCell class] forCellWithReuseIdentifier:@"brandTile"];
        [collection registerClass:[HYMallHomeBrandAdsCell class] forCellWithReuseIdentifier:@"brandAds"];
        [collection registerClass:[HYMallHomeInterestCell class] forCellWithReuseIdentifier:@"interest"];
        [collection registerClass:[HYMallHomeBrandMoreCell class] forCellWithReuseIdentifier:@"brandMore"];
        [collection registerClass:[HYMallHomeMoreTimeCell class] forCellWithReuseIdentifier:@"time"];
        [collection registerClass:[HYMallHomeShoppingPlaceCell class] forCellWithReuseIdentifier:@"shoppingPlace"];
        [collection registerClass:[HYMallHomeLoadMoreView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"loadMore"];
        [collection registerClass:[HYMallHomeRecommendHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"recommendedHead"];
        [collection registerClass:[HYMallHomeTextAdsCell class] forCellWithReuseIdentifier:@"text"];
        [collection registerClass:[HYMallHomeBaseLineHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"lineHeader"];
        [self addSubview:collection];
        self.collectionView = collection;
        
        self.viewModel = [[HYMallHomeViewModel alloc] init];
        self.viewModel.totalSection = 1;
        
//        if (!_titleView)
//        {
//            CGRect rect = CGRectMake(0, 0, frame.size.width, 44);
//            if (CheckIOS7)
//            {
//                rect.size.height += 20;
//            }
//            _titleView = [[UIView alloc] initWithFrame:rect];
//            _titleView.backgroundColor = [UIColor colorWithRed:192.0/255.0
//                                                         green:11.0/255.0
//                                                          blue:11.0/255.0
//                                                         alpha:1.0];
//            [self addSubview:_titleView];
//        }
    }
    return self;
}

//- (void)updateNavgationbarAlpha
//{
//    [UIView animateWithDuration:.3 animations:^{
//        _titleView.alpha = (self.collectionView.contentOffset.y)/64;
//    }];
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //计算section!
    return self.viewModel.totalSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numberOfItemsForSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger mappedSection = [self.viewModel boardTypeForSection:indexPath.section];
    if (mappedSection == MallHomeAds)
    {
        if (indexPath.row == 0) //轮播
        {
            HYMallHomeHeaderCell *header = [collectionView dequeueReusableCellWithReuseIdentifier:@"header" forIndexPath:indexPath];
            header.headerView.delegate = self;
            header.headerView.boardType = MallHomeAds;
            header.backgroundColor = [UIColor whiteColor];
            header.headerView.adsData = _viewModel.homeAds.programPOList;
            return header;
        }
        else                    //兴趣列表
        {
            HYMallHomeInterestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"interest" forIndexPath:indexPath];
            cell.items = self.viewModel.interest.programPOList;
            cell.boardType = MallHomeInterestTag;
            cell.delegate = self;
            WS(weakSelf);
            cell.checkAllTags = ^{
                if ([weakSelf.delegate respondsToSelector:@selector(checkInterestTags)]) {
                    [weakSelf.delegate checkInterestTags];
                }
            };
            return cell;
        }
    }
    else if (mappedSection == MallHomeMore) //更多
    {
        if (indexPath.row == 0)
        {
            HYMallHomeMoreTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"time" forIndexPath:indexPath];
            NSDate *date = self.viewModel.moreBoard.lastUpdateDate;
            if (date)
            {
                NSString *time = [PTDateFormatrer stringFromDate:date format:@"HH:mm"];
                cell.time = [NSString stringWithFormat:@"%@ 更新", time];
                NSInteger week = [date getWeekday];
                NSString *weekstr = [PTDateFormatrer weekChinese:(int)week];
                NSString *datestr = [PTDateFormatrer stringFromDate:date format:@"MM/dd"];
                cell.date = [NSString stringWithFormat:@"%@ %@", datestr, weekstr];
            }
            return cell;
        }
        else
        {
            HYMallHomeProductCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recomend" forIndexPath:indexPath];
            
            NSInteger index = indexPath.row - 1;
            if (index < self.viewModel.moreBoard.programPOList.count)
            {
                HYMallHomeItem *item = [self.viewModel.moreBoard.programPOList objectAtIndex:index];
                cell.item = item;
            }
            
            return cell;
        }
    }
    else if (mappedSection == MallHomeActive)   //超优惠（活动）
    {
        NSInteger index = indexPath.row;
        if (self.viewModel.textAds.programPOList.count == 0) {
            index += 1;
        }
        if (index == 0) {           //文字广告
            HYMallHomeTextAdsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text" forIndexPath:indexPath];
            cell.board = _viewModel.textAds;
            return cell;
        }
        else if (index == 1) {
            HYMallHomeTitleCell *title = [collectionView dequeueReusableCellWithReuseIdentifier:@"title" forIndexPath:indexPath];
            title.titleLabel.text = self.viewModel.productPreferential.title;
            title.iconImg.image = [UIImage imageNamed:@"icon_home_sale"];
            title.descLabel.text = nil;
            title.moreLabel.text = nil;
            return title;
        }
        else if (index == 2) {
            HYMallHomeTileCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"tileCell" forIndexPath:indexPath];
            cell.boardType = MallHomeActive;
            cell.title = self.viewModel.productPreferential.title;
            cell.items = self.viewModel.productPreferential.programPOList;
            cell.delegate = self;
            return cell;
        }
    }
    else if (mappedSection == MallHomeBrand)    //品牌街
    {
        NSInteger index = indexPath.row;
        if ((self.viewModel.brand.programPOList.count == 0 || !self.viewModel.brand) &&
            index > 0)
        {
            index += 2;
        }
        if (index == 0)
        {
            HYMallHomeTitleCell *title = [collectionView dequeueReusableCellWithReuseIdentifier:@"title" forIndexPath:indexPath];
            title.titleLabel.text = self.viewModel.brand.title;
            title.iconImg.image = [UIImage imageNamed:@"icon_home_brandstreet"];
            title.descLabel.text = nil;
            title.moreLabel.text = nil;
            return title;
        }
        else if (index == 1)
        {
            HYMallHomeBrandTileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"brandTile" forIndexPath:indexPath];
            cell.items = self.viewModel.brand.programPOList;
            cell.boardType = MallHomeBrand;
            cell.delegate = self;
            return cell;
        }
        else if (index == 2)
        {
            HYMallHomeBrandMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"brandMore" forIndexPath:indexPath];
            
            return cell;
        }
        else
        {
            HYMallHomeBrandAdsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"brandAds" forIndexPath:indexPath];
            cell.headerView.boardType = MallHomeBrandAds;
            cell.headerView.adsData = [[self.viewModel boardWithType:MallHomeBrandAds] programPOList];
            cell.headerView.delegate = self;
            return cell;
        }
    }
    else if (mappedSection == MallHomeImageAds)
    {
        HYMallHomeBrandAdsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"brandAds" forIndexPath:indexPath];
        cell.headerView.boardType = MallHomeImageAds;
        cell.headerView.adsData = [[self.viewModel boardWithType:MallHomeImageAds] programPOList];
        cell.headerView.delegate = self;
        return cell;
    }
    else if (mappedSection == MallHomeEspCheap) //视频购物
    {
        if (indexPath.row == 0)
        {
            HYMallHomeTitleCell *title = [collectionView dequeueReusableCellWithReuseIdentifier:@"title" forIndexPath:indexPath];
            title.titleLabel.text = self.viewModel.especialCheap.title;
            title.iconImg.image = [UIImage imageNamed:@"icon_home_brand"];
            title.descLabel.text = @"特奢汇已为您试用";
            title.moreLabel.text = @"更多>>";
            title.showMore = YES;
            return title;
        }
        else
        {
            HYMallHomeBrandBoostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"brand" forIndexPath:indexPath];
            cell.boardType = MallHomeEspCheap;
            cell.items = self.viewModel.especialCheap.programPOList;
            cell.delegate = self;
            return cell;
        }
    }
    else if (mappedSection == MallHomeShoppingPlace)
    {
        HYMallHomeShoppingPlaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shoppingPlace" forIndexPath:indexPath];
        if (indexPath.row < self.viewModel.shoppingPlace.programPOList.count) {
            cell.item = self.viewModel.shoppingPlace.programPOList[indexPath.row];
        }
        return cell;
    }
    
    //default test
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"default" forIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger mappedSection = [self.viewModel boardTypeForSection:indexPath.section];
    if (mappedSection == MallHomeMore)
    {
        if ([kind isEqualToString:UICollectionElementKindSectionFooter])
        {
            HYMallHomeLoadMoreView *moreview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"loadMore" forIndexPath:indexPath];
            if (_viewModel->_hasMore)
            {
                [moreview startLoadMore];
            }
            else
            {
                [moreview stopLoadMore];
            }
            return moreview;
        }
        else
        {
            HYMallHomeRecommendHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"recommendedHead" forIndexPath:indexPath];
            return header;
        }
    }
    else
    {
        if ([kind isEqualToString:UICollectionElementKindSectionFooter])
        {
            HYMallHomeBaseLineHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"lineHeader" forIndexPath:indexPath];
            return header;
        }
    }
    
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"default" forIndexPath:indexPath];
}

/// 这里的高度计算全部使用与效果图相同比例
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger mappedSection = [_viewModel boardTypeForSection:indexPath.section];
    CGFloat width = self.frame.size.width;
    if (mappedSection == MallHomeAds)
    {
        if (indexPath.row == 0)
        {
            //0.57
            return CGSizeMake(width, width*0.6038);
        }
        else
        {
            return CGSizeMake(width, TFScalePoint(130));
        }
    }
    
    if (mappedSection == MallHomeActive )
    {
        NSInteger index = indexPath.row;
        if (self.viewModel.textAds.programPOList.count == 0) {
            index += 1;
        }
        if (index == 0) {
            return CGSizeMake(width, TFScalePoint(44));
        }
        else if (index == 1) {
            return CGSizeMake(width, TFScalePoint(25));
        }
        else {
            return CGSizeMake(width, TFScalePoint(225));
        }
    }
    else if (mappedSection == MallHomeEspCheap)
    {
        if (indexPath.row > 0)
        {
            return CGSizeMake(width, TFScalePoint(125));
        }
    }
    else if (mappedSection == MallHomeBrand)
    {
        if (indexPath.row > 0)
        {
            NSInteger index = indexPath.row;
            if (!self.viewModel.brand || self.viewModel.brand.programPOList.count == 0)
            {
                index += 2;
            }
            if (index == 1)
            {
                return CGSizeMake(width, TFScalePoint(144));
            }
            else if (index == 2)
            {
                return CGSizeMake(width, TFScalePoint(37));
            }
            else if (index == 3)
            {
                return CGSizeMake(width, TFScalePoint(100));
            }
        }
    }
    else if (mappedSection == MallHomeImageAds)
    {
        return CGSizeMake(width, TFScalePoint(100));
    }
    else if (mappedSection == MallHomeShoppingPlace)    //卖场活动
    {
        return CGSizeMake(width, TFScalePoint(130)+5);
    }
    else if (mappedSection == MallHomeMore)
    {
        CGFloat width = (self.frame.size.width-24) / 2;
        if (indexPath.row == 0)
        {
            return CGSizeMake(width, width*0.2);
        }
        else
        {
            return CGSizeMake(width, width*1.4);
        }
    }
    return CGSizeMake(width, TFScalePoint(25));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    NSUInteger mappedSection = _viewModel->_sectionMapping[section];
    if (mappedSection == MallHomeMore)
    {
        return 8;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSUInteger mappedSection = _viewModel->_sectionMapping[section];
    if (mappedSection == MallHomeMore)
    {
        return UIEdgeInsetsMake(0, 8, 0, 8);
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    NSUInteger mappedSection = _viewModel->_sectionMapping[section];
    if (mappedSection == MallHomeMore)
    {
        return CGSizeMake(self.frame.size.width, 44);
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger mappedSection = _viewModel-> _sectionMapping[indexPath.section];
    if (mappedSection == MallHomeLife && indexPath.row > 0) //生活日用
    {
        NSInteger index = indexPath.row - 1;
        //统计
        [HYUmengMobClick homePageLifeClickedWithNumber:(int)index+1];
        [self.delegate checkBoard:MallHomeLife itemAtIndex:index];
    }
    else if (mappedSection == MallHomeProductType && indexPath.row > 0)
    {
        NSInteger index = indexPath.row - 1;
        //统计
        [HYUmengMobClick homePageChoicenessClickedWithNumber:(int)index+1];
        [self.delegate checkBoard:mappedSection itemAtIndex:index];
    }
    else if (mappedSection == MallHomeBrand)    //  品牌街，第三行，更多品牌可以点击
    {
        if (indexPath.row == 2) {
            [self.delegate checkMoreBrand];
        }
    }
    else if (mappedSection == MallHomeActive && !indexPath.row)    //  超优惠，第一行是文字轮播广告
    {
        HYMallHomeTextAdsCell *cell = (HYMallHomeTextAdsCell*)[collectionView cellForItemAtIndexPath:indexPath];
        [self.delegate checkBoard:MallHomeTextAds itemAtIndex:cell.currentIdx];
        [HYUmengMobClick homePageTextADClickedWithNumber:(int)cell.currentIdx];
    }
    else if (mappedSection == MallHomeShoppingPlace)    ///卖场活动
    {
        [self.delegate checkBoard:MallHomeShoppingPlace itemAtIndex:indexPath.row];
    }
    else if (mappedSection == MallHomeMore && indexPath.row > 0)
    {
        NSInteger index = indexPath.row - 1;
        [self.delegate checkBoard:mappedSection itemAtIndex:index];
    }
    else if (mappedSection == MallHomeEspCheap && indexPath.row == 0)
    {
        [HYUmengMobClick homePagePublicityBrandMoreClicked];
        [self.delegate performSelector:@selector(brandBoostWillCheckMore)];
    }
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
        if (scrollView.contentOffset.y > self.frame.size.height*3)
        {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [_scrollToTopBtn setHidden:YES];
        }
    }
//    [self updateNavgationbarAlpha];
    
    //加载更多
    float scrollOffset = scrollView.contentOffset.y;
    float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (scrollOffset >= maximumOffset && self.viewModel.hasMore)
    {
        [self.delegate homeViewWillLoadMoreData];
    }
    
    // 根据滚动距离设置首页导航栏透明度
    UIColor *color = [UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0f];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT)
    {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        if ([self.delegate respondsToSelector:@selector(navigationBarAlphaWithColor:alpha:)])
        {
            [self.delegate navigationBarAlphaWithColor:color alpha:alpha];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(navigationBarAlphaWithColor:)])
        {
            [self.delegate navigationBarAlphaWithColor:color];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    //    [self.baseViewController setToolBarIsShow:YES];
    if (scrollView.contentOffset.y > self.frame.size.height*3)
    {
        [self.scrollToTopBtn setHidden:NO];
    }
    else
    {
        [_scrollToTopBtn setHidden:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _prevContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        if (scrollView.contentOffset.y > self.frame.size.height*3)
        {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [_scrollToTopBtn setHidden:YES];
        }
    }
}

#pragma mark -- cell delegate
- (void)didClickWithBoardType:(NSInteger)boardType itemAtIndex:(NSInteger)idx
{
    [self.delegate checkBoard:boardType itemAtIndex:idx];
}

- (void)brandBoostWillCheckMore
{
    [self.delegate performSelector:@selector(brandBoostWillCheckMore)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
