//
//  HYGetRedpacketSendListReq.h
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *发送的红包列表
 */

#import "CQBaseRequest.h"
#import "HYGetRedpacketListReq.h"

@interface HYGetRedpacketSendListReq : CQBaseRequest

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger num_per_page;

@end

