//
//  HYShareGetPointView.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 分享赚现金券的入口浮层，处于“我的界面”
 *
 */
@interface HYShareGetPointView : UIView
{
    BOOL _isHalfHidden; /// 是否处于半藏状态
}

+ (HYShareGetPointView *)sharedView;
- (void)show;
- (void)showInView:(UIView *)view;
- (void)dismiss;

/// 点击回调
@property (nonatomic, copy) void (^didCheck)(void);

@end
