//
//  HYAgencyIncomeOrderViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-19.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyIncomeOrderViewController.h"
#import "NSObject+PropertyListing.h"
#import "HYAgencyIncomeOrderListRequestParam.h"
#import "HYOrderIncomInfo.h"
#import "SingleSelectForm.h"
#import "HYUserInfo.h"
#import "UIAlertView+Utils.h"

#import "HYRowDataView.h"
#import "HYGridCell.h"
#import "HYCategoryView.h"
#include "HYStyleConst.h"
#include "HYOrderTypes.h"
#import "UINavigationItem+Margin.h"

#define CompanyInComeListWidth @[@130, @90, @90, @90, @80, @100, @100]
#define AgencyInComeListWidth   @[@130,@90, @90, @80, @80, @100,@100 ]
#define PromotersInComeListWidth   @[@130,@90, @90, @80, @80, @100, @90 ,@100 ]


@interface HYAgencyIncomeOrderViewController ()
<
SingleSelectFormDelegate,
HYRowDataViewDelegate
>
{
    SingleSelectForm *_singleForm;
    OrderType _orderType;
    HYCategoryView *_categoryView;
}

@property (nonatomic, strong) HYRowDataView *dataView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HYAgencyIncomeOrderListRequestParam *request;

/**
 *  参数
 */
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
//@property (nonatomic, strong) NSString *group;  //"company", "agency", "promoters"
@property (nonatomic, strong) NSString *company_id;
@property (nonatomic, strong) NSString *agency_id;
@property (nonatomic, strong) NSString *promoter_id;
@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, assign) IncomeType incomeType;

@end

@implementation HYAgencyIncomeOrderViewController

#pragma mark -  Setter
- (void)setCompanyIncomeInfo:(HYCompanyIncomeInfo *)companyIncomeInfo
{
    self.start_time = companyIncomeInfo.start_time;
    self.end_time = companyIncomeInfo.end_time;
    if (companyIncomeInfo.company_id.length > 0)
    {
        self.company_id = companyIncomeInfo.company_id;
    } else {
        self.company_id = companyIncomeInfo.m_id;
    }
    self.incomeType = IncomeTypeCompany;
}

- (void)setAgencyIncomeInfo:(HYAgencyIncomeInfo *)agencyIncomeInfo
{
    self.start_time = agencyIncomeInfo.start_time;
    self.end_time = agencyIncomeInfo.end_time;
    self.agency_id = agencyIncomeInfo.m_id;
    self.incomeType = IncomeTypeAgency;
}

- (void)setPromoterIncome:(HYPromoterEarning *)promoterIncome
{
    self.start_time = promoterIncome.start_time;
    self.end_time = promoterIncome.end_time;
    self.promoter_id = promoterIncome.promoters_id;
    self.user_id = promoterIncome.user_id;
    self.incomeType = IncomeTypePromoter;
}

#pragma mark - View cicle

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
        _orderType = MallOrder;
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"收益详情";
    if (self.incomeType == IncomeTypePromoter)
    {
        self.title = @"补贴详情";
    }
    UIImage *back = [UIImage imageNamed:@"icon_back.png"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:back forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = backItem;
    [self.navigationItem setLeftBarButtonItemWithMargin:backItem];
    
    //[self.view addSubview:_seg];
    
    CGFloat tablex;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        tablex = 20;
    }
    else
    {
        tablex = 10;
    }
    
    NSArray *titles = @[@"商城", @"机票", @"酒店", @"鲜花", @"团购", @"在线购卡", @"会员续保"];
    _categoryView = [[HYCategoryView alloc] initWithFrame:
                     CGRectMake(0,
                                0,
                                CGRectGetWidth(self.view.frame),
                                40)
                                                   titles:titles];
    [self.view addSubview:_categoryView];
    _categoryView.form.delegate = self;
    
    
    //线
    
    [self createDataView];
    
    //[self sendRequest];
    
    _categoryView.form.selectedIndex = 0;
}

