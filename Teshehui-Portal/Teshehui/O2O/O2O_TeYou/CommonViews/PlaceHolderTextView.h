//
//  PlaceHolderTextView.h
//  TTClub
//
//  Created by xkun on 15/4/23.
//  Copyright (c) 2015年 熙文 张. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlaceHolderTextView;
@protocol PlaceHolderTextViewDelegate

@optional
//- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView;
//- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView;
//
//- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView;
//- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView;
//
//- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
//- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView;
//
//- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height;
//- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height;
//
//- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView;
- (BOOL)PlaceHolderTextViewShouldReturn:(PlaceHolderTextView *)growingTextView;


@end

@interface PlaceHolderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, assign) id <UITextViewDelegate> delegate;

- (CGRect)placeholderRectForBounds:(CGRect)bounds;

@end
