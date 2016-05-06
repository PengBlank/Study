//
//  HYSecondKillViewController.h
//  Teshehui
//
//  Created by Kris on 15/12/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "RKBasePageViewController.h"

@interface HYSecondKillViewController : RKBasePageViewController

/**
 *  @brief  需直接显示的活动id
 *  如果从通知进入秒杀列表，需显示对应的活动
 */
@property (nonatomic, strong) NSString *activityId;

/**
 * 秒杀标题
 */
@property (nonatomic, copy) NSString* name;

@end
