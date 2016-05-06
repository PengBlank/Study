//
//  HYRecvRedpacketReq.h
//  Teshehui
//
//  Created by HYZB on 15/1/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
  领取红包
 */

#import "CQBaseRequest.h"
#import "HYRedpacketInfo.h"
#import "HYRedpacketRecv.h"

@interface HYRecvRedpacketReq : CQBaseRequest

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *luck_password;

@end

@interface HYRecvRedpacketResp : CQBaseResponse

@property (nonatomic, strong) HYRedpacketInfo *packetInfo;
@property (nonatomic, strong) HYRedpacketRecv *recv;

@end

/*
 id	INT	红包ID
 luck_password	STRINTG	拼手气红包密钥
*/