//
//  HYShakeActivityItem.h
//  Teshehui
//
//  Created by HYZB on 16/3/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYShakeViewModel;
/**
 * 摇一摇活动
 */
@interface HYShakeActivityItem : UIView

@property (nonatomic, strong) HYShakeViewModel *shakeModel;
@property (nonatomic, strong) UIButton *detailBtn;

@end
