//
//  TYCustomAlertView.h
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/12.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  提示框

#import <UIKit/UIKit.h>
#import "JCAlertView.h" // 提示框

typedef  NS_ENUM(NSInteger, TYCAlertViewType)
{
    Type_Default  = 0  // 默认（标题、消息、两个按钮）

};
typedef NS_ENUM(NSInteger, TYCAlertViewBtnTag)
{
    ButtonTag_OkBtn         = 1000, // 确认按钮tag
    ButtonTag_CancelBtn     = 1001, // 取消按钮tag
};

typedef void(^ButtonClickBlock)(TYCAlertViewBtnTag tag);

@interface TYCustomAlertView : UIView

- (id)initWithFrame:(CGRect)frame WithType:(TYCAlertViewType)type;

/** 按钮点击回调*/
- (void)buttonClickBlock:(ButtonClickBlock)btnClickBlock;

/** 修改标题属性*/
-(void)setTitle:(NSString *)title Color:(UIColor *)color Font:(CGFloat)font;
/** 修改内容属性*/
-(void)setMsg:(NSString *)msg Color:(UIColor *)color Font:(CGFloat)font;
/** 修改 左边按钮 属性*/
-(void)setButtonTitle_Left:(NSString *)title Color:(UIColor *)color Font:(CGFloat)font;
/** 修改 右边按钮 属性*/
-(void)setButtonTitle_Rigth:(NSString *)title Color:(UIColor *)color Font:(CGFloat)font;
/** 线颜色*/
-(void)setLineColor:(UIColor *)color;

- (void)show;

@end
