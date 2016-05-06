//
//  HYAgcySumViewController.m
//  HYManagmentDept
//
//  Created by apple on 15/1/12.
//  Copyright (c) 2015年 回亿资本. All rights reserved.
//

#import "HYAgcySumViewController.h"
#import "HYSummaryTableViewCell.h"
#import "HYGridCell.h"
#include "HYStyleConst.h"
#import "UINavigationItem+Margin.h"

@interface HYAgcySumViewController ()
<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HYAgcySumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    //CGFloat x = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 10 : 20;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(self.view.frame)-40, CGRectGetHeight(self.view.frame)-20)
                                                          style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    self.title = [NSString stringWithFormat:@"%@概览", _summary.name];
    
    UIImage *back = [UIImage imageNamed:@"icon_back.png"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:back forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = backItem;
    [self.navigationItem setLeftBarButtonItemWithMargin:backItem];
}

- (void)backItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    HYGridCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //这里需要显示的数据不多，没有用到重用
    if (!cell) {
        //cell = [[HYSummaryTableViewCell alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 44)];
        cell = [[HYGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.rowView.columnWidths = @[@97, @(CGRectGetWidth(tableView.frame) - 97)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    CGFloat fontsize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 14.0 : 16.0;
    cell.rowView.defaultFont = [UIFont systemFontOfSize:fontsize];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [cell.rowView addContent:@"会员卡库存"];
            [cell.rowView addContent:[NSString stringWithFormat:@"%@张", _summary.card_stock]];
        }
        else if (indexPath.row ==1)
        {
            [cell.rowView addContent:@"会员卡总数"];
            [cell.rowView addContent:[NSString stringWithFormat:@"%@张", _summary.card_count]];
        }
    }
    if (indexPath.section ==1)
    {
        if (indexPath.row == 0)
        {
            [cell.rowView addContent:@"本月新增会员"];
            [cell.rowView addContent:[NSString stringWithFormat:@"%ld名", (long)_summary.month_new_member_count]];
        }
        else if (indexPath.row ==1)
        {
            [cell.rowView addContent:@"会员总数"];
            [cell.rowView addContent:[NSString stringWithFormat:@"%ld名", (long)_summary.member_count]];
        }
    }
    if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            [cell.rowView addContent:@"上期收益"];
            [cell.rowView addContent:[NSString stringWithFormat:@"%.2f元", _summary.clearing_agency]];
        }
        else if (indexPath.row ==1)
        {
            [cell.rowView addContent:@"总收益"];
            [cell.rowView addContent:[NSString stringWithFormat:@"%.2f元", _summary.agency_receivable_count]];
        }
    }
    if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            [cell.rowView addContent:@"上期补贴"];
            [cell.rowView addContent:[NSString stringWithFormat:@"%.2f元", _summary.clearing_agency_to_company_profit]];
        }
        else if (indexPath.row ==1)
        {
            [cell.rowView addContent:@"总补贴"];
            [cell.rowView addContent:[NSString stringWithFormat:@"%.2f元", _summary.clearing_agency_to_company_profit_count]];
        }
    }
    
    [cell.rowView setNeedsDisplay];
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
