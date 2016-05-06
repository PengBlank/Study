//
//  HYOrderReturnDetailResponse.h
//  Teshehui
//
//  Created by RayXiang on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallReturnsInfo.h"

@interface HYOrderReturnDetailResponse : CQBaseResponse

@property (nonatomic, strong, readonly) HYMallReturnsInfo *retInfo;

@end
