//
//  HYProducySKUSelectView.h
//  Teshehui
//
//  Created by HYZB on 15/9/2.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallGoodsDetail.h"
#import "HYProductSummaryCell.h"

@protocol HYProductSKUSelectViewDelegate <HYProductSummaryCellDelegate>

@optional

- (void)didDismiss;
- (void)didFinishedSelectSKU;
- (void)didFinishedSelectSKUToAddShoppingCar:(BOOL)addCar;

@end

@interface HYProductSKUSelectView : UIView

@property (nonatomic, weak) id<HYProductSKUSelectViewDelegate> delegate;
@property (nonatomic, strong) HYMallGoodsDetail *goodsDetail;

- (id)initWithFrame:(CGRect)frame showDone:(BOOL)done;

- (void)showWithAnimation:(BOOL)animation;
- (void)dismiss;
- (void)updatePriceInfo;

@end
