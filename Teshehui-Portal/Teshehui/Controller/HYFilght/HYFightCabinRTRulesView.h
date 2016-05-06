//
//  HYFightCabinRTRules.h
//  Teshehui
//
//  Created by HYZB on 14-8-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 退改签说明界面
 */

#import <UIKit/UIKit.h>


@class HYFlightSKU;

@protocol HYFightCabinRTRulesViewDelegate <NSObject>

- (void)rulesViewDidClickBuyWithCabins:(HYFlightSKU*)cabin;

@end

@interface HYFightCabinRTRulesView : UIView

- (id)initWithCabinRTRules:(HYFlightSKU *)cabin;
- (void)showWithAnimation:(BOOL)animation;

@property (nonatomic, weak) id<HYFightCabinRTRulesViewDelegate> delegate;

@end
