//
//  HYMallCancelOrderReponse.h
//  Teshehui
//
//  Created by HYZB on 14-9-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYMallCancelOrderReponse : CQBaseResponse

@end

/*
 状态：200（成功）
 201(红包已经领,只针对手气红包)
 202(红包已经过期)
 203(不能重复领取)
*/