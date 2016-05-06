//
//  HYPhoneChargeOrderListCancelRequest.h
//  Teshehui
//
//  Created by HYZB on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYPhoneChargeOrderListCancelRequest : CQBaseRequest

@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, copy) NSString *orderCode;

@end
