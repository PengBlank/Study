//
//  HYGetRebpacketListReq.h
//  Teshehui
//
//  Created by HYZB on 15/1/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *119)  红包列表 
 */

#import "CQBaseRequest.h"
#import "HYRedpacketInfo.h"

@interface HYGetRebpacketListReq : CQBaseRequest

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int num_per_page;

@end


@interface HYGetRebpacketListResp : CQBaseResponse

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int total;
@property (nonatomic, assign) int total_page;
@property (nonatomic, strong) NSArray *packetList;

@end