//
//  HYHYFlowerFinishOrderResponse.h
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYFlowerOrderInfo.h"

@interface HYFlowerFinishOrderResponse : CQBaseResponse

@property(nonatomic,retain)HYFlowerOrderInfo* orderInfo;
@end
