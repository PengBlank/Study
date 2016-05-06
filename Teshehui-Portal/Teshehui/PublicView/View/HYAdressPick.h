//
//  HYAdressPick.h
//  Teshehui
//
//  Created by ichina on 14-3-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMslselectionInfo.h"

@protocol HYAdressDelegate;

/**
 * 选择配送区域界面,弹出框
 */
@interface HYAdressPick : UIView
<
UIPickerViewDelegate,
UIPickerViewDataSource
>
@property (nonatomic, weak) id<HYAdressDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) HYMslselectionInfo* proInfo;
@property (nonatomic, strong) HYMslselectionInfo* cityInfo;
@property (nonatomic, strong) HYMslselectionInfo* regionInfo;

- (void)showWithAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;

@end

@protocol HYAdressDelegate <NSObject>

@optional
- (void)pickerCancel;
- (void)selectComplete:(HYAdressPick *)pickerView;

@end
