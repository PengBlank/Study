//
//  HYMallLogisticsTrackCell.h
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallLogisticsInfo.h"
#import "HYMallExpressItem.h"

@interface HYMallLogisticsTrackCell : HYBaseLineCell

@property (nonatomic, assign) BOOL isLastInfo;
@property (nonatomic, strong) HYMallExpressItem *trackInfo;

@end
