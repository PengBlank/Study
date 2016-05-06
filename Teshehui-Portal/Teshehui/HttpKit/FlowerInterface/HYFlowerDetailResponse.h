//
//  HYFlowerDetailResponse.h
//  Teshehui
//
//  Created by ichina on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import  "HYFlowerDetailInfo.h"

@interface HYFlowerDetailResponse : CQBaseResponse

@property (nonatomic, strong) HYFlowerDetailInfo *flowerDetailInfo;

@end
