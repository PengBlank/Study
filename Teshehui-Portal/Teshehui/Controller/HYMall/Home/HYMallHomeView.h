//
//  HYMallHomeView.h
//  Teshehui
//
//  Created by 成才 向 on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallHomeViewModel.h"

@protocol HYMallHomeViewDelegate <NSObject>

- (void)homeViewWillLoadMoreData;
- (void)reloadAllData;
- (void)checkBannerItem:(id)product withBoard:(id)board;
- (void)checkBoard:(NSInteger)boardType itemAtIndex:(NSInteger)idx;
- (void)checkInterestTags;
- (void)checkMoreBrand;

/** 导航栏透明度渐变 */
- (void)navigationBarAlphaWithColor:(UIColor *)color alpha:(CGFloat)alpha;
/** 导航栏透明 */
- (void)navigationBarAlphaWithColor:(UIColor *)color;

@end

@interface HYMallHomeView : UIView
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, weak) id<HYMallHomeViewDelegate> delegate;

- (void)setupWithModel:(HYMallHomeViewModel *)viewmodel;

//- (void)updateNavgationbarAlpha;

@end
