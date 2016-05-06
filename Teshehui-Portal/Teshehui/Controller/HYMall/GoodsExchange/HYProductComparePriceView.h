//
//  HYProductComparePriceView.h
//  Teshehui
//
//  Created by Kris on 15/9/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYComparePriceResponse.h"
#import "HYProductDetailToolView.h"
#import "HYComparePriceNullView.h"
#import "HYProductComparePriceViewModel.h"
#import "HYProductDetailViewController.h"

@interface HYProductComparePriceView : UIView

@property (nonatomic, strong) HYComparePriceNullView *nullView;
@property (nonatomic, strong) HYProductComparePriceViewModel *data;
@property (nonatomic, weak) id<HYProductDetailToolViewDelegate> delegate;
+ (instancetype)instanceView;
- (void)show;

//- (void)showNullView;

@end
