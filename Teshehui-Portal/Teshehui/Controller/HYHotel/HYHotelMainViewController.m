//
//  HYHotelMainViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelMainViewController.h"
#import "HYHotelMainCell.h"
#import "HYHotelMainCheckCell.h"
#import "HYHotelMainKeywordCell.h"
#import "HYHotelLocationCell.h"
#import "HYAppDelegate.h"
#import "HYLocationManager.h"

#import "HYHotelCitySelectViewController.h"
#import "HYDateSettingViewController.h"
#import "HYKeywordSettingViewController.h"
#import "HYConditionSettingViewController.h"
#import "HYHotelListViewController.h"
#import "HYHotelCondition.h"

#import "PTDateFormatrer.h"
#import "NSDate+Addition.h"
#import "HYHotelPriceConditionView.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface HYHotelMainViewController ()
<
HYCitySelectDelegate,
CQDateSettingViewControllerDelegate,
HYConditionSettingDelegate,
UIAlertViewDelegate,
HYHotelLocationCellV2Protocol,
UITextFieldDelegate,
HYHotelConditionChangeDelegate
>
{
    BOOL isSetCheckInDate;
}

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) HYHotelCityInfo *cityInfo;
@property (nonatomic, strong) HYHotelCondition *searchCondition;
@property (nonatomic, strong) NSString *cityCellDisplay;
@property (nonatomic, assign) BOOL searchNear;

@property (nonatomic, copy) NSString *location;  //防止该城市无酒店信息的时候可以显示
@property (nonatomic, copy) NSString *searchCheckInDate;
@property (nonatomic, copy) NSString *checkInWeedDay;
@property (nonatomic, copy) NSString *searchCheckOutDate;
@property (nonatomic, copy) NSString *checkOutWeedDay;
@property (nonatomic, assign) NSInteger checkDays;

- (void)initDefDateInfo;
- (void)initDefCondition;
- (void)searchHotel:(id)sender;
- (void)searchHotelWithNear:(BOOL)near;
@end

@implementation HYHotelMainViewController

