//
//  DatePickerViewController.h
//  DaXueBao
//
//  Created by Ray on 14-4-13.
//  Copyright (c) 2014年 souvi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  用于iphone的日期选择器，类似。。。从底部弹出，包含灰色遮挡界面
 */
@interface DatePickerViewController : UIViewController {
    UIDatePicker *_datePicker;
    UIView *_maskView;
    UIToolbar *_toolBar;
    UIView *_pickerWrapper;
    //void (^completionHandler) (NSDate *date);
}

//@property (nonatomic, strong)
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, copy) void (^completionHandler)(NSDate *date);

@end

@interface UIViewController (DatePickerViewController)
- (void)showDatePickerViewController:(DatePickerViewController *)picker;
- (void)showDatePickerViewController:(DatePickerViewController *)picker withCompletionHandler:(void (^)(NSDate *date))handler;
@end
