//
//  HYDatePickerView.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYDatePickerViewDelegate;
@interface HYDatePickerView : UIView

@property (nonatomic, weak) id<HYDatePickerViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIDatePicker *pickerView;
@property (nonatomic, assign, readonly) BOOL isShow;

- (void)showWithAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;

@end


@protocol HYDatePickerViewDelegate <NSObject>

@optional
- (void)didSelectDate:(NSDate *)date;
- (void)datePickerView:(HYDatePickerView *)pickerView didSelectDate:(NSDate *)date;

@end