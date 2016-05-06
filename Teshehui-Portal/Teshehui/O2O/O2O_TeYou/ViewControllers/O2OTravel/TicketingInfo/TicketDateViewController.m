//
//  TicketDateViewController.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TicketDateViewController.h"
#import "TUCalendarView.h"

@interface TicketDateViewController ()<TUCalendarDataSource>{
    TUCalendarView *_calendar;
}
@property (weak, nonatomic) IBOutlet TUCalendarHeaderView *TUcalendarHeaderView;
@property (weak, nonatomic) IBOutlet TUCalendarContentView *TUcalendarContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblWeekday;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;

@end

@implementation TicketDateViewController

- (void)viewDidLayoutSubviews
{
    [_calendar repositionViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //　初始化日历控件
    _calendar = [TUCalendarView new];
    _calendar.defaultCalendar.firstWeekday = 1;
    [_calendar setHeaderView:self.TUcalendarHeaderView];
    [_calendar setContentView:self.TUcalendarContentView];
    [_calendar setDataSource:self];
    
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString转NSDate
    NSDate *serverDate     = [formatter dateFromString:_serverDate];
    _calendar.currentDate  = serverDate;// 这里设置之后会随着月份变化
    _calendar.dateServer   = serverDate;//　所以又加了这个服务器时间
    _calendar.limitDays    = 6;// 默认只能选七天
    
    //　设置默认选中
    if (_selectedDate) {
        NSDate *selectDate     = [formatter dateFromString:_selectedDate];
        _calendar.dateSelected = selectDate;
    }else{
        _calendar.dateSelected = serverDate;
    }
    
    [_calendar reloadData];
    [self setLabelDate:_calendar.currentDate];
}

//　点击空白处时从父页面移除
- (IBAction)btnClickBlank:(id)sender {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc{
//    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - TUCalendarDataSource

- (BOOL)calendarHaveEvent:(TUCalendarView *)calendar date:(NSDate *)date
{
    return NO;
}

- (void)calendarDidDateSelected:(TUCalendarView *)calendar date:(NSString *)dateString {
    if (_TicketDateSelected) {
        self.TicketDateSelected(dateString);
    }
    [self performSelector:@selector(btnClickBlank:) withObject:nil afterDelay:0.5f];
}

- (void)calendarDidLoadPreviousPage
{
}

- (void)calendarDidLoadNextPage
{
}

#pragma mark - Fake data
// 设置显示日期
-(void)setLabelDate:(NSDate *)date{
    
    
    NSDateComponents *_comps = [_calendar.defaultCalendar components:(NSYearCalendarUnit |
                                    NSMonthCalendarUnit |
                                    NSDayCalendarUnit|
                                    NSHourCalendarUnit|
                                    NSMinuteCalendarUnit |
                                    NSSecondCalendarUnit|
                                    NSWeekdayCalendarUnit) fromDate:date];
    NSInteger nowYear  = [_comps year];
    NSInteger nowMonth = [_comps month];
    NSInteger nowDay   = [_comps day];
    NSInteger nowWeek  = [_comps weekday];
    
    _lblWeekday.text = [self getChineseWeekDay:nowWeek];
    _lblMonth.text = [self getChineseMonth:nowMonth];
    _lblDay.text = [NSString stringWithFormat:@"%@",@(nowDay)];
    _lblYear.text = [NSString stringWithFormat:@"%@",@(nowYear)];
}
- (NSString *)getChineseWeekDay:(NSInteger)weekday{
    NSString *weekStr = @"";
    switch (weekday) {
        case 1:
            weekStr = @"星期日";
            break;
        case 2:
            weekStr = @"星期一";
            break;
        case 3:
            weekStr = @"星期二";
            break;
        case 4:
            weekStr = @"星期三";
            break;
        case 5:
            weekStr = @"星期四";
            break;
        case 6:
            weekStr = @"星期五";
            break;
        case 7:
            weekStr = @"星期六";
            break;
            
        default:
            break;
    }
    return weekStr;
}
- (NSString *)getChineseMonth:(NSInteger)month{
    NSString *weekStr = @"";
    switch (month) {
        case 1:
            weekStr = @"一月";
            break;
        case 2:
            weekStr = @"二月";
            break;
        case 3:
            weekStr = @"三月";
            break;
        case 4:
            weekStr = @"四月";
            break;
        case 5:
            weekStr = @"五月";
            break;
        case 6:
            weekStr = @"六月";
            break;
        case 7:
            weekStr = @"七月";
            break;
        case 8:
            weekStr = @"八月";
            break;
        case 9:
            weekStr = @"九月";
            break;
        case 10:
            weekStr = @"十月";
            break;
        case 11:
            weekStr = @"十一月";
            break;
        case 12:
            weekStr = @"十二月";
            break;
        default:
            break;
    }
    return weekStr;
}
@end
