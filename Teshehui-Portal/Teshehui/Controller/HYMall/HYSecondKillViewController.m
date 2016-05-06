//
//  HYSecondKillViewController.m
//  Teshehui
//
//  Created by Kris on 15/12/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSecondKillViewController.h"
#import "Masonry.h"
#import "HYSeckillBannerView.h"
#import "HYSeckillTimeView.h"
#import "HYSeckillGoodsListViewController.h"
#import "HYSeckillService.h"
#import "METoast.h"
#import "MJRefresh.h"
#import "UIAlertView+BlocksKit.h"
#import "HYNullView.h"

@interface HYSecondKillViewController ()

@property (nonatomic, strong) HYSeckillBannerView *bannerView;
@property (nonatomic, strong) HYSeckillTimeView *timeView;
@property (nonatomic, strong) HYSeckillService *seckillService;

/// 活动为空界面
@property (nonatomic, strong) HYNullView *nullView;

/// 数据domain
@property (nonatomic, strong) NSArray<HYSeckillActivityModel *> *activities;

@end

@implementation HYSecondKillViewController

///界面组装
- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;

    ///顶部banner
    CGFloat bannerHeight = TFScalePoint(50);
    HYSeckillBannerView *banner = [[HYSeckillBannerView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, bannerHeight)];
    [self.view addSubview:banner];
    WS(weakSelf);
    banner.didSelectItemAtIndex = ^(NSInteger idx) {
        [weakSelf showActivityWithIndex:idx];
    };
    self.bannerView = banner;

    ///计时banner
    
    /// 组装子视图
    self.pageContent = CGRectMake(0, bannerHeight, rect.size.width, rect.size.height-bannerHeight);
    NSMutableArray *controllers = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++)
    {
        HYSeckillGoodsListViewController *content = [[HYSeckillGoodsListViewController alloc] init];
        [controllers addObject:content];
    }
    self.contentControllers = controllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.name;
    [self loadActivity];
}

/**
 *  @brief 获取活动列表
 */
- (void)loadActivity
{
    [HYLoadHubView show];
    WS(weakSelf);
    [self.seckillService getSeckillActivities:^(NSArray<HYSeckillActivityModel *> *list, NSString *err)
    {
        [HYLoadHubView dismiss];
        [weakSelf updateWithActivityList:list error:err];
    }];
}

/** 
 *  @brief 活动列表更新
 *
 *  @param activityList 获得的活动列表model
 *  @param err          错误信息
 */
- (void)updateWithActivityList:(NSArray*)activityList error:(NSString *)err
{
    if (err)
    {
        [METoast toastWithMessage:err];
    }
    else if (activityList == nil || activityList.count == 0)
    {
        self.activities = nil;
        self.bannerView.items = nil;
        self.timeView.activity = nil;
        self.contentControllers = nil;
        
        self.nullView.hidden = NO;
    }
    else
    {
        self.activities = activityList;
        self.bannerView.items = activityList;
        self.contentControllers = nil;
        
        self.nullView.hidden = YES;
        
        /// 组装子视图
        NSMutableArray *controllers = [NSMutableArray array];
        NSInteger toShow = 0;
        for (NSInteger i = 0; i < activityList.count; i++)
        {
            HYSeckillGoodsListViewController *content = [[HYSeckillGoodsListViewController alloc] init];
            content.activity = [activityList objectAtIndex:i];
            /**
             *  @brief 下拉刷新时，更新上部的显示
             */
            WS(weakSelf);
            content.pulldownCallback = ^(HYSeckillActivityModel *getActivity)
            {
                NSMutableArray *activitys = [self.activities mutableCopy];
                [activitys replaceObjectAtIndex:weakSelf.currentIdx withObject:getActivity];
                weakSelf.activities = activitys;
                [weakSelf showActivityWithIndex:weakSelf.currentIdx];
            };
            content.timeEndCallback = ^{
                [weakSelf loadActivity];
            };
            [controllers addObject:content];
            
            /// 需要直接显示的活动项
            if (_activityId && [[[activityList objectAtIndex:i] activityId] isEqualToString:_activityId])
            {
                toShow = i;
            }
        }
        self.contentControllers = controllers;
        
        [self showActivityWithIndex:toShow];
    }
}

/**
 *  @brief 显示对应序号的活动
 *
 *  @param idx 活动序号
 *  需要：1、显示选中banner。2、显示相应子视图。
 */
- (void)showActivityWithIndex:(NSInteger)idx
{
    self.bannerView.selectedIdx = idx;
    self.currentIdx = idx;
}

/// 显示子控制器
- (void)didShowControllerAtIndex:(NSInteger)idx
{
    self.bannerView.selectedIdx = idx;
}

- (HYSeckillService *)seckillService
{
    if (!_seckillService) {
        _seckillService = [[HYSeckillService alloc] init];
    }
    return _seckillService;
}

- (HYNullView *)nullView
{
    if (!_nullView)
    {
        _nullView = [[HYNullView alloc] initWithFrame:self.pageContent];
        _nullView.descInfo = @"暂无秒杀活动";
        [self.view insertSubview:_nullView atIndex:0];
    }
    return _nullView;
}


@end
