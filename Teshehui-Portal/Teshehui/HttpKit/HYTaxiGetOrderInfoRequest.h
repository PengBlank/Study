//
//  HYTaxiGetOrderInfoRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYTaxiGetOrderInfoResponse.h"

@interface HYTaxiGetOrderInfoRequest : CQBaseRequest

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *userUserId;
@property (nonatomic, assign) BOOL isEnterprise;

@end
