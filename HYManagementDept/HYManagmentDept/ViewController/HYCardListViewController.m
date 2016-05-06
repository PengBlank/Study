//
//  HYCardListViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-15.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYCardListViewController.h"
#import "HYVIPCardListRequestParam.h"
#import "HYVIPCardInfo.h"
#import "NSObject+PropertyListing.h"
#import "NSDate+Addition.h"
#import "HYCardListHeaderView.h"
#import "HYDataManager.h"
#import "HYPopSelectViewController.h"
#import "HYHeaderDateGetter.h"
#import "UIAlertView+Utils.h"

#import "HYRowDataView.h"
#import "HYGridCell.h"

#define CardListColumnWidthCompany  @[@120, @110, @80, @110, @110]
#define CardListColumnWidthAgency @[@120, @80, @100, @80, @110]
#define CardListColumnWidthPromoter @[@130, @130, @130]

#define FromFieldPopTag 101
#define ToFieldPopTag   202

@interface HYCardListViewController ()
<UITextFieldDelegate,
HYHeaderDateDelegate,
HYHeaderViewDelegate,
HYPopSelectViewDelegate,
HYRowDataViewDelegate>
{
    UIPopoverController *_popController;
    NSDate *_fromDate;
    NSDate *_toDate;
    OrganType _organType;
    NSInteger _isActive;    //0全部，1未激活，2已活
}

@property (nonatomic, strong) HYCardListHeaderView *headerView;

@property (nonatomic, strong) HYHeaderDateGetter *dateGetter;

@property (nonatomic, strong) HYRowDataView *dataView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HYVIPCardListRequestParam *request;

@end

@implementation HYCardListViewController

- (void)dealloc
{
    [_request cancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _organType = [HYDataManager sharedManager].userInfo.organType;
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"会员卡列表";
    
    //头
    _headerView = [[HYCardListHeaderView alloc] initWithFrame:
                   CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 75)
                                                    organType:_organType];
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _headerView.delegate = self;
    [self.view addSubview:_headerView];
    
    _headerView.fromDateField.delegate = self;
    _headerView.toDateField.delegate = self;
    _headerView.cardNumField.delegate = self;
    _headerView.premoterField.delegate = self;
    [_headerView.statBtn addTarget:self
                            action:@selector(statBtnAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self createDataView];
    
    self.dateGetter = [[HYHeaderDateGetter alloc] init];
    _dateGetter.delegate = self;
    
    [self sendRequest];
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
    
    NSArray *columnWidth = [self getTableColumnWidth];
    [self.dataView setTableColumnWidth:columnWidth];
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

#pragma mark - Select state
- (void)statBtnAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    HYPopSelectViewController *select = [[HYPopSelectViewController alloc] init];
    select.title = @"选择激活状态";
    select.dataArray = @[@"全部", @"未激活", @"已激活"];
    select.associatedControl = btn;
    select.delegate = self;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _popController = [[UIPopoverController alloc] initWithContentViewController:select];
        [_popController presentPopoverFromRect:btn.frame inView:btn.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }
    else
    {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:select];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)popSelectView:(HYPopSelectViewController *)select didSelectIndex:(NSInteger)selectIdx andGetString:(NSString *)getString
{
    [_popController dismissPopoverAnimated:YES];
    _isActive = selectIdx;
    NSArray *titles = @[@"全部", @"未激活", @"已激活"];
    NSString *title = [titles objectAtIndex:selectIdx];
    [_headerView.statBtn setTitle:title forState:UIControlStateNormal];
    [_headerView.statBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark - TextFieldDelegate
#pragma mark - 时间选择
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSDate *fromdate = _headerView.fromDateField == textField ? nil : _fromDate;
    if (textField == _headerView.fromDateField ||
        textField == _headerView.toDateField)
    {
        [self.view endEditing:YES];
        [self.dateGetter beginGetDateWithField:textField
                              inViewController:self
                                      miniDate:fromdate];
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

#pragma mark - 
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _headerView.cardNumField ||
        textField == _headerView.premoterField)
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
    switch (_organType) {
        case OrganTypeCompany:
            return CardListColumnWidthCompany;
            break;
        case OrganTypeAgency:
            return CardListColumnWidthAgency;
        case OrganTypePromoter:
            return CardListColumnWidthPromoter;
        default:
            return nil;
            break;
    }
}

- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    HYVIPCardInfo *info = (HYVIPCardInfo *)model;
    HYGridRowView *rowView = cell.rowView;
    NSArray *pros = nil;
    switch (_organType) {
        case OrganTypeCompany:
            pros = @[@"number", @"enterprise_name", @"status", @"active_time", @"agency_name"];
            break;
        case OrganTypeAgency:
            pros = @[@"number", @"promoters_name", @"enterprise_name",@"status", @"active_time"];
            break;
        case OrganTypePromoter:
            pros = @[@"number", @"status", @"active_time"];
            break;
        default:
            break;
    }
    NSArray *vals = [info valuesForPropertys:pros
                                   nilMarker:[NSString string]];
    [rowView setContents:vals];
    [rowView setNeedsDisplay];
}

- (NSArray *)tableHeaderTexts
{
    switch (_organType) {
        case OrganTypeCompany:
            return @[@"会员卡号", @"所属企业", @"状态", @"激活时间", @"营运中心"];
            break;
        case OrganTypeAgency:
            return @[@"会员卡号", @"操作员", @"所属企业", @"状态", @"激活时间"];
            break;
        case OrganTypePromoter:
            return @[@"会员卡号", @"状态", @"激活时间"];
            break;
        default:
            return nil;
            break;
    }
}


#pragma mark -

- (void)headViewDidClickedQueryBtn:(HYCardListHeaderView *)headView
{
    [self.view endEditing:YES];
    _page = 1;
    [self sendRequest];
}

- (void)headViewDidClickedAllBtn:(HYCardListHeaderView *)headView
{
    [self.view endEditing:YES];
    [_headerView clear];
    _page = 1;
    _isActive = 0;
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

#pragma mark -
#pragma mark Request

- (void)sendRequest
{
    if (_request) {
        [_request cancel];
        _request = nil;
    }
    _request = [[HYVIPCardListRequestParam alloc] init];
    _request.page = _page;
    
    NSString *cardNum = _headerView.cardNumField.text;
    if (cardNum.length > 0) {
        _request.number = cardNum;
    }
    
    if (_organType == OrganTypeAgency )
    {
        NSString *promoters = _headerView.premoterField.text;
        if (promoters.length > 0) {
            _request.promoters = promoters;
        }
    }
    
    if (_fromDate) {
        _request.start_time = [_fromDate timeDescription];
    }
    if (_toDate) {
        _request.end_time = [_toDate timeDescription];
    }
    
    _request.status = _isActive;
    
    [self showLoadingView];
    __weak typeof(self) b_self = self;
    if (_page == 1) {
        [self.dataView clear];
    }
    [_request sendReuqest:^(id result, NSError *error)
     {
         [b_self hideLoadingView];
         [b_self.dataView endRefresh];
         
         HYVIPCardListRespnse *rs = (HYVIPCardListRespnse *)result;
         if (rs)
         {
             if (rs.status == 200)
             {
                 [self.dataView add:rs.dataArray];
                 [b_self.dataView setTotal:rs.total
                                currentNum:b_self.dataView.dataArray.count];             }
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
