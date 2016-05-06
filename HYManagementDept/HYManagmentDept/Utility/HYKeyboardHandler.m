//
//  HYKeyboardHandler.m
//  Teshehui
//
//  Created by RayXiang on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYKeyboardHandler.h"

@implementation HYKeyboardHandler

- (id)init
{
    if (self = [super init]) {
        self.tapToDismiss = YES;
    }
    return self;
}

- (instancetype)initWithDelegate:(id)delegate view:(UIView *)view
{
    if (self = [super init])
    {
        self.view = view;
        self.delegate = delegate;
        self.tapToDismiss = YES;
    }
    return self;
}

- (void)startListen
{
    if (self.tapToDismiss
        && !_editTap) {
        _editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTapAction:)];
        _editTap.delegate = self;
        if (self.view) {
            [self.view addGestureRecognizer:_editTap];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)stopListen
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardChanged:(NSNotification *)notification
{
    NSValue *frameData = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [frameData CGRectValue];
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(keyboardChangeFrame:)])
    {
        [self.delegate keyboardChangeFrame:frame];
    }
}
- (void)keyboardShow:(NSNotification *)notification
{
    _edit = YES;
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(keyboardShow)]) {
        [self.delegate keyboardShow];
    }
}

- (void)keyboardHide:(NSNotification *)notification
{
    _edit = NO;
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(keyboardHide)])
    {
        [self.delegate keyboardHide];
    }
}

- (void)editTapAction:(UITapGestureRecognizer *)tap
{
    if (_edit) {
        [self.view endEditing:YES];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return _edit;
}


@end
