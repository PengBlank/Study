//
//  HYMyAccountViewController.m
//  Teshehui
//
//  Created by Kris on 15/12/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyAccountViewController.h"
#import "HYMyInformationViewController.h"
#import "HYMineCardViewController.h"
#import "HYEmployeesListViewController.h"
#import "HYMineInfoCell.h"
#import "HYRealnameConfirmViewController.h"
#import "HYGetPersonRequest.h"
#import "HYGetPersonResponse.h"
#import "METoast.h"

@interface HYMyAccountViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
GetUserInfoDelegate
>
{
    HYGetPersonRequest* _getUserInfoReq;
}


@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HYMyAccountViewController

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithWhite:.91f alpha:1.0f];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    tableview.contentInset = UIEdgeInsetsZero;
    tableview.rowHeight = 60;
    
    /*
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          frame.size.width,
                                                                          1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
    tableview.tableHeaderView = lineView;
     */
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的账户";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self updateUserInfo];
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_idAuth boolValue]? 2 : 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //first get total rows in that section by current indexPath.
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1)
    {
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    HYMineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[HYMineInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellIdentifier];
        [cell setHiddenLine:NO];
        [cell setHasNew:NO];
    }
    if (indexPath.row == 0)
    {
        [cell.textLabel setText:@"个人资料"];
        cell.imageView.image = [UIImage imageNamed:@"setting_myAccount"];
        return cell;
    }
    else if (indexPath.row == 1)
    {
        HYUserInfo *userinfo = [HYUserInfo getUserInfo];
        if (userinfo.userType == Enterprise_User)
        {
            [cell.textLabel setText:@"我的员工"];
            cell.imageView.image = [UIImage imageNamed:@"PersonInfo"];
        }
        else
        {
            [cell.textLabel setText:@"我的名片"];
            cell.imageView.image = [UIImage imageNamed:@"setting_myBusinessCard"];
        }
        
        return cell;
    }
    else
    {
        [cell.textLabel setText:@"实名登记"];
        cell.imageView.image = [UIImage imageNamed:@"setting_realName"];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        [MobClick event:kSettingMineAccountMyInfoClick];
        
        HYUserInfo *userinfo = [HYUserInfo getUserInfo];
        NSString *idAuth = userinfo.idAuthentication;
        WS(weakSelf);
        HYMyInformationViewController *vc = [[HYMyInformationViewController alloc]initWithAuthType:idAuth];
        vc.callback = ^(NSString *idAuth){
            _idAuth = idAuth;
            [weakSelf.tableView reloadData];
        };
        vc.userInfo = [HYUserInfo getUserInfo];
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else if (indexPath.row == 1)
    {
        [MobClick event:kSettingMineAccountMyIDCardClick];
        
        HYUserInfo *userinfo = [HYUserInfo getUserInfo];
        if (userinfo.userType == Enterprise_User)
        {
            HYEmployeesListViewController *vc = [[HYEmployeesListViewController alloc] init];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
        else if (userinfo.userType == Normal_User)
        {
            HYMineCardViewController *vc = [[HYMineCardViewController alloc] init];
            vc.title = @"我的名片";
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
    }
    else
    {
        [MobClick event:kSettingMineAccountRealNameClick];
        
        HYRealnameConfirmViewController *vc = [[HYRealnameConfirmViewController alloc] init];
        vc.navbarTheme = self.navbarTheme;
        vc.delegate = self;
        vc.title = @"实名登记";
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

#pragma mark GetUserInfoDelegate
-(void)updateUserInfo
{
    if (!_getUserInfoReq)
    {
        _getUserInfoReq = [[HYGetPersonRequest alloc] init];
    }
    
    _getUserInfoReq.userId = [HYUserInfo getUserInfo].userId;
    
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_getUserInfoReq sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if (result && [result isKindOfClass:[HYGetPersonResponse class]])
         {
             HYGetPersonResponse *response = (HYGetPersonResponse *)result;
             if (response.status == 200)
             {
                 _idAuth =  response.userInfo.idAuthentication;
                 [b_self.tableView reloadData];
             }
             else
             {
                 [METoast toastWithMessage:response.suggestMsg];
             }
         }
     }];
}
/*
HYRealnameConfirmViewController *vc = [[HYRealnameConfirmViewController alloc] init];
vc.navbarTheme = self.navbarTheme;
vc.delegate = self;
vc.title = @"实名登记";
[self.navigationController pushViewController:vc
                                     animated:YES];
 */

#pragma mark overloaded

@end
