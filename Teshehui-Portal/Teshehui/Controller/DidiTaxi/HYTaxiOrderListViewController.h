//
//  HYTaxiOrderListViewController.h
//  Teshehui
//
//  Created by HYZB on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

// 滴滴打车状态
typedef NS_ENUM(NSInteger, didiTaxiStatus) {
    didiTaxiStatusBegin         = 10,
    didiTaxiStatusUnfinished    = 20,
    didiTaxiStatusFinished      = 30,
    didiTaxiStatusClosed        = 40,
};

@interface HYTaxiOrderListViewController : HYMallViewBaseController

@end
