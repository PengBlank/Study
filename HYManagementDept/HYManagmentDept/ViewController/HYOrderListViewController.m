//
//  HYOrderListViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYOrderListViewController.h"
#import "HYAgencyOrderListRequestParam.h"
#import "HYAgencyIncomeOrderListResponse.h"
#import "HYDataManager.h"
#import "HYOrderInfo.h"
#import "NSObject+PropertyListing.h"
#import "NSDate+Addition.h"
#import "DatePickerViewController.h"
#import "UIAlertView+Utils.h"
#import "HYOrderListHeaderView.h"
#import "HYHeaderDateGetter.h"

#import "HYRowDataView.h"
#import "HYGridCell.h"
#import "HYCategoryView.h"
#include "HYStyleConst.h"

#define OrderListColumnWidthCompany @[@110, @70, @70, @70, @90, @110]
#define OrderListColumnWidthAgency  @[@110, @70, @70, @70, @90, @110, @110]
#define OrderListColumnWidthPromoter @[@110, @70, @70, @70, @90, @100]

#define FromFieldPopTag 1
#define ToFieldPopTag   2

@interface HYOrderListViewController ()
<HYHeaderViewDelegate,
HYHeaderDateDelegate,
HYRowDataViewDelegate,
SingleSelectFormDelegate>
{
    //Datas...
    NSDate *_fromDate;
    NSDate *_toDate;
    
    OrganType _organType;
    
    HYOrderListHeaderView *_headerView;
}

@property (nonatomic, strong) HYHeaderDateGetter *dateGetter;
@property (nonatomic, strong) HYCategoryView *categoryView;
@property (nonatomic, strong) HYRowDataView *dataView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HYAgencyOrderListRequestParam *request;

@end

@implementation HYOrderListViewController

- (void)dealloc
{
    [_request cancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _organType = [HYDataManager sharedManager].userInfo.organType;
        self.dateGetter = [[HYHeaderDateGetter alloc] init];
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"已结算订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titles = @[@"商城", @"机票", @"酒店", @"鲜花", @"团购", @"在线购卡", @"会员续保"];
    _categoryView = [[HYCategoryView alloc] initWithFrame:
                     CGRectMake(0,
                                0,
                                CGRectGetWidth(self.view.frame),
                                40)
                                                   titles:titles];
    _categoryView.form.delegate = self;
    [self.view addSubview:_categoryView];
    
    //头
    _headerView = [[HYOrderListHeaderView alloc] initWithFrame:
                   CGRectMake(0, CGRectGetMaxY(_categoryView.frame), CGRectGetWidth(self.view.bounds), 75)
                   organType:_organType];
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _headerView.delegate = self;
    [self.view addSubview:_headerView];
    
    //[self createTableWithOffset:CGRectGetMaxY(_headerView.frame)];
    
    [self createDataView];
    
    _headerView.fromDateField.delegate = self;
    _headerView.toDateField.delegate = self;
    _headerView.orderSnField.delegate = self;
    _headerView.premoterField.delegate = self;
    self.dateGetter.delegate = self;
    
    self.categoryView.form.selectedIndex = 0;
}

- (void)createDataView
{
    CGFloat yoffset = CGRectGetMaxY(_headerView.frame);
    float tableWidth = CGRectGetWidth(self.view.frame);
    HYRowDataView *dataView = [[HYRowDataView alloc] initWithFrame:CGRectMake(0, yoffset, tableWidth, CGRectGetHeight(self.view.frame) - yoffset)];
    dataView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dataView.delegate = self;
    [self.view addSubview:dataView];
    self.dataView = dataView;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_request cancel];
    [self hideLoadingView];
    [self.dataView endRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)singleSelectForm:(SingleSelectForm *)form didSelectedButton:(UIButton *)button atIndex:(NSInteger)idx
{
    for (UIButton *btn in form.buttons) {
        [btn setBackgroundColor:kCategoryNormalColor];
    }
    [button setBackgroundColor:kCategorySelectColor];
    
    if (idx < OrderTypeCount)
    {
        _orderType = OrderTypeIndex[idx];
        _page = 1;
        [self sendRequest];
    }
}

#pragma mark - table view
- (NSArray *)getTableColumnWidth
{
    switch (_organType) {
        case OrganTypeCompany:
            return OrderListColumnWidthCompany;
            break;
        case OrganTypeAgency:
            return OrderListColumnWidthAgency;
            break;
        case OrganTypePromoter:
            return OrderListColumnWidthPromoter;
            break;
        default:
            return nil;
            break;
    }
}

- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    HYOrderInfo *info = (HYOrderInfo *)model;
    HYGridRowView *rowView = cell.rowView;
    [rowView addContent:info.order_sn];
    [rowView addContent:info.type];
    [rowView addContent:info.order_amount];
    NSString *profit = nil;
    if (_organType == OrganTypeCompany)
    {
        profit = info.company_profit;
    } else if (_organType == OrganTypeAgency) {
        profit = info.agency_profit;
    } else if (_organType == OrganTypePromoter) {
        profit = info.agency_profit;
    }
    [rowView addContent:profit];
    [rowView addContent:info.order_create_time];
    if (_organType == OrganTypePromoter) {
        [rowView addContent:info.number];    //7
    }
    else if (_organType == OrganTypeAgency) {
        [rowView addContent:info.number];
        [rowView addContent:info.promoters_real_name];
    } else if (_organType == OrganTypeCompany){
        [rowView addContent:info.number];
    }
    [rowView setNeedsDisplay];
}

