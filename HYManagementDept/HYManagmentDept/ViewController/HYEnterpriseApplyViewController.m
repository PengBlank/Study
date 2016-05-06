//
//  HYEnterpriseApplyViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYEnterpriseApplyViewController.h"
#import "HYEnterpriseMemberApplyListRequest.h"
#import "HYEnterpriseMemberApply.h"
#import "NSObject+PropertyListing.h"
#import "HYEnterpriseApplyActionViewController.h"
#import "HYDataManager.h"
#import "UIAlertView+Utils.h"

#import "HYRowDataView.h"
#import "HYGridCell.h"

#define VIPListColumnWidth @[@110, @90, @70, @90, @100, @100, @100, @70]

@interface HYEnterpriseApplyViewController ()
<HYRowDataViewDelegate>
@property (nonatomic, assign) OrganType organType;

@property (nonatomic, strong) HYRowDataView *dataView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HYEnterpriseMemberApplyListRequest *request;

@end

@implementation HYEnterpriseApplyViewController

- (void)dealloc
{
    DebugNSLog(@"et apply vc is released");
    if (self.presentedViewController)
    {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
    [_request cancel];
    [self hideLoadingView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"企业会员申请列表";
    
    [self createDataView];
    
    //[self sendArrayRequest:self.request];
    
    _organType = [[HYDataManager sharedManager].userInfo organType];
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
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_request cancel];
    [self hideLoadingView];
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
    return VIPListColumnWidth;
}

- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    HYEnterpriseMemberApply *info = (HYEnterpriseMemberApply *)model;
    HYGridRowView *rowView = cell.rowView;
    NSArray *pros = @[@"enterprise_name", @"created",
                      @"total_member", @"status_txt",
                      @"agency_approve_time", @"company_approve_time",
                      @"finance_approve_time"];
    NSArray *vals = [info valuesForPropertys:pros
                                   nilMarker:[NSString string]];
    [rowView setContents:vals];
    
    [rowView addContent:@"审批"];
    rowView.actionColums = @[@(rowView.contents.count - 1)];
    if ([self canApproveApply:info])
    {
        rowView.actionColor = [UIColor colorWithRed:182/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    } else {
        rowView.actionColor = [UIColor grayColor];
    }
    [rowView setNeedsDisplay];
}

- (BOOL)canApproveApply:(HYEnterpriseMemberApply *)apply
{
    if ((_organType == OrganTypeAgency &&
         [apply appStatus] == HYEtAppStart) ||
        (_organType == OrganTypeCompany &&
         [apply appStatus] == HYEtAppCenApproved))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSArray *)tableHeaderTexts
{
    return @[@"所属企业用户", @"申请时间",
             @"申请会员总数", @"状态",
             @"中心审批时间", @"管理公司申批时间",
             @"财务审批时间", @"操作"];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HYEnterpriseMemberApply *info = [self.dataView dataAtIndex:indexPath.row];
    if ([self canApproveApply:info])
    {
        HYEnterpriseApplyActionViewController *action = [[HYEnterpriseApplyActionViewController alloc] init];
        action.memberApply = info;
        action.actionCallback = [self actionCallback];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:action];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void (^)(BOOL success))actionCallback
{
    __weak HYEnterpriseApplyViewController *w_self = self;
    void (^callback)(BOOL success) = ^(BOOL success)
    {
        HYEnterpriseApplyViewController *s_self = w_self;
        if (success)
        {
            s_self.page = 1;
            //[s_self->_tableView reloadData];
            [s_self sendRequest];
        }
    };
    return callback;
}

- (void)reloadDatas
{
    _page = 1;
    [self sendRequest];
}


#pragma mark -

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
#pragma mark -
#pragma mark Data

- (void)sendRequest
{
    if (_request) {
        [_request cancel];
        _request = nil;
        [self hideLoadingView];
    }
    _request = [[HYEnterpriseMemberApplyListRequest alloc] init];
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
         
        HYEnterpriseMemberApplyListResponse *rs = (HYEnterpriseMemberApplyListResponse *)result;
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
