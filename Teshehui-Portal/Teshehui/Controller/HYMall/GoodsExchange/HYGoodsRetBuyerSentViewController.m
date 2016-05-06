//
//  HYGoodsRetPressInfoViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-9-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetBuyerSentViewController.h"

@interface HYGoodsRetBuyerSentViewController ()

@end

@implementation HYGoodsRetBuyerSentViewController

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
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
        return (UITableViewCell *)[self warningCellWithWarning:[self warning]];
    }
    if (indexPath.row == 3) {
        NSString *expressName = self.returnsInfo.express_company;
        return [self infoCellWithInfo:@{@"退货物流": expressName}];
    }
    if (indexPath.row == 4) {
        NSString *expressCode = self.returnsInfo.invoice_no;
        return [self infoCellWithInfo:@{@"快递单号": expressCode}];
    }
    if (indexPath.row == 5) {
        return (UITableViewCell *)[self serviceTypeCell];
    }
    if (indexPath.row == 6) {
        return [self numCell];
    }
    if (indexPath.row == 7) {
        return (UITableViewCell *)[self detailCell];
    }
    if (indexPath.row == 8) {
        return (UITableViewCell *)[self photoCell];
    }
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

- (NSString *)warning
{
    return @"物品已寄出，请及时关注物流信息，商家收到货物将会退回货款。";
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
