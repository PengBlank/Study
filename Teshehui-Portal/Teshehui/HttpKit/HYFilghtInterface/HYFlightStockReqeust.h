//
//  HYFlightStockReqeust.h
//  Teshehui
//
//  Created by 成才 向 on 15/6/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYFlightStockResponse.h"

/**
 * 机票可订查询
 */
@interface HYFlightStockReqeust : CQBaseRequest

@property (nonatomic, strong) NSString *skuId;

@end
