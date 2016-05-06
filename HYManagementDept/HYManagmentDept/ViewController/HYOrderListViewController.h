//
//  HYOrderListViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYAgencyOrderListRequestParam.h"
#import "HYBaseDetailViewController.h"
/**
 *  已结算订单列表界面
 */
@interface HYOrderListViewController : HYBaseDetailViewController
<
UITextFieldDelegate
>
@property (nonatomic, assign) OrderType orderType;

- (void)reloadData;

@end
