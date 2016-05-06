//
//  HYAgcySumListViewController.m
//  HYManagmentDept
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 回亿资本. All rights reserved.
//

#import "HYAgcySumListViewController.h"
#import "HYAgencyCountRequest.h"
#import "HYRowDataView.h"
#import "HYGridCell.h"
#import "HYAgencySummary.h"
#import "HYSortHeadView.h"
#import "NSObject+PropertyListing.h"
#import "UIAlertView+Utils.h"
#import "HYAgcySumViewController.h"
#import "UINavigationItem+Margin.h"

@interface HYAgcySumListViewController ()
<HYRowDataViewDelegate, HYSortHeadViewDelegate>
@property (nonatomic, strong) HYAgencyCountRequest *request;
@property (nonatomic, strong) HYRowDataView *dataView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HYSortHeadView *headView;

@end

@implementation HYAgcySumListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"中心概览";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *back = [UIImage imageNamed:@"icon_back.png"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:back forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = backItem;
    [self.navigationItem setLeftBarButtonItemWithMargin:backItem];
    
    [self createHeadView];
    
    [self createDataView];
    
    [self sendRequest];
}

- (void)createHeadView
{
    CGFloat yoff;
    CGFloat xoff;
    CGFloat height;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        yoff = 20;
        xoff = 20;
        height = 55;
        _headView = [[HYSortHeadView alloc] initWithFrame:CGRectMake(xoff, yoff, CGRectGetWidth(self.view.frame) - xoff * 2, height)];
        _headView.fromLabel.text = @"运营中心名称";
        _headView.fromField.placeholder = @"请输入中心名称";
    }
    else
    {
        yoff = 10;
        xoff = 10;
        height = 35;
        _headView = [[HYSortHeadView alloc] initWithFrame:CGRectMake(xoff, yoff, CGRectGetWidth(self.view.frame) - xoff * 2, height)];
        _headView.fromField.placeholder = @"运营中心名称";
    }
    
    _headView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _headView.delegate = self;
    _headView.fromField.returnKeyType = UIReturnKeySearch;
    _headView.fromField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_headView];
}

- (void)backItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createDataView
{
    CGFloat yoffset = CGRectGetMaxY(_headView.frame) + 10;
    float tableWidth = CGRectGetWidth(self.view.frame);
    HYRowDataView *dataView = [[HYRowDataView alloc] initWithFrame:CGRectMake(0, yoffset, tableWidth, CGRectGetHeight(self.view.frame) - yoffset)];
    dataView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dataView.delegate = self;
    [self.view addSubview:dataView];
    self.dataView = dataView;
    [self.dataView reloadData];
}

- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    HYAgencySummary *summary = (HYAgencySummary *)model;
    HYGridRowView *rowview = cell.rowView;
    NSArray *pros = @[@"name", @"card_stock", @"card_count", @"month_new_member_count", @"member_count"];
    NSArray *values = [summary valuesForPropertys:pros nilMarker:[NSString string]];
    values = [values arrayByAddingObject:[NSString stringWithFormat:@"%.2f", summary.clearing_agency]];
    values = [values arrayByAddingObject:[NSString stringWithFormat:@"%.2f", summary.agency_receivable_count]];
    values = [values arrayByAddingObject:[NSString stringWithFormat:@"%.2f", summary.clearing_agency_to_company_profit]];
    values = [values arrayByAddingObject:[NSString stringWithFormat:@"%.2f", summary.clearing_agency_to_company_profit_count]];
    [rowview setContents:values];
    rowview.actionColums = @[@0];
    [rowview setNeedsDisplay];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
}
- (NSArray *)tableHeaderTexts
{
    return @[@"运营中心名称", @"会员卡库存",
             @"会员卡总数", @"本月新增会员",
             @"会员总数", @"上期收益", @"总收益", @"上期补贴", @"总补贴"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HYAgcySumViewController *agcy = [[HYAgcySumViewController alloc] init];
    HYAgencySummary *summary = [self.dataView dataAtIndex:indexPath.row];
    agcy.summary = summary;
    [self.navigationController pushViewController:agcy animated:YES];
    //[self.navigationController presentViewController:agcy animated:YES completion:nil];
}

- (NSArray *)getTableColumnWidth
{
    return @[@110, @70, @70, @70, @90, @110, @80, @100, @100];
}

#pragma mark -

- (void)headViewDidClickedAllBtn:(HYSortHeadView *)headView
{
    [self.view endEditing:YES];
    _headView.fromField.text = nil;
    _page = 1;
    [self sendRequest];
}

- (void)headViewDidClickedQueryBtn:(HYSortHeadView *)headView
{
    [self.view endEditing:YES];
    _page = 1;
    [self sendRequest];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _headView.fromField)
    {
        [textField resignFirstResponder];
        [self headViewDidClickedQueryBtn:nil];
    }
    return YES;
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

- (void)sendRequest
{
    if (_request) {
        [_request cancel];
    }
    self.request = [[HYAgencyCountRequest alloc] init];
    
    NSString *aName = _headView.fromField.text;
    if (aName.length > 0) {
        _request.agency_name = aName;
    }
    
    [self showLoadingView];
    __weak typeof(self) b_self = self;
    if (_page == 1) {
        [self.dataView clear];
    }
    [_request sendReuqest:^(id result, NSError *error)
    {
        [self hideLoadingView];
        [b_self.dataView endRefresh];
        
        if ([result isKindOfClass:[HYAgencyCountResponse class]])
        {
            HYAgencyCountResponse *rs = (HYAgencyCountResponse *)result;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
