//
//  HYFlightDateViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightDateViewController.h"
#import "CQCalendarView.h"
#import "CQCalendarDayView.h"

#import "PTDateFormatrer.h"
#import "NSDate+Addition.h"

@interface HYFlightDateViewController () <CQCalendarViewDelegate>
//设置酒店的时间
@property (nonatomic, strong) CQCalendarDayView *checkInDay;
@property (nonatomic, strong) CQCalendarDayView *checkOutDay;

@end

@implementation HYFlightDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect rect = self.view.frame;
    if (_singleWay)
    {
        CQCalendarView *calender = [[CQCalendarView alloc] initWithFrame:rect defDate:self.startDate];
        calender.delegate = self;
        [self.view addSubview:calender];
    }
    else
    {
        CQCalendarView *calender = [[CQCalendarView alloc] initWithFrame:rect
                                                                   start:self.startDate
                                                                     end:self.endDate];
        calender.delegate = self;
        [self.view addSubview:calender];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CQCalendarViewDelegate
- (void)didSelectDate:(CQCalendarDayView *)dayView
{
    if (self.singleWay)
    {
        if ([self.delegate respondsToSelector:@selector(didSelectStartDate:week:)])
        {
            NSDate *date1 = dayView.dayAsDate;
            NSDateComponents *dateC1 = dayView.day;
            NSString *day = [date1 timeDescription];
            NSString *week = [PTDateFormatrer weekChinese:(int)dateC1.weekday];
            [self.delegate didSelectStartDate:day week:week];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (!self.checkInDay)
        {
            self.checkInDay = dayView;
        }
        else if (!self.checkOutDay)
        {
            
            //不能连续选中同一天
            if (self.checkInDay == dayView)
            {
                return;
            }
            
            self.checkOutDay = dayView;
            
            NSDate *date1 = self.checkInDay.dayAsDate;
            NSDate *date2 = self.checkOutDay.dayAsDate;
            
            NSDateComponents *dateC1 = self.checkInDay.day;
            NSDateComponents *dateC2 = self.checkOutDay.day;
            
            if ([date2 compare:date1] == NSOrderedAscending)
            {
                date1 = date2;
                date2 = self.checkInDay.dayAsDate;
                
                dateC1 = dateC1;
                dateC2 = self.checkInDay.day;
            }
            
            NSString *checkInDay = [date1 timeDescription];
            NSString *checkInWeek = [PTDateFormatrer weekChinese:(int)dateC1.weekday];
            NSString *checkOutDay = [date2 timeDescription];
            NSString *checkOutWeek = [PTDateFormatrer weekChinese:(int)dateC2.weekday];
            
            if ([self.delegate respondsToSelector:@selector(didSelectStartDate:sWeek:backDate:bWeek:)])
            {
                [self.delegate didSelectStartDate:checkInDay
                                            sWeek:checkInWeek
                                         backDate:checkOutDay
                                            bWeek:checkOutWeek];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
