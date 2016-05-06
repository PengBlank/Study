//
//  HYMallFinishOrderResponse.h
//  Teshehui
//
//  Created by ichina on 14-3-13.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallOrderSummary.h"

@interface HYMallSubmitOrderResponse : CQBaseResponse

@property (nonatomic, strong) HYMallOrderSummary *orderList;

@end
