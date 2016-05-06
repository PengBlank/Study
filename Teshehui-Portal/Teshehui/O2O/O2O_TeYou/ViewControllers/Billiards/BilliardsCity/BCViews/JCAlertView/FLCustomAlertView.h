//
//  FLCustomAlertView.h
//  Teshehui
//
//  Created by macmini5 on 15/12/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

/*
 使用了JCAlertView里面自定义View的方法
 - (instancetype)initWithCustomView:(UIView *)customView dismissWhenTouchedBackground:(BOOL)dismissWhenTouchBackground;
 
 自定义View点击button需要调用 
 - (void)dismissWithCompletion:(void(^)(void))completion;
 来移除提示框
 
 里面还有其他固定样式可使用.
*/

#import <UIKit/UIKit.h>
#import "JCAlertView.h"

typedef  NS_ENUM(NSInteger, FLCAlertViewType)
{
    OneButton_TitleMessage  = 0,  // 有标题、有副标题、有消息 一个按钮的
    TwoButton_TitleMessage  = 1,  // 有标题、有消息 两个按钮的
    ThreeButton_NoTM        = 2,  // 无标题、无消息 三个按钮的
};

typedef NS_ENUM(NSInteger, FLCAlertViewBtnTag)
{
    ButtonTag_OkBtn         = 2001, // 确认按钮tag
    ButtonTag_CancelBtn     = 2002, // 取消按钮tag
    
    // 三个按钮
    ButtonTag_Index0        = 3001,
    ButtonTag_Index1        = 3002,
    ButtonTag_Index2        = 3003
};

typedef void(^ButtonClickBlock)(FLCAlertViewBtnTag tag);

@interface FLCustomAlertView : UIView
/**
 初始化方法 需要传一个类型.
 OneButton_TitleMessage:有标题有消息 一个按钮的;
 TwoButton_TitleMessage:有标题有消息 两个按钮的;
 ThreeButton_NoTM      :无标题无消息 三个按钮的
 */
- (id)initWithFrame:(CGRect)frame TheViewType:(FLCAlertViewType)type;

/**
 OneButton_TitleMessage类型 设置标题文字、副标题、内容 的文字、颜色
 */
- (void)setTitle:(NSString *)title TitleColor:(UIColor *)titleColor subTitle:(NSString *)subTitle AndSubTitleColor:(UIColor *)subTitleColor andMessage:(NSString *)message MessageColor:(UIColor *)messageColor;
/**
 OneButton_TitleMessage、TwoButton_TitleMessage类型 设置标题文字、颜色和内容文字、颜色
 */
- (void)setTitle:(NSString *)title TitleColor:(UIColor *)titleColor andMessage:(NSString *)message MessageColor:(UIColor *)messageColor;

/**
 OneButton_TitleMessage、TwoButton_TitleMessage类型 设置OK按钮标题，标题颜色，按钮背景色
 */
- (void)setOkButtonWithTitle:(NSString *)title TitleColor:(UIColor *)titleColor BackgroundColor:(UIColor *)backgroundColor;

/**
 TwoButton_TitleMessage类型 设置Cancel按钮标题，标题颜色，按钮背景色
 */
- (void)setCancelButtonWithTitle:(NSString *)title TitleColor:(UIColor *)titleColor BackgroundColor:(UIColor *)backgroundColor;

/**
 ThreeButton_NoTM类型 设置按钮标题，标题颜色，按钮背景色
 */
- (void)setIndex0ButtonWithTitle:(NSString *)title TitleColor:(UIColor *)titleColor BackgroundColor:(UIColor *)backgroundColor;
- (void)setIndex1ButtonWithTitle:(NSString *)title TitleColor:(UIColor *)titleColor BackgroundColor:(UIColor *)backgroundColor;
- (void)setIndex2ButtonWithTitle:(NSString *)title TitleColor:(UIColor *)titleColor BackgroundColor:(UIColor *)backgroundColor;

/**
 设置TitleLabel文字大小
 */
- (void)setTitleLabeltextFont:(UIFont *)font;

/**
 ThreeButton_NoTM类型 分割线的颜色
 */
//- (void)setIndexButtonLineColor:(UIColor *)lineColor;

/**
 自定义View上按钮点击的回调方法 根据FLCAlertViewBtnTag tag来区分
 */
- (void)buttonClickBlock:(ButtonClickBlock)btnClickBlock;

/**
 显示
 */
- (void)show;

@end
