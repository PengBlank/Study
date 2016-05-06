//
//  HYFlightListViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightListViewController.h"
#import "HYFlightSearchRequest.h"
#import "HYFlightListCell.h"
#import "HYFlightCabinCell.h"
#import "HYFlightFillOrderViewController.h"
#import "HYFlightDateUpdateView.h"
#import "HYLoadHubView.h"
#import "NSDate+Addition.h"
#import "CQSegmentControl.h"
#import "HYFlightBackListViewController.h"
#import "HYUpdateCabinPriceRequest.h"

#import "HYFlightCabinListViewController.h"
#import "PTDateFormatrer.h"

@interface HYFlightListViewController ()<HYFlightDateUpdateViewDeleage, HYFlightListCellDelegate>
{
    HYFlightDateUpdateView *_dateUpdateView;
    HYFlightSearchRequest *_searchRequest;
    CQSegmentControl *_segControl;
    CGFloat _prevContentOffsetY;
    
    BOOL _timeAscendSort;
    BOOL _priceAscendSort;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *flightList;

@end

@implementation HYFlightListViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_searchRequest cancel];
    _searchRequest = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _timeAscendSort = YES;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //顶部，前后天界面
    _dateUpdateView = [[HYFlightDateUpdateView alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 40)];
    _dateUpdateView.delegate = self;
    
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.startTimestamp];
    NSDate *date = [NSDate dateFromString:self.startDate];
//    NSString *weekday = [PTDateFormatrer weekChinese:(int)[date getWeekday]];
    
    _dateUpdateView.dateLabel.text = [date timeDescription];
    
    [self.view addSubview:_dateUpdateView];
    
    //tableview
    frame.origin.y = 40;
    frame.size.height -= 40.0;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self.view addSubview:tableview];
    
	self.tableView = tableview;
    
    // bottom bar
    if (!_segControl)
    {
        //综合筛选
        CQSegmentItem *filter = [[CQSegmentItem alloc] init];
        filter.dicection = Horizontal;
        filter.title = NSLocalizedString(@"起飞", nil);
        filter.doubleImage = [UIImage imageNamed:@"icon_sort_rate_down"];
        filter.hightlightImage = [UIImage imageNamed:@"icon_sort_rate_up"];
        
        //排序
        CQSegmentItem *sort = [[CQSegmentItem alloc] init];
        sort.dicection = Horizontal;
        sort.title = NSLocalizedString(@"价格", nil);
        sort.doubleImage = [UIImage imageNamed:@"icon_sort_rate_down"];
        sort.hightlightImage = [UIImage imageNamed:@"icon_sort_rate_up"];
        
        NSArray *items = [NSArray arrayWithObjects:filter, sort, nil];
        frame.origin.y = (frame.origin.y+frame.size.height-48);
        frame.size.height = 48;
        _segControl = [[CQSegmentControl alloc] initWithFrame:frame items:items];
        _segControl.selectColor = @"0099FF";
        _segControl.normalColor = @"333333";
        _segControl.showSelectStatus = YES;
        _segControl.supportDouble = YES;
        [_segControl setSelectedItemIndex:0];
//        _segControl.bgImage = [[UIImage imageNamed:@"hotel_bg_tab"] stretchableImageWithLeftCapWidth:2
//                                                                                        topCapHeight:0];
        [_segControl addEventforSelectChangeTarget:self
                                            action:@selector(didchangeSelectValue:)];
        
        /// 加一根蓝线，没有分隔线太丑了。by:成才
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, .5)];
        line.backgroundColor = [UIColor colorWithRed:33.0/255.0
                                               green:181.0/255.0
                                                blue:255.0/255.0
                                               alpha:1.0];
        [_segControl addSubview:line];
        
        [self.view addSubview:_segControl];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"%@-%@", self.orgCity.cityName, self.dstCity.cityName];
    [self searchflight];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private methods
