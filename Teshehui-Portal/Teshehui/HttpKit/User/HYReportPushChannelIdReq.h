//
//  HYReportPushChannelId.h
//  Teshehui
//
//  Created by HYZB on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 * 上报推送id
 */
#import "CQBaseRequest.h"

@interface HYReportPushChannelIdReq : CQBaseRequest

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *channelid;
@property (nonatomic, copy) NSString *baidu_user_id;
@property (nonatomic, copy) NSString *channelid_type;

@end

/*
 user_id                  会员ID
 channelid                推送channelid
 channelid_type           推送APP类型  1：安卓 2：IOS
*/