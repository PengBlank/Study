//
//  SceneOrderDetailViewController.h
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  场景订单详细页面vc
//  分为4种样式：1已使用、2可使用、3未付款、4无效订单(退款中、已退款)

#import "HYMallViewBaseController.h"

@interface SceneOrderDetailViewController : HYMallViewBaseController

///**订单状态 0已使用1可使用2未付款3已取消4退款中5已退款*/
//@property (assign)          NSInteger   orderStatus;

/** 订单编号*/
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, assign) NSInteger comeType;
/**支付按钮*/
@property (nonatomic, strong) UIButton *payButton;

@end
