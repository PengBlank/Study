//
//  HYNewAccountSecurityViewController.m
//  Teshehui
//
//  Created by Kris on 15/12/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYNewAccountSecurityViewController.h"
#import "HYBaseLineCell.h"
#import "HYModiyPsdViewController.h"
#import "HYResetPswViewController.h"

@interface HYNewAccountSecurityViewController ()
<UITableViewDataSource,
UITableViewDelegate
>
@property(nonatomic, strong)UITableView *tableview;

@end

@implementation HYNewAccountSecurityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"账户安全";
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    //    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithWhite:.91f alpha:1.0f];
    self.view = view;
    
    //tableview
    //    frame.size.height -= 48;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    tableview.contentInset = UIEdgeInsetsZero;
    tableview.rowHeight = 60;
    
    /*
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
    tableview.tableHeaderView = lineView;
     */
    [self.view addSubview:tableview];
    self.tableview = tableview;
}

#pragma mark tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    if (indexPath.row == 0)
    {
        [cell.textLabel setText:@"重置密码"];
        cell.imageView.image = [UIImage imageNamed:@"setting_resetPassword"];
    }
    else
    {
        [cell.textLabel setText:@"修改密码"];
        cell.imageView.image = [UIImage imageNamed:@"setting_modifyPassword"];
    }
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0:
        {
            [MobClick event:kSettingMineAccountSecurityResetPsdClick];
            
            HYResetPswViewController *vc = [[HYResetPswViewController alloc] init];
            vc.title = @"重置密码";
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
            break;
        case 1:
        {
            [MobClick event:kSettingMineAccountSecurityModifyPsdClick];
            
            HYModiyPsdViewController *vc = [[HYModiyPsdViewController alloc] init];
            vc.title = @"修改密码";
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
            break;
        default:
            break;
    }

}
@end
