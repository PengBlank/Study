//
//  HYAnalyticsBaseParams.h
//  Teshehui
//
//  Created by 成才 向 on 16/1/13.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYRequestParams.h"

@interface HYAnalyticsBaseParams : HYRequestParams

@property (nonatomic, copy) NSString *xres_uid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *site_id;
@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, copy) NSString *device_no;
@property (nonatomic, copy) NSString *device_type;
@property (nonatomic, copy) NSString *app_ver;
@property (nonatomic, copy) NSString *phone_model;
@property (nonatomic, copy) NSString *os_msg;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *ll_type;
@property (nonatomic, copy) NSString *qd_key;  //渠道标识
@property (nonatomic, strong) NSNumber *nk_type;
@property (nonatomic, strong) NSNumber *nk_opt;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *mac;

@end
