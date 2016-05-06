//
//  HYBuyDrinksViewController.h
//  Teshehui
//
//  Created by macmini7 on 15/11/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//  购买酒水&结单

#import "HYMallViewBaseController.h"
#import "BilliardsOrderInfo.h"
#import "BilliardsTableInfo.h"
@interface HYBuyDrinksViewController : HYMallViewBaseController

//@property (nonatomic, strong) NSString           *starTime;
@property (nonatomic, strong) BilliardsOrderInfo *orderInfo;
@property (nonatomic, assign) BOOL backRefresh;

@property (nonatomic, strong) BilliardsTableInfo *billiardsTableInfo;

@end
