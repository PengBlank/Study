//
//  HYPickerToolView.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _PickerType{
    HotelRoomCount = 1,
    HotelArrivalTime,
    flightType
}PickerType;

@protocol HYPickerToolViewDelegate;

@interface HYPickerToolView : UIView
<
UIPickerViewDelegate,
UIPickerViewDataSource
>

@property (nonatomic, weak) id<HYPickerToolViewDelegate> delegate;
@property (nonatomic, assign) PickerType pType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *dataSouce;
@property (nonatomic, assign) NSInteger currentIndex;


- (void)showWithAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;
@end


@protocol HYPickerToolViewDelegate <NSObject>

@optional
- (void)pickerCancel;
- (void)selectComplete:(HYPickerToolView *)pickerView;

@end
