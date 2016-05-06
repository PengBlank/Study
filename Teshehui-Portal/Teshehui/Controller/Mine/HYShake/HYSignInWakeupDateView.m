//
//  HYSignInWakeupDateView.m
//  Teshehui
//
//  Created by HYZB on 16/3/28.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYSignInWakeupDateView.h"

@interface HYSignInWakeupDateView ()


@end

@implementation HYSignInWakeupDateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.hidden = YES;
    
    UIButton *ConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ConfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [ConfirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:ConfirmBtn];
    _ConfirmBtn = ConfirmBtn;
    
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeTime;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    picker.locale = locale;
    [self addSubview:picker];
    _picker = picker;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:(@"HH:mm")];
    _formatter = formatter;
}


- (void)layoutSubviews
{
    _ConfirmBtn.frame = CGRectMake(self.frame.size.width-80, 20, 60, 20);
    
    _picker.frame = CGRectMake(0, CGRectGetMaxY(_ConfirmBtn.frame)+10, self.frame.size.width, self.frame.size.height-(CGRectGetMaxY(_ConfirmBtn.frame)+20));
}

@end
