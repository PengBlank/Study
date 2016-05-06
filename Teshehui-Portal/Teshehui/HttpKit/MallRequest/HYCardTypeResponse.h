//
//  HYCardTypeResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYCardType.h"

@interface HYCardTypeResponse : CQBaseResponse

@property (nonatomic, strong, readonly) NSArray *cardList;

@end
