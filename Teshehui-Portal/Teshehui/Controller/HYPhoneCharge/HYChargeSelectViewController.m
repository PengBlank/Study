//
//  HYChargeSelectViewController.m
//  Teshehui
//
//  Created by 成才 向 on 16/2/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYChargeSelectViewController.h"
#import "HYChargeSelectView.h"
#import "HYPhoneChargeDataController.h"
#import "HYChargeSelectViewModel.h"
#import "HYPhoneChargeButton.h"
#import "HYPaymentViewController.h"
#import "UIAlertView+BlocksKit.h"
#import "HYPhoneChargeOrderListViewController.h"
#import "HYPhoneChargeOrder.h"

@interface HYChargeSelectViewController ()
<HYChargeSelectViewDelegate>

@property (nonatomic, strong) HYChargeSelectView *mainView;
@property (nonatomic, strong) HYChargeSelectViewModel *viewModel;
@property (nonatomic, strong) HYPhoneChargeDataController *dataCtrler;

@end

@implementation HYChargeSelectViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)init
{
    if (self = [super init])
    {
        //receive the notification from the phone view
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleDataController:)
                                                    name:@"kWhetherShowPrice"
                                                  object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadView
{
    HYChargeSelectView *mainView = [HYChargeSelectView instanceView];
    self.mainView = mainView;
    mainView.delegate = self;
    self.view = mainView;
}

- (void)renderViewWithData:(NSArray *)data
{
    HYChargeSelectViewModel *viewModel = [[HYChargeSelectViewModel alloc]init];
    viewModel.dataList = data;
    [self.mainView bindDataWithViewModel:viewModel];
}

#pragma mark private methods
- (void)startPaymentFromOrder:(HYPhoneChargeOrder *)order
{
    /*
     * 支付宝说明: 13-8-22;
     * 在多订单付款的时候，支付宝订单号使用订单的order_id，单订单的时候使用order_sn
     * 传递到支付界面的id必须都是订单id
     * 支付宝得回调都是订单id
     */
    //现在只用主订单号
    if (order && self.delegate)
    {
        [self.delegate payWithOrder:order];
    }
}

- (void)clearMainViewData
{
    [self.mainView removeData];
}

#pragma mark HYChargeSelectViewDelegate
- (void)addRechargeOrder:(HYPhoneChargeButton *)sender
{
    WS(weakSelf);
    [self.dataCtrler addRechargeOrderWithParamObjects:sender.paramModel
                                                 Type:ChargePhone
                                      CompletionBlock:^(HYPhoneChargeOrder *order){
          [weakSelf startPaymentFromOrder:order];
    }];
}

#pragma mark notification callback
- (void)handleDataController:(NSNotification *)sender
{
    WS(weakSelf);
    if (sender.object)
    {
        NSArray *params = sender.object;
        NSNumber *platform = params[0];
        NSString *num = params[1];
        
        [self.dataCtrler fetchRechargeGoodsType:ChargePhone
                              withPlatForm:[platform integerValue]
                                 andNumber:num completionBlock:^(NSArray *dataList) {
            [weakSelf renderViewWithData:dataList];
        }];
    }
    else
    {
        [self clearMainViewData];
    }
}

#pragma mark getter & setter
- (HYPhoneChargeDataController *)dataCtrler
{
    if (!_dataCtrler)
    {
        _dataCtrler = [[HYPhoneChargeDataController alloc]init];
    }
    return _dataCtrler;
}

@end
