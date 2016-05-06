//
//  HYSeckillService.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYSeckillActivityModel.h"

@interface HYSeckillService : NSObject

/// 获取秒杀活动列表
- (void)getSeckillActivities:(void (^)(NSArray<HYSeckillActivityModel*> *list, NSString *err))callback;

@end
