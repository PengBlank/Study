//
//  HYAfterSaleLogisticsViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYMallAfterSaleInfo.h"

/**
 *  售后服务, 登记快递信息, 登记物流信息
 */
@interface HYAfterSaleLogisticsViewController : HYMallViewBaseController

@property (nonatomic, strong) HYMallAfterSaleInfo *saleInfo;

@property (nonatomic, copy) void (^callback)(void);

@end
