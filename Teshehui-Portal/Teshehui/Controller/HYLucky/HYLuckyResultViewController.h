//
//  HYLuckyResultViewController.h
//  Teshehui
//
//  Created by HYZB on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 * 抽奖结果(我抓的牌)
 */

#import "HYMallViewBaseController.h"
#import "HYLuckyStatusInfo.h"
#import "HYLuckyInfo.h"

@interface HYLuckyResultViewController : HYMallViewBaseController

@property (nonatomic, strong) HYLuckyStatusInfo *selectCards;
@property (nonatomic, strong) HYLuckyInfo *luckyInfo;
@end
