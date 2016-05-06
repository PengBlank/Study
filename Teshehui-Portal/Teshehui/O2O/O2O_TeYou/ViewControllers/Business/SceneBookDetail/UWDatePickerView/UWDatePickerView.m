//
//  UWDatePickerView.h
//  UWDatePickerView
//
//  Created by Fengur on 15/11/04.
//  Copyright © 2015年. All rights reserved.
//


#import "UWDatePickerView.h"

@interface UWDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray *_arrDate;
    NSMutableArray *_arrDateKeys;
    NSInteger _intSelectedDate;
}

@property (nonatomic, strong) NSString *selectDate;
@property (weak, nonatomic) IBOutlet UIButton *cannelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *backgVIew;
@property (weak, nonatomic) IBOutlet UIButton *backGroundBtn;

@end

@implementation UWDatePickerView

+ (UWDatePickerView *)instanceDatePickerView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"UWDatePickerView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}


- (void)awakeFromNib
{
    _datePicker.delegate = self;
    _datePicker.dataSource = self;
    
    _arrDate = [NSMutableArray arrayWithCapacity:30];
    _arrDateKeys = [NSMutableArray arrayWithCapacity:30];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeInterval time = 0;
    
    for (int i = 0 ; i < 30 ; i ++ ) {
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateNew = [NSDate dateWithTimeIntervalSinceNow:time];
        
        NSString *date = [dateFormatter stringFromDate:dateNew];
        [_arrDate addObject:date];
        
        [dateFormatter setDateFormat:@"M月    d日"];
        NSString *dateKeys = [dateFormatter stringFromDate:dateNew];
        NSString *dateWeek = [dateKeys stringByAppendingString:@"          "];
        dateWeek = [dateWeek stringByAppendingString:[self getWeekDayFordate: dateNew]];
        [_arrDateKeys addObject:dateWeek];
        
        time += 60 * 60 * 24;
    }
}

- (NSString *)getWeekDayFordate:(NSDate *)date
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _arrDateKeys.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _arrDateKeys[row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _intSelectedDate = row;
}

- (void)animationbegin:(UIView *)view
{
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation.duration = 2; // 动画持续时间
    animation.repeatCount = -1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
    
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
}

- (void) removeSelfFromSuperview {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/**
 *  取消按钮点击
 */
- (IBAction)removeBtnClick:(id)sender {
    // 开始动画
    [self animationbegin:sender];
    [self.delegate getSelectDate:self.selectDate type:DateTypeOfEnd];
    [self removeSelfFromSuperview];
}

/**
 *  确定按钮点击,会触发代理事件
 */
- (IBAction)sureBtnClick:(id)sender {
    // 开始动画
    [self animationbegin:sender];
    self.selectDate = [_arrDate objectAtIndex:_intSelectedDate];
    [self.delegate getSelectDate:self.selectDate type:self.type];
    [self removeSelfFromSuperview];
}

/**
 *  点击其他地方移除时间选择器
 */
- (IBAction)backGroundBtnClicked:(id)sender
{
    [self removeSelfFromSuperview];
}
@end
