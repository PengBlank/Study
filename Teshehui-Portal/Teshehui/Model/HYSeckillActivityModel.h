//
//  HYSeckillActivityModel.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYSeckillActivityModel : JSONModel

@property (nonatomic, copy) NSString *activityStatusName;
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *activityName;
@property (nonatomic, copy) NSString *m_description;
@property (nonatomic, copy) NSString *activityStatus;
@property (nonatomic, copy) NSString *serviceCurrentTime;
// 活动状态活动状态 10:待审核；20：即将开始；21：审核不通过；30：抢购中；40：已结束；99：活动已删除；

@end
