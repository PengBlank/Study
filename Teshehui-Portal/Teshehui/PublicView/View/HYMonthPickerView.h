//
//  HYMonthPickerView.h
//  Teshehui
//
//  Created by HYZB on 14-8-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 信用卡有效期选择，只显示年月
 */
#import <UIKit/UIKit.h>
#import "SRMonthPicker.h"

@protocol HYMonthPickerViewDelegate;
@interface HYMonthPickerView : UIView

@property (nonatomic, weak) id<HYMonthPickerViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) SRMonthPicker *pickerView;

- (void)showWithAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;

@end


@protocol HYMonthPickerViewDelegate <NSObject>

@optional

- (void)didSelectDate:(NSDate *)date;

@end