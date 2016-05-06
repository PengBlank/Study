//
//  HYEnterpriseMemberListViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYEnterpriseMemberListViewController.h"
#import "HYEnterpriseMemberListRequest.h"
#import "HYEnterpriseMember.h"
#import "NSObject+PropertyListing.h"
#import "HYDataManager.h"
#import "UIAlertView+Utils.h"

#import "HYRowDataView.h"
#import "HYGridCell.h"
#import "HYSortHeadView.h"

#define VIPListColumnWidth @[@130, @130, @130]
#define VIPListColumnWidthAgency @[@140, @140]

@interface HYEnterpriseMemberListViewController ()
<HYSortHeadViewDelegate,
HYRowDataViewDelegate>
{
    OrganType _organType;
}

@property (nonatomic, strong) HYSortHeadView *headView;
@property (nonatomic, strong) HYRowDataView *dataView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HYEnterpriseMemberListRequest *request;
@end

@implementation HYEnterpriseMemberListViewController

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
        _organType = [HYDataManager sharedManager].userInfo.organType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"企业会员列表";
    
    [self createHeadView];
    [self createDataView];
    
    //[self sendArrayRequest:self.request];
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
    _headView.fromField.returnKeyType = UIReturnKeySearch;
    _headView.fromField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _headView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
    if (_organType == OrganTypeCompany) {
        return VIPListColumnWidth;
    } else if (_organType == OrganTypeAgency) {
        return VIPListColumnWidthAgency;
    }
    return nil;
}

- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    HYEnterpriseMember *info = (HYEnterpriseMember *)model;
    HYGridRowView *rowView = cell.rowView;
    NSArray *pros;
    if (_organType == OrganTypeCompany) {
        pros  = @[@"number", @"real_name", @"name"];
    } else if (_organType == OrganTypeAgency) {
        pros  = @[@"number", @"real_name"];
    }
    
    NSArray *vals = [info valuesForPropertys:pros
                                   nilMarker:[NSString string]];
    [rowView setContents:vals];
    [rowView setNeedsDisplay];
}


- (NSArray *)tableHeaderTexts
{
    if (_organType == OrganTypeCompany) {
        return @[@"会员卡号", @"真实姓名", @"所属运营中心"];
    } else if (_organType == OrganTypeAgency) {
        return @[@"会员卡号", @"真实姓名"];
    }
    return nil;
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
    [textField resignFirstResponder];
    if (textField == _headView.fromField)
    {
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
    _request = [[HYEnterpriseMemberListRequest alloc] init];
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
         
         HYEnterpriseMemberListResponse *rs = (HYEnterpriseMemberListResponse *)result;
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