- (void)searchflight
{
    if (_searchRequest)
    {
        [_searchRequest cancel];
        _searchRequest = nil;
    }
    
    //清除本地数据
    self.flightList = nil;
    [self.tableView reloadData];
    
    [HYLoadHubView show];
    
    _searchRequest = [[HYFlightSearchRequest alloc] init];
    _searchRequest.flightDate = self.startDate;
    _searchRequest.startCityId = self.orgCity.code;
    _searchRequest.endCityId = self.dstCity.code;
    
    NSArray *cabinTyps = [NSArray arrayWithObject:[NSNumber numberWithInt:self.cabin.type]];
    if (self.cabin.type==Business_Cabin || self.cabin.type==First_Cabin)
    {
        cabinTyps = [NSArray arrayWithObjects:@"1", @"2", nil];
    }
    _searchRequest.cabinType = cabinTyps;
    
    __weak typeof(self) b_self = self;
    [_searchRequest sendReuqest:^(id result, NSError *error) {
        NSArray *flights = nil;
        if ([result isKindOfClass:[HYFlightSearchResponse class]])
        {
            HYFlightSearchResponse *reponse = (HYFlightSearchResponse *)result;
            flights = reponse.flightList;
        }
        
        [b_self updateTableViewWithflights:flights error:error];
    }];
}

- (void)updateTableViewWithflights:(NSArray *)flights error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    self.flightList = flights;

    //对于查询失败的容错处理
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:error.domain
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else if ([flights count] <= 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"暂无可售航班信息"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    //0、1、yes、no确定四种排序规则，四选1
    if (_segControl.currentIndex == 0) //排序规则
    {
        __block BOOL sort = _timeAscendSort;
        self.flightList = [self.flightList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            HYFlightListSummary *h1 = (HYFlightListSummary *)obj1;
            HYFlightListSummary *h2 = (HYFlightListSummary *)obj2;
            if (sort)
            {
                return h1.startTimestamp > h2.startTimestamp;
            }
            else
            {
                return h1.startTimestamp < h2.startTimestamp;
            }
        }];
    }
    else
    {
        __block BOOL sort = _priceAscendSort;
        self.flightList = [self.flightList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            HYFlightListSummary *h1 = (HYFlightListSummary *)obj1;
            HYFlightListSummary *h2 = (HYFlightListSummary *)obj2;
            if (sort)
            {
                return h1.price > h2.price;
            }
            else
            {
                return h1.price < h2.price;
            }
        }];
    }
    
    [self.tableView reloadData];
}

- (void)didchangeSelectValue:(id)sender
{
    if ([self.flightList count] > 0)
    {
        if ([sender isKindOfClass:[CQSegmentControl class]])
        {
            CQSegmentControl *seg = (CQSegmentControl *)sender;
            NSInteger index = seg.currentIndex;
            if (index == 0)
            {
                //按照起飞时间排序
                _timeAscendSort = !_timeAscendSort;
                __block BOOL sort = _timeAscendSort;
                self.flightList = [self.flightList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    HYFlightListSummary *h1 = (HYFlightListSummary *)obj1;
                    HYFlightListSummary *h2 = (HYFlightListSummary *)obj2;
                    if (sort)
                    {
                        return h1.startTimestamp > h2.startTimestamp;
                    }
                    else
                    {
                        return h1.startTimestamp < h2.startTimestamp;
                    }
                }];
                
                [self.tableView reloadData];
            }
            else
            {
                _priceAscendSort = !_priceAscendSort;
                __block BOOL sort = _priceAscendSort;
                self.flightList = [self.flightList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    HYFlightListSummary *h1 = (HYFlightListSummary *)obj1;
                    HYFlightListSummary *h2 = (HYFlightListSummary *)obj2;
                    if (sort)
                    {
                        return h1.price.floatValue > h2.price.floatValue;
                    }
                    else
                    {
                        return h1.price.floatValue < h2.price.floatValue;
                    }
                }];
                
                [self.tableView reloadData];
            }
        }
    }
}

