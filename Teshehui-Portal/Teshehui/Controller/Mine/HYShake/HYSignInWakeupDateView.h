//
//  HYSignInWakeupDateView.h
//  Teshehui
//
//  Created by HYZB on 16/3/28.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 签到提醒
 */
@interface HYSignInWakeupDateView : UIView

@property (nonatomic, strong) UIButton *ConfirmBtn;
@property (nonatomic, strong) UIDatePicker *picker;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end
