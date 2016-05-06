//
//  HYTaxiCallCarAgainReq.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYTaxiCallCarAgainResp.h"

@interface HYTaxiCallCarAgainReq : CQBaseRequest

@property (nonatomic, strong) NSString *didiOrderId;
@property (nonatomic, strong) NSString *carTypeCode;

@end
