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
- (void)keyboardHide;

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
@property (nonatomic, assign) BOOL tapToDismiss;    //default yes.

- (void)startListen;
- (void)stopListen;

@end
