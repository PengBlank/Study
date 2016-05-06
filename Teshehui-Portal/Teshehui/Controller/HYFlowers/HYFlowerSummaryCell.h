//
//  HYFlowerSummaryCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-4-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYFlowerDetailInfo.h"

@interface HYFlowerSummaryCell : HYBaseLineCell

@property (nonatomic, strong) HYFlowerDetailInfo *flowerInfo;
@property (nonatomic, assign) NSInteger total;

@end
