//
//  HYWalletViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYWalletViewController.h"
#import "HYMineInfoCell.h"
#import "HYAccountBalanceViewController.h"
#import "HYCoinAccoutViewController.h"
#import "HYRedpacketsHomeViewController.h"
#import "HYPointsViewController.h"
#import "StoreBalanceViewController.h"

@interface HYWalletViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HYWalletViewController

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    
    UITableView *table = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:table];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的钱包";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId =  @"walletCellId";
    HYMineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell)
    {
        cell = [[HYMineInfoCell alloc] initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:cellId];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:.4 alpha:1];
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"现金券";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", self.points];
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_points"];
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"账户余额";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f", self.balance];
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_balance"];
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"实体店余额";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f", self.o2obalance];
        cell.imageView.image = [UIImage imageNamed:@"my_wallet_red_envelope"];
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"红包";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.packetNew, self.packetTotal];
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_packets"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
        {
            [MobClick event:kMineWalletCashTicketClick];
            
            HYPointsViewController *vc = [[HYPointsViewController alloc] init];
            vc.points = self.points;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            [MobClick event:kMineWalletBalanceOfAccountClick];
            
            HYAccountBalanceViewController *vc = [[HYAccountBalanceViewController alloc] init];
//            vc.balance = self.balance;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            /// 实体店余额详情入口点
            StoreBalanceViewController *vc = [[StoreBalanceViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            [MobClick event:kMineWalletRedPacketClick];
            
            HYRedpacketsHomeViewController *vc = [[HYRedpacketsHomeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        default:
            break;
    }
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
