//
//  HYFlowerOrderListCell.h
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYFlowerOrderSummary.h"
#import "HYFlowerCancelOrderRequest.h"
#import "HYFlowerCancelOrderResponse.h"
#import "HYFlowerOrderListViewController.h"

@interface HYFlowerOrderListCell : HYBaseLineCell
<
UIAlertViewDelegate
>
{
    HYFlowerCancelOrderRequest *_cancelOrderRequest;
    CGFloat _org_y;
}

@property(nonatomic, weak)HYFlowerOrderListViewController* pushViewController;

@property(nonatomic,strong)UILabel* order_sn;
@property(nonatomic,strong)UILabel* order_amout;
@property(nonatomic,strong)UILabel* order_time;
@property(nonatomic,strong)UILabel* messageLabel;
@property(nonatomic,strong)UILabel* addressLabel;
@property(nonatomic,strong)UILabel* order_status;
@property(nonatomic,strong)UILabel* order_name_Label;

@property(nonatomic,strong)UIButton* payBtn;
@property(nonatomic,strong)UIButton* cancelBtn;
@property(nonatomic,strong)UIButton* delBtn;

@property(nonatomic, strong) HYFlowerOrderSummary *orderListInfo;
@end
