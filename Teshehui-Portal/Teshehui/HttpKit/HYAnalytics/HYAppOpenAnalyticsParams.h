//
//  HYAppOpenAnalyticsParams.h
//  Teshehui
//
//  Created by 成才 向 on 16/3/12.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYAnalyticsBaseParams.h"

/**
 *  @brief app启动统计参数对象
 */

@interface HYAppOpenAnalyticsParams : HYAnalyticsBaseParams
/// 1启动，2从后台返回
@property (nonatomic, assign) unsigned int open_type;

/// 1商城2聚宝橙3绿巨人
@property (nonatomic, assign) unsigned int app_type;

@end
