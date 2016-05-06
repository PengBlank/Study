//
//  HYFlightBackListViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 返程航班列表
 */

#import "HYFlightListViewController.h"
#import "HYCabins.h"

@interface HYFlightBackListViewController : HYFlightListViewController

@property (nonatomic, strong) HYCabins *orgCabin;  //去程的仓位信息

@end
