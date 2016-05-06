//
//  HYFlightCabinListViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-6-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightCabinListViewController.h"
#import "HYFlightCabinCell.h"
#import "HYFlightFillOrderViewController.h"
#import "HYFlightSummaryView.h"
#import "HYLoadHubView.h"
#import "METoast.h"
#import "HYFightCabinRTRulesView.h"
#import "HYGetFlightDetailReq.h"

@interface HYFlightCabinListViewController ()
<
HYFlightListCellDelegate,   //cell点击回调
HYFightCabinRTRulesViewDelegate //退改签界面回调
>
{
    HYGetFlightDetailReq *_getFilghtDetailReq;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYFlightDetailInfo *flightDetail;

@end

@implementation HYFlightCabinListViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_getFilghtDetailReq cancel];
    _getFilghtDetailReq = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"航班仓位选择";
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                           green:237.0f/255.0f
                                            blue:237.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionHeaderHeight = 150;
    [self.view addSubview:tableview];
    
    //机票大致信息
    HYFlightSummaryView *headerView = [[HYFlightSummaryView alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 140)];
    headerView.flightSummary = self.flightSummary;
    headerView.backgroundColor = [UIColor whiteColor];
    tableview.tableHeaderView = headerView;
    
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!self.flightDetail)
    {
        [self getFlightDetailInfo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark private methods
- (void)getFlightDetailInfo
{
    [HYLoadHubView show];
    
    if (_getFilghtDetailReq)
    {
        [_getFilghtDetailReq cancel];
        _getFilghtDetailReq = nil;
    }
    
    _getFilghtDetailReq = [[HYGetFlightDetailReq alloc] init];
    _getFilghtDetailReq.productId = self.flightSummary.productId;
    _getFilghtDetailReq.startCityId = self.flightSummary.startCityId;
    _getFilghtDetailReq.endCityId = self.flightSummary.endCityId;
    _getFilghtDetailReq.flightDate = self.startDate;
    
    NSArray *cabinTyps = [NSArray arrayWithObject:[NSNumber numberWithInt:self.type]];
    if (self.type==Business_Cabin || self.type==First_Cabin)
    {
        cabinTyps = [NSArray arrayWithObjects:@"1", @"2", nil];
    }
    _getFilghtDetailReq.cabinType = cabinTyps;
    
    __weak typeof(self) b_self = self;
    [_getFilghtDetailReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        
        if (!error && [result isKindOfClass:[HYGetFlightDetailResp class]])
        {
            HYGetFlightDetailResp *response = (HYGetFlightDetailResp *)result;
            b_self.flightDetail = response.flightInfo;
            [b_self updateFlightDetailWidthSummary];
            [b_self.tableView reloadData];
        }
        else
        {
            [METoast toastWithMessage:error.domain];
        }
    }];
}

//取航班详情的时候，航班基础信息都没有返回，在这里进行赋值，如果以后后台返回，该方法可以删掉
- (void)updateFlightDetailWidthSummary
{
    self.flightDetail.planeType = self.flightSummary.planeType;
    self.flightDetail.airlineCode = self.flightSummary.airlineCode;
    self.flightDetail.airlineName = self.flightSummary.airlineName;
    self.flightDetail.endCityCode = self.flightSummary.endCityId;
    self.flightDetail.startCityCode = self.flightSummary.startCityId;
    self.flightDetail.endCityName = self.flightSummary.endCityName;
    self.flightDetail.startCityName = self.flightSummary.startCityName;
    self.flightDetail.endAirportName = self.flightSummary.endPortName;
    self.flightDetail.startAirportName = self.flightSummary.startPortName;
    self.flightDetail.startAirportTerminal = self.flightSummary.startTerminal;
    self.flightDetail.endAirportTerminal = self.flightSummary.endTerminal;
    self.flightDetail.stopTimes = self.flightSummary.stopTimes;
    self.flightDetail.carrierCompanyName = self.flightSummary.carrierCompany;
    self.flightDetail.startDatetime = self.flightSummary.startDatetime;
    self.flightDetail.endDatetime = self.flightSummary.endDatetime;
    
}

//防止获取不到价格时候手动刷新价格，需要刷新界面
- (void)updateCabinPriceFinished
{
    [self.tableView reloadData];
}

#pragma mark - hyfightrtview delegate
//退改签信息界面回调界面
//点击购买按钮的时候调用
- (void)rulesViewDidClickBuyWithCabins:(HYFlightSKU *)cabin
{
    //开始购买〜〜
    HYFlightFillOrderViewController *vc = [[HYFlightFillOrderViewController alloc] init];
    vc.flightSummary = self.flightSummary;
    vc.orgCabin = cabin;
    vc.flight = self.flightDetail;
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
    return [self.flightDetail.productSKUArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
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
    static NSString *passengerCellId = @"passengerCellId";
    HYFlightCabinCell *cell = [tableView dequeueReusableCellWithIdentifier:passengerCellId];
    if (cell == nil)
    {
        cell = [[HYFlightCabinCell alloc]initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:passengerCellId];
        cell.backgroundColor = [UIColor whiteColor];
        cell.delegate = self;
    }
    
    if (indexPath.row < [self.flightDetail.productSKUArray count])
    {
        HYFlightSKU *cabin = [self.flightDetail.productSKUArray objectAtIndex:indexPath.row];
        [cell setCabin:cabin];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [self.flightDetail.productSKUArray count])
    {
        HYFlightSKU *sku = [self.flightDetail.productSKUArray objectAtIndex:indexPath.row];
        
        if (sku.stock > 0)
        {
            /****************/
            HYFightCabinRTRulesView *ruleView = [[HYFightCabinRTRulesView alloc] initWithCabinRTRules:sku];
            ruleView.delegate = self;
            [ruleView showWithAnimation:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"该航班仓位不可售！"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

@end
