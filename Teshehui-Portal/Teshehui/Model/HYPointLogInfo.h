//
//  HYPointLogInfo.h
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

@interface HYPointLogInfo : NSObject<CQResponseResolve>

@property(nonatomic,copy)NSString* logs;

@property(nonatomic,copy)NSString* points;

@property(nonatomic,copy)NSString* created;

@end
