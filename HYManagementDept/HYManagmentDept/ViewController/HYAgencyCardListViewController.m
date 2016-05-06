//
//  HYAgencyCardListViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-19.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyCardListViewController.h"
#import "HYAgencyCardListRequestParam.h"
#import "HYVIPCardInfo.h"
#import "NSObject+PropertyListing.h"
#import "UIAlertView+Utils.h"

#import "HYRowDataView.h"
#import "HYGridCell.h"
#import "HYSortHeadView.h"
#import "UINavigationItem+Margin.h"

#define AgencyCardListColumnWidth @[@120, @120, @80, @140]

@interface HYAgencyCardListViewController ()
<HYSortHeadViewDelegate,
HYRowDataViewDelegate>
{
    
}
@property (nonatomic, strong) HYSortHeadView *headView;
@property (nonatomic, strong) HYRowDataView *dataView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HYAgencyCardListRequestParam *request;

@end

@implementation HYAgencyCardListViewController

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
    if (self.agencyInfo) {
        self.title = [NSString stringWithFormat:@"%@的会员卡信息", _agencyInfo.name];
    }
    
    UIImage *back = [UIImage imageNamed:@"icon_back.png"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:back forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = backItem;
    [self.navigationItem setLeftBarButtonItemWithMargin:backItem];
    
    //头
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
        _headView.fromField.placeholder = @"请输入会员卡号";
    }
    else
    {
        yoff = 10;
        xoff = 10;
        height = 45;
        _headView = [[HYSortHeadView alloc] initWithFrame:CGRectMake(xoff, yoff, CGRectGetWidth(self.view.frame) - xoff * 2, height)];
        _headView.fromField.placeholder = @"会员卡号";
    }
    
    _headView.fromLabel.text = @"会员卡号";
    _headView.fromField.keyboardType = UIKeyboardTypeNumberPad;
    _headView.fromField.returnKeyType = UIReturnKeySearch;
    _headView.fromField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _headView.delegate = self;
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

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Refresh

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _headView.fromField)
    {
        [textField resignFirstResponder];
        _page = 1;
        [self sendRequest];
    }
    return YES;
}

#pragma mark -
#pragma mark TableView

- (NSArray *)getTableColumnWidth
{
    return AgencyCardListColumnWidth;
}


- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    HYVIPCardInfo *info = (HYVIPCardInfo*)model;
    HYGridRowView *rowView = cell.rowView;
    NSArray *proNames = @[@"number", @"agency_name", @"status", @"active_time"];
    NSArray *values = [info valuesForPropertys:proNames nilMarker:[NSString string]];
    [rowView setContents:values];
    [rowView setNeedsDisplay];
}

- (NSArray *)tableHeaderTexts
{
    return @[@"会员卡号", @"运营中心名称", @"状态", @"激活时间"];
}

#pragma mark - Event

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
    _request = [[HYAgencyCardListRequestParam alloc] init];
    _request.agency_id = self.agencyInfo.m_id;
    _request.page = _page;
    
    NSString *number = _headView.fromField.text;
    if (number.length > 0) {
        _request.number = number;
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
         
         if ([result isKindOfClass:[HYAgencyCardListResponse class]])
         {
             HYAgencyCardListResponse *rs = (HYAgencyCardListResponse *)result;
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
