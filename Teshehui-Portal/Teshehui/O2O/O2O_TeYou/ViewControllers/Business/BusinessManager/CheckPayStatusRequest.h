//
//  CheckPayStatusRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface CheckPayStatusRequest : CQBaseRequest

@property (nonatomic,strong) NSString   *OrderNo;//O2O的订单流水
@property (nonatomic,strong) NSString   *Type;

@end
