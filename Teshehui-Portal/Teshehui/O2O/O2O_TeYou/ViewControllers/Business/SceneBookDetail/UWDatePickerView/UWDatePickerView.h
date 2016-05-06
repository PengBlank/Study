//
//  UWDatePickerView.h
//  UWDatePickerView
//
//  Created by Fengur on 15/11/04.
//  Copyright © 2015年 Fengur. All rights reserved.
//




#import <UIKit/UIKit.h>
typedef enum{
    
    // 开始日期
    DateTypeOfStart = 0,
    
    // 结束日期
    DateTypeOfEnd,
    
}DateType;

@protocol UWDatePickerViewDelegate <NSObject>

/**
 *  选择日期确定后的代理事件
 *
 *  @param date 日期
 *  @param type 时间选择器状态
 */
- (void)getSelectDate:(NSString *)date type:(DateType)type;

@end

@interface UWDatePickerView : UIView

+ (UWDatePickerView *)instanceDatePickerView;

@property (nonatomic, weak) id<UWDatePickerViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;

@property (nonatomic, assign) DateType type;

@end
