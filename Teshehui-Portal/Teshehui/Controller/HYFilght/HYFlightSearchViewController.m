//
//  HYFlightSearchViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightSearchViewController.h"
#import "HYFlightCitySettingCell.h"
#import "HYFlightDateSettingCell.h"
#import "HYFlightCity.h"
#import "NSDate+Addition.h"
#import "UIImage+Addition.h"
#import "PTDateFormatrer.h"
#import "HYFlightCityViewController.h"
#import "HYFlightListViewController.h"
#import "HYFlightSwitchView.h"
#import "HYPickerToolView.h"
#import "HYCabins.h"
#import "HYFlightDateViewController.h"
#import "HYSearchChairCell.h"
#import "HYFlightBuyTicketGetPrimeRateExplainView.h"
#import "HYFlightBuyTicketPrimeRateExplainInfoRequest.h"
#import <UIKit/UIKit.h>

#define kMainScreenBounds [UIScreen mainScreen].bounds

@interface HYFlightSearchViewController ()
<
HYFlightCitySettingCellDelegate,
HYFlightCityViewControllerDelegate,
HYPickerToolViewDelegate,
HYFlightDateSettingCellDelegate,
HYFlightDateViewControllerDelegate
>
{
    HYFlightBuyTicketPrimeRateExplainInfoRequest *_PrimeRateExplainrequest;
    UIWebView *webV;
    
    BOOL _isSingleWay;
    BOOL _setOrgCity;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HYFlightCity *orgCity;  //出发城市
@property (nonatomic, strong) HYFlightCity *dstCity;  //到达城市

@property (nonatomic, copy) NSString *startDate;  //出发日期 月日
@property (nonatomic, copy) NSString *startTime; //出发日期 年 周
@property (nonatomic, copy) NSString *backDate;  //返回日期 月日
@property (nonatomic, copy) NSString *backTime; //返回日期 年 周


//@property (nonatomic, assign) NSTimeInterval startTimestamp; //出发时间戳
//@property (nonatomic, assign) NSTimeInterval backTimestamp; //返回时间戳

@property (nonatomic, strong) HYPickerToolView *pickerView;

//这里的cabin其实只用到cabin.type
@property (nonatomic, strong) HYCabins *cabin;

@property (nonatomic, copy) NSString *air_tips;

@end

@implementation HYFlightSearchViewController

- (void)dealloc
{
    [_PrimeRateExplainrequest cancel];
    _PrimeRateExplainrequest = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isSingleWay = YES;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f
                                           green:242.0f/255.0f
                                            blue:242.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStyleGrouped];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    
    //line and banner
    UIView *containerView = [[UIView alloc]initWithFrame:TFRectMake(0, 0, 320, 140)];
    UIImage *bannerImg = [UIImage imageWithNamedAutoLayout:@"banner_flight"];
    UIImageView *banner = [[UIImageView alloc]initWithImage:bannerImg];
    banner.userInteractionEnabled = YES;
    banner.frame = TFRectMake(0, 0, 320, 92);
    [containerView addSubview:banner];
    
    UITapGestureRecognizer *bannerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerDidClicked:)];
    [banner addGestureRecognizer:bannerTap];
    
    HYFlightSwitchView *headerView = [[HYFlightSwitchView alloc] initWithFrame:TFRectMake(0, 92, 320, 40)];
    [headerView addTarget:self
                   action:@selector(switchflightSingle:)
         forControlEvents:UIControlEventValueChanged];
    [containerView addSubview:headerView];
    //header
    tableview.tableHeaderView = containerView;

    
    UIView *footerView = [[UIView alloc] initWithFrame:TFRectMake(0, 1, 320, 80)];
    UIImage *bg = [[UIImage imageNamed:@"fightSearch_btn"]stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = TFRectMake(20, 20, 280, 35);
    [searchBtn setImage:[UIImage imageNamed:@"fightSearch_btn2"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:bg
                         forState:UIControlStateNormal];
    [searchBtn addTarget:self
                  action:@selector(searchflight:)
        forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitle:@"搜 索"
               forState:UIControlStateNormal];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:TFScalePoint(13)];
    [footerView addSubview:searchBtn];
    tableview.tableFooterView = footerView;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"机票查询", nil);
    
//    UIImage *image = [[UIImage imageNamed:@"hotel_bg_blue"] stretchableImageWithLeftCapWidth:20
//                                                                                topCapHeight:0];
//    [self.navigationController.navigationBar setBackgroundImage:image
//                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self initData];
    [self setDefDateInfo];
    [self getBuyTicketPrimeRateExplainInfo];
}

