//
//  HYSummaryDetailViewController.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-5.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSummaryDetailViewController.h"
#import "HYHomeSummaryRequestParam.h"
#import "HYSummaryTableViewCell.h"
#import "UITableView+Extend.h"
#import "HYDataManager.h"
#import "UIAlertView+Utils.h"
#import "HYSplitViewController.h"
#import "HYAgcySumListViewController.h"
#import "HYGridCell.h"
#include "HYStyleConst.h"

@interface HYSummaryDetailViewController ()

@property (nonatomic, strong) HYHomeSummaryRepsonse *summaryData;
@property (nonatomic, strong) HYHomeSummaryRequestParam *request;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) OrganType organType;

@end

@implementation HYSummaryDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self sendRequest];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_request cancel];
    _request = nil;
    [self hideLoadingView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //BOOL ispad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    HYUserInfo *userInfo = [HYDataManager sharedManager].userInfo;
    self.title = [NSString stringWithFormat:@"概览"];
    
    [self createTable];
    
    _organType = userInfo.organType;
}

- (void)createTable
{
    CGFloat x = 20;
    CGFloat w = CGRectGetWidth(self.view.frame) - 2 * x;
    CGFloat h = CGRectGetHeight(self.view.frame);
    CGRect frame = CGRectMake(x, 0, w, h);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setExtraLinesHidden];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_organType == OrganTypeCompany && section == 3)
    {
        return 1;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger n = 4;
//    if (_organType == OrganTypePromoter) {
//        n += 1;
//    }
//    if (_organType == OrganTypeCompany) {
//        n = n + 1;
//    }
    if (_organType == OrganTypeAgency)
    {
        return 3;
    }
    return n;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    BOOL isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    return isPad ? 20 : 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *clear = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 20)];
    clear.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(clear.frame)-5, CGRectGetWidth(clear.frame), 5)];
    line.backgroundColor = kGridFrameColor;
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [clear addSubview:line];
    return clear;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    HYGridCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //这里需要显示的数据不多，没有用到重用
    if (!cell)
    {
        //cell = [[HYSummaryTableViewCell alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 44)];
        cell = [[HYGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.rowView.columnWidths = @[@110, @(CGRectGetWidth(tableView.frame) - 97)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    CGFloat fontsize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 14.0 : 16.0;
    cell.rowView.defaultFont = [UIFont systemFontOfSize:fontsize];
    
    HYHomeSummaryRepsonse *summary = self.summaryData;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0)
            {
                [cell.rowView addContent:@"会员卡库存"];
                [cell.rowView addContent:[NSString stringWithFormat:@"%lu张", (unsigned long)summary.card_stock]];
            }
            else if (indexPath.row == 1)
            {
                [cell.rowView addContent:@"会员卡总数"];
                [cell.rowView addContent:summary.cardCountDisplay];
            }
            break;
        }
        case 1:
        {
            if (indexPath.row == 0)
            {
                [cell.rowView addContent:@"本月新增会员"];
                [cell.rowView addContent:summary.monthMemDisplay];
            }
            else if (indexPath.row == 1)
            {
                [cell.rowView addContent:@"会员总数"];
                [cell.rowView addContent:summary.memCountDisplay];
            }
            break;
        }
        case 2:
        {
            if (indexPath.row == 0)
            {
                if ([HYDataManager sharedManager].userInfo.organType == OrganTypePromoter)
                {
                    [cell.rowView addContent:@"上期补贴"];
                }
                else
                {
                    [cell.rowView addContent:@"上期收益"];
                }
                [cell.rowView addContent:summary.lastEarningDisplay];
            }
            else if (indexPath.row == 1)
            {
                if ([HYDataManager sharedManager].userInfo.organType == OrganTypePromoter)
                {
                    [cell.rowView addContent:@"补贴总额"];
                }
                else
                {
                    [cell.rowView addContent:@"总收益"];
                }
                [cell.rowView addContent:summary.totalEarningDisplay];
            }
            break;
        }
        case 3:
        {
            if (_organType == OrganTypeCompany)
            {
                if (indexPath.row == 0)
                {
                    [cell.rowView addContent:@"中心数"];
                    [cell.rowView addContent:[NSString stringWithFormat:@"%@(点击查看详情)", summary.agencyCountDisplay]];
                }
            }
            else if (_organType == OrganTypeAgency)
            {
                if (indexPath.row == 0)
                {
                    [cell.rowView addContent:@"上期补贴"];
                    [cell.rowView addContent:[NSString stringWithFormat:@"%.2f", summary.clearing_agency_to_company_profit]];
                }
                else if (indexPath.row == 1)
                {
                    [cell.rowView addContent:@"总补贴"];
                    [cell.rowView addContent:[NSString stringWithFormat:@"%.2f", summary.clearing_agency_to_company_profit_count]];
                }
            }
            else
            {
                if (indexPath.row == 0)
                {
                    [cell.rowView addContent:@"所属中心"];
                    [cell.rowView addContent:summary.agencyNameDisplay];
                }
                else if (indexPath.row == 1)
                {
                    [cell.rowView addContent:@"邀请码"];
                    [cell.rowView addContent:summary.codeDisplay];
                }
            }
            break;
        }
        default:
            break;
    }
    [cell.rowView setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && _organType == OrganTypeCompany)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        });
        HYAgcySumListViewController *sumList = [[HYAgcySumListViewController alloc] init];
        [self.navigationController pushViewController:sumList animated:YES];
    }
}

#pragma mark private methods
- (void)sendRequest
{
    if (_request) {
        [_request cancel];
        _request = nil;
    }
    __weak HYSummaryDetailViewController * _self = self;
    _request = [[HYHomeSummaryRequestParam alloc] init];
    [self showLoadingView];
    [_request sendReuqest:^(id result, NSError *error)
    {
        [_self hideLoadingView];
        if ([result isKindOfClass:[HYHomeSummaryRepsonse class]])
        {
            HYHomeSummaryRepsonse *rs = (HYHomeSummaryRepsonse *)result;
            if (rs.status == 200)
            {
                _self.summaryData = rs;
                [_self.tableView reloadData];
                if (rs.name && rs.name.length > 0)
                {
                    _self.title = [NSString stringWithFormat:@"%@ 概览", rs.name];
                }
                
                
                //获得邀请码后，将邀请码赋给...
                if (rs.code)
                {
                    HYSplitViewController *split = (HYSplitViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
                    split.inviteCode = rs.code;
                    [HYDataManager sharedManager].inviteCode = rs.code;
                }
            }
            else
            {
                [UIAlertView showMessage:rs.rspDesc];
            }
        }
        else
        {
            if (self.view.window)
            {
                [UIAlertView showMessage:@"网络请求异常"];
            }
        }
    }];
}

@end
