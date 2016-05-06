//
//  HYSeckillBannerView.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYSeckillActivityModel.h"

///秒杀界面, 顶部bannerView
@interface HYSeckillBannerView : UIView

///具体项
@property (nonatomic, strong) NSArray<HYSeckillActivityModel*> *items;

///点击选项回调
@property (nonatomic, copy) void (^didSelectItemAtIndex)(NSInteger idx);

/// 设置当前显示的item，用于子视图下拉刷新
- (void)setCurrentItem:(HYSeckillActivityModel *)curActivity;

/**
 *  @brief  选中项
 *  @setter 设定显示动画, 但不触发点击事件
 *  @getter 获取当前选中
 */
@property (nonatomic, assign) NSInteger selectedIdx;

@end
