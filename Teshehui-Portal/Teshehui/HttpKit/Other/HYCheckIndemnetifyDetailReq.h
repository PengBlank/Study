//
//  HYCheckIndemnetifyDetailReq.h
//  Teshehui
//
//  Created by HYZB on 15/4/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYIndemnityinfo.h"

@interface HYCheckIndemnetifyDetailReq : CQBaseRequest

//必须字段
@property (nonatomic, copy) NSString *indemntify_id;  //贵就赔id

//可选字段

@end


@interface HYCheckIndemnetifyDetailResq : CQBaseResponse

@property (nonatomic, strong) HYIndemnityinfo *indemnityInfo;

@end