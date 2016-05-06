//
//  HYFlightStockResponse.h
//  Teshehui
//
//  Created by 成才 向 on 15/6/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYFlightSKUStock.h"

@interface HYFlightStockResponse : CQBaseResponse

@property (nonatomic, strong) HYFlightSKUStock *skuStock;

@end
