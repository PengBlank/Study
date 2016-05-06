//
//  HYShakeCashItem.h
//  Teshehui
//
//  Created by HYZB on 16/3/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYShakeViewModel;

typedef NS_ENUM(NSUInteger, ShakeType)
{
    kShakeTypeGoods = 1, // 商品
    kShakeTypeActivity = 2,  // 活动
    kShakeTypeToken = 3,  // 现金券
    kShakeTypeCash = 4,  // 现金
};

/**
 * 摇一摇现金及现金券
 */
@interface HYShakeCashItem : UIView

@property (nonatomic, strong) HYShakeViewModel *shakeModel;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIButton *showBtn;

@end
