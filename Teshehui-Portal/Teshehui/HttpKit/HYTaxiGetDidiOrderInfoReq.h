//
//  HYTaxiGetDidiOrderInfoReq.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYTaxiGetDidiOrderInfoResp.h"

@interface HYTaxiGetDidiOrderInfoReq : CQBaseRequest

@property (nonatomic, strong) NSString *didiOrderId;

@end
