//
//  HYHotStaticsAnalyticsParams.h
//  Teshehui
//
//  Created by 成才 向 on 16/1/15.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYAnalyticsBaseParams.h"

@interface HYHotStaticsAnalyticsParams : HYAnalyticsBaseParams

@property (nonatomic, copy) NSString *hot_type;
@property (nonatomic, copy) NSString *board_code;
@property (nonatomic, copy) NSString *banner_code;
@property (nonatomic, copy) NSString *banner_type;

@end

/*
 hot_type	热区类型	Number
 枚举类型：
 1：首页；
 2：二级频道页
 board_code	版块编码	String
 banner_code	栏位编码	String
 banner_type	栏位类型编码	String
 */