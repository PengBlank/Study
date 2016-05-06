//
//  HYMallRecommendResponse.h
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallHomeBoard.h"

@interface HYMallRecommendResponse : CQBaseResponse

@property (nonatomic, strong) HYMallHomeBoard *boradInfo;

@end
