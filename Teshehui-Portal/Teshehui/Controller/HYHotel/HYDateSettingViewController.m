//
//  CQDateSettingViewController.m
//  Teshehui
//
//  Created by ChengQian on 13-10-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYDateSettingViewController.h"

#import "CQCalendarView.h"
#import "CQCalendarDayView.h"

#import "PTDateFormatrer.h"
#import "NSDate+Addition.h"

@interface HYDateSettingViewController () <CQCalendarViewDelegate>

//设置酒店的时间
@property (nonatomic, strong) CQCalendarDayView *checkInDay;
@property (nonatomic, strong) CQCalendarDayView *checkOutDay;

@end

@implementation HYDateSettingViewController

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
    CQCalendarView *calender = [[CQCalendarView alloc] initWithFrame:rect
                                                               start:self.checkInDate
                                                                 end:self.checkOutDate];
    calender.delegate = self;
        
    [self.view addSubview:calender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CQCalendarViewDelegate
- (void)didSelectDate:(CQCalendarDayView *)dayView
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
            
            dateC1 = dateC2;
            dateC2 = self.checkInDay.day;
        }
        
        NSString *checkInDay = [date1 timeDescription];
        NSString *checkInWeek = [PTDateFormatrer weekChinese:(int)dateC1.weekday];
        NSString *checkOutDay = [date2 timeDescription];
        NSString *checkOutWeek = [PTDateFormatrer weekChinese:(int)dateC2.weekday];
        
        [self.delegate didSelectCheckInDate:checkInDay
                                checkInWeek:checkInWeek
                               CheckOutDate:checkOutDay
                               checkOutWeek:checkOutWeek];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
