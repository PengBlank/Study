//
//  HYUserRegisterAnalyticsParams.h
//  Teshehui
//
//  Created by Charse on 16/4/22.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

/*
 * 1.12	用户注册统计（UserRegister）
 •	功能描述：用户注册成功的统计数据。
 •	页面打点：用户注册成功后触发调用。
 app_type	APP类型	Number
 枚举类型：
 1：商城
 2：聚宝橙
 3：绿巨人	必选
 (为Wap时此参数可不传)
 reg_type	注册类型	Number
 枚举类型：
 101：APP-快速注册
 102：APP-实体卡激活
 103：APP-在线购卡注册
 201：WAP-抽奖页注册
 202：WAP-第三方合作商页注册
 203：WAP-O2O商户页注册
 204：WAP-现金券红包页注册
 205：WAP-分享赚现金券页注册
 206：WAP-现金券账单分享页注册
 300：其他方式注册
 1.12.3	示例
 */

#import "HYAnalyticsBaseParams.h"

@interface HYUserRegisterAnalyticsParams : HYAnalyticsBaseParams


@property (nonatomic, assign) NSInteger reg_type;

/// 1商城2聚宝橙3绿巨人
@property (nonatomic, assign) NSInteger app_type;

@end
