//
//  HYIndemnityProgressViewController.m
//  Teshehui
//
//  Created by Fei Wang on 15-3-31.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYIndemnityProgressViewController.h"
#import "HYIndemnityProgresSummaryCell.h"
#import "HYIndemnityProgressCell.h"
#import "HYMallOrderGoodsInfo.h"
#import "HYLoadHubView.h"
#import "HYUserInfo.h"
#import "HYIndemnityDetailViewController.h"
#import "HYCheckIndemnetifyDetailReq.h"
#import "HYMallProductUrlCell.h"
#import "HYMallGuijiupeiDescriptionCell.h"
#import "PhotoBrowserDelegate.h"

@interface HYIndemnityProgressViewController ()<HYIndemnityProgresSummaryCellDelegate>
{
    HYCheckIndemnetifyDetailReq *_checkReq;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYIndemnityinfo *indemnityInfo;

@property (nonatomic, strong) PhotoBrowserDelegate *browserDelegate;

@end

@implementation HYIndemnityProgressViewController

- (void)dealloc
{
    [_checkReq cancel];
    _checkReq = nil;
    
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    [tableview registerClass:[HYMallProductUrlCell class] forCellReuseIdentifier:@"MallProductUrlCell"];
    [tableview registerClass:[HYMallGuijiupeiDescriptionCell class] forCellReuseIdentifier:@"MallGuijiupeiDescriptionCell"];
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查看贵就赔申赔进度";
    
    [self loadProgress];
}

#pragma mark private methods
- (void)loadProgress
{
    [_checkReq cancel];
    _checkReq = nil;
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    
    _checkReq = [[HYCheckIndemnetifyDetailReq alloc] init];
    _checkReq.indemntify_id = self.goodsInfo.guijiupeiId;
    _checkReq.userId = user.userId;
    
    [HYLoadHubView show];
    
    __weak typeof(self) bself = self;
    [_checkReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        
        if (!error)
        {
            HYCheckIndemnetifyDetailResq *resp = (HYCheckIndemnetifyDetailResq *)result;
            bself.indemnityInfo = resp.indemnityInfo;
            [bself.tableView reloadData];
        }
    }];
}

#pragma mark - HYIndemnityProgresSummaryCellDelegate
- (void)checkIndemnityDetail
{
    HYIndemnityDetailViewController *vc = [[HYIndemnityDetailViewController alloc] init];
    vc.indemnityInfo = self.indemnityInfo;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    if (section == 0)
    {
        count = [self.indemnityInfo.progressList count];
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 210;
    if (indexPath.section == 0)
    {
        if (indexPath.row < [self.indemnityInfo.progressList count])
        {
            HYMallGuijiupeiOrderLogItem *progress = [self.indemnityInfo.progressList objectAtIndex:indexPath.row];
            
            CGSize size = [progress.content sizeWithFont:[UIFont systemFontOfSize:14]
                                    constrainedToSize:CGSizeMake(TFScalePoint(280), 200)];
            height = size.height+45;
        }
    }
    if (indexPath.section == 2)
    {
        CGSize size = [self.indemnityInfo.compareURL sizeWithFont:[UIFont systemFontOfSize:14]
                            constrainedToSize:CGSizeMake(TFScalePoint(300), MAXFLOAT)];
        
        height = (size.height+50);
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) //赔付进度
    {
        static NSString *preferentialCellId = @"preferentialCellId";
        HYIndemnityProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:preferentialCellId];
        if (!cell)
        {
            cell = [[HYIndemnityProgressCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                 reuseIdentifier:preferentialCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row < [self.indemnityInfo.progressList count])
        {
            HYMallGuijiupeiOrderLogItem *progress = [self.indemnityInfo.progressList objectAtIndex:indexPath.row];
            [cell setProgress:progress];
        }
        
        [cell setIsFrist:(indexPath.row==0)];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        //问题描述
        static NSString *mallGuijiupeiDescriptionCellID = @"MallGuijiupeiDescriptionCell";
        HYMallGuijiupeiDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:mallGuijiupeiDescriptionCellID forIndexPath:indexPath];
        [cell setDescriptionData:self.indemnityInfo];
        __weak typeof(self) weakSelf = self;
        cell.didClickImage = ^(NSInteger idx)
        {
            [weakSelf didClickImage:idx];
        };
        return cell;
    }
    else
        //商品链接
    {
        static NSString *mallProductUrlCellID = @"MallProductUrlCell";
        HYMallProductUrlCell *cell = [tableView dequeueReusableCellWithIdentifier:mallProductUrlCellID forIndexPath:indexPath];
        [cell setUrlString:self.indemnityInfo.compareURL];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didClickImage:(NSInteger)idx
{
    if (!self.browserDelegate) {
        self.browserDelegate = [[PhotoBrowserDelegate alloc] init];
    }
    self.browserDelegate.photoURLs = self.indemnityInfo.imgs;
    MWPhotoBrowser *browser = [self.browserDelegate createBrowser];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
    [browser setCurrentPhotoIndex:idx];
    [self presentViewController:nav animated:YES completion:nil];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    bgview.backgroundColor = [UIColor colorWithRed:237.0/255.0
//                                             green:237.0/255.0
//                                              blue:237.0/255.0
//                                             alpha:1.0];
//    
//    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 30)];
//    contentView.backgroundColor = [UIColor whiteColor];
//    [bgview addSubview:contentView];
//    
//    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
//    topLine.backgroundColor = [UIColor colorWithWhite:0.82 alpha:1.0];
//    [contentView addSubview:topLine];
//    
//    UILabel *descLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.view.frame.size.width, 20)];
//    descLab.backgroundColor = [UIColor clearColor];
//    descLab.textColor = [UIColor blackColor];
//    
//    if (section == 0)
//    {
//        descLab.text = @"申赔进度";
//    }
//    else if (section == 1)
//    {
//        descLab.text = @"商品信息";
//    }
//    
//    descLab.font = [UIFont systemFontOfSize:14];
//    [contentView addSubview:descLab];
//    
//    UIView *buttomLine = [[UIView alloc] initWithFrame:CGRectMake(14, 29, self.view.frame.size.width-28, 1)];
//    buttomLine.backgroundColor = [UIColor colorWithWhite:0.82 alpha:1.0];
//    [contentView addSubview:buttomLine];
//    
//    return bgview;
//}

@end
