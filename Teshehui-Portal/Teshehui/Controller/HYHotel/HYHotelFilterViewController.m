//
//  HYHotelFilterViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelFilterViewController.h"
#import "HYConditionSettingViewController.h"
#import "HYKeywordListViewController.h"
#import "HYHotelFilterCell.h"

@interface HYHotelFilterViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HYHotelFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:235.0f/255.0f
                                           green:235.0f/255.0f
                                            blue:235.0f/255.0f
                                           alpha:1.0f];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionHeaderHeight = 0;
    tableview.sectionFooterHeight = 0;
    
    //line
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
    tableview.tableHeaderView = lineView;
    
    [self.view addSubview:tableview];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 320, 80)];
    UIImage *bg = [UIImage imageNamed:@"btn_search_done"];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(80, 20, 160, 45);
    [doneBtn setBackgroundImage:bg
                         forState:UIControlStateNormal];
    [doneBtn addTarget:self
                  action:@selector(searchConditionDone:)
        forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitle:NSLocalizedString(@"done", nil)
               forState:UIControlStateNormal];
    [doneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 36, 0, 0)];
    [footerView addSubview:doneBtn];
    tableview.tableFooterView = footerView;
    [self.view addSubview:tableview];
    
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"filter", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - private 
- (void)searchConditionDone:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(searchConditionDidChange)])
    {
        [self.delegate searchConditionDidChange];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -1){
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    HYHotelFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[HYHotelFilterCell alloc]initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
//    switch (indexPath.row)
//    {
//        case 0: //区域位置
//        {
//            [cell.textLabel setText:NSLocalizedString(@"location", nil)];
//            [cell.detailTextLabel setText:[self.condition getShowStringWithType:Location]];
//        }
//            break;
//        case 1:  //价格星级
//        {
//            [cell.textLabel setText:NSLocalizedString(@"price_star", nil)];
//            [cell.detailTextLabel setText:[self.condition getShowStringWithType:PriceAndStar]];
//        }
//            break;
//        case 2: //距离
//        {
//            [cell.textLabel setText:NSLocalizedString(@"distance", nil)];
//            [cell.detailTextLabel setText:self.condition.distance];
//        }
//            break;
//        case 3: //配套服务
//        {
//            [cell.textLabel setText:NSLocalizedString(@"service", nil)];
//            
//            if ([self.condition.service isEqualToString:@"BroadNet"])
//            {
//                [cell.detailTextLabel setText:@"Wi-Fi"];
//            }
//            else if ([self.condition.service isEqualToString:@"Parking"])
//            {
//                [cell.detailTextLabel setText:@"停车场"];
//            }
//            else
//            {
//                [cell.detailTextLabel setText:self.condition.service];
//            }
//        }
//            break;
//        default:
//            break;
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    switch (indexPath.row)
//    {
//        case 0:  //区域位置
//        {
//            HYConditionSettingViewController *vc = [[HYConditionSettingViewController alloc] init];
//            vc.condition = self.condition;
//            vc.viewType = Location;
//            [self.navigationController pushViewController:vc
//                                                 animated:YES];
//        }
//            break;
//        case 1:  //价格星级
//        {
//            HYConditionSettingViewController *vc = [[HYConditionSettingViewController alloc] init];
//            vc.condition = self.condition;
//            vc.viewType = PriceAndStar;
//            [self.navigationController pushViewController:vc
//                                                 animated:YES];
//        }
//            break;
//        case 2:  //距离
//        {
//            HYKeywordListViewController *vc = [[HYKeywordListViewController alloc] init];
//            vc.condition = self.condition;
//            vc.condType = Distance;
//            [self.navigationController pushViewController:vc
//                                                 animated:YES];
//        }
//            break;
//        case 3:  //配套服务
//        {
//            HYKeywordListViewController *vc = [[HYKeywordListViewController alloc] init];
//            vc.condition = self.condition;
//            vc.condType = Service;
//            [self.navigationController pushViewController:vc
//                                                 animated:YES];
//        }
//            break;
//        default:
//            break;
//    }
}

@end
