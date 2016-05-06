//
//  HYGoodsRetMoneyViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-9-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetMoneyViewController.h"

@interface HYGoodsRetMoneyViewController ()

@end

@implementation HYGoodsRetMoneyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return [self progressCell];
    }
    if (indexPath.row == 1) {
        return (UITableViewCell *)[self statCell];
    }
    if (indexPath.row == 2) {
        return [self warningCellWithWarning:[self warning]];
    }
    if (indexPath.row == 3) {
        return (UITableViewCell *)[self serviceTypeCell];
    }
    if (indexPath.row == 4) {
        return [self numCell];
    }
    if (indexPath.row == 5) {
        return (UITableViewCell *)[self detailCell];
    }
    if (indexPath.row == 6) {
        return (UITableViewCell *)[self photoCell];
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

- (NSString *)warning
{
    if (self.refundStatus == HYRefund_Refunded)
    {
        return @"退款已按照原支付方式返还，请注意查收。";
    }
    else
    {
        return @"退款中，我们将在一个工作日内为您退款，请耐心等待。";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