- (void)setToolBarIsShow:(BOOL)show
{
    if (show)
    {
        CGRect rect = _segControl.frame;
        rect.origin.y = [[UIScreen mainScreen] bounds].size.height-rect.size.height-64;
        [UIView animateWithDuration:0.3
                         animations:^{
                             _segControl.frame = rect;
                         }];
        
        UIEdgeInsets insets = self.tableView.scrollIndicatorInsets;
        insets.bottom = self.view.frame.size.height-rect.origin.y;
        self.tableView.scrollIndicatorInsets = insets;
    }
    else
    {
        CGRect rect = _segControl.frame;
        rect.origin.y = [[UIScreen mainScreen] bounds].size.height-rect.size.height;
        [UIView animateWithDuration:0.3
                         animations:^{
                             _segControl.frame = rect;
                         }];
        
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }
}

#pragma mark =- HYFlightDateUpdateViewDeleage
- (void)searchLastDayFlight
{
    NSDate *today = [NSDate date];
    NSTimeInterval todayInterval = [today timeIntervalSince1970];
    
    //86400为24小时
    NSDate *date = [NSDate dateFromString:self.startDate];
    
    NSTimeInterval lastInterval = [date timeIntervalSince1970] -86400;
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:lastInterval];
    
    if (todayInterval<lastInterval || (todayInterval-lastInterval<86400))
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:lastInterval];
//        NSString *week = [PTDateFormatrer weekChinese:(int)[date getWeekday]];
        _dateUpdateView.dateLabel.text = [date timeDescription];
        self.startDate = [date timeDescription];
        //重新查询
        [self searchflight];
    }
}

- (void)searchNextDayFlight
{
    NSDate *date = [NSDate dateFromString:self.startDate];
    NSTimeInterval lastInterval = [date timeIntervalSince1970]+86400;
    
    NSDate *ndate = [NSDate dateWithTimeIntervalSince1970:lastInterval];
//    NSString *week = [PTDateFormatrer weekChinese:(int)[ndate getWeekday]];
    _dateUpdateView.dateLabel.text = [ndate timeDescription];;
    self.startDate = [ndate timeDescription];
    
    //重新查询
    [self searchflight];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.flightList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
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
    static NSString *searchnearID = @"searchnearID";
    HYFlightListCell *cell = [tableView dequeueReusableCellWithIdentifier:searchnearID];
    if (cell == nil)
    {
        cell = [[HYFlightListCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:searchnearID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.delegate = self;
    }
    
    if (indexPath.section < [self.flightList count])
    {
        HYFlightListSummary *flight = [self.flightList objectAtIndex:indexPath.section];
        [cell setFlight:flight];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /**
     *  往返的情况：点击航班后，再次进入到航班选择界面，需要再选择一次
     *  单程则直接进入舱位选择
     */
    if (!self.singleWay)
    {
        //返程
        HYFlightBackListViewController *vc = [[HYFlightBackListViewController alloc] init];
        vc.orgCity = self.dstCity;
        vc.dstCity = self.orgCity;
        vc.startDate  = self.backDate;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else
    {
        DebugNSLog(@"indexPath = %@", indexPath);
        
        if (indexPath.section < [self.flightList count])
        {
            HYFlightListSummary *flight = [self.flightList objectAtIndex:indexPath.section];
            
            HYFlightCabinListViewController *vc = [[HYFlightCabinListViewController alloc] init];
            
            vc.flightSummary = flight;
            vc.type = self.cabin.type;
            vc.startDate = self.startDate;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
            /*
            
            NSArray *cabins = [flight Cabins];
            
            HYCabins *cabin = flight.cheapCabins;
            if ([cabins count] > 0 && (indexPath.row>0))
            {
                NSInteger index = indexPath.row-1;
                if (index < [cabins count])
                {
                    cabin = [cabins objectAtIndex:index];
                }
            }
            
            HYFlightFillOrderViewController *vc = [[HYFlightFillOrderViewController alloc] init];
            vc.flight = flight;
            vc.orgCabin = cabin;
            vc.orgCity = self.orgCity;
            vc.dstCity = self.dstCity;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
             */
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging)
    {
        CGFloat deltaY = scrollView.contentOffset.y-_prevContentOffsetY;
        _prevContentOffsetY = MAX(scrollView.contentOffset.y, -scrollView.contentInset.top);
        
        if (deltaY > 0)
        {
            [self setToolBarIsShow:NO];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self setToolBarIsShow:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setToolBarIsShow:YES];
}

@end