- (void)createDataView
{
    CGFloat yoffset =  CGRectGetHeight(_categoryView.frame) + 10;
    float tableWidth = CGRectGetWidth(self.view.frame);
    
    HYRowDataView *dataView = [[HYRowDataView alloc] initWithFrame:CGRectMake(0, yoffset, tableWidth, CGRectGetHeight(self.view.frame) - yoffset)];
    dataView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dataView.delegate = self;
    [self.view addSubview:dataView];
    self.dataView = dataView;
    
    [self.dataView setTableColumnWidth:[self getTableColumnWidth]];
    
    self.dataView.additionInfo = @"说明：当交易过程中出现退款或者退货情况时，该订单收益会显示为“0”。";
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)backItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    [_categoryView layoutSubviews];
//}

#pragma mark - Event

- (void)singleSelectForm:(SingleSelectForm *)form didSelectedButton:(UIButton *)button atIndex:(NSInteger)idx
{
    for (UIButton *btn in form.buttons) {
        [btn setBackgroundColor:kCategoryNormalColor];
    }
    [button setBackgroundColor:kCategorySelectColor];
    
    if (idx < ClearingTypeCount)
    {
        _orderType = ClearingTypeIndex[idx];
        _page = 1;
        [self sendRequest];
    }
}

#pragma mark - Refresh

#pragma mark -
#pragma mark TableView

- (NSArray *)getTableColumnWidth
{
    if (_incomeType == IncomeTypeCompany) {
        return CompanyInComeListWidth;
    } else if (_incomeType == IncomeTypeAgency)
    {
        return AgencyInComeListWidth;
    } else if (_incomeType == IncomeTypePromoter)
    {
        return PromotersInComeListWidth;
    }
    return nil;
}

- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    HYOrderIncomInfo *info = (HYOrderIncomInfo *)model;
    HYGridRowView *rowView = cell.rowView;
    NSArray *pros;
    if (_incomeType == IncomeTypeCompany) {
        pros = @[@"order_sn",
                 @"type",
                 @"remark",
                 @"order_amount",
                 @"company_profit",
                 @"order_create_time",
                 @"number"
                 ];
    } else if (_incomeType == IncomeTypeAgency)
    {
        pros = @[@"order_sn",
                 @"type",
                 @"remark",
                 @"order_amount",
                 @"agency_profit",
                 @"order_create_time",
                 @"number"
                 ];
    }
    else if (_incomeType == IncomeTypePromoter)
    {
        pros = @[@"order_sn",
                 @"type",
                 @"remark",
                 @"order_amount",
                 @"promoters_profit",
                 @"order_create_time",
                 @"agency_name",
                 @"number"
                 ];
    }
    
    NSArray *vals = [info valuesForPropertys:pros
                                   nilMarker:[NSString string]];
    [rowView setContents:vals];
    [rowView setNeedsDisplay];
}

- (NSArray *)tableHeaderTexts
{
    if (_incomeType == IncomeTypeCompany) {
        return @[@"订单号", @"订单状态", @"原因",@"订单金额",  @"收益", @"下单时间", @"会员卡号"];
    } else if (_incomeType == IncomeTypeAgency)
    {
        return @[@"订单号", @"订单状态", @"原因", @"订单金额", @"收益", @"下单时间", @"会员卡号"];
    }else if (_incomeType == IncomeTypePromoter)
    {
        return @[@"订单号", @"订单状态", @"原因", @"订单金额", @"补贴", @"下单时间", @"所属中心", @"会员卡号"];
    }
    return nil;
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
    _request = [[HYAgencyIncomeOrderListRequestParam alloc] init];
    _request.page = _page;
    
    _request.start_time = self.start_time;
    _request.end_time = self.end_time;
    if (_incomeType == IncomeTypeCompany) {
        _request.company_id = self.company_id;
        _request.group = @"company";
    }
    else if (_incomeType == IncomeTypeAgency)
    {
        _request.agency_id = self.agency_id;
        _request.group = @"agency";
    }
    else if (_incomeType == IncomeTypePromoter)
    {
        _request.user_id = self.user_id;
        _request.promoters_id = self.promoter_id;
        _request.group = @"promoters";
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
         
         HYAgencyIncomeOrderListResponse *rs = (HYAgencyIncomeOrderListResponse *)result;
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
                 b_self.dataView.total = 0;
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
