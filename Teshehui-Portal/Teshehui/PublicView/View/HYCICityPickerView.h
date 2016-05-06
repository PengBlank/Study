//
//  HYCICityPickerView.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HYCICityInfo.h"

@protocol HYCICityPickerViewDelegate;

@interface HYCICityPickerView : UIView
<
UIPickerViewDelegate,
UIPickerViewDataSource
>
@property (nonatomic, weak) id<HYCICityPickerViewDelegate> delegate;
- (void)showWithAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;

@property (nonatomic, strong) HYCICityInfo *provinceInfo;
@property (nonatomic, strong) HYCICityInfo *cityInfo;
@property (nonatomic, strong) HYCICityInfo *areaInfo;
@end

@protocol HYCICityPickerViewDelegate <NSObject>

@optional
- (void)pickerCancel;
- (void)selectComplete:(HYCICityPickerView *)pickerView;

@end