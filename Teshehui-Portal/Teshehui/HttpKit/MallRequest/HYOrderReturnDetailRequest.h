//
//  HYGetOrderReturnDetailRequest.h
//  Teshehui
//
//  Created by RayXiang on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYOrderReturnDetailResponse.h"

@interface HYOrderReturnDetailRequest : CQBaseRequest

@property (nonatomic, strong) NSString *return_id;

@end
