//
//  HYPremoterListViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPremoterListViewController.h"
#import "HYPremoterListHeaderView.h"
#import "HYHeaderDateGetter.h"
#import "HYPromotersListRequsetParam.h"
#import "NSDate+Addition.h"
#import "HYPromoters.h"
#import "NSObject+PropertyListing.h"
#import "HYPromoterSelectListRequest.h"
#import "HYPopSelectViewController.h"
#import "UIView+FindView.h"
#import "UIAlertView+Utils.h"

#import "HYRowDataView.h"
#import "HYGridCell.h"
#import "HYStrokeField.h"
#import "HYSelectField.h"

#import "HYPromoterCancelViewController.h"
#import "HYPromoterAddViewController.h"

#define VIPListColumnWidth @[@90, @110, @70, @70, @50, @80, @100, @80]

@interface HYPremoterListViewController ()
<HYHeaderDateDelegate,
HYHeaderViewDelegate,
HYGridRowViewDelegate,
HYCustomModalPresentDelegate,
HYRowDataViewDelegate,
UITextFieldDelegate>
{
    HYPremoterListHeaderView *_headerView;
    NSDate *_fromDate;
    NSDate *_toDate;
}

@property (nonatomic, strong) HYHeaderDateGetter *dateGetter;

@property (nonatomic, strong) HYPromoterSelectListRequest *promSelRequest;
@property (nonatomic, strong) NSArray *promSelList;

@property (nonatomic, strong) HYPromoterCancelViewController *cancelController;

@property (nonatomic, strong) HYRowDataView *dataView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HYPromotersListRequsetParam *request;
@end

@implementation HYPremoterListViewController

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
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"操作员列表";
    
    //头
    _headerView = [[HYPremoterListHeaderView alloc] initWithFrame:
                   CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 75)];
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _headerView.delegate = self;
    [self.view addSubview:_headerView];
    _headerView.fromDateField.delegate = self;
    _headerView.toDateField.delegate = self;
    _headerView.promoterField.delegate = self;
    _headerView.inviCodeField.delegate = self;
    
    [self createDataView];
    
    self.dateGetter = [[HYHeaderDateGetter alloc] init];
    self.dateGetter.delegate = self;
    
    [self sendRequest];
    //[self reloadPromList];
}

- (void)createDataView
{
    CGFloat yoffset = CGRectGetMaxY(_headerView.frame);
    yoffset += 10;
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

- (void)headViewDidClickedQueryBtn:(HYBaseHeaderView *)headView
{
    [self.view endEditing:YES];
    _page = 1;
    [self sendRequest];
}

- (void)headViewDidClickedAllBtn:(HYBaseHeaderView *)headView
{
    [_headerView clear];
    [self.view endEditing:YES];
    
    _page = 1;
    _fromDate = nil;
    _toDate = nil;
    [self sendRequest];
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

#pragma mark - text field
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _headerView.fromDateField)
    {
        [self.view endEditing:YES];
        [self.dateGetter beginGetDateWithField:textField inViewController:self miniDate:nil];
        return NO;
    }
    if (textField == _headerView.toDateField)
    {
        [self.view endEditing:YES];
        [self.dateGetter beginGetDateWithField:textField inViewController:self miniDate:_fromDate];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _headerView.promoterField ||
        textField == _headerView.inviCodeField)
    {
        [textField resignFirstResponder];
        [self headViewDidClickedQueryBtn:nil];
    }
    return YES;
}


#pragma mark -
#pragma mark TableView

- (NSArray *)getTableColumnWidth
{
    return VIPListColumnWidth;
}

- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    HYPromoters *info = (HYPromoters *)model;
    HYGridRowView *rowView = cell.rowView;
    rowView.delegate = self;
    NSArray *pros = @[@"code", @"number",
                      @"real_name", @"nickname"];
    NSArray *vals = [info valuesForPropertys:pros nilMarker:[NSString string]];
    NSMutableArray *mvals = [NSMutableArray arrayWithArray:vals];
    
    NSString *type;
    if (info.promoters_type == 1)
    {
        type = @"员工";
    }
    else if (info.promoters_type == 2)
    {
        type = @"商户";
    }
    else{
        type = @"";
    }
    [mvals addObject:type];
    
    //状态
//    NSString *status = info.status == 1 ? @"有效":@"无效";
//    [mvals addObject:status];
    
    NSString *reviewStatus = nil;
    NSString *action = nil;
    NSString *dateStr = nil;
    
    if (info.audit_status == HYPromoterReject)
    {
        reviewStatus = @"未通过(查看原因)";
        action = @"编辑";
        rowView.actionColums = [NSArray arrayWithObjects:@(5),@(7), nil];
    }
    else if (info.audit_status == HYPromoterAccept)
    {
        reviewStatus = @"审核通过";
        action = @"取消操作员";
        rowView.actionColums = [NSArray arrayWithObjects:@(7), nil];
    }
    else if (info.audit_status == HYPromoterWaitReview)
    {
        reviewStatus = @"待审核";
        action = @"";
        rowView.actionColums = nil;
    }
    
    //时间
    long long time = [info.created longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    dateStr = [date timeDescription];
    
    [mvals addObject:reviewStatus];
    [mvals addObject:dateStr];
    [mvals addObject:action];
    
    [rowView setContents:mvals];
    
    //点击事件
//    rowView.actionColumn = mvals.count-1;
    
    
    [rowView setNeedsDisplay];
}

- (void)gridRowView:(HYGridRowView *)rowView atIndexPath:(NSIndexPath *)path didClickColumn:(NSInteger)column
{
    DebugNSLog(@"click idx %ld", (long)path.row);
    
    if (self.dataView.count > path.row)
    {
        HYPromoters *info = [self.dataView dataAtIndex:path.row];
        
        if (info.audit_status == HYPromoterReject)
        {
            if (column == 7)
            {
                HYPromoterAddViewController *vc = [[HYPromoterAddViewController alloc] init];
                vc.action = HYEditPromoter;
                vc.promotersInfo = info;
                __weak typeof(self) b_self = self;
                vc.editCallback = ^()
                {
                    b_self.page = 1;
                    [b_self sendRequest];
                };
                [self. navigationController pushViewController:vc animated:YES];
            }
            else if (column == 5)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:info.rejection_reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
        else if (info.audit_status == HYPromoterAccept && column == 7)
        {
            HYPromoterCancelViewController *vc = [[HYPromoterCancelViewController alloc] init];
            self.cancelController = vc;
            vc.promoters = info;
            vc.delegate = self;
            [vc show];
        }
    }
}

- (void)customModalDismiss:(BOOL)success
{
    [self.cancelController dismiss];
    self.cancelController = nil;
    if (success) {
        [self sendRequest];
    }
}

- (NSArray *)tableHeaderTexts
{
    return @[@"邀请码", @"操作员卡号",
             @"操作员姓名", @"操作员别名", @"类型",
             @"审核状态",
             @"申请/添加时间", @"操作"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (_cancelController) {
        [_cancelController adjustViewFrame];
    }
}

#pragma mark -
#pragma mark Internet

- (void)sendRequest
{
    if (_request) {
        [_request cancel];
        _request = nil;
        [self hideLoadingView];
    }
    
    _request = [[HYPromotersListRequsetParam alloc] init];
    
    _request.page = _page;
    _request.promoters = _headerView.promoterField.text;
    _request.code = _headerView.inviCodeField.text;
    if (_fromDate) {
        _request.start_time = [_fromDate timeDescription];
    }
    if (_toDate) {
        _request.end_time = [_toDate timeDescription];
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
         
         HYPromotersListResponse *rs = (HYPromotersListResponse *)result;
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
