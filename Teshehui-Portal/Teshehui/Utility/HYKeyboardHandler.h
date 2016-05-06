//
//  HYKeyboardHandler.h
//  Teshehui
//
//  Created by RayXiang on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HYKeyboardHandlerDelegate <NSObject>
@optional
- (void)keyboardShow;
- (void)keyboardChangeFrame:(CGRect)kFrame;
- (void)keyboardWillChangeFrame:(CGRect)kFrame;
- (void)keyboardHide;
- (void)keyboardWillHide;

- (void)inputView:(UIView *)inputView willCoveredWithOffset:(CGFloat)offset;

@end

@interface HYKeyboardHandler : NSObject
<UIGestureRecognizerDelegate>
{
    BOOL _edit;
    UITapGestureRecognizer *_editTap;
}
- (instancetype)initWithDelegate:(id<HYKeyboardHandlerDelegate>)delegate view:(UIView *)view;

@property (nonatomic, weak) id<HYKeyboardHandlerDelegate> delegate;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, assign) BOOL tapToDismiss;

/***/
@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, weak) UIView *inputView;

- (void)startListen;
- (void)stopListen;


/// 单例
+ (instancetype)sharedHandler;
@property (nonatomic, assign) BOOL keyboardIsShow;

@end