- (NSArray *)tableHeaderTexts
{
    NSArray *ret;
    switch (_organType) {
        case OrganTypeCompany:
            ret = @[@"订单号",
                    @"订单状态",
                    @"订单金额",
                    @"收益",
                    @"下单时间",
                    @"会员卡号"
                    ];
            break;
        case OrganTypeAgency:
            ret = @[@"订单号",
                    @"订单状态",
                    @"订单金额",
                    @"收益",
                    @"下单时间",
                    @"会员卡号",
                    @"操作员"
                    ];
            break;
        case OrganTypePromoter:
            ret = @[@"订单号",
                    @"订单状态",
                    @"订单金额",
                    @"补贴",
                    @"下单时间",
                    @"会员卡号"
                    ];
            break;
        default:
            break;
    }
    return ret;
}

#pragma mark -
#pragma mark Events

- (void)headViewDidClickedAllBtn:(HYBaseHeaderView *)headView
{
    [_headerView clear];
    [self.view endEditing:YES];
    _page = 1;
    _fromDate = nil;
    _toDate = nil;
    [self sendRequest];
}

- (void)headViewDidClickedQueryBtn:(HYBaseHeaderView *)headView
{
    [self.view endEditing:YES];
    _page = 1;
    [self sendRequest];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _headerView.fromDateField)
    {
        [self.view endEditing:YES];
        [self.dateGetter beginGetDateWithField:textField
                              inViewController:self
                                      miniDate:nil];
        return NO;
    }
    if (textField == _headerView.toDateField)
    {
        [self.view endEditing:YES];
        [self.dateGetter beginGetDateWithField:textField
                              inViewController:self
                                      miniDate:_fromDate];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _headerView.orderSnField ||
        textField == _headerView.premoterField)
    {
        [textField resignFirstResponder];
        [self rowDataViewWillBeginRefreshHeader:nil];
    }
    return YES;
}

- (void)dateGetterDidGetDate:(NSDate *)getDate
{
    if (_dateGetter.activeField == _headerView.fromDateField)
    {
        _fromDate = [_dateGetter getMiniDateFromDate:getDate];
        _headerView.fromDateField.text = [_fromDate timeDescription];
    }
    if (_dateGetter.activeField == _headerView.toDateField)
    {
        _toDate = [_dateGetter getPreMiniDateFromDate:getDate];
        _headerView.toDateField.text = [_toDate timeDescription];
    }
}

#pragma mark - 
- (void)rowDataViewWillBeginRefreshHeader:(HYRowDataView *)dataView
{
    _page = 1;
    [self sendRequest];
}

- (void)rowDataViewWillBeginRefreshFooter:(HYRowDataView *)dataView
{
    _page += 1;
    [self sendRequest];
}

#pragma mark -
#pragma mark Internet

- (void)sendRequest
{
    if (_request) {
        [_request cancel];
        _request = nil;
    }
    _request = [[HYAgencyOrderListRequestParam alloc] init];
    _request.type = self.orderType;
    _request.page = _page;
    
    NSString *orderno = _headerView.orderSnField.text;
    if (orderno.length > 0) {
        _request.order_no = orderno;
    }
    
    NSString *promoters = _headerView.premoterField.text;
    if (promoters.length > 0) {
        _request.promoters = promoters;
    }
    
    if (_fromDate) {
        _request.start_time = [_fromDate timeIntervalSince1970String];
    }
    
    if (_toDate) {
        _request.end_time = [_toDate timeIntervalSince1970String];
    }
    
    [self showLoadingView];
    __weak typeof(self) b_self = self;
    if (_page == 1) {
        [self.dataView clear];
    }
    [_request sendReuqest:^(id result, NSError *error)
    {
        [b_self hideLoadingView];
        [b_self.dataView endRefresh];
        
        HYAgencyIncomeOrderListResponse *rs = (HYAgencyIncomeOrderListResponse *)result;
        if (rs)
        {
            if (rs.status == 200)
            {
                [self.dataView add:rs.dataArray];
                [b_self.dataView setTotal:rs.total
                               currentNum:b_self.dataView.dataArray.count];
            }
            else
            {
                [UIAlertView showMessage:rs.rspDesc];
                [b_self.dataView setTotal:0
                               currentNum:0];
            }
        }
        else
        {
            if (self.view.window)
            {
                [UIAlertView showMessage:@"网络请求异常"];
            }
        }
        [b_self.dataView reloadData];
    }];
}

- (void)reloadData
{
    _page = 1;
    [_headerView clear];
    _fromDate = nil;
    _toDate = nil;
    [self.dataView clear];
    [self sendRequest];
}


#pragma mark -

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
