//
//  HYOrderTrackResponse.h
//  Teshehui
//
//  Created by ichina on 14-3-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallLogisticsInfo.h"

@interface HYOrderTrackResponse : CQBaseResponse

@property (nonatomic, strong) HYMallLogisticsInfo *trackInfo;

@end
