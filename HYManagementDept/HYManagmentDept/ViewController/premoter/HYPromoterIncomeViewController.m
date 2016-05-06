//
//  HYPromoterIncomeViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromoterIncomeViewController.h"
#import "HYPromotersEarningsRequestParam.h"
#import "HYPromoterEarning.h"
#import "NSObject+PropertyListing.h"
#import "HYAgencyIncomeOrderViewController.h"
#import "UIAlertView+Utils.h"

#import "HYRowDataView.h"
#import "HYGridCell.h"

#import "HYDataManager.h"

#define VIPListColumnWidth @[@80, @110, @70, @90, @90]

@interface HYPromoterIncomeViewController ()
<HYRowDataViewDelegate>
@property (nonatomic, strong) HYRowDataView *dataView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HYPromotersEarningsRequestParam *request;

@end

@implementation HYPromoterIncomeViewController


- (void)dealloc
{
    [self hideLoadingView];
    [_request cancel];
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
    if ([HYDataManager sharedManager].userInfo.organType == OrganTypeAgency)
    {
        self.title = @"操作员补贴";
    }
//    else if ([HYDataManager sharedManager].userInfo.organType == OrganTypePromoter)
//    {
//        self.title = @"我的创利";
//    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createDataView];
    
    [self sendRequest];
}

- (void)createDataView
{
    CGFloat yoffset = 10;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark TableView

- (NSArray *)getTableColumnWidth
{
    return VIPListColumnWidth;
}

- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    
    HYPromoterEarning *info = (HYPromoterEarning *)model;
    HYGridRowView *rowView = cell.rowView;
    NSArray *pros = @[@"real_name", @"clearing_period", @"clearing_time"];
    NSArray *vals = [info valuesForPropertys:pros nilMarker:[NSString string]];
    NSMutableArray *mvals = [NSMutableArray arrayWithArray:vals];
    
    NSString *recive = [NSString stringWithFormat:@"%.2f", info.receivable];
    [mvals insertObject:recive atIndex:2];
    
    [mvals addObject:@"查看订单"];
    
    [rowView setContents:mvals];
    rowView.actionColums = @[@(rowView.contents.count - 1)];
    
    [rowView setNeedsDisplay];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
}

- (NSArray *)tableHeaderTexts
{
    return @[@"操作员", @"结算周期",
             @"补贴", @"结算时间",
             @"操作"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HYPromoterEarning *info = [self.dataView dataAtIndex:indexPath.row];
    HYAgencyIncomeOrderViewController *orderV = [[HYAgencyIncomeOrderViewController alloc] init];
    orderV.promoterIncome = info;
    [self.navigationController pushViewController:orderV animated:YES];
}

#pragma mark -
#pragma mark Internet

- (void)sendRequest
{
    if (_request) {
        [_request cancel];
        _request = nil;
    }
    _request = [[HYPromotersEarningsRequestParam alloc] init];
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
         
         HYPromotersEarningsResponse *rs = (HYPromotersEarningsResponse *)result;
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
             if (self.view.window) {
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
