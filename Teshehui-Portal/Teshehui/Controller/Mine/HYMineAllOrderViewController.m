//
//  HYMineAllOrderViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMineAllOrderViewController.h"
#import "HYImageButton.h"
#import "HYOrderSelectView.h"
#import "HYHotelOrderListViewController.h"
#import "HYMallOrderListViewController.h"
#import "HYFlowerOrderListViewController.h"
#import "HYFlightOrderListViewController.h"
#import "HYMeituanOrderListViewController.h"
#import "HYMallFavoritesViewController.h"
#import "HYCIOrderListViewController.h"
#import "HYMallCartViewController.h"
#import "HYTaxiOrderListViewController.h"
//#import "OrderGroupViewController.h"
#import "BusinessOrderViewController.h"
#import "HYMeiWeiQiQiOrderListViewController.h"
#import "HYMovieTicketOrderListViewController.h"
#import "HYPhoneChargeOrderListViewController.h"

@interface HYMineAllOrderViewController ()
{
    __weak UIViewController *_orderViewController;
    HYImageButton *_titleBtn;
}

@end

@implementation HYMineAllOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"订单列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleBtn = [[HYImageButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [_titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:@"icon_arrow_pulldown"] forState:UIControlStateNormal];
    _titleBtn.type = ImageButtonTypeTitleFirst;
    _titleBtn.spaceInTestAndImage = 5;
    [_titleBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleBtn;
}

- (void)showOrderViewController:(UIViewController *)orderViewcontroller
{
    if (_orderViewController) {
        [_orderViewController removeFromParentViewController];
    }
    [self addChildViewController:orderViewcontroller];
    [self.view addSubview:orderViewcontroller.view];
    _orderViewController = orderViewcontroller;
    
    [_titleBtn setTitle:orderViewcontroller.title forState:UIControlStateNormal];
    [_titleBtn setNeedsLayout];
}

- (UIViewController *)showOrderViewWithType:(BusinessType)type
{
    UIViewController *child = nil;
    switch (type) {
        case AirTickets:
        {
            child = [[HYFlightOrderListViewController alloc] init];
            break;
        }
        case Hotel:
        {
            child = [[HYHotelOrderListViewController alloc] init];
            break;
        }
        case Flower:
        {
            child = [[HYFlowerOrderListViewController alloc] init];
            break;
        }
        case CarInsurance:
        {
            child = [[HYCIOrderListViewController alloc] init];
            break;
        }
        case Meituan:
        {
            child = [[HYMeituanOrderListViewController alloc] init];
            break;
        }
        case DidiTaxi:
        {
            child = [[HYTaxiOrderListViewController alloc] init];
            break;
        }
        case MeiWeiQiQi:
        {
            child = [[HYMeiWeiQiQiOrderListViewController alloc] init];
            break;
        }
        case PhoneCharge:
        {
            child = [[HYPhoneChargeOrderListViewController alloc] init];
            break;
        }
        case MovieTicket:
        {
            child = [[HYMovieTicketOrderListViewController alloc] init];
            break;
        }
        default:
            break;
    }
    if (child) {
        [self showOrderViewController:child];
    }
    return child;
}

- (void)titleBtnAction:(UIButton *)btn
{
    HYOrderSelectView *select = [HYOrderSelectView getView];
    [select showWithAnimation:YES];
    select.didGetOrderController = ^(UIViewController *controller)
    {
        if (controller)
        {
            [self showOrderViewController:controller];
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
