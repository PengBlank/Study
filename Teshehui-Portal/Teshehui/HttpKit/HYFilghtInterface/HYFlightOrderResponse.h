//
//  HYFlightOrderResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYFlightOrder.h"

@interface HYFlightOrderResponse : CQBaseResponse

@property (nonatomic, strong) HYFlightOrder *filghtOrder;

@end
