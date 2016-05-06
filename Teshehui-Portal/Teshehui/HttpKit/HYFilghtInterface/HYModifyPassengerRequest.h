//
//  HYModifyPassengerRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 修改乘机人信息
 */

#import "HYAddPassengerRequest.h"

@interface HYModifyPassengerRequest : HYAddPassengerRequest

@property (nonatomic, copy) NSString *passengerId;  //

@end
