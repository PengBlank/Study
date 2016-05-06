//
//  HYTaxiProcessViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYTaxiAddOrderParam.h"
#import "HYTaxiService.h"


/**
 *  滴滴打车, 叫车流程界面
 *  包含创建订单(等待), 叫车过程, 等待司机, 行程已开始四个状态
 *
 */
@interface HYTaxiProcessViewController : HYMallViewBaseController

/**
 *  打车类型, 1快车, 2专车
 */
@property (nonatomic, assign) NSInteger taxiType;

/**
 *  下单参数
 */
@property (nonatomic, strong) HYTaxiAddOrderParam *orderParam;

/**
 *  未完成订单
 */
@property (nonatomic, strong) HYTaxiOrder *taxiOrder;

@end
