//
//  HYAddRechargeOrderResponse.h
//  Teshehui
//
//  Created by Kris on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYPhoneChargeOrder.h"

@interface HYAddRechargeOrderResponse : CQBaseResponse

@property (nonatomic, strong) HYPhoneChargeOrder *order;

//@property (nonatomic, strong, readonly) HYPhoneChargeOrderModel *order1;

@end
