//
//  HYFlowerAdressPick.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-14.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYFlowerCityInfo.h"

@protocol HYFlowerAddressDelegate;

@interface HYFlowerAddressPick : UIView
<
UIPickerViewDelegate,
UIPickerViewDataSource
>
@property (nonatomic, weak) id<HYFlowerAddressDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) HYFlowerCityInfo *proInfo;
@property (nonatomic, strong) HYFlowerCityInfo *cityInfo;
@property (nonatomic, strong) HYFlowerCityInfo *areaInfo;

- (void)showWithAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;

@end

@protocol HYFlowerAddressDelegate <NSObject>

@optional
- (void)pickerCancel;
- (void)selectComplete:(HYFlowerAddressPick *)pickerView;

@end
