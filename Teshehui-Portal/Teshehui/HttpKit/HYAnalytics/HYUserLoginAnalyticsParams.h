//
//  HYUserLoginAnalyticsParams.h
//  Teshehui
//
//  Created by Charse on 16/4/22.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

/*
 *1.13	用户登录统计（UserLogin）
 •	功能描述：用户登录的统计数据。
 •	页面打点：用户登录成功后触发调用。
 */

#import "HYAnalyticsBaseParams.h"

@interface HYUserLoginAnalyticsParams : HYAnalyticsBaseParams

/*
 
 Number
 枚举类型：
 101：APP-快速登录
 102：APP-密码登录
 111：APP-第三方登录之微信
 112：APP-第三方登录之QQ
 201：WAP登录
 300：其他方式登录
 */
@property (nonatomic, assign) NSInteger lg_type;

/// 1商城2聚宝橙3绿巨人
@property (nonatomic, assign) NSInteger app_type;

@end
