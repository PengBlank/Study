//
//  HYCompanyIncomeViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-15.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYCompanyIncomeViewController.h"
#import "HYCompanyIncomeRequestParam.h"
#import "HYCompanyIncomeInfo.h"
#import "NSDate+Addition.h"
#import "HYAgencyIncomeOrderViewController.h"
#import "UIAlertView+Utils.h"

#import "HYRowDataView.h"
#import "HYGridCell.h"
#import "HYSortHeadView.h"

#define IncomeListWidth @[@130, @110, @70, @110, @70]

@interface HYCompanyIncomeViewController ()
<HYRowDataViewDelegate>
{
    
}

@property (nonatomic, strong) HYRowDataView *dataView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HYCompanyIncomeRequestParam *request;

@end

@implementation HYCompanyIncomeViewController

- (void)dealloc
{
    [_request cancel];
    [self hideLoadingView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createDataView];
    
    [self sendRequest];
}

- (void)createDataView
{
    CGFloat yoffset =  10;
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
    return IncomeListWidth;
}

- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    HYCompanyIncomeInfo *info = (HYCompanyIncomeInfo *)model;
    HYGridRowView *rowView = cell.rowView;
    [rowView addContent:info.company_name];
    [rowView addContent:info.clearing_period];
    [rowView addContent:[NSString stringWithFormat:@"%.2f", info.receivable]];
    [rowView addContent:info.clearing_time];
    [rowView addContent:@"查看订单"];
    rowView.actionColums = @[@4];
    [rowView setNeedsDisplay];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
}

- (NSArray *)tableHeaderTexts
{
    return @[@"运营公司", @"结算周期", @"应收款", @"结算时间", @"操作"];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HYAgencyIncomeOrderViewController *order = [[HYAgencyIncomeOrderViewController alloc] init];
    HYCompanyIncomeInfo *info = [self.dataView dataAtIndex:indexPath.row];
    order.companyIncomeInfo = info;
    
    [self.navigationController pushViewController:order animated:YES];
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
    _request = [[HYCompanyIncomeRequestParam alloc] init];
    _request.page = _page;
    
    [self showLoadingView];
    __weak typeof(self) b_self = self;
    if (_page == 1) {
        [self.dataView clear];
    }
    [_request sendReuqest:^(id result, NSError *error)
     {
         [b_self hideLoadingView];
         [b_self.dataView endRefresh];
         
         HYCompanyIncomeResponse *rs = (HYCompanyIncomeResponse *)result;
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
