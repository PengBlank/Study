//
//  HYHeaderDateDelegate.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYHeaderDateGetter.h"
#import "HYPopDateViewController.h"
#import "DatePickerViewController.h"

@interface HYHeaderDateGetter ()
<PopDateViewDelegate>
@end

@implementation HYHeaderDateGetter
{
    UIPopoverController *_popController;
}

- (void)beginGetDateWithField:(UITextField *)field
             inViewController:(UIViewController *)vc miniDate:(NSDate *)miniDate
{
    _activeField = field;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        HYPopDateViewController *pop = [[HYPopDateViewController alloc] init];
        
        pop.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pop];
        nav.contentSizeForViewInPopover = CGSizeMake(320, 240);
        _popController = [[UIPopoverController alloc] initWithContentViewController:nav];
        [_popController presentPopoverFromRect:field.frame
                                        inView:vc.view
                      permittedArrowDirections:UIPopoverArrowDirectionUp
                                      animated:YES];
        if (miniDate)
        {
            if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
            {
                [pop view];
            }
            pop.datePicker.minimumDate = miniDate;
        }
    }
    else
    {
        DatePickerViewController *datePicker = [[DatePickerViewController alloc] init];
        if (miniDate)
        {
            [datePicker view];
            datePicker.datePicker.minimumDate = miniDate;
            //datePicker.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1000];
        }
        __weak HYHeaderDateGetter *b_self = self;
        [vc showDatePickerViewController:datePicker withCompletionHandler:^(NSDate *date)
        {
            NSDate *getDate = nil;
            if (date)
            {
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *comps = [calendar components:NSYearCalendarUnit|
                                           NSMonthCalendarUnit|
                                           NSDayCalendarUnit|
                                           NSHourCalendarUnit|
                                           NSMinuteCalendarUnit|
                                           NSSecondCalendarUnit fromDate:date];
                comps.hour = 0;
                comps.minute = 0;
                comps.second = 0;
                getDate = [calendar dateFromComponents:comps];
            }
            
            if (b_self.delegate &&
                [b_self.delegate respondsToSelector:@selector(dateGetterDidGetDate:)])
            {
                [b_self.delegate dateGetterDidGetDate:getDate];
            }
        }];
    }
}

- (void)popDateViewDidGetDate:(NSDate *)date
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(dateGetterDidGetDate:)])
    {
        [self.delegate dateGetterDidGetDate:date];
    }
    [_popController dismissPopoverAnimated:YES];
    _popController = nil;
}

- (void)popDateViewDidClickCancel
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(dateGetterDidGetDate:)])
    {
        [self.delegate dateGetterDidGetDate:nil];
    }
    [_popController dismissPopoverAnimated:YES];
    _popController = nil;
}

- (NSDate*)getMiniDateFromDate:(NSDate *)date
{
    if (date)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSYearCalendarUnit|
                                   NSMonthCalendarUnit|
                                   NSDayCalendarUnit|
                                   NSHourCalendarUnit|
                                   NSMinuteCalendarUnit|
                                   NSSecondCalendarUnit fromDate:date];
        comps.hour = 0;
        comps.minute = 0;
        comps.second = 0;
        NSDate *miniDate = [calendar dateFromComponents:comps];
        return miniDate;
    }
    return nil;
}
- (NSDate *)getPreMiniDateFromDate:(NSDate *)date
{
    if (date)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSYearCalendarUnit|
                                   NSMonthCalendarUnit|
                                   NSDayCalendarUnit|
                                   NSHourCalendarUnit|
                                   NSMinuteCalendarUnit|
                                   NSSecondCalendarUnit fromDate:date];
        comps.hour = 0;
        comps.minute = 0;
        comps.second = 0;
        comps.day += 1;
        NSDate *miniDate = [calendar dateFromComponents:comps];
        miniDate = [miniDate dateByAddingTimeInterval:-1];
        return miniDate;
    }
    return nil;
}

@end
