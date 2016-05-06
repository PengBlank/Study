//
//  HYGoodsRetExchangeViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-9-28.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetExchangeViewController.h"
#import "HYMallOrderDetailViewController.h"
#import "METoast.h"

@interface HYGoodsRetExchangeViewController ()

@end

@implementation HYGoodsRetExchangeViewController

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
    
    CGRect frame = self.tableView.frame;
    frame.size.height -= 44;
    self.tableView.frame = frame;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-44, CGRectGetWidth(self.view.bounds), 44)];
    [self.view addSubview:footer];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:footer.bounds];
    bg.image = [UIImage imageNamed:@"g_ret_foot_bg.png"];
    [footer addSubview:bg];
    
    UIImage *apply = [UIImage imageNamed:@"g_ret_apply.png"];
    CGFloat x = CGRectGetMidX(footer.bounds) - apply.size.width/2;
    CGFloat y = CGRectGetMidY(footer.bounds) - apply.size.height/2;
    UIButton *applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, apply.size.width, apply.size.height)];
    [applyBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [applyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [applyBtn setBackgroundImage:apply forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applyAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:applyBtn];
    
    [self.view addSubview:footer];
}

- (void)applyAction:(UIButton *)btn
{
    if (self.returnsInfo.exchange_order_id.length > 0)
    {
        HYMallOrderDetailViewController *detail = [[HYMallOrderDetailViewController alloc]init];
        HYMallChildOrder *order = [[HYMallChildOrder alloc] init];
        order.orderId = self.returnsInfo.exchange_order_id;
        detail.orderInfo = order;
        [self.navigationController pushViewController:detail animated:YES];
    }
//    if (self.returnsInfo.orderItem.count > 0)
//    {
//        
//        HYMallOrderItem *goods = [self.returnsInfo.orderItem lastObject];
//        if (goods.related_id.length > 0)
//        {
//            HYMallOrderDetail *newOrder = [[HYMallOrderDetail alloc] init];
//            newOrder.order_id = goods.related_id;
//            HYMallOrderDetailViewController *detail = [[HYMallOrderDetailViewController alloc]init];
//            detail.orderInfo = newOrder;
//            [self.navigationController pushViewController:detail animated:YES];
//        }
//        else
//        {
//            [METoast toastWithMessage:@"未找到相关订单，请到订单列表查看"];
//        }
//    }
    else
    {
        [METoast toastWithMessage:@"未找到相关订单，请到订单列表查看"];
    }
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
    if (self.refundStatus == HYRefund_BuyerRecieved)  //换货买家已经收到货表示已经换货完成
    {
        return @"您的换货服务已完成，详情请至订单中心查看。";
    }
    
    return @"卖家正在帮您换货，详情请至订单中心查看。";
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