- (void)getBuyTicketPrimeRateExplainInfo
{
    _PrimeRateExplainrequest = [[HYFlightBuyTicketPrimeRateExplainInfoRequest alloc] init];
    _PrimeRateExplainrequest.copywriting_key = @"air_tips";
    [HYLoadHubView show];
    
    __weak typeof(self) b_self = self;
    [_PrimeRateExplainrequest sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        
        if (!error && [result isKindOfClass:[HYFlightBuyTicketPrimeRateExplainInfoResponse class]]) {
            
            HYFlightBuyTicketPrimeRateExplainInfoResponse *response = (HYFlightBuyTicketPrimeRateExplainInfoResponse *)result;
            b_self.air_tips = response.air_tips;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private methods
/**
 *  设置初始数据
 *  默认起终点城市、舱位类型
 */
- (void)initData
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *startCity = [def objectForKey:kLastStartCity];
    NSString *comeCity = [def objectForKey:kLastComeCity];
    if ([startCity length] <= 0)
    {
        startCity = [def objectForKey:kCurrentCity];
    }
    
    if ([startCity length] > 0)
    {
        self.orgCity = [HYFlightCity getWithCityName:startCity];
    }
    if ([comeCity length] > 0)
    {
        self.dstCity = [HYFlightCity getWithCityName:comeCity];
    }
    
    self.cabin = [[HYCabins alloc] init];
}

/**
 *  设置默认起始时间
 *  如果是往返的，设置默认返回时间
 */
- (void)setDefDateInfo
{
    if (_isSingleWay)
    {
        if (!self.startTime)
        {
            NSDate *date = [NSDate date];
            NSString *today = [date timeDescription];
            NSDate *nextDay = [NSDate dateFromString:today];
            nextDay = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:nextDay];
            self.startTime = [nextDay timeDescription];
            self.startDate = [nextDay localDescription];
        }
    }
    else
    {
        if (!self.backTime)
        {
            NSDate *date = [NSDate date];
            NSString *today = [date timeDescription];
            NSDate *nextDay = [NSDate dateFromString:today];
            nextDay = [NSDate dateWithTimeInterval:(24*60*60*3) sinceDate:nextDay];
            self.backTime = [nextDay timeDescription];
//            self.backTimestamp = [nextDay timeIntervalSince1970];
            
            NSDateComponents *nextDayCom = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSCalendarCalendarUnit fromDate:nextDay];
            
            NSString *week = [PTDateFormatrer weekChinese:(int)nextDayCom.weekday];
            self.backDate = [NSString stringWithFormat:@"%ld年 %@", nextDayCom.year, week];
        }
    }
}


/**
 *  搜索按钮点击事件
 *  根据条件搜索航班
 *
 *  @param sender
 */
- (void)searchflight:(id)sender
{
    NSString *alertMsg = nil;
    if (!self.startTime)
    {
        alertMsg = @"请选择出发时间";
    }
    
    if (!self.orgCity)
    {
        alertMsg = @"请选择出发城市";
    }
    
    if (!self.dstCity)
    {
        alertMsg = @"请选择到达城市";
    }
    
    if (!alertMsg)
    {
        HYFlightListViewController *vc = [[HYFlightListViewController alloc] init];
        vc.orgCity = self.orgCity;
        vc.dstCity = self.dstCity;
        vc.cabin = self.cabin;
        vc.startDate = self.startTime;
        vc.backDate = self.backTime;
        vc.singleWay = _isSingleWay;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"知道了", nil];
        [alert show];
    }
    

}

- (void)switchflightSingle:(id)sender
{
    _isSingleWay = !_isSingleWay;
    [self setDefDateInfo];
    [self.tableView reloadData];
}

- (HYPickerToolView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[HYPickerToolView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        _pickerView.delegate = self;
        _pickerView.dataSouce = @[@"不限", @"经济舱", @"头等舱/商务舱"];
        _pickerView.title = @"舱位选择";
    }
    
    return _pickerView;
}

#pragma mark - HYFlightDateViewControllerDelegate
//单程选择时间回调
//返回时间为三天，代码进行计算
- (void)didSelectStartDate:(NSString *)start
                      week:(NSString *)week
{
    self.startDate = week;
    self.startTime = start;
    NSDate *date = [NSDate dateFromString:start];
    [self.tableView reloadData];
    
    NSDate *nextDay = [NSDate dateWithTimeInterval:(24*60*60*3) sinceDate:date];
    self.backDate = [nextDay localDescription];
    
    NSDateComponents *nextDayCom = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSCalendarCalendarUnit fromDate:nextDay];
    
    NSString *nextWeek = [PTDateFormatrer weekChinese:(int)nextDayCom.weekday];
    self.backTime = [NSString stringWithFormat:@"%ld年 %@", nextDayCom.year, nextWeek];
}

//往返选择时间回调
- (void)didSelectStartDate:(NSString *)start
                     sWeek:(NSString *)sWeek
                  backDate:(NSString *)backDate
                     bWeek:(NSString *)bWeek
{
    self.startDate = sWeek;
    self.startTime = start;
    
    self.backDate = bWeek;
    self.backTime = backDate;
    
    [self.tableView reloadData];
}

