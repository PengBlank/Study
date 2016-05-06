//
//  HYPopDateViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-14.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopDateViewDelegate <NSObject>

@optional

- (void)dismissPopView;
- (void)popDateViewDidGetString:(NSString *)string;
- (void)popDateViewDidGetDate:(NSDate *)date;
- (void)popDateViewDidClickCancel;

- (void)popDateViewDidGetDate:(NSDate *)date withTag:(NSInteger)tag;

@end


@interface HYPopDateViewController : UIViewController
{
    UIDatePicker* datePicker;
}

@property (nonatomic, strong) UIDatePicker *datePicker;

@property(nonatomic,strong)id<PopDateViewDelegate>delegate;

//当一个界面有多个弹出框时，使用tag来进行区别
@property (nonatomic, assign) NSInteger tag;



@end
