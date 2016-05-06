//
//  HYProductDetailNavigationTitleView.h
//  Teshehui
//
//  Created by Kris on 16/3/30.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYHYMallOrderListFilterView.h"

@protocol HYProductDetailNavigationTitleViewDelegate <NSObject>

@end

@interface HYProductDetailNavigationTitleView : UIView

@property (nonatomic, strong, readonly) HYHYMallOrderListFilterView *filter;
@property (nonatomic, weak) id<HYProductDetailNavigationTitleViewDelegate> delegate;

- (void)changeTitle;
- (void)restoreTitle;

@end
