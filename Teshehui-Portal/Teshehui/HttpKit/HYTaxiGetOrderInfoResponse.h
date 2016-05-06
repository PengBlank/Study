//
//  HYTaxiGetOrderInfoResponse.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYTaxiOrder.h"

@interface HYTaxiGetOrderInfoResponse : CQBaseResponse

@property (nonatomic, strong) HYTaxiOrder *orderInfo;

@end
