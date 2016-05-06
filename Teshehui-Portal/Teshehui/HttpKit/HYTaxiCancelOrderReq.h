//
//  HYTaxiCancelOrderReq.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYTaxiCancelOrderResp.h"

@interface HYTaxiCancelOrderReq : CQBaseRequest

@property (nonatomic, strong) NSString *orderCode;
@property (nonatomic, assign) BOOL isForceCancel;

@end
