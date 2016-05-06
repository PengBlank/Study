//
//  HYMasterTableViewController.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-5.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYMasterTableViewController.h"
#import "HYSplitViewController.h"
#import "HYMasterTableViewCell.h"
#import "HYMasterTableViewSubCell.h"
#import "HYHelpViewController.h"
#import "HYAppDelegate.h"
#import "HYDataManager.h"

#import "UITableView+Extend.h"

#import "HYPromoterCardMoveViewController.h"

#import "HYMasterTableConfig.h"
#include "HYStyleConst.h"


@interface HYMasterTableViewController () {
    UILabel *_nameLabel;
    
    UIView *_popView;
}

@property (nonatomic, strong) SKSTableView *tableView;

@property (nonatomic, assign) OrganType organType;

@property (nonatomic, strong) HYMasterTableConfig *tableConfig;

@end

@implementation HYMasterTableViewController

- (void)dealloc
{
    DebugNSLog(@"master table view is released");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor greenColor];
    //self.view.backgroundColor = kTableBackColor;
    
    CGFloat infoHeight;
    CGSize touSize;
    CGFloat infoLabelOffset;
    CGFloat versionOffset;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        infoHeight = 90;
        touSize = CGSizeMake(50, 64);
        infoLabelOffset = 25;
    }
    else
    {
        infoHeight = 50;
        touSize = CGSizeMake(25, 32);
        infoLabelOffset = 10;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        versionOffset = 20;
    }
    
    HYUserInfo *userinfo = [HYDataManager sharedManager].userInfo;
    
    self.organType = userinfo.organType;
    self.tableConfig = [HYMasterTableConfig configWithOrganType:_organType];
    
    //table view
    self.tableView = [[SKSTableView alloc] initWithFrame:
                      CGRectMake(0,
                                 0,
                                 CGRectGetWidth(self.view.frame),
                                 CGRectGetHeight(self.view.frame))
                                                   style:UITableViewStylePlain];
    self.tableView.SKSTableViewDelegate = self;
    //DebugNSLog(@"frame %@", NSStringFromCGRect(self.tableView.frame));
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setExtraLinesHidden];
    self.tableView.tableHeaderView = [self tableHeaderView];
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
    //[self tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (UIView *)tableHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 70)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
//    UIView *banner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
//    banner.backgroundColor = [UIColor colorWithRed:0/255.0 green:172/255.0 blue:238/255.0 alpha:1];
//    banner.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [view addSubview:banner];
    
    UIImageView *photo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_tx"]];
    photo.frame = CGRectMake(12, 12, 41, 41);
    [view addSubview:photo];
    
    UILabel *welcome = [[UILabel alloc] initWithFrame:CGRectMake(62, 15, 100, 17)];
    welcome.backgroundColor = [UIColor clearColor];
    welcome.font = [UIFont systemFontOfSize:15.0];
    welcome.textColor = [UIColor whiteColor];
    welcome.text = @"欢迎光临";
    [view addSubview:welcome];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(62, 38, 100, 17)];
    name.backgroundColor = [UIColor clearColor];
    name.font = [UIFont systemFontOfSize:15.0];
//    name.text = [HYDataManager sharedManager].userInfo.user_name;
    NSString *names = [HYDataManager sharedManager].userInfo.user_name;
    name.text = names;
    name.textColor = [UIColor whiteColor];
    [view addSubview:name];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 68, CGRectGetWidth(self.view.frame), 2)];
    line.backgroundColor = [UIColor whiteColor];
    line.alpha = .3;
    [view addSubview:line];
    
    return view;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)logOutBtnClicked:(UIButton *)btn
{
    UIApplication *app = [UIApplication sharedApplication];
    HYAppDelegate *delegate = (HYAppDelegate *)app.delegate;
    [delegate showLogin];
}

#pragma mark -
#pragma mark Rotation support
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_tableConfig masterRowCount];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [_tableConfig subRowCountForRow:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FirstTableViewController";
    
    // Dequeue or create a cell of the appropriate type.
    HYMasterTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HYMasterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
        cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    // Set appropriate labels for the cells.
    NSArray *titles = [_tableConfig masterTitles];
    
    cell.isExpandable = [_tableConfig masterRowIsExpandable:indexPath.row];
    
    cell.icon.image = [_tableConfig iconForRow:indexPath.row];
    
    if (indexPath.row < titles.count)
    {
        cell.contentLabel.text = [titles objectAtIndex:indexPath.row];
    } else
        NSAssert(1, @"首页列表序号问题");
    
    return cell;
}

- (UITableViewCell *)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"subCell";
    HYMasterTableViewSubCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HYMasterTableViewSubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = kTableBackColor;
//        UIImage *select = [UIImage imageNamed:@"master_table_selection_mask.png"];
//        UIImageView *selectV = [[UIImageView alloc] initWithImage:select];
//        [cell setSelectedBackgroundView:selectV];
    }
    
    NSArray *titles = [_tableConfig subRowTitlesForRow:indexPath.row];
    
    if (indexPath.subrow < titles.count+1 && indexPath.subrow > 0)
    {
        cell.contentLabel.text = [titles objectAtIndex:indexPath.subrow-1];
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_tableConfig indexPathIsHelp:indexPath])
    {
        [self showHelpViewWithIndex:indexPath.subrow];
    }
    else
    {
        HYSplitViewController *detailViewManager = self.splitViewController;
        UINavigationController *show = [_tableConfig controllerForRow:indexPath.row subrow:indexPath.subrow];
        if (show) {
            [detailViewManager showDetailViewController:show];
        }
    }
}

#pragma mark - private
- (void)showHelpViewWithIndex:(NSInteger)idx
{
    if (idx > 0 && idx < 5)
    {
        HYHelpViewController *helpV = [[HYHelpViewController alloc] init];
        helpV.type = idx - 1;
        [helpV configure];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:helpV];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (UINavigationController *)summaryNav
{
    return _tableConfig.summaryNav;
}

@end
