//
//  HYMallHomeModalAdsView.h
//  Teshehui
//
//  Created by Kris on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallHomeModalAdsViewModel.h"
@class HYMallHomeViewController;

@interface HYMallHomeModalAdsView : UIView

@property (nonatomic, weak) HYMallHomeViewController *delegate;

+ (instancetype)adsView;
- (void)setupScrollViewWithModel:(HYMallHomeModalAdsViewModel *)data;
- (void)show;
- (void)dismiss;

@end
