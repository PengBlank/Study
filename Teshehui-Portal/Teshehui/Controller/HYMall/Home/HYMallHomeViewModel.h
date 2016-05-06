//
//  HYMallHomeViewModel.h
//  Teshehui
//
//  Created by 成才 向 on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYMallHomeSections.h"
#import "HYMallHomeBoard.h"

@interface HYMallHomeViewModel : NSObject
{
    @public
    NSInteger _sectionMapping[50];
    BOOL _hasMore;
    NSInteger _pageNumber;
}

//界面配置缓存
@property (nonatomic, assign) NSInteger totalSection;    //以section为key, section为value


@property (nonatomic, strong) HYMallHomeBoard *homeAds;
@property (nonatomic, strong) HYMallHomeBoard *especialCheap;  //特实惠, 品牌助推
@property (nonatomic, strong) HYMallHomeBoard *homeRcmd;  //力荐商品
@property (nonatomic, strong) HYMallHomeBoard *productPreferential;  //优惠
@property (nonatomic, strong) HYMallHomeBoard *storeWeekly;  //每周好店
@property (nonatomic, strong) HYMallHomeBoard *category;  //分类
@property (nonatomic, strong) HYMallHomeBoard *weekHot;  //热品
@property (nonatomic, strong) HYMallHomeBoard *weekNew;  //每周新品
@property (nonatomic, strong) HYMallHomeBoard *textAds; //文字广告
@property (nonatomic, strong) HYMallHomeBoard *fashionScroll;
@property (nonatomic, strong) HYMallHomeBoard *fashion;
@property (nonatomic, strong) HYMallHomeBoard *life;
@property (nonatomic, strong) HYMallHomeBoard *brand;
@property (nonatomic, strong) HYMallHomeBoard *brandAds;
@property (nonatomic, strong) HYMallHomeBoard *moreBoard;
//@property (nonatomic, strong) NSMutableArray<HYMallHomeItem*> *recommended;
/// 卖场活动
@property (nonatomic, strong) HYMallHomeBoard *shoppingPlace;   //
/// 新增图文广告
@property (nonatomic, strong) HYMallHomeBoard *imageAds;
/// 兴趣版块
@property (nonatomic, strong) HYMallHomeBoard *interest;

- (instancetype)initWithHomeItems:(NSArray *)items;

@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) NSInteger pageNumber;
- (void)addMoreProducts:(NSArray *)products;

@property (nonatomic, copy) void (^dataDidUpdate)(void);

- (NSInteger)numberOfItemsForSection:(NSInteger)section;
- (NSInteger)boardTypeForSection:(NSInteger)section;

- (HYMallHomeBoard *)boardWithType:(NSInteger)boardType;

- (void)cleanAllMemoryData;

@end
