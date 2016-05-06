//
//  HYOutOrderListViewController.m
//  HYManagmentDept
//
//  Created by Ray on 14-12-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYOutOrderListViewController.h"
#import "NSObject+PropertyListing.h"
#import "SingleSelectForm.h"
#import "HYUserInfo.h"
#import "UIAlertView+Utils.h"
#import "HYOutOrderListRequest.h"
#import "HYOutOrder.h"
#import "HYOutOrderListHeaderView.h"
#import "HYHeaderDateGetter.h"
#import "NSDate+Addition.h"
#import "HYCategoryView.h"

#import "HYRowDataView.h"
#import "HYGridCell.h"
#import "HYDataManager.h"
#include "HYStyleConst.h"
#include "HYOrderTypes.h"

#define OutOrderListWidth @[@130, @90, @80, @100, @100]
#define TListWidth @[@130, @90, @80, @100, @100]

struct OutOrderListMetrics {
    CGFloat tablex;
};

typedef struct OutOrderListMetrics OutOrderListMetrics;

@interface HYOutOrderListViewController ()
<
SingleSelectFormDelegate,
HYRowDataViewDelegate,
HYHeaderViewDelegate,
UITextFieldDelegate,
HYHeaderDateDelegate
>
{
    HYCategoryView *_categoryView;
    OrganType _organType;
}

@property (nonatomic, strong) HYRowDataView *dataView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) HYOutOrderListRequest *request;
@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, strong) HYOutOrderListHeaderView *headView;
@property (nonatomic, strong) HYHeaderDateGetter *dateGetter;
@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;

@property (nonatomic, assign) OutOrderListMetrics metrics;
@end

@implementation HYOutOrderListViewController

- (void)dealloc
{
    [_request cancel];
    [self hideLoadingView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _orderType = 1;
        _page = 1;
        _organType = [HYDataManager sharedManager].userInfo.organType;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            _metrics.tablex = 20;
        }
        else
        {
            _metrics.tablex = 10;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titles = @[@"商城", @"机票", @"酒店", @"鲜花", @"团购"];
    _categoryView = [[HYCategoryView alloc] initWithFrame:
                     CGRectMake(0,
                                0,
                                CGRectGetWidth(self.view.frame),
                                40)
                                                   titles:titles];
    _categoryView.form.delegate = self;
    [self.view addSubview:_categoryView];
    
    _headView = [[HYOutOrderListHeaderView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_categoryView.frame), CGRectGetWidth(self.view.frame), 75)];
    _headView.delegate = self;
    _headView.fromDateField.delegate = self;
    _headView.toDateField.delegate = self;
    _headView.orderSnField.delegate = self;
    [self.view addSubview:_headView];
    
    self.dateGetter = [[HYHeaderDateGetter alloc] init];
    _dateGetter.delegate = self;
    
    
    [self createDataView];
    
    //[self sendRequest];
    
    _categoryView.form.selectedIndex = 0;
}

- (void)createDataView
{
    CGFloat yoffset =  CGRectGetMaxY(_headView.frame)+10;
    float tableWidth = CGRectGetWidth(self.view.frame);
    
    HYRowDataView *dataView = [[HYRowDataView alloc] initWithFrame:CGRectMake(0, yoffset, tableWidth, CGRectGetHeight(self.view.frame) - yoffset)];
    dataView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dataView.delegate = self;
    [self.view addSubview:dataView];
    self.dataView = dataView;
    
    [self.dataView setTableColumnWidth:[self getTableColumnWidth]];
}

#pragma mark - Event

- (void)singleSelectForm:(SingleSelectForm *)form didSelectedButton:(UIButton *)button atIndex:(NSInteger)idx
{
    for (UIButton *btn in form.buttons) {
        [btn setBackgroundColor:kCategoryNormalColor];
    }
    [button setBackgroundColor:kCategorySelectColor];
    
    if (idx < OutOrderTypeCount)
    {
        _orderType = OutOrderTypeIndex[idx];
        _page = 1;
        [self sendRequest];
    }
}

- (void)headViewDidClickedAllBtn:(HYBaseHeaderView *)headView
{
    [_headView clear];
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
    if (textField == _headView.fromDateField)
    {
        [self.view endEditing:YES];
        [self.dateGetter beginGetDateWithField:textField
                              inViewController:self
                                      miniDate:nil];
        return NO;
    }
    if (textField == _headView.toDateField)
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
    if (textField == _headView.orderSnField)
    {
        [textField resignFirstResponder];
        [self rowDataViewWillBeginRefreshHeader:nil];
    }
    return YES;
}

- (void)dateGetterDidGetDate:(NSDate *)getDate
{
    if (_dateGetter.activeField == _headView.fromDateField)
    {
        _fromDate = [_dateGetter getMiniDateFromDate:getDate];
        _headView.fromDateField.text = [_fromDate timeDescription];
    }
    if (_dateGetter.activeField == _headView.toDateField)
    {
        _toDate = [_dateGetter getPreMiniDateFromDate:getDate];
        _headView.toDateField.text = [_toDate timeDescription];
    }
}

#pragma mark -
#pragma mark TableView

- (NSArray *)getTableColumnWidth
{
    if (_organType == OrganTypePromoter) {
        return @[@130, @90, @80, @100, @100];
    } else
    {
        return @[@130, @90, @80, @100, @100, @100];
    }
}

- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    HYOutOrder *info = (HYOutOrder *)model;
    HYGridRowView *rowView = cell.rowView;
    NSArray *pros;
    pros = @[@"order_no",
             @"order_status",
             @"order_amount",
             @"created_time",
             @"number"
             ];
    if (_organType != OrganTypePromoter) {
        pros = [pros arrayByAddingObject:@"promoters_name"];
    }
    
    NSArray *vals = [info valuesForPropertys:pros
                                   nilMarker:@""];
    [rowView setContents:vals];
    [rowView setNeedsDisplay];
}

- (NSArray *)tableHeaderTexts
{
    if (_organType == OrganTypePromoter) {
        return @[@"订单号", @"订单状态", @"订单金额", @"下单时间", @"会员卡号"];
    }
    else
    {
        return @[@"订单号", @"订单状态", @"订单金额", @"下单时间", @"会员卡号", @"操作员"];
    }
}

#pragma mark - Refresh
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
#pragma mark Data
- (void)sendRequest
{
    if (_request) {
        [_request cancel];
        _request = nil;
    }
    _request = [[HYOutOrderListRequest alloc] init];
    _request.page = _page;
    
    
    if ((_fromDate && !_toDate) || (!_fromDate && _toDate))
    {
        [UIAlertView showMessage:@"请选择起始时间和结束时间"];
        return;
    }
    
    if (_fromDate) {
        _request.start_time = [_fromDate timeDescription];
    }
    
    if (_toDate) {
        _request.end_time = [_toDate timeDescription];
    }
    
    NSString *order_no = _headView.orderSnField.text;
    if (order_no && order_no.length > 0)
    {
        _request.order_no = order_no;
    }
    
    _request.type = _orderType;
    
    [self showLoadingView];
    __weak typeof(self) b_self = self;
    if (_page == 1) {
        [self.dataView clear];
    }
    [_request sendReuqest:^(id result, NSError *error)
     {
         [b_self hideLoadingView];
         [b_self.dataView endRefresh];
         
         HYOutOrderListResponse *rs = (HYOutOrderListResponse *)result;
         if (rs) {
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
                               currentPage:0
                                   perPage:0];
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

#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
