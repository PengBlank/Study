//
//  HYAdsScrollView.h
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 *  滑动轮播界面
 */

#import <UIKit/UIKit.h>

@protocol HYAdsScrollViewDataSource <NSObject>

@required
- (NSArray *)adsContents;

@optional

@end

@protocol HYAdsScrollViewDelegate <NSObject>

@optional
- (void)didClickAdsIndex:(NSInteger)index;

@end

@interface HYAdsScrollView : UIView
<UIScrollViewDelegate>
{
    @public
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
    
    UIScrollView *_scorllView;
}
@property (nonatomic, weak) id<HYAdsScrollViewDataSource> dataSource;
@property (nonatomic, weak) id<HYAdsScrollViewDelegate> delegate;

@property (nonatomic, assign) BOOL autoScroll;  // Defaults is NO
@property (nonatomic, assign) CGFloat scrollOffsetY;

- (id)initWithFrame:(CGRect)frame linePageControl:(BOOL)linePageControl;
- (void)setScrollView:(UIScrollView *)scrollView;

- (void)reloadData;
- (void)cleanTimer;
@end
