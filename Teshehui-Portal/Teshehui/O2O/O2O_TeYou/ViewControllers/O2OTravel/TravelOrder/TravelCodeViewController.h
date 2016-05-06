//
//  TravelCodeViewController.h
//  Teshehui
//
//  Created by macmini5 on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

/**
 旅游订单二维码页面
 **/

#import "HYMallViewBaseController.h"
#import "TravelOrderInfo.h"

typedef NS_ENUM(NSInteger, TravelOrderType)
{
    UsableTravelOrder   = 0,    // 可用订单
    PastTraveOrder      = 1     // 历史订单
};
@interface TravelCodeViewController : HYMallViewBaseController

@property (nonatomic, strong) TravelOrderInfo *travelOrderInfo;
@property (nonatomic, assign) NSInteger        travelOrderType; // 0为可用订单 1为历史订单

@end
