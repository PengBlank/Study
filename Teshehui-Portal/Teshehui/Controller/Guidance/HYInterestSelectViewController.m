//
//  HYInterestSelectViewController.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYInterestSelectViewController.h"
#import "Masonry.h"
#import "HYInterestSelectView.h"
#import "HYMallHomeService.h"
#import "METoast.h"
#import "HYMallHomeBoard.h"
#import "HYInterestBulbleView.h"
#import "YYCache.h"
#import "UIControl+BlocksKit.h"

@interface HYInterestSelectViewController ()

@property (nonatomic, strong) HYInterestView *contentView;

@property (nonatomic, strong) HYMallHomeService *service;
@property (nonatomic, strong) HYMallHomeBoard *board;

/// array of item
@property (nonatomic, strong) NSArray *selectedItem;

@property (nonatomic, strong) YYCache *interestCache;

@end

@implementation HYInterestSelectViewController

- (void)loadView
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:bounds];
    if (!SupportSystemVersion(8))
    {
        self.contentView = [[HYInterestSelectView alloc] initWithFrame:bounds
                                                           supportSkip:self.supportSkip];
        [self.view addSubview:self.contentView];
    }
    else
    {
        self.contentView = [[HYInterestBulbleView alloc] initWithFrame:self.view.bounds
                                                           supportSkip:self.supportSkip];
        [self.view addSubview:self.contentView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我感兴趣";
    self.service = [[HYMallHomeService alloc] init];
    
    WS(weakSelf);
    [self.service loadAllInterestTags:^(NSArray *items) {
        
        [weakSelf loadAndUpdateCacheSelectedItems:items
                                         callback:^(NSArray *idxs) {
            [weakSelf.contentView bindWithData:items selectedIndexs:idxs];
        }];
    }];
    
    if ([self.contentView isKindOfClass:[HYInterestBulbleView class]] &&
        self.supportSkip)  //支持跳过
    {
        UIButton *skipt = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame)-50,
                                                                     10,
                                                                     40,
                                                                     40)];
        [skipt setImage:[UIImage imageNamed:@"label_close"]
               forState:UIControlStateNormal];
        [skipt bk_addEventHandler:^(id sender) {
            [weakSelf dismissViewControllerAnimated:YES
                                         completion:nil];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:skipt];
    }
    
    self.contentView.completeSelect = ^(NSArray *selectedIdxs) {
        [weakSelf saveSelectedItems:selectedIdxs];
        [weakSelf dismissViewControllerAnimated:YES
                                     completion:nil];
    };
    
    self.contentView.skip = ^{
        [weakSelf dismissViewControllerAnimated:YES
                                     completion:nil];
    };
}

- (void)loadAndUpdateCacheSelectedItems:(NSArray *)newItems
                               callback:(void (^)(NSArray *items))callback
{
    WS(weakSelf);
    [self.interestCache objectForKey:@"items" withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        
        //只获取服务器下发标签里面存在的，过滤掉本地过期的
        NSArray *cacheItmes = (NSArray *)object;
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
        for (HYMallHomeItem *item in newItems)
        {
            if (item.bannerCode && [cacheItmes containsObject:item.bannerCode])
            {
                [tempArr addObject:item.bannerCode];
            }
        }
        
        NSArray *updateArr = [tempArr copy];
        
        //update cache
        [weakSelf.interestCache setObject:updateArr
                                   forKey:@"items"];
        //涉及到更新UI，必须为主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            //callback
            callback(updateArr);
        });
    }];
}

- (void)saveSelectedItems:(NSArray *)items
{
    //判断是否变化
    NSArray *cacheTags = (NSArray *)[self.interestCache objectForKey:@"items"];
    BOOL hasChange = YES;
    if ([cacheTags count])
    {
        hasChange = [cacheTags isEqualToArray:items];
    }
    
    [self.interestCache setObject:items
                           forKey:@"items"];
    if (self.didSelectedInterest) {
        self.didSelectedInterest(hasChange);
    }
    
    //标记选择了
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:kSettingInterestLabel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate
#pragma mark -- HYInterestSelectViewDelegate
- (void)interestSkip
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (YYCache *)interestCache
{
    if (!_interestCache) {
        _interestCache = [[YYCache alloc] initWithName:@"interestCache"];
    }
    return _interestCache;
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
