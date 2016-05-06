//
//  HYAnalyticsBaseReq.h
//  Teshehui
//
//  Created by HYZB on 15/11/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYAnalyticsBaseReq : CQBaseRequest

@property (nonatomic, copy) NSString *xres_uid;
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

@end