#pragma mark - HYFlightDateSettingCellDelegate
//日期cell点击回调事件
- (void)startDateSetting
{
    HYFlightDateViewController *vc = [[HYFlightDateViewController alloc] init];
    vc.title = @"选择出发日期";
    vc.delegate = self;
    vc.singleWay = _isSingleWay;
    NSDate *date = [NSDate dateFromString:self.startTime];
    vc.startDate = date;
    if (!_isSingleWay)
    {
        vc.title = @"选择往返日期";
        NSDate *bdate = [NSDate dateFromString:self.backTime];
        vc.endDate = bdate;
    }
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)backDateSetting
{
    HYFlightDateViewController *vc = [[HYFlightDateViewController alloc] init];
    vc.title = @"选择往返日期";
    vc.delegate = self;
    vc.singleWay = _isSingleWay;
    NSDate *date = [NSDate dateFromString:self.startTime];
    vc.startDate = date;
    NSDate *bdate = [NSDate dateFromString:self.backTime];
    vc.endDate = bdate;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TFScalePoint(68.0);
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -1){
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 )
    {
        static NSString *citySettingCell = @"citySettingCell";
        HYFlightCitySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:citySettingCell];
        if (cell == nil)
        {
            cell = [[HYFlightCitySettingCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:citySettingCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        cell.orgCity = self.orgCity;
        cell.dstCity = self.dstCity;
        return cell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *dateSettingCell = @"dateSettingCell";
        HYFlightDateSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:dateSettingCell];
        if (cell == nil)
        {
            cell = [[HYFlightDateSettingCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:dateSettingCell];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.delegate = self;
        }
        
        cell.singleWay = _isSingleWay;
        cell.startDate = self.startDate;
        cell.startTime = self.startTime;
        cell.backDate = self.backDate;
        cell.backTime = self.backTime;
        return cell;
    }
    else
    {
        static NSString *cabinCellID = @"searchnearID";
        HYSearchChairCell *cell = [tableView dequeueReusableCellWithIdentifier:cabinCellID];
        if (cell == nil)
        {
            cell = [[HYSearchChairCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cabinCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryNone;
             
            cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
            [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.frame = TFRectMake(10, 50, 120, 18);
        }
//        UILabel *searchChair = [UILabel new];
//        searchChair.text = @"选择舱位";
//        searchChair.textColor = [UIColor grayColor];
//        searchChair.frame = TFRectMake(30, 5, 50, 10);
//        searchChair.font = [UIFont systemFontOfSize:TFScalePoint(11)];
//        [cell.contentView addSubview:searchChair];
        
        switch (self.cabin.type)
        {
            case All_Cabin:
                cell.mainTextLab.text = @"不限";
                break;
            case Economy_Cabin:
                cell.mainTextLab.text = @"经济舱";
                break;
            case First_Cabin:
                cell.mainTextLab.text = @"头等舱/商务舱";
                break;
            default:
                break;
        }

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2)
    {
        [self.pickerView showWithAnimation:YES];
    }
}

#pragma mark HYFlightCitySettingCellDelegate
//使用_setOrgCity成员来确定是起始城市还是终点城市
- (void)setflightOrgCity
{
    _setOrgCity = YES;
    HYFlightCityViewController *vc = [[HYFlightCityViewController alloc] init];
    vc.delegate = self;
    vc.dataSoucreType = FlightCity;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setflightDstCity
{
    _setOrgCity = NO;
    HYFlightCityViewController *vc = [[HYFlightCityViewController alloc] init];
    vc.delegate = self;
    vc.dataSoucreType = FlightCity;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)transformflightCity
{
    HYFlightCity *tempCity = self.orgCity;
    self.orgCity = self.dstCity;
    self.dstCity = tempCity;
}

#pragma mark - HYFlightCityViewControllerDelegate
- (void)didSelectCity:(HYCountryInfo *)city
{
    if ([city isKindOfClass:[HYFlightCity class]])
    {
        if (_setOrgCity)
        {
            self.orgCity = (HYFlightCity *)city;
            [[NSUserDefaults standardUserDefaults] setObject:self.orgCity.cityName
                                                      forKey:kLastStartCity];
        }
        else
        {
            self.dstCity = (HYFlightCity *)city;
            [[NSUserDefaults standardUserDefaults] setObject:self.dstCity.cityName
                                                      forKey:kLastComeCity];
        }
        [self.tableView reloadData];
    }
}

#pragma mark -
- (void)selectComplete:(HYPickerToolView *)pickerView
{
    //F-头等舱 C-商务舱 Y-经济舱
    switch (pickerView.currentIndex)
    {
        case 0:
            self.cabin.type = All_Cabin;
            break;
        case 1:
            self.cabin.type = Economy_Cabin;
            break;
        default:
            self.cabin.type = First_Cabin;
            break;
    }

    [self.tableView reloadData];
}

#pragma mark - bannerDidClicked
- (void)bannerDidClicked:(UITapGestureRecognizer *)tap
{
    if (self.air_tips) {
        HYFlightBuyTicketGetPrimeRateExplainView *primeRateExplainView = [[HYFlightBuyTicketGetPrimeRateExplainView alloc] initWithHTMLstring:self.air_tips];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:primeRateExplainView];
    }
    
}


@end
