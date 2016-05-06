//
//  HYRedpacketRecv.h
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

@interface HYRedpacketRecv : NSObject<CQResponseResolve>

@property (nonatomic, assign) int total_amount;
@property (nonatomic, copy) NSString *get_time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger status; //0未领取，1已领取，－1过期
@property (nonatomic, strong) NSString *phone_mob;


@end
