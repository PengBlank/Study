//
//  HYVIPListViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-15.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYVIPListViewController.h"
#import "HYVIPListRequestParma.h"
#import "NSObject+PropertyListing.h"
#import "HYVIPMemberInfo.h"
#import "HYDataManager.h"
#import "UIAlertView+Utils.h"

#import "HYRowDataView.h"
#import "HYGridCell.h"
#import "HYSortHeadView.h"
#import "HYVipListHeaderView.h"
#import "HYHeaderDateGetter.h"
#import "NSDate+Addition.h"

#define VIPListColumnWidthCompany   @[@110, @90, @90, @90, @120]
#define VIPListColumnWidthPromoter  @[@110, @120, @120]
#define VIPListColumnWidthAgency    @[@110, @90, @90, @90, @120]

@interface HYVIPListViewController ()
<
HYRowDataViewDelegate,
HYHeaderViewDelegate,
HYHeaderDateDelegate,
UITextFieldDelegate>
{
    OrganType _organType;
    NSDate *_fromDate;
    NSDate *_toDate;
}
@property (nonatomic, strong) HYHeaderDateGetter *dateGetter;
@property (nonatomic, strong) HYVipListHeaderView *headerView;
@property (nonatomic, strong) HYRowDataView *dataView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HYVIPListRequestParma *request;
@end

@implementation HYVIPListViewController

- (void)dealloc
{
    [_request cancel];
    [self hideLoadingView];
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"会员列表";
    
    _headerView = [[HYVipListHeaderView alloc] initWithFrame:
                   CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 75)
                                                     organType:_organType];
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _headerView.delegate = self;
    [self.view addSubview:_headerView];
    
    _headerView.fromDateField.delegate = self;
    _headerView.toDateField.delegate = self;
    _headerView.orderSnField.delegate = self;
    _headerView.premoterField.delegate = self;
    self.dateGetter.delegate = self;
    
    [self createDataView];
    
    [self sendRequest];
}

- (void)createDataView
{
    CGFloat yoffset = CGRectGetMaxY(_headerView.frame) + 10;
    float tableWidth = CGRectGetWidth(self.view.frame);
    
    HYRowDataView *dataView = [[HYRowDataView alloc] initWithFrame:CGRectMake(0, yoffset, tableWidth, CGRectGetHeight(self.view.frame) - yoffset)];
    dataView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dataView.delegate = self;
    [self.view addSubview:dataView];
    self.dataView = dataView;
    
    [self.dataView setTableColumnWidth:[self getTableColumnWidth]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark TableView

- (NSArray *)getTableColumnWidth
{
    if (_organType == OrganTypePromoter) {
        return VIPListColumnWidthPromoter;
    } else if (_organType == OrganTypeAgency){
        return VIPListColumnWidthAgency;
    } else if (_organType == OrganTypeCompany) {
        return VIPListColumnWidthCompany;
    }
    return nil;
}

- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    HYVIPMemberInfo *info = (HYVIPMemberInfo *)model;
    HYGridRowView *rowView = cell.rowView;
    if (_organType == OrganTypePromoter) {
        NSArray *pros = @[@"number",
                          @"real_name",
                          @"reg_time"];
        NSArray *vals = [info valuesForPropertys:pros nilMarker:[NSString string]];
        [rowView setContents:vals];
    }
    else if (_organType == OrganTypeAgency)
    {
        NSArray *pros = @[@"number",
                          @"real_name",
                          @"reg_time",
                          @"enterprise_name",
                          @"promoters_name"];
        NSArray *vals = [info valuesForPropertys:pros nilMarker:[NSString string]];
        [rowView setContents:vals];
    }
    else if (_organType == OrganTypeCompany)
    {
        NSArray *pros = @[@"number",
                          @"real_name",
                          @"reg_time",
                          @"enterprise_name",
                          @"name"];
        NSArray *vals = [info valuesForPropertys:pros nilMarker:[NSString string]];
        [rowView setContents:vals];
    }
    [rowView setNeedsDisplay];
}

- (NSArray *)tableHeaderTexts
{
    if (_organType == OrganTypePromoter)
    {
        return @[@"会员卡号", @"真实姓名", @"注册时间"];
    }
    else if (_organType == OrganTypeCompany)
    {
        return @[@"会员卡号", @"真实姓名", @"注册时间",  @"所属企业", @"所属运营中心"];
    }
    else if (_organType == OrganTypeAgency)
    {
        return @[@"会员卡号", @"真实姓名", @"注册时间", @"所属企业", @"操作员"];
    }
    return nil;
}


#pragma mark -

- (void)headViewDidClickedQueryBtn:(HYBaseHeaderView *)headView
{
    [self.view endEditing:YES];
    _page = 1;
    [self sendRequest];
}
- (void)headViewDidClickedAllBtn:(HYVipListHeaderView *)headView
{
    [self.view endEditing:YES];
    
    _page = 1;
    _headerView.fromDateField.text = nil;
    _headerView.toDateField.text = nil;
    _headerView.orderSnField.text = nil;
    _headerView.premoterField.text = nil;
    _fromDate = nil;
    _toDate = nil;
    
    [self sendRequest];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    if (textField == _headerView.fromField)
//    {
//        [self headViewDidClickedQueryBtn:nil];
//    }
    
    return YES;
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
    _request = [[HYVIPListRequestParma alloc] init];
    _request.page = _page;
    
    NSString *orderno = _headerView.orderSnField.text;
    if (orderno.length > 0) {
        _request.number = orderno;
    }
    
    NSString *promoters = _headerView.premoterField.text;
    if (promoters.length > 0) {
        _request.promoters = promoters;
    }
    
    if (_fromDate) {
        _request.fromdate = _fromDate;
    }
    
    if (_toDate) {
        _request.todate = _toDate;
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
         
         HYVIPListResponse *rs = (HYVIPListResponse *)result;
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
