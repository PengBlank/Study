//
//  HYAgencyCenterViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-15.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyCenterViewController.h"
#import "HYAgencyListRequestParam.h"
#import "HYAgencyInfo.h"
#import "NSObject+PropertyListing.h"
#import "HYAgencyCardListViewController.h"
#import "UIAlertView+Utils.h"

#import "HYRowDataView.h"
#import "HYGridCell.h"
#import "HYSortHeadView.h"

#define AgencyListColumnWidth @[@80, @80, @110, @110, @80, @60, @60,@90]

@interface HYAgencyCenterViewController ()
<
HYSortHeadViewDelegate,
HYRowDataViewDelegate
>
{
    
}
@property (nonatomic, strong) HYSortHeadView *headView;
@property (nonatomic, strong) HYRowDataView *dataView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HYAgencyListRequestParam *request;

@end

@implementation HYAgencyCenterViewController

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
    self.title = @"运营中心";
    
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
        height = 45;
        _headView = [[HYSortHeadView alloc] initWithFrame:CGRectMake(xoff, yoff, CGRectGetWidth(self.view.frame) - xoff * 2, height)];
        _headView.fromField.placeholder = @"运营中心名称";
    }
    
    _headView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _headView.delegate = self;
    _headView.fromField.returnKeyType = UIReturnKeySearch;
    _headView.fromField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_headView];
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
    return AgencyListColumnWidth;
}

- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    HYAgencyInfo *info = (HYAgencyInfo *)model;
    HYGridRowView *rowView = cell.rowView;
    NSArray *proNames = @[@"name", @"tel", @"address",
                          @"bank_account", @"bank_name",
                          @"payee", @"type"];
    NSArray *values = [info valuesForPropertys:proNames nilMarker:[NSString string]];
    [rowView setContents:values];
    [rowView addContent:@"查看会员卡"];
    rowView.actionColums = @[@(7)];
    [rowView setNeedsDisplay];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (NSArray *)tableHeaderTexts
{
    return @[@"运营中心名称", @"运营中心电话",
             @"运营中心地址", @"运营中心银行帐号",
             @"银行名称", @"收款人",
             @"类型", @"操作"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HYAgencyInfo *info = [self.dataView.dataArray objectAtIndex:indexPath.row];
    HYAgencyCardListViewController *cardList = [[HYAgencyCardListViewController alloc] init];
    cardList.agencyInfo = info;
    [self.navigationController pushViewController:cardList animated:YES];
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

#pragma mark -
#pragma mark Data
- (void)sendRequest
{
    if (_request) {
        [_request cancel];
        _request = nil;
    }
    _request = [[HYAgencyListRequestParam alloc] init];
    _request.page = _page;
    
    NSString *aName = _headView.fromField.text;
    if (aName.length > 0) {
        _request.agecny_name = aName;
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
         
         if ([result isKindOfClass:[HYAgencyListResponse class]])
         {
             HYAgencyListResponse *rs = (HYAgencyListResponse *)result;
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
