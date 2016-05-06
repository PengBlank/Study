//
//  HYFlowerCityInfo.h
//  Teshehui
//
//  Created by 回亿资本 on 14-4-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

@interface HYFlowerCityInfo : NSObject<CQResponseResolve>

@property(nonatomic,copy)NSString* adressid;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* parent_id;
@property(nonatomic,copy)NSString* updated;

@end
