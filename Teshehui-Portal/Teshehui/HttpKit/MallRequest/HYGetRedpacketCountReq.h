//
//  HYGetRedpacketCountReq.h
//  Teshehui
//
//  Created by HYZB on 15/1/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *119) 可领取红包数
 */

#import "CQBaseRequest.h"

@interface HYGetRedpacketCountReq : CQBaseRequest

@end

@interface HYGetRedpacketCountResp : CQBaseResponse

@property (nonatomic, assign) NSInteger count;

@end