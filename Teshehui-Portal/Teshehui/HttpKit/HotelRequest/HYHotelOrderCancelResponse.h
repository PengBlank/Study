//
//  HYHotelOrderCancelResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYHotelOrderBase.h"

@interface HYHotelOrderCancelResponse : CQBaseResponse

@property (nonatomic, readonly, strong) HYHotelOrderBase *order;

@end
