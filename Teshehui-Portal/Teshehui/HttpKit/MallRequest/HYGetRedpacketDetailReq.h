//
//  HYGetRedpacketDetailReq.h
//  Teshehui
//
//  Created by HYZB on 15/1/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *红包详情
 */

#import "CQBaseRequest.h"
#import "HYRedpacketInfo.h"

@interface HYGetRedpacketDetailReq : CQBaseRequest

@property (nonatomic, copy) NSString *code;

@end


@interface HYGetRedpacketDetailResp : CQBaseResponse

@property (nonatomic, strong) HYRedpacketInfo *redpacket;
@property (nonatomic, strong) NSArray *recvList;

@end