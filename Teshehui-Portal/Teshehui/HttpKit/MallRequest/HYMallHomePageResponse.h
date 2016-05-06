//
//  HYMallHomePageResponse.h
//  Teshehui
//
//  Created by HYZB on 14-10-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallRecommend.h"
#import "HYMallHomeBoard.h"

@interface HYMallHomePageResponse : CQBaseResponse

@property (nonatomic, strong, readonly) NSArray *homeItems;

@end
