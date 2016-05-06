//
//  HYindemnityProgress.h
//  Teshehui
//
//  Created by HYZB on 15/4/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

@interface HYIndemnityProgress : NSObject<CQResponseResolve>
{
    NSString *_timeDesc;
}

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy, readonly) NSString *timeDesc;

@end