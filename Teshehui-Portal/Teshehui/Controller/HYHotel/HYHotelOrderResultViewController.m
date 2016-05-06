//
//  HYHotelOrderResultViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderResultViewController.h"
#import "HYHotelOrderDetailViewController.h"
#import "HYBaseLineCell.h"
#import "HYUserInfo.h"
#import "Masonry.h"

@interface HYHotelOrderResultViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HYHotelOrderResultViewController

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
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 220)];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    icon.image = [UIImage imageNamed:@"ico_successpage"];
    [headerView addSubview:icon];
    
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectZero];
    desc.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    desc.backgroundColor = [UIColor clearColor];
    [desc setFont:[UIFont systemFontOfSize:18]];
    desc.text = @"您的订单已经成功提交！";
    [headerView addSubview:desc];
    
    UILabel *descDetail = [[UILabel alloc] initWithFrame:CGRectMake(90, 60, CGRectGetWidth(frame)-110, 34)];
    descDetail.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    descDetail.backgroundColor = [UIColor clearColor];
    descDetail.lineBreakMode = NSLineBreakByCharWrapping;
    descDetail.numberOfLines = 0;
    [descDetail setFont:[UIFont systemFontOfSize:12]];
    descDetail.text = @"我们将尽快处理，稍后通知您预订结果。";
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectZero];
    line.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
    [headerView addSubview:line];
    
    [headerView addSubview:descDetail];
    
    tableview.tableHeaderView = headerView;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
    
    //layout
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(38);
    }];
    
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(icon.mas_centerX);
        make.top.equalTo(icon.mas_bottom).offset(30);
        make.width.lessThanOrEqualTo(headerView.mas_width);
    }];
    
    [descDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(desc.mas_centerX);
        make.top.equalTo(desc.mas_bottom).offset(5);
        make.width.lessThanOrEqualTo(headerView.mas_width);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"hotel_order_result", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
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
    static NSString *searchnearID = @"searchnearID";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:searchnearID];
    if (cell == nil)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:searchnearID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"订单编号:%@", self.hotelOrder.orderCode];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"酒店名称:%@", self.hotelInfo.productName];//self.hotelInfo.productName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HYHotelOrderDetailViewController *vc = [[HYHotelOrderDetailViewController alloc] init];
    vc.navbarTheme = self.navbarTheme;
    
    //更新buyerid
    HYUserInfo *user = [HYUserInfo getUserInfo];
    self.hotelOrder.buyerId = user.userId;
    
    vc.hotelOrder = (HYHotelOrderDetail *)self.hotelOrder;  //这个地方实际上这样处理不太好
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

@end
