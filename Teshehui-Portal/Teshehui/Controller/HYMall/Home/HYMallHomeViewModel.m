//
//  HYMallHomeViewModel.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallHomeViewModel.h"

@implementation HYMallHomeViewModel

- (instancetype)initWithHomeItems:(NSArray *)items
{
    if (self = [super init]) {
        for (HYMallHomeBoard *board in items)
        {
            switch (board.boardType)
            {
                case MallHomeAds:
                    self.homeAds = board;
                    break;
                case MallHomeEspCheap:
                    self.especialCheap = board;
                    break;
                case MallHomeRecm:
                    self.homeRcmd = board;
                    break;
                case MallHomeActive:
                    self.productPreferential = board;
                    break;
                case MallHomeStore:
                    self.storeWeekly = board;
                    break;
                case MallHomeNew:
                    self.weekNew = board;
                    break;
                case MallHomeHot:
                    self.weekHot = board;
                    break;
                case MallHomeProductType:
                    self.category = board;
                    break;
                case MallHomeMore:
                    self.moreBoard = board;
//                    self.recommended = [board.programPOList mutableCopy];
                    break;
                case MallHomeTextAds:
                    self.textAds = board;
                    break;
                case MallHomeBrand:
                    self.brand = board;
                    break;
                case MallHomeBrandAds:
                    self.brandAds = board;
                    break;
                case MallHomeFashion:
                    self.fashion = board;
                    break;
                case MallHomeFashionScroll:
                    self.fashionScroll = board;
                    break;
                case MallHomeLife:
                    self.life = board;
                    break;
                case MallHomeShoppingPlace:
                    self.shoppingPlace = board;
                    break;
                case MallHomeImageAds:
                    self.imageAds = board;
                    break;
                case MallHomeInterestTag:
                {
                    self.interest = board;
                    break;
                }
                default:
                    break;
            }
        }
        
        [self calculateUIElementMapping];
        
        _hasMore = YES;
        _pageNumber = 1;
    }
    return self;
}

- (void)calculateUIElementMapping
{
    NSInteger count = 0;
    _sectionMapping[count] = MallHomeAds;
    if (self.productPreferential.programTotalNum.intValue > 0)
    {
        count += 1;
        _sectionMapping[count] = MallHomeActive;
    }
    //+ self.brandAds.programTotalNum.intValue > 0  4.6.0去掉了品牌街里面的滑动页广告
    if (self.brand.programTotalNum.intValue)
    {
        count += 1;
        _sectionMapping[count] = MallHomeBrand;
    }
    if (self.imageAds.programTotalNum.intValue > 0)
    {
        count += 1;
        _sectionMapping[count] = MallHomeImageAds;
    }
    if (self.especialCheap.programTotalNum.intValue > 0)
    {
        count += 1;
        _sectionMapping[count] = MallHomeEspCheap;
    }
    if (self.shoppingPlace.programPOList.count > 0) {
        count += 1;
        _sectionMapping[count] = MallHomeShoppingPlace;
    }
    if (self.moreBoard.programPOList.count > 0)
    {
        count += 1;
        _sectionMapping[count] = MallHomeMore;
    }
    self.totalSection = count + 1;
}

- (void)addMoreProducts:(NSArray *)products
{
    NSMutableArray *moreGoods = [self.moreBoard.programPOList mutableCopy];
    [moreGoods addObjectsFromArray:products];
    self.moreBoard.programPOList = (id)moreGoods;
    if (self.dataDidUpdate) {
        self.dataDidUpdate();
    }
}

- (NSInteger)numberOfItemsForSection:(NSInteger)section
{
    NSInteger count = 1;
    
    NSUInteger mappedSection = _sectionMapping[section];
    switch (mappedSection)
    {
        case MallHomeAds:
            if (self.interest.programPOList.count > 0) {
                count += 1;
            }
            break;
        case MallHomeActive:         //超优汇, 带头部两行
            count = 2;
            if (self.textAds.programPOList.count > 0) { //文字广告移到超优汇版块
                count += 1;
            }
            break;
//        case MallHomeFashion:
//            if (self.fashion.programPOList.count > 0)
//            {
//                count += 1;
//            }
//            if (self.fashionScroll.programPOList.count > 0)
//            {
//                count += 1;
//            }
//            break;
        case MallHomeBrand:
            
             //+ self.brandAds.programPOList.count 4.6.0版本去掉了品牌的广告图
            if (self.brand.programPOList.count > 0)
            {
                count += 1;
                count += 1; //新增更多品牌的入口
            }
            break;
//        case MallHomeLife:         //生活日用
//            count += 3;  //每一个小图块就是一个cell,方便不足时计算
//            break;
//        case MallHomeProductType:         //精选分类
//            count = 1 + 10;
//            break;
        case MallHomeEspCheap:
            count = 2; //品牌助推
            break;
        case MallHomeShoppingPlace:
            count = self.shoppingPlace.programPOList.count;
            break;
        case MallHomeMore:
            count = self.moreBoard.programPOList.count + 1;
            break;
        default:
            break;
    }
    return count;
}

- (HYMallHomeBoard *)boardWithType:(NSInteger)boardType
{
    HYMallHomeBoard *board = nil;
    switch (boardType) {
        case MallHomeAds:
        {
            board = self.homeAds;
        }
            break;
        case MallHomeFashionScroll:
        {
            board = self.fashionScroll;
            break;
        }
        case MallHomeFashion:
        {
            board = self.fashion;
            break;
        }
        case MallHomeBrand:
        {
            board = self.brand;
            break;
        }
        case MallHomeBrandAds:
        {
            board = self.brandAds;
            break;
        }
        case MallHomeLife:
        {
            board = self.life;
            break;
        }
        case MallHomeTextAds:
        {
            board = self.textAds;
            break;
        }
        case MallHomeEspCheap:
        {
            board = self.especialCheap;
            break;
        }
        case MallHomeMore:
        {
            board = self.moreBoard;
            break;
        }
        case MallHomeProductType:
        {
            board = self.category;
            break;
        }
        case MallHomeNew:
        {
            board = self.weekNew;
            break;
        }
        case MallHomeHot:
        {
            board = self.weekHot;
            break;
        }
        case MallHomeStore:
        {
            board = self.storeWeekly;
            break;
        }
        case MallHomeActive:
        {
            board = self.productPreferential;
            break;
        }
        case MallHomeRecm:
        {
            board = self.homeRcmd;
            break;
        }
        case MallHomeShoppingPlace:
            board = self.shoppingPlace;
            break;
        case MallHomeImageAds:
            board = self.imageAds;
            break;
        case MallHomeInterestTag:
            board = self.interest;
            break;
        default:
            break;
    }
    return board;
}

- (NSInteger)boardTypeForSection:(NSInteger)section
{
    return  self->_sectionMapping[section];
}

- (void)cleanAllMemoryData
{
    _pageNumber = 1;
    //    [self.productManager removeAllObject];
    
    self.homeAds = nil;
    self.especialCheap = nil;
    self.storeWeekly = nil;
    self.homeRcmd = nil;
    self.productPreferential = nil;
    self.weekHot = nil;
    self.weekNew = nil;
    self.imageAds = nil;
    self.shoppingPlace = nil;
    self.textAds = nil;
    
    _hasMore = YES;
}

@end