- (void)dealloc
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cityCellDisplay = @"深圳";
        self.searchNear = NO;
        self.checkDays = 0;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 48.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionHeaderHeight = 0;
    tableview.sectionFooterHeight = 0;
    tableview.delaysContentTouches = NO;
    
    /**
     *  header 320 : 90
     */
    CGFloat headerHeight = CGRectGetWidth(frame) * 0.28;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, headerHeight)];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hotelSearch_banner"]];
    img.frame = headView.bounds;
    [headView addSubview:img];
    tableview.tableHeaderView = headView;
    
    [self.view addSubview:tableview];
    
    UILabel *tipeView = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-100, frame.size.height-60, 200, 40)];
    tipeView.font = [UIFont systemFontOfSize:12];
    tipeView.textAlignment = NSTextAlignmentCenter;
    tipeView.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    tipeView.text = @"* 酒店数据由携程、艺龙联合提供";
    [self.view addSubview:tipeView];
    
    self.tableView = tableview;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"hotel", nil);
    
    //更新城市列表
    __weak typeof(self) bself = self;
    [HYHotelCityInfo updateHotelCityWithCallback:^(BOOL succ, BOOL hasChange) {
        if (succ && hasChange)
        {
            //更新城市的信息
            [bself.searchCondition.cityInfo updateInfo];
        }
    }];
    
    //设置日期
    [self initDefDateInfo];
    
    //设置条件
    [self initDefCondition];
    self.cityCellDisplay = @"定位中...";
    
    //初始化城市信息
    __weak typeof(self) b_self = self;
    self.searchNear = NO;
    [[HYLocationManager sharedManager] getCacheAddressInfo:^(HYLocateState state, HYLocateResultInfo *addrInfo)
    {
        [b_self initCityInfo:state withAddressInfo:addrInfo];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (![self.view window])
    {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
        self.view = nil;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        HYHotelCitySelectViewController *vc = [[HYHotelCitySelectViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

#pragma mark - CQDateSettingViewControllerDelegate
- (void)didSelectCheckInDate:(NSString *)checkInDate
                 checkInWeek:(NSString *)checkInWeek
                CheckOutDate:(NSString *)checkOutDate
                checkOutWeek:(NSString *)checkOutWeek
{
    NSString *informate = @"yyyy-MM-dd";
    NSDate *inDate = [PTDateFormatrer dateFromString:checkInDate format:informate];
    NSDate *outDate = [PTDateFormatrer dateFromString:checkOutDate format:informate];
    self.searchCheckInDate = checkInDate;
    self.searchCheckOutDate = checkOutDate;
    self.checkInWeedDay = checkInWeek;
    self.checkOutWeedDay = checkOutWeek;
    
    if (inDate && outDate)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned int unitFlag = NSCalendarUnitDay;
        NSDateComponents *components = [calendar components:unitFlag fromDate:inDate toDate:outDate options:0];
        NSInteger days = [components day];
        self.checkDays = days;
    }
    else
    {
        self.checkDays = 0;
    }
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:checkInDate forKey:kHotelCheckInDate];
    [def setObject:checkOutDate forKey:kHotelCheckOutDate];
    [def synchronize];
    
    [self.tableView reloadData];
}

#pragma mark - HYHotelLocationCellDelegate
- (void)hotelLocationCellDidClickCityBtn
{
    HYHotelCitySelectViewController *vc = [[HYHotelCitySelectViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)hotelLocationCellDidClickLocateBtn
{
    
    //清空本地城市信息
    //这里需要在定位回调前清空，如果选择城市后再点选定位，不清空位置可能会给用户带来误解
    self.searchCondition.cityInfo = nil;
    [[HYLocationManager sharedManager] clearAddressInfo];
    
    //点选定位时清空商业区等条件，与携程一致
    [self.searchCondition clearLocationInfos];
    self.searchCondition.keyword = nil;
    
    self.cityCellDisplay = @"定位中...";
    self.searchNear = YES;
    [self.tableView reloadData];
    //update
    //获取位置并缓存
    __weak HYHotelMainViewController *w_self = self;
    [[HYLocationManager sharedManager] getCacheAddressInfo:^(HYLocateState state, HYLocateResultInfo *result)
    {
        [w_self initCityInfo:state withAddressInfo:result];
    }];
}

#pragma mark - HYCitySelectDelegate
- (void)didSelectCity:(HYHotelCityInfo *)city
{
    if ([city isKindOfClass:[HYHotelCityInfo class]])
    {
        HYHotelCityInfo *hCity = (HYHotelCityInfo *)city;
        
        self.searchNear = NO;
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:hCity.cityName forKey:kHotelDefCity];
        
        self.searchCondition.cityInfo = city;
        self.cityCellDisplay = hCity.cityName;
        
        [self.tableView reloadData];
    }
}

#pragma mark - HYConditionSettingDelegate
- (void)didSelectCondition:(HYHotelCondition *)condition type:(ConditionType)viewType
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 44.0f;
    }
    else if (indexPath.row == 1)
    {
        return 56.0f;
    }
    else if (indexPath.row == 4)
    {
        return 60;
    }
    
    return 44.0f;
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
    HYBaseLineCell *cell = nil;

    switch (indexPath.row)
    {
        case 0: //附近的酒店
        {
            static NSString *searchnearID = @"searchnearID";
            HYHotelLocationCell* cell = [tableView dequeueReusableCellWithIdentifier:searchnearID];
            if (cell == nil)
            {
                cell = [[HYHotelLocationCell alloc]initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:searchnearID];
            }
            cell.delegate = self;
            cell.locationLab.text = self.cityCellDisplay;
//            cell.locationLab.text = @"超长测试超长测试超长测试超长测试超长测试超长测试超长测试超长测试超长测试超长测试超长测试超长测试超长测试超长测试超长测试";
            return cell;
        }
            break;
        case 1:  //hotelCheckIn
        {
            static NSString *hotelCheckID = @"hotelCheckID";
            cell = [tableView dequeueReusableCellWithIdentifier:hotelCheckID];
            if (cell == nil)
            {
                cell = [[HYHotelMainCheckCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:hotelCheckID];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            
            [(HYHotelMainCheckCell *)cell setCheckInDate:[self getDateDisplay:_searchCheckInDate]];
            [(HYHotelMainCheckCell *)cell setCheckInweekDay:self.checkInWeedDay];
            [(HYHotelMainCheckCell *)cell setCheckOutDate:[self getDateDisplay:_searchCheckOutDate]];
            [(HYHotelMainCheckCell *)cell setCheckOutweekDay:self.checkOutWeedDay];
            [(HYHotelMainCheckCell *)cell setDay:self.checkDays];
        }
            break;
        case 2: //keyword
        {
            static NSString *keyCellID = @"keyCellID";
            cell = [tableView dequeueReusableCellWithIdentifier:keyCellID];
            if (cell == nil)
            {
                cell = [[HYHotelMainKeywordCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                    reuseIdentifier:keyCellID];
                //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            HYHotelMainKeywordCell *keyCell = (HYHotelMainKeywordCell *)cell;
            //[cell.textLabel setText:NSLocalizedString(@"keyword", nil)];
            keyCell.keyField.text = self.searchCondition.keyword;
            keyCell.keyField.clearButtonMode = UITextFieldViewModeAlways;
            keyCell.keyField.delegate = self;
            keyCell.keyField.tag = 99;
        }
            break;
        case 3:  //价格/星级
        {
            static NSString *priceCellId = @"priceCellId";
            cell = [tableView dequeueReusableCellWithIdentifier:priceCellId];
            if (cell == nil)
            {
                cell = [[HYHotelMainKeywordCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                             reuseIdentifier:priceCellId];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            
            HYHotelMainKeywordCell *priceCell = (HYHotelMainKeywordCell *)cell;
            priceCell.keyField.text = [self.searchCondition showPriceAndStar];
            priceCell.keyField.clearButtonMode = UITextFieldViewModeUnlessEditing;
            priceCell.keyField.delegate = self;
            priceCell.keyField.placeholder = @"价格/星级";
            priceCell.keyField.tag = 100;
        }
            break;
        case 4:
        {
            static NSString *searchId = @"searchId";
            cell = [tableView dequeueReusableCellWithIdentifier:searchId];
            if (!cell)
            {
                cell = [[HYBaseLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchId];
                cell.hiddenLine = YES;
                UIImage *bg = [UIImage imageNamed:@"fightSearch_btn"];
                bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch];
                UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                searchBtn.frame = CGRectMake(12, 15, self.view.frame.size.width-2*12, 40);
                [searchBtn setBackgroundImage:bg
                                     forState:UIControlStateNormal];
                [searchBtn addTarget:self
                              action:@selector(searchHotel:)
                    forControlEvents:UIControlEventTouchUpInside];
                [searchBtn setTitle:@"搜索"
                           forState:UIControlStateNormal];
                [searchBtn setImage:[UIImage imageNamed:@"fightSearch_btn2"] forState:UIControlStateNormal];
                [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                [cell.contentView addSubview:searchBtn];
            }
            break;
        }
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0:  //
        {
            [self hotelLocationCellDidClickCityBtn];
        }
            break;
        /*case 1:  //city
        {
            HYHotelCitySelectViewController *vc = [[HYHotelCitySelectViewController alloc] init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc
                                                 animated:YES];

        }
            break;*/
        case 1:  //check in date
        {
            HYDateSettingViewController *vc = [[HYDateSettingViewController alloc] init];
            vc.title = @"选择入住时间";
            vc.delegate = self;
            NSDate *checkIn = [NSDate dateFromString:self.searchCheckInDate];
            NSDate *checkOut = [NSDate dateFromString:self.searchCheckOutDate];
            vc.checkInDate = checkIn;
            vc.checkOutDate = checkOut;
            vc.navbarTheme = self.navbarTheme;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
            break;
//        case 2:
//        {
//            HYKeywordSettingViewController *vc = [[HYKeywordSettingViewController alloc] init];
//            vc.condition = self.searchCondition;
//            [self.navigationController pushViewController:vc
//                                                 animated:YES];
//        }
//            break;
        case 3:
        {
            /*
            HY SettingViewController *vc = [[HYConditionSettingViewController alloc] init];
            vc.delegate = self;
            vc.condition = self.searchCondition;
            vc.viewType = PriceAndStar;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
             */
            [self.view endEditing:YES];
            HYHotelPriceConditionView *conditionView = [[HYHotelPriceConditionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 330)];
            conditionView.condition = self.searchCondition;
            conditionView.delegate = self;
            [conditionView showWithAnimation:YES];
        }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
}

#pragma mark - text field
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 99) {
        self.searchCondition.keyword = textField.text;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 99)
    {
        
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 99)
    {
        if (currentDeviceType() == iPhone4_4S)
        {
            [self.tableView setContentOffset:CGPointMake(0, 100) animated:NO];
        }
        return YES;
    }
    if (textField.tag == 100) {
        [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        return NO;
    }
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField.tag == 99) {
        _searchCondition.keyword = nil;
        textField.text = nil;
        return NO;
    }
    if (textField.tag == 100) {
        _searchCondition.hotelPrice = nil;
        _searchCondition.hotelStars = nil;
        textField.text = nil;
        return NO;
    }
    return YES;
}

#pragma mark - ConditionChangeDelegate
- (void)hotelConditionChanged:(HYHotelCondition *)condition
{
    //DebugNSLog(@"price:%d, level:%@", priceLevel, stars);
    [self.tableView reloadData];
}

#pragma mark private methods
- (void)initDefDateInfo
{
    NSString *defDateStr = [[NSUserDefaults standardUserDefaults] objectForKey:kHotelCheckInDate];
    NSDate *defDate = [NSDate dateFromString:defDateStr];
    NSDate *date = [NSDate date];
    
    if (!defDate || [defDate compare:date] == NSOrderedAscending)
    {
        self.searchCheckInDate = [date timeDescription];
        
        NSDateComponents *todayDayCom = [[NSCalendar currentCalendar] components: NSWeekdayCalendarUnit | NSCalendarCalendarUnit
                                                                        fromDate:date];
        self.checkInWeedDay = [PTDateFormatrer weekChinese:(int)todayDayCom.weekday];
        
        NSDate *nextDay = [NSDate dateFromString:self.searchCheckInDate];
        nextDay = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:nextDay];
        self.searchCheckOutDate = [nextDay timeDescription];
        
        NSDateComponents *nextDayCom = [[NSCalendar currentCalendar] components: NSWeekdayCalendarUnit | NSCalendarCalendarUnit
                                                                       fromDate:nextDay];
        
        self.checkOutWeedDay = [PTDateFormatrer weekChinese:(int)nextDayCom.weekday];
        self.checkDays = 1;
    }
    else
    {
        self.searchCheckInDate = defDateStr;
        
        NSDateComponents *todayDayCom = [[NSCalendar currentCalendar] components: NSWeekdayCalendarUnit | NSCalendarCalendarUnit
                                                                        fromDate:defDate];
        self.checkInWeedDay = [PTDateFormatrer weekChinese:(int)todayDayCom.weekday];
        
        NSString *checkOutDayStr = [[NSUserDefaults standardUserDefaults] objectForKey:kHotelCheckOutDate];
        NSDate *checkOutDay = [NSDate dateFromString:checkOutDayStr];
        self.searchCheckOutDate = checkOutDayStr;
        
        NSDateComponents *nextDayCom = [[NSCalendar currentCalendar] components: NSWeekdayCalendarUnit | NSCalendarCalendarUnit |NSDayCalendarUnit
                                                                       fromDate:checkOutDay];
        
        self.checkOutWeedDay = [PTDateFormatrer weekChinese:(int)nextDayCom.weekday];
        
        NSDateComponents *dayCom = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:defDate toDate:checkOutDay options:0];
        self.checkDays = dayCom.day;
    }
}

- (void)initDefCondition
{
    if (!_searchCondition)
    {
        _searchCondition = [[HYHotelCondition alloc] init];
    }
}

//初始化城市和地理位置信息，缓存在_cityInfo中
- (void)initCityInfo:(HYLocateState)state withAddressInfo:(HYLocateResultInfo *)result
{
    if (!_searchCondition.cityInfo)
    {
        _searchCondition.cityInfo = [[HYHotelCityInfo alloc] init];
    }
    
    if (state < HYLocateSuccess)
    {
        if (![_searchCondition.cityInfo.cityName isEqualToString:@"深圳"])
        {
            _searchCondition.cityInfo.cityName = @"深圳";
            [_searchCondition.cityInfo updateInfo];
        }
        self.cityCellDisplay = @"深圳";
        self.searchNear = NO;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"定位失败，您可以通过在设置中开启定位服务，开启WiFi，以提高定位成功率，或者选择城市查询"
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                                  otherButtonTitles:@"选择城市", nil];
        [alertView show];
    }
    else
    {
        NSString *cityName = result.city;
        NSString *location = result.address;
//        
//        self.location = location;
        if ([cityName length] > 0 && ![_searchCondition.cityInfo.cityName isEqualToString:cityName])
        {
            _searchCondition.cityInfo.cityName = cityName;
            [_searchCondition.cityInfo updateInfo];
        }
        
        self.searchCondition.DotX = @(result.lat);
        self.searchCondition.DotY = @(result.lon);
        
        self.cityCellDisplay = _searchNear ? location : cityName;
    }
    
    [self.tableView reloadData];
}

- (void)searchHotelWithNear:(BOOL)near
{
    [self.view endEditing:YES];
    if (!_searchCondition.cityInfo) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"定位中请稍后，您也可以选择城市查询"
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                                  otherButtonTitles:@"选择城市", nil];
        [alertView show];
        return;
    }
    
    HYHotelListViewController *vc = [[HYHotelListViewController alloc] init];
    vc.condition = self.searchCondition;
    vc.searchCheckInDate = self.searchCheckInDate;
    vc.searchCheckOutDate = self.searchCheckOutDate;
    vc.searchNear = near;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)searchHotel:(id)sender
{
    [self searchHotelWithNear:self.searchNear];
}

-(UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSString *)getDateDisplay:(NSString *)inDate
{
    NSArray *coms = [inDate componentsSeparatedByString:@"-"];
    if (coms.count == 3)
    {
        return [NSString stringWithFormat:@"%@月%@日", coms[1], coms[2]];
    }
    return inDate;
}

@end
