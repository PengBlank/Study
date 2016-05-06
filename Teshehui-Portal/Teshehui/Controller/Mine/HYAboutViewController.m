//
//  HYAboutViewController.m
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAboutViewController.h"
#import "HYIntroductionViewController.h"
#import "HYCopyrightNoticeViewController.h"
#import "HYAttentionMeViewController.h"
#import "HYHelpViewController.h"
#import "HYNavigationController.h"
#import "HYBaseLineCell.h"
#import "HYMessageViewController.h"


@interface HYAboutViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation HYAboutViewController

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"关于特奢汇";
    
    UIImageView* ImageVC = [[UIImageView alloc]initWithFrame:TFRectMake(125,55, 60, 60)];
    ImageVC.image = [UIImage imageNamed:@"app_logo"];
    [self.view addSubview:ImageVC];
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
    
    UILabel* nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                TFScalePoint(130),
                                                                self.view.frame.size.width,
                                                                16)];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.text = @"特奢汇客户端iOS版";
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:15.0f];
    nameLab.textColor = [UIColor darkGrayColor];
    [self.view addSubview:nameLab];
    
    UILabel* versionLab = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                   TFScalePoint(150),
                                                                   self.view.frame.size.width,
                                                                   16)];
    versionLab.backgroundColor = [UIColor clearColor];
    versionLab.text = [NSString stringWithFormat:@"版本号%@",versionNum];
    versionLab.textAlignment = NSTextAlignmentCenter;
    versionLab.font = [UIFont systemFontOfSize:15.0f];
    versionLab.textColor = [UIColor darkGrayColor];
    [self.view addSubview:versionLab];
    
    UIImageView* speImg = [[UIImageView alloc]init];
    speImg.frame = CGRectMake(0, TFScalePoint(199), self.view.frame.size.width, 0.5);
    [self.view addSubview:speImg];

    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, TFScalePoint(199)+1, self.view.frame.size.width, 200)
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    speImg.backgroundColor = tableview.separatorColor;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.scrollEnabled = NO;
    speImg.backgroundColor = tableview.separatorColor;
    
    if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self setExtraCellLineHidden:tableview];
    [self.view addSubview:tableview];

}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    HYBaseLineCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"cell"];
        cell.textLabel.font =  [UIFont systemFontOfSize:18.0f];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"公司介绍";
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"官方公告";
            break;
        }
            
        case 2:
        {
            cell.textLabel.text = @"版权声明";
            break;
        }
            
        case 3:
        {
            cell.textLabel.text = @"关注我们";
            break;
        }
        default:
            break;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            HYIntroductionViewController *vc = [[HYIntroductionViewController alloc] init];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
            break;
        }
        case 1:
        {
            HYMessageViewController* vc = [[HYMessageViewController alloc]init];
            vc.title = @"官方公告";
//            [self.baseViewController setTabbarShow:NO];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 2:
        {
            HYCopyrightNoticeViewController *vc = [[HYCopyrightNoticeViewController alloc] init];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
            break;
        }
        case 3:
        {
            HYAttentionMeViewController *vc = [[HYAttentionMeViewController alloc] init];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
            break;
        }
        default:
            break;
    }

}
@end
